# conflict_flow_controller.gd — Phase State-Machine for Raid Flows
# TIDELINES: Cedar, Sea & Legacy
#
# Drives a raid flow (offensive or defensive) through all 6 phases.
# Reads flow data from DataLoader, presents choices, runs the engine,
# and emits signals for the UI layer.

class_name ConflictFlowController
extends Node

# ============================================================
# SIGNALS  (UI listens to these)
# ============================================================

signal phase_started(phase_data: Dictionary, state_snapshot: Dictionary)
signal narrative_shown(text: String)
signal choices_ready(choices: Array, prompt: String)
signal sub_choice_ready(sub_key: String, prompt: String, options: Array)
signal intel_report(intel: Dictionary)
signal intimidation_report(result: Dictionary)
signal round_narrated(round_index: int, round_data: Dictionary)
signal outcome_announced(outcome: String, narrative: String)
signal aftermath_report(aftermath: Dictionary)
signal flow_complete(final_state: Dictionary)
signal debug_snapshot(data: Dictionary)
signal status_changed(status: Dictionary)

# ============================================================
# SUB-SYSTEMS
# ============================================================

var engine := ConflictEngine.new()
var feud_tracker := FeudTracker.new()
var trait_manager := WarTraitManager.new()
var aftermath_proc := AftermathProcessor.new()

# ============================================================
# STATE
# ============================================================

var state: ConflictState = null
var _awaiting_choice := false
var _sub_choice_queue: Array = []   # remaining sub_choice keys for approach phase

# ============================================================
# PUBLIC API
# ============================================================

## Start an offensive or defensive raid flow.
func start_flow(flow_type: String) -> void:
	state = ConflictState.new()
	state.id = "conflict_%d" % randi()
	state.flow_type = flow_type
	state.flow_data = DataLoader.get_raid_flow(flow_type)
	if state.flow_data.is_empty():
		push_error("[ConflictFlow] No raid flow data for type: " + flow_type)
		return

	# Load phases
	state.phases = state.flow_data.get("phases", [])
	state.current_phase_index = -1

	# Set up forces from context
	var ctx: Dictionary = state.flow_data.get("context", {})
	_init_forces(ctx)

	# Set initial feud
	state.feud_state_before = ctx.get("feud_state", "NONE")
	state.feud_escalation_total = _feud_base(state.feud_state_before)

	state.morale_current = state.attacker.get("morale", 60) if flow_type == "offensive" else state.defender.get("morale", 60)

	# Emit start
	EventBus.conflict_started.emit({"id": state.id, "type": flow_type, "title": state.flow_data.get("title", "")})
	_emit_status()
	_emit_debug()

	# Advance to first phase
	advance_phase()

## Called by UI when the player picks a choice.
func select_choice(choice_id: String) -> void:
	if not _awaiting_choice or state == null:
		return
	_awaiting_choice = false

	var phase := state.get_current_phase()
	var choice := _find_choice(phase, choice_id)
	if choice.is_empty():
		push_warning("[ConflictFlow] Choice not found: " + choice_id)
		return

	# Record
	state.record_choice(state.get_phase_id(), choice_id, choice.get("effects", []), choice.get("narrative", choice.get("outcome_narrative", "")))

	# Apply effects
	_apply_effects(choice)

	# Show outcome narrative
	var narr: String = choice.get("outcome_narrative", choice.get("narrative", ""))
	if narr != "":
		narrative_shown.emit(narr)

	_emit_status()
	_emit_debug()

	# Check if we have queued sub-choices
	if _sub_choice_queue.size() > 0:
		_present_next_sub_choice()
		return

	# Phase-specific post-choice logic
	_post_choice_logic()

## Called by UI when a sub-choice is picked (approach phase time/formation).
func select_sub_choice(sub_key: String, option_id: String) -> void:
	if state == null:
		return
	var phase := state.get_current_phase()
	var subs: Dictionary = phase.get("sub_choices", {})
	if not subs.has(sub_key):
		return
	var opts: Array = subs[sub_key].get("options", [])
	for opt in opts:
		if opt.get("id", "") == option_id:
			state.record_choice(sub_key, option_id, [], opt.get("narrative", ""))
			_apply_sub_effects(sub_key, opt)
			if opt.get("narrative", "") != "":
				narrative_shown.emit(opt["narrative"])
			break

	_emit_status()
	_emit_debug()

	# Continue to next sub-choice or post-choice
	if _sub_choice_queue.size() > 0:
		_present_next_sub_choice()
	else:
		_post_choice_logic()

