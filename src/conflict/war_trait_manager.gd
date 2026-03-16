# war_trait_manager.gd — Character Progression Through Conflict
# TIDELINES: Cedar, Sea & Legacy

class_name WarTraitManager
extends RefCounted

# chief_id -> {total, wins, decisive_wins, losses, offensive_raids, village_defenses, sea_wins, feuds_resolved}
var chief_logs: Dictionary = {}
# character_id -> [trait_ids]
var character_traits: Dictionary = {}

func record_conflict(chief_id: String, state: ConflictState) -> Array[String]:
	if not chief_logs.has(chief_id):
		chief_logs[chief_id] = _new_log()
	var log: Dictionary = chief_logs[chief_id]
	log["total"] += 1

	var win := state.outcome in ["DECISIVE_VICTORY", "VICTORY"]
	var decisive := state.outcome == "DECISIVE_VICTORY"
	if win:
		log["wins"] += 1
	if decisive:
		log["decisive_wins"] += 1
	if state.outcome in ["DEFEAT", "DEVASTATING_DEFEAT"]:
		log["losses"] += 1
	if state.flow_type == "offensive":
		log["offensive_raids"] += 1
	if state.flow_type == "defensive":
		log["village_defenses"] += 1

	return _evaluate_chief(chief_id, log, state)

func _evaluate_chief(chief_id: String, log: Dictionary, state: ConflictState) -> Array[String]:
	var awarded: Array[String] = []
	var existing: Array = character_traits.get(chief_id, [])

	if log["total"] >= 3 and "battle_tested" not in existing:
		awarded.append("battle_tested")
	if log["decisive_wins"] >= 3 and "fearsome" not in existing:
		awarded.append("fearsome")
	if log["offensive_raids"] >= 3 and "raider" not in existing:
		awarded.append("raider")
	if log["village_defenses"] >= 2 and "defender_of_the_people" not in existing:
		awarded.append("defender_of_the_people")
	if state.outcome == "DEVASTATING_DEFEAT" and state.attacker_tactic == "overwhelming_assault":
		if "reckless" not in existing:
			awarded.append("reckless")
	if state.crew_killed_list.size() > 0 and "grief_hardened" not in existing:
		awarded.append("grief_hardened")

	for t in awarded:
		if not existing.has(t):
			existing.append(t)
		EventBus.war_trait_earned.emit(chief_id, t)

	character_traits[chief_id] = existing
	return awarded

func has_trait(character_id: String, trait_id: String) -> bool:
	return trait_id in character_traits.get(character_id, [])

func get_traits(character_id: String) -> Array:
	return character_traits.get(character_id, [])

func _new_log() -> Dictionary:
	return {
		"total": 0, "wins": 0, "decisive_wins": 0, "losses": 0,
		"offensive_raids": 0, "village_defenses": 0, "sea_wins": 0,
		"feuds_resolved": 0,
	}
