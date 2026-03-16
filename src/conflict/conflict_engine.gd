# conflict_engine.gd — Conflict Math Engine
# TIDELINES: Cedar, Sea & Legacy
#
# Stateless calculation functions for intimidation, engagement resolution,
# force scoring, and outcome determination. All methods are static-like
# (operate on passed data, no internal state).

class_name ConflictEngine
extends RefCounted

# ============================================================
# INTIMIDATION
# ============================================================

## Calculate total intimidation score for an attacking force.
static func calculate_intimidation(force: Dictionary) -> int:
	var score := 0
	score += mini(force.get("war_canoe_rating", 0), 25)
	score += mini(force.get("conflict_reputation", 0), 30)
	# Chief trait
	var traits: Array = force.get("chief_traits", [])
	if "fearsome" in traits:
		score += 15
	elif "battle_tested" in traits:
		score += 8
	score += mini(force.get("crest_display", 0), 10)
	score += mini(int(force.get("prestige", 0) / 100.0), 10)
	if force.get("recent_victory_seasons", 99) <= 2:
		score += 10
	if force.get("has_war_song", false):
		score += 5
	return score

## Calculate resolve score for a defending force.
static func calculate_resolve(defender: Dictionary, is_home: bool, fortification: int) -> int:
	var score := 0
	score += clampi(defender.get("community_size", 30), 20, 60)
	score += mini(defender.get("chief_leadership", 0), 15)
	if is_home:
		score += 20
	score += mini(defender.get("alliance_strength", 0), 15)
	if defender.get("recent_victory_seasons", 99) <= 2:
		score += 10
	score += mini(fortification * 5, 15)
	if defender.get("desperate", false):
		score += 15
	return score

## Run a full intimidation check. Returns result dictionary.
static func check_intimidation(attacker: Dictionary, defender: Dictionary,
		is_home: bool, fortification: int, bonus: float = 0.0) -> Dictionary:
	var intim := calculate_intimidation(attacker) + int(bonus)
	var resolve := calculate_resolve(defender, is_home, fortification)
	var delta := intim - resolve

	var result_id := "neutral"
	var defender_morale_pen := 0
	var attacker_morale_pen := 0
	var fled := false
	var negotiate := false

	if delta >= 50:
		result_id = "overwhelming"
		fled = true
	elif delta >= 30:
		result_id = "dominant"
		negotiate = true
	elif delta >= 15:
		result_id = "strong"
		defender_morale_pen = randi_range(15, 25)
	elif delta >= 1:
		result_id = "slight"
		defender_morale_pen = randi_range(5, 10)
	elif delta <= -15:
		result_id = "reversed"
		attacker_morale_pen = randi_range(5, 15)

	return {
		"intimidation_score": intim,
		"resolve_score": resolve,
		"delta": delta,
		"result_id": result_id,
		"defender_fled": fled,
		"negotiation_offered": negotiate,
		"defender_morale_penalty": defender_morale_pen,
		"attacker_morale_penalty": attacker_morale_pen,
	}

# ============================================================
# TACTIC MODIFIERS
# ============================================================

static func get_tactic_modifier(tactic: String, is_attacker: bool) -> float:
	if is_attacker:
		match tactic:
			"overwhelming_assault": return 1.30
			"measured_push": return 1.10
			"feint_and_probe": return 0.80
			"intimidation_display": return 0.50
			"encirclement": return 1.40
			"negotiation_under_arms": return 0.40
			_: return 1.0
	else:
		match tactic:
			"hold_the_beach": return 1.25
			"meet_at_sea": return 1.10
			"fighting_withdrawal": return 0.80
			"concentrated_defense": return 1.40
			"surrender_terms": return 0.10
			_: return 1.0

static func get_loss_modifier(tactic: String, is_attacker: bool) -> float:
	if is_attacker:
		match tactic:
			"overwhelming_assault": return 1.50
			"measured_push": return 1.00
			"feint_and_probe": return 0.60
			"intimidation_display": return 0.20
			"encirclement": return 1.20
			"negotiation_under_arms": return 0.10
			_: return 1.0
	else:
		match tactic:
			"fighting_withdrawal": return 0.60
			"concentrated_defense": return 0.80
			_: return 1.0

# ============================================================
# ROUND SCORING
# ============================================================