## Advance to the next phase. Called after choice resolution or auto-phases.
func advance_phase() -> void:
	if state == null:
		return
	state.current_phase_index += 1
	if state.current_phase_index >= state.phases.size():
		_finish_flow()
		return
	state.sub_step = 0
	var phase := state.get_current_phase()
	phase_started.emit(phase, state.get_status_summary())
	_emit_debug()
	_process_phase(phase)

# ============================================================
# PHASE PROCESSING
# ============================================================

func _process_phase(phase: Dictionary) -> void:
	var pid: String = phase.get("phase", "")

	# Show intro narrative
	var intro: String = phase.get("narrative_intro", "")
	if intro != "":
		narrative_shown.emit(intro)

	# Determine what the player needs to do in this phase
	if phase.has("choices"):
		_present_choices(phase["choices"], "Choose your action:")
	elif phase.has("defender_preparation_choices"):
		# Defensive scramble phase — show civilian evac narrative first
		if phase.has("civilian_evacuation"):
			narrative_shown.emit(phase["civilian_evacuation"].get("narrative", ""))
		_present_choices(phase["defender_preparation_choices"], "How will you defend?")
	elif phase.has("sub_choices"):
		# Multi-part approach phase
		_sub_choice_queue.clear()
		var subs: Dictionary = phase["sub_choices"]
		for key in subs:
			_sub_choice_queue.append(key)
		_present_next_sub_choice()
	elif phase.has("sample_resolution"):
		# Resolution phase — run the engine
		_run_resolution(phase)
	elif phase.has("aftermath_choices"):
		# Aftermath with choices
		_show_aftermath_results(phase)
		_present_choices(phase["aftermath_choices"], "What will you do now?")
	elif phase.has("immediate_aftermath"):
		# Aftermath (full data-driven)
		_show_aftermath_results(phase)
		if phase.has("aftermath_choices"):
			_present_choices(phase["aftermath_choices"], "What will you do now?")
		else:
			# Auto-advance after showing aftermath
			_awaiting_choice = false
			_finalize_aftermath(phase)
	elif phase.has("warning_level"):
		# Defensive warning phase — show warning info then choices
		var wl: Dictionary = phase.get("warning_level", {})
		if wl.get("narrative", "") != "":
			narrative_shown.emit(wl["narrative"])
		if phase.has("choices"):
			_present_choices(phase["choices"], "The enemy approaches. What do you do?")
	elif phase.has("intimidation_check") and not phase.has("choices"):
		# Engagement phase with only intimidation check + narrative
		_run_intimidation_from_phase(phase)
		if phase.get("engagement_narrative", "") != "":
			narrative_shown.emit(phase["engagement_narrative"])
		# Auto-advance
		await get_tree().create_timer(0.1).timeout
		advance_phase()
	else:
		# Unknown or auto-advance phase
		await get_tree().create_timer(0.1).timeout
		advance_phase()

func _present_choices(choices: Array, prompt: String) -> void:
	_awaiting_choice = true
	choices_ready.emit(choices, prompt)

func _present_next_sub_choice() -> void:
	if _sub_choice_queue.size() == 0:
		return
	var key: String = _sub_choice_queue.pop_front()
	var phase := state.get_current_phase()
	var subs: Dictionary = phase.get("sub_choices", {})
	if subs.has(key):
		var sub: Dictionary = subs[key]
		_awaiting_choice = true
		sub_choice_ready.emit(key, sub.get("prompt", "Choose:"), sub.get("options", []))

func _post_choice_logic() -> void:
	var phase := state.get_current_phase()
	var pid: String = phase.get("phase", "")

	# After approach phase, run intimidation check if present
	if pid == "2_approach" and phase.has("intimidation_check"):
		_run_intimidation_from_phase(phase)

	# After engagement choice in offensive, auto-advance to resolution
	# After any normal choice, advance
	await get_tree().create_timer(0.1).timeout
	advance_phase()

