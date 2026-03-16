# aftermath_processor.gd — Post-Conflict Resolution Processor
# TIDELINES: Cedar, Sea & Legacy

class_name AftermathProcessor
extends RefCounted

## Process the full aftermath of a resolved conflict.  Mutates state in-place.
func process(state: ConflictState) -> Dictionary:
	var result: Dictionary = {}
	var is_attacker_win := state.outcome in ["DECISIVE_VICTORY", "VICTORY"]
	var is_player_attacker := state.flow_type == "offensive"
	var player_won := (is_player_attacker and is_attacker_win) or (not is_player_attacker and not is_attacker_win)

	# --- Casualties ---
	var player_force := state.attacker if is_player_attacker else state.defender
	var enemy_force := state.defender if is_player_attacker else state.attacker
	var player_loss_mod := ConflictEngine.get_loss_modifier(
		state.attacker_tactic if is_player_attacker else state.defender_tactic,
		is_player_attacker
	)
	var cas := ConflictEngine.calculate_casualties(
		state.outcome, player_force.get("crew_size", 15), player_won, player_loss_mod
	)

	# Named casualties
	var named_crew: Array = player_force.get("named_crew", [])
	for i in range(mini(cas["killed"], named_crew.size())):
		var member: Dictionary = named_crew[i]
		state.crew_killed_list.append(member)
		EventBus.crew_member_lost.emit(member.get("id", "unknown"), "killed_in_action")
	for i in range(mini(cas["wounded"], maxi(named_crew.size() - cas["killed"], 0))):
		var idx := cas["killed"] + i
		if idx < named_crew.size():
			var member: Dictionary = named_crew[idx]
			var severity := "light" if randf() < 0.5 else ("moderate" if randf() < 0.75 else "severe")
			member["wound_severity"] = severity
			state.crew_wounded_list.append(member)
			EventBus.crew_member_wounded.emit(member.get("id", "unknown"), severity)

	state.crew_alive = maxi(player_force.get("crew_size", 15) - cas["killed"], 1)
	state.canoe_damage = cas["canoe_damage"]
	result["casualties"] = cas

	# --- Spoils (attacker wins only) ---
	if is_player_attacker and player_won:
		state.spoils = _generate_spoils(state.outcome)
		if state.outcome == "DECISIVE_VICTORY":
			state.canoe_captured = true
			EventBus.canoe_captured.emit(state.id)
	result["spoils"] = state.spoils
	result["canoe_captured"] = state.canoe_captured

	# --- Prestige ---
	var prestige_raw := ConflictEngine._prestige_for_outcome(state.outcome)
	if not is_player_attacker:
		prestige_raw = -prestige_raw   # Defender wins: invert
	state.prestige_change = prestige_raw
	result["prestige_change"] = prestige_raw

	# --- Morale ripple ---
	var morale_delta := 0
	if player_won:
		morale_delta = 20 if state.outcome == "DECISIVE_VICTORY" else 10
	else:
		morale_delta = -25 if state.outcome == "DEVASTATING_DEFEAT" else -15
	state.morale_current = clampi(state.morale_current + morale_delta, 0, 100)
	result["morale_delta"] = morale_delta
	EventBus.morale_changed.emit(state.morale_current, "conflict_aftermath")

	# --- Feud ---
	result["feud_escalation"] = state.feud_escalation_total
	result["feud_state_after"] = state.feud_state_after

	# --- Pole opportunity ---
	if player_won and state.outcome in ["DECISIVE_VICTORY", "VICTORY"]:
		state.pole_opportunity = "war_memorial_pole" if state.outcome == "DECISIVE_VICTORY" else "history_pole"
	result["pole_opportunity"] = state.pole_opportunity

	# --- Song ---
	if state.outcome == "DECISIVE_VICTORY":
		state.song_created = true
		EventBus.battle_song_created.emit({"conflict_id": state.id, "outcome": state.outcome})
	result["song_created"] = state.song_created

	# --- Legacy entry ---
	state.legacy_entry = _build_legacy(state)
	result["legacy_entry"] = state.legacy_entry

	# --- Retaliation clock ---
	var retaliation_turns := 0
	if is_player_attacker and player_won:
		retaliation_turns = 6 if state.outcome == "DECISIVE_VICTORY" else 4
		EventBus.retaliation_expected.emit(
			enemy_force.get("community_id", "unknown"), retaliation_turns
		)
	result["retaliation_turns"] = retaliation_turns

	EventBus.aftermath_completed.emit(state.id, result)
	return result

func _generate_spoils(outcome: String) -> Array[Dictionary]:
	var spoils: Array[Dictionary] = []
	match outcome:
		"DECISIVE_VICTORY":
			spoils.append({"resource": "dried_fish", "amount": 25})
			spoils.append({"resource": "cedar_bark", "amount": 10})
			spoils.append({"resource": "dentalium", "amount": 8})
		"VICTORY":
			spoils.append({"resource": "dried_fish", "amount": 15})
			spoils.append({"resource": "cedar_bark", "amount": 5})
	return spoils

func _build_legacy(state: ConflictState) -> String:
	var target := state.defender.get("community_name", "an enemy village") if state.flow_type == "offensive" else state.attacker.get("community_name", "raiders")
	var verb := "raided" if state.flow_type == "offensive" else "defended against"
	var tone := ""
	match state.outcome:
		"DECISIVE_VICTORY": tone = "A great victory."
		"VICTORY": tone = "The crew returned with honor."
		"STALEMATE": tone = "Neither side could claim victory."
		"DEFEAT": tone = "A bitter retreat."
		"DEVASTATING_DEFEAT": tone = "Many did not return."
	var killed_names := ""
	for k in state.crew_killed_list:
		killed_names += k.get("name", "unnamed") + " "
	var entry := "The village %s %s. %s" % [verb, target, tone]
	if killed_names != "":
		entry += " Lost: %s." % killed_names.strip_edges()
	if state.traits_earned.size() > 0:
		entry += " Traits earned: %s." % ", ".join(state.traits_earned)
	return entry