## Calculate a single round score for one side.
static func calculate_round_score(force: Dictionary, round_type: String,
		is_attacker: bool, tactic_mod: float, conditions: Dictionary) -> float:
	var score := 0.0

	match round_type:
		"opening":
			score += force.get("morale", 50) * 0.40
			score += force.get("crew_quality", 50) * 0.20
			score += force.get("crew_size", 10) / 20.0 * 100.0 * 0.20
			score += force.get("canoe_combat_rating", 50) * 0.10
			if force.get("blessed", false):
				score *= 1.05
		"sustained":
			score += force.get("crew_quality", 50) * 0.35
			score += force.get("crew_size", 10) / 20.0 * 100.0 * 0.25
			score += force.get("stamina", 50) * 0.20
			score += force.get("chief_leadership", 50) * 0.15
			score += force.get("canoe_combat_rating", 50) * 0.05
		"turning":
			score += force.get("morale", 50) * 0.35
			score += force.get("crew_quality", 50) * 0.25
			score += force.get("chief_leadership", 50) * 0.20
			score *= randf_range(0.80, 1.20)

	score *= tactic_mod

	# Weather advantage
	var side_name := "attacker" if is_attacker else "defender"
	if conditions.get("weather_advantage", "") == side_name:
		score *= 1.10

	# War traits
	for trait_id in force.get("war_traits", []):
		score += _trait_bonus(trait_id, round_type, is_attacker)

	return score

static func _trait_bonus(trait_id: String, round_type: String, is_attacker: bool) -> float:
	match trait_id:
		"veteran": return 3.0
		"shieldbearer": return 5.0 if not is_attacker else 0.0
		"war_singer": return 5.0 if round_type == "turning" else 2.0
		"loyal_to_the_death": return 3.0 if round_type == "turning" else 0.0
		"scarred": return 2.0
		_: return 0.0

# ============================================================
# TURNING POINT EVENTS
# ============================================================

const TURNING_POINT_EVENTS := [
	{"id": "warrior_falls", "text": "A named warrior falls in the fighting.",
	 "atk_bonus": -5, "def_bonus": 10, "triggers_grief": true},
	{"id": "chief_rallies", "text": "The chief rallies the crew with a battle cry.",
	 "atk_bonus": 15, "def_bonus": 0},
	{"id": "canoe_captured", "text": "A canoe is seized in the chaos.",
	 "atk_bonus": 12, "def_bonus": -8},
	{"id": "fire_breaks_out", "text": "Fire erupts — smoke and confusion.",
	 "atk_bonus": -5, "def_bonus": -5},
	{"id": "reinforcements", "text": "Allied canoes appear on the horizon.",
	 "atk_bonus": 0, "def_bonus": 20},
	{"id": "war_song", "text": "A war song rises above the clash.",
	 "atk_bonus": 10, "def_bonus": 0},
	{"id": "fog_rolls_in", "text": "Sudden fog. Both sides lose cohesion.",
	 "atk_bonus": -8, "def_bonus": -3},
	{"id": "champion_duel", "text": "Two warriors face each other between the lines.",
	 "atk_bonus": 8, "def_bonus": 8},
]

static func pick_turning_point() -> Dictionary:
	return TURNING_POINT_EVENTS[randi() % TURNING_POINT_EVENTS.size()]

# ============================================================
# FULL ENGAGEMENT RESOLUTION
# ============================================================