func _run_intimidation_from_phase(phase: Dictionary) -> void:
	var is_home := state.flow_type == "defensive"
	var fort := state.defender.get("fortification_level", 0) if state.fortification_active else 0
	var result := ConflictEngine.check_intimidation(
		state.attacker, state.defender, is_home, fort, state.intimidation_bonus
	)
	state.intimidation_score = result["intimidation_score"]
	state.resolve_score = result["resolve_score"]
	state.intimidation_delta = result["delta"]
	state.intimidation_result = result["result_id"]
	state.defender_fled = result["defender_fled"]
	state.negotiation_offered = result["negotiation_offered"]

	# Apply morale penalties
	if result["defender_morale_penalty"] > 0:
		state.defender["morale"] = maxi(state.defender.get("morale", 50) - result["defender_morale_penalty"], 5)
	if result["attacker_morale_penalty"] > 0:
		state.attacker["morale"] = maxi(state.attacker.get("morale", 50) - result["attacker_morale_penalty"], 5)

	if state.flow_type == "offensive":
		state.morale_current = state.attacker.get("morale", 60)
	else:
		state.morale_current = state.defender.get("morale", 60)

	intimidation_report.emit(result)

	# Show narrative
	var ic: Dictionary = phase.get("intimidation_check", {})
	if state.defender_fled and ic.has("if_intimidation_succeeds"):
		narrative_shown.emit(ic["if_intimidation_succeeds"].get("narrative", ""))
	elif state.negotiation_offered and ic.has("if_intimidation_succeeds"):
		narrative_shown.emit(ic["if_intimidation_succeeds"].get("narrative", ""))
	elif ic.has("if_intimidation_fails"):
		narrative_shown.emit(ic["if_intimidation_fails"].get("narrative", ""))
	elif ic.has("narrative"):
		narrative_shown.emit(ic["narrative"])
	elif ic.has("result"):
		narrative_shown.emit(ic["result"])

	EventBus.intimidation_success.emit(state.id, state.intimidation_result)
	_emit_debug()

# ============================================================
# RESOLUTION
# ============================================================

func _run_resolution(phase: Dictionary) -> void:
	# Run the real engine
	var result := ConflictEngine.resolve_engagement(state)
	state.outcome = result["outcome"]
	state.outcome_ratio = result["ratio"]
	state.attacker_score_total = result["attacker_total"]
	state.defender_score_total = result["defender_total"]
	state.rounds = result["rounds"]
	state.turning_point = result["turning_point"]
	state.prestige_change = result["prestige_shift"]

	EventBus.conflict_resolved.emit(result)

	# Narrate rounds from flow data (use sample_resolution narratives)
	var sr: Dictionary = phase.get("sample_resolution", {})
	var round_keys := ["round_1_opening_clash", "round_2_sustained_engagement", "round_3_turning_point", "round_4_resolution"]
	for i in range(round_keys.size()):
		var rk: String = round_keys[i]
		if sr.has(rk):
			var rd: Dictionary = sr[rk]
			# Check conditional turning points
			if rd.get("is_conditional", false):
				var cond: String = rd.get("condition", "")
				if not _condition_met(cond):
					# Try alternate
					var alt_key := rk + "_alternate"
					if sr.has(alt_key):
						rd = sr[alt_key]
					else:
						continue
			var narr_text: String = rd.get("narrative", "")
			if narr_text != "":
				var round_info := {"index": i, "narrative": narr_text}
				if i < state.rounds.size():
					round_info.merge(state.rounds[i])
				round_narrated.emit(i, round_info)

	# Announce outcome — use the engine outcome overridden by flow data if present
	var outcome_narr := ""
	if sr.has("round_4_resolution"):
		outcome_narr = sr["round_4_resolution"].get("narrative", "")
		# Override outcome from data if specified
		var data_outcome: String = sr["round_4_resolution"].get("outcome", "")
		if data_outcome != "":
			state.outcome = data_outcome
			state.prestige_change = ConflictEngine._prestige_for_outcome(data_outcome)
	outcome_announced.emit(state.outcome, outcome_narr)

	_emit_status()
	_emit_debug()

	# Auto-advance to withdrawal
	await get_tree().create_timer(0.1).timeout
	advance_phase()

# ============================================================
# AFTERMATH
# ============================================================

func _show_aftermath_results(phase: Dictionary) -> void:
	# Run aftermath processor
	var am_result := aftermath_proc.process(state)

	# Update feud
	var player_id: String = state.attacker.get("community_id", "player") if state.flow_type == "offensive" else state.defender.get("community_id", "player")
	var enemy_id: String = state.defender.get("community_id", "enemy") if state.flow_type == "offensive" else state.attacker.get("community_id", "enemy")
	var feud := feud_tracker.escalate(player_id, enemy_id, state.feud_escalation_total, "conflict")
	state.feud_state_after = feud.get("state", "GRIEVANCE")

	# Evaluate war traits
	var chief_id: String = state.attacker.get("chief_id", "player_chief") if state.flow_type == "offensive" else state.defender.get("chief_id", "player_chief")
	state.traits_earned = trait_manager.record_conflict(chief_id, state)

	# Show flow-data narrative for aftermath
	if phase.has("immediate_aftermath"):
		var ia: Dictionary = phase["immediate_aftermath"]
		# Casualty report narrative
		var cr: Dictionary = ia.get("casualty_report", {})
		for k in cr.get("killed", []):
			narrative_shown.emit("☠ %s — %s" % [k.get("name", "Unknown"), k.get("description", "")])
		for w in cr.get("wounded", []):
			narrative_shown.emit("⚔ %s (%s) — %s" % [w.get("name", "Unknown"), w.get("severity", ""), w.get("description", "")])
		# Spoils
		if ia.has("spoils_catalogued"):
			narrative_shown.emit(ia["spoils_catalogued"].get("narrative", ""))
		# Material assessment
		if ia.has("material_assessment"):
			var ma: Dictionary = ia["material_assessment"]
			if ma.has("canoe_captured"):
				narrative_shown.emit(ma["canoe_captured"].get("narrative", ""))
			if ma.has("village_damage"):
				narrative_shown.emit(ma["village_damage"].get("narrative", ""))

	# Short-term effects
	var ste: Dictionary = phase.get("short_term_effects", {})
	if ste.has("morale"):
		narrative_shown.emit(ste["morale"].get("narrative", ""))
	if ste.has("reputation_spread"):
		narrative_shown.emit(ste["reputation_spread"].get("narrative", ""))
	if ste.has("retaliation_clock"):
		narrative_shown.emit(ste["retaliation_clock"].get("narrative", ""))

	# Long-term effects
	var lte: Dictionary = phase.get("long_term_effects", {})
	if lte.has("feud_update"):
		narrative_shown.emit(lte["feud_update"].get("narrative", ""))
	if lte.has("battle_song"):
		narrative_shown.emit(lte["battle_song"].get("narrative", ""))
	if lte.has("dream_sequence_trigger"):
		narrative_shown.emit(lte["dream_sequence_trigger"].get("narrative", ""))
	if lte.has("legacy_entry"):
		state.legacy_entry = lte["legacy_entry"]

	aftermath_report.emit(am_result)
	_emit_status()
	_emit_debug()

func _finalize_aftermath(phase: Dictionary) -> void:
	# Long-term effects narrative
	var lte: Dictionary = phase.get("long_term_effects", {})
	if lte.has("pole_opportunity"):
		narrative_shown.emit(lte["pole_opportunity"].get("narrative", ""))

	await get_tree().create_timer(0.1).timeout
	advance_phase()

# ============================================================
# FINISH
# ============================================================

func _finish_flow() -> void:
	if state == null:
		return
	var final := state.get_debug_snapshot()
	final["legacy_entry"] = state.legacy_entry
	flow_complete.emit(final)

# ============================================================
# EFFECT APPLICATION
# ============================================================