## Resolve a full engagement from a ConflictState. Returns result dict.
static func resolve_engagement(state: ConflictState) -> Dictionary:
	var atk := state.attacker
	var defn := state.defender
	var conditions := {
		"surprise": state.surprise_bonus > 10.0,
		"fortified": state.fortification_active,
		"weather_advantage": state.weather_advantage,
	}

	var atk_mod := get_tactic_modifier(state.attacker_tactic, true)
	var def_mod := get_tactic_modifier(state.defender_tactic, false)

	# Apply intimidation morale adjustments to copies
	var atk_adj := atk.duplicate(true)
	var def_adj := defn.duplicate(true)
	if state.intimidation_delta > 0:
		def_adj["morale"] = maxi(def_adj.get("morale", 50) - state.intimidation_delta / 3, 5)
	elif state.intimidation_delta < 0:
		atk_adj["morale"] = maxi(atk_adj.get("morale", 50) + state.intimidation_delta / 3, 5)

	# Round 1: Opening Clash
	var r1_atk := calculate_round_score(atk_adj, "opening", true, atk_mod, conditions)
	var r1_def := calculate_round_score(def_adj, "opening", false, def_mod, conditions)
	if conditions.get("surprise", false):
		r1_atk *= 1.0 + state.surprise_bonus / 100.0
	if conditions.get("fortified", false):
		r1_def *= 1.20

	var round_1 := {
		"name": "Opening Clash", "atk": r1_atk, "def": r1_def,
		"narrative": "The first clash — momentum vs. fortification."
	}

	# Round 2: Sustained Engagement
	var r2_atk := calculate_round_score(atk_adj, "sustained", true, atk_mod, conditions)
	var r2_def := calculate_round_score(def_adj, "sustained", false, def_mod, conditions)
	var round_2 := {
		"name": "Sustained Engagement", "atk": r2_atk, "def": r2_def,
		"narrative": "Crew quality and leadership decide the middle phase."
	}

	# Round 3: Turning Point
	var tp := pick_turning_point()
	var r3_atk := calculate_round_score(atk_adj, "turning", true, atk_mod, conditions)
	var r3_def := calculate_round_score(def_adj, "turning", false, def_mod, conditions)
	r3_atk += tp.get("atk_bonus", 0)
	r3_def += tp.get("def_bonus", 0)
	var round_3 := {
		"name": "Turning Point", "atk": r3_atk, "def": r3_def,
		"event": tp, "narrative": tp.get("text", "A critical moment.")
	}

	# Final tally
	var total_atk := r1_atk + r2_atk + r3_atk
	var total_def := r1_def + r2_def + r3_def
	total_atk *= randf_range(0.88, 1.12)
	total_def *= randf_range(0.88, 1.12)

	var ratio := total_atk / maxf(total_def, 1.0)
	var outcome := determine_outcome(ratio)

	var rounds_array := [round_1, round_2, round_3]

	return {
		"outcome": outcome,
		"ratio": ratio,
		"attacker_total": total_atk,
		"defender_total": total_def,
		"rounds": rounds_array,
		"turning_point": tp,
		"prestige_shift": _prestige_for_outcome(outcome),
		"narrative_tone": _tone_for_outcome(outcome),
	}

# ============================================================
# OUTCOME DETERMINATION
# ============================================================

static func determine_outcome(ratio: float) -> String:
	if ratio > 1.8: return "DECISIVE_VICTORY"
	elif ratio > 1.3: return "VICTORY"
	elif ratio > 0.85: return "STALEMATE"
	elif ratio > 0.55: return "DEFEAT"
	else: return "DEVASTATING_DEFEAT"

static func _prestige_for_outcome(outcome: String) -> int:
	match outcome:
		"DECISIVE_VICTORY": return 30
		"VICTORY": return 15
		"STALEMATE": return 0
		"DEFEAT": return -15
		"DEVASTATING_DEFEAT": return -30
		_: return 0

static func _tone_for_outcome(outcome: String) -> String:
	match outcome:
		"DECISIVE_VICTORY": return "triumphant"
		"VICTORY": return "satisfied"
		"STALEMATE": return "tense"
		"DEFEAT": return "bitter"
		"DEVASTATING_DEFEAT": return "devastating"
		_: return "neutral"

# ============================================================
# CASUALTY CALCULATION
# ============================================================

## Calculate casualties for one side. Returns {killed, wounded, captured, canoe_damage}.
static func calculate_casualties(outcome: String, crew_size: int,
		is_winner: bool, loss_mod: float) -> Dictionary:
	var base_loss := 0.0
	match outcome:
		"DECISIVE_VICTORY":
			base_loss = 0.05 if is_winner else 0.35
		"VICTORY":
			base_loss = 0.12 if is_winner else 0.25
		"STALEMATE":
			base_loss = 0.10
		"DEFEAT":
			base_loss = 0.25 if not is_winner else 0.10
		"DEVASTATING_DEFEAT":
			base_loss = 0.45 if not is_winner else 0.05

	base_loss *= loss_mod
	base_loss *= randf_range(0.7, 1.3)
	base_loss = clampf(base_loss, 0.0, 0.60)

	var total_hit := int(crew_size * base_loss)
	var killed := int(total_hit * randf_range(0.2, 0.4))
	var wounded := total_hit - killed
	var captured := 0
	if not is_winner and outcome in ["DEFEAT", "DEVASTATING_DEFEAT"]:
		captured = maxi(1, int(total_hit * 0.15))
		wounded -= captured

	var canoe_dmg := 0.0
	if outcome == "DEVASTATING_DEFEAT" and not is_winner:
		canoe_dmg = randf_range(0.3, 0.7)
	elif outcome in ["DEFEAT"] and not is_winner:
		canoe_dmg = randf_range(0.1, 0.3)
	elif not is_winner:
		canoe_dmg = randf_range(0.0, 0.15)

	return {
		"killed": maxi(killed, 0),
		"wounded": maxi(wounded, 0),
		"captured": maxi(captured, 0),
		"canoe_damage": canoe_dmg,
	}