func _apply_effects(choice: Dictionary) -> void:
	for eff in choice.get("effects", []):
		var t: String = eff.get("type", "")
		match t:
			"INTELLIGENCE_METHOD":
				state.intel_quality = _quality_from_method(eff.get("method", "traders"))
			"TACTIC":
				if state.flow_type == "offensive":
					state.attacker_tactic = eff.get("tactic", "measured_push")
				else:
					state.defender_tactic = eff.get("tactic", "hold_the_beach")
				EventBus.engagement_begun.emit(state.id, eff.get("tactic", ""))
			"DEFENSE_TACTIC":
				state.defender_tactic = eff.get("tactic", "hold_the_beach")
			"ATTACK_MODIFIER":
				pass  # handled via tactic
			"ALARM_LEVEL":
				if eff.get("level", "") == "full":
					state.surprise_bonus = 0
			"SURPRISE_NEGATED":
				state.surprise_bonus = 0
			"AMBUSH_ENABLED":
				state.ambush_enabled = true
				state.surprise_bonus += 20
			"SURPRISE_REVERSED":
				state.surprise_bonus = -15  # attacker loses surprise
			"FORTIFICATION_ACTIVE":
				state.fortification_active = true
				state.defender["fortification_level"] = 3
			"FLANKING_ACTIVE":
				state.flanking_active = true
				state.defender["morale"] = state.defender.get("morale", 50) + 10
			"DEFENSE_MODIFIER":
				pass  # handled via tactic
			"DEFENDER_MORALE":
				state.defender["morale"] = clampi(state.defender.get("morale", 50) + eff.get("value", 0), 0, 100)
				if state.flow_type == "defensive":
					state.morale_current = state.defender.get("morale", 50)
			"CREW_MORALE":
				state.morale_current = clampi(state.morale_current + eff.get("value", 0), 0, 100)
			"PRESTIGE":
				state.prestige_change += eff.get("amount", 0)
			"SPOILS_MODIFIER":
				pass  # will scale spoils
			"PURSUIT_RISK", "TIME_ON_BEACH":
				pass
			"PURSUIT":
				if eff.get("value", false):
					state.prestige_change += 10
					state.feud_escalation_total += 2
			"FEUD_ESCALATION":
				state.feud_escalation_total += eff.get("value", 0)
			"FEUD_DEESCALATION":
				state.feud_escalation_total = maxi(0, state.feud_escalation_total - eff.get("value", 1))
			"SECONDARY_OBJECTIVE":
				state.feud_escalation_total += 3
			"CAPTIVE_TAKEN":
				state.captives_taken += eff.get("count", 1)
			"SET_FLAG":
				EventBus.flag_set.emit(eff.get("flag", ""), true)
			"RESOURCE":
				pass  # would integrate with village resource system
			"INTIMIDATION_BONUS":
				state.intimidation_bonus += eff.get("amount", 0)
			"DETECTION_RISK":
				if randf() < eff.get("chance", 0):
					state.defender["alert_level"] = 1
					narrative_shown.emit("⚠ Your scouts may have been spotted.")
			"DIPLOMACY_ATTEMPT":
				pass
			"DIPLOMACY_CHECK":
				pass
			"INTELLIGENCE_BOOST":
				state.intel_quality = "PRECISE"
			"BEACH_CONCEDED":
				state.canoe_damage = 0.3  # some canoe risk
			"CANOE_RISK":
				state.canoe_damage += 0.2
			"CREW_SPLIT":
				pass
			"PREPARATION_TURNS":
				pass  # in full game would add turns
			"CIVILIANS_EVACUATED":
				pass
			"TURN_COST":
				pass
			"PEACE_CANOE_RISK":
				pass
			"CIVILIAN_RISK":
				pass
			"ADDITIONAL_LOSS_RISK":
				pass
			"CREW_FATIGUE":
				state.morale_current = maxi(state.morale_current - 5, 10)
			"DIPLOMATIC_LEVERAGE":
				state.prestige_change += 5

	_emit_status()

func _apply_sub_effects(sub_key: String, option: Dictionary) -> void:
	var effs: Variant = option.get("effects", {})
	if effs is Dictionary:
		if sub_key == "time_of_day":
			state.approach_time = option.get("id", "dawn")
			state.surprise_bonus += effs.get("surprise_bonus", 0)
		elif sub_key == "formation":
			state.formation = option.get("id", "single")
			state.stealth_bonus += effs.get("stealth_bonus", 0)
			state.intimidation_bonus += effs.get("intimidation_bonus", 0)

# ============================================================
# HELPERS
# ============================================================

func _find_choice(phase: Dictionary, choice_id: String) -> Dictionary:
	for arr_key in ["choices", "defender_preparation_choices", "aftermath_choices"]:
		if phase.has(arr_key):
			for c in phase[arr_key]:
				if c.get("id", "") == choice_id:
					return c
	return {}

func _quality_from_method(method: String) -> String:
	match method:
		"scouts": return "ACCURATE"
		"traders": return "VAGUE"
		"omens": return "VAGUE"
		_: return "VAGUE"

func _condition_met(cond: String) -> bool:
	if "launch_counter_at_sea" in cond:
		return state.choices_made.get("2_scramble", "") == "launch_counter_at_sea"
	if "hold_the_beach" in cond:
		return state.choices_made.get("2_scramble", "") == "assign_beach_defense"
	return true

func _init_forces(ctx: Dictionary) -> void:
	if state.flow_type == "offensive":
		state.attacker["community_id"] = "player"
		state.attacker["community_name"] = ctx.get("player_village", "Your Village")
		state.attacker["chief_id"] = "player_chief"
		state.attacker["crew_size"] = 15
		state.attacker["morale"] = 65
		state.attacker["crew_quality"] = 55
		state.attacker["canoe_combat_rating"] = 60
		state.attacker["prestige"] = 200
		state.attacker["conflict_reputation"] = 12
		state.attacker["war_canoe_rating"] = 14
		state.attacker["crest_display"] = 7
		state.attacker["chief_leadership"] = 55
		state.attacker["stamina"] = 70
		state.attacker["named_crew"] = [
			{"id": "gwaay", "name": "Gwaay", "traits": ["veteran"]},
			{"id": "kaahl", "name": "Kaahl", "traits": ["war_singer"]},
			{"id": "naang", "name": "Naang", "traits": []},
		]
		state.attacker["war_traits"] = ["veteran", "war_singer"]

		state.defender["community_id"] = ctx.get("target_village", "enemy").to_lower().replace(" ", "_")
		state.defender["community_name"] = ctx.get("target_village", "Enemy Village")
		state.defender["crew_size"] = 12
		state.defender["morale"] = 55
		state.defender["crew_quality"] = 45
		state.defender["canoe_combat_rating"] = 40
		state.defender["community_size"] = 35
		state.defender["chief_leadership"] = 40
		state.defender["fortification_level"] = 0
		state.defender["named_crew"] = []
	else:
		# Defensive — player is defender
		state.defender["community_id"] = "player"
		state.defender["community_name"] = ctx.get("player_village", "Your Village")
		state.defender["chief_id"] = "player_chief"
		state.defender["crew_size"] = 22
		state.defender["morale"] = 65
		state.defender["crew_quality"] = 55
		state.defender["canoe_combat_rating"] = 55
		state.defender["community_size"] = 50
		state.defender["chief_leadership"] = 55
		state.defender["fortification_level"] = 2
		state.defender["alliance_strength"] = 8
		state.defender["named_crew"] = [
			{"id": "taaydal", "name": "Taaydal", "traits": []},
			{"id": "guudangaay", "name": "Guudangaay", "traits": ["veteran"]},
			{"id": "skil", "name": "Skil", "traits": []},
		]
		state.defender["war_traits"] = ["veteran"]

		state.attacker["community_id"] = ctx.get("attacker_village", "enemy").to_lower().replace(" ", "_")
		state.attacker["community_name"] = ctx.get("attacker_village", "Raiders")
		state.attacker["crew_size"] = 40
		state.attacker["morale"] = 60
		state.attacker["crew_quality"] = 50
		state.attacker["canoe_combat_rating"] = 55
		state.attacker["prestige"] = 180
		state.attacker["conflict_reputation"] = 15
		state.attacker["war_canoe_rating"] = 20
		state.attacker["crest_display"] = 8
		state.attacker["chief_leadership"] = 50
		state.attacker["stamina"] = 65
		state.attacker["named_crew"] = []
		state.attacker["war_traits"] = []

func _feud_base(feud_str: String) -> int:
	match feud_str:
		"ACTIVE_FEUD": return 8
		"BLOOD_FEUD": return 14
		"GRIEVANCE": return 3
		"SMOULDERING": return 1
		_: return 0

func _emit_status() -> void:
	if state:
		status_changed.emit(state.get_status_summary())

func _emit_debug() -> void:
	if state:
		debug_snapshot.emit(state.get_debug_snapshot())
