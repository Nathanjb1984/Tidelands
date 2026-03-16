# data_loader.gd — JSON Data Loading System
# TIDELINES: Cedar, Sea & Legacy
#
# Loads and caches all data-driven content from JSON files.
# Register as an autoload for global access to game data.

extends Node

# ============================================================
# CACHED DATA
# ============================================================

var canoe_types: Array = []
var canoe_upgrades: Array = []
var buildings: Array = []
var chiefs: Array = []
var moieties: Dictionary = {}
var crests: Array = []
var pole_types: Array = []
var eras: Array = []
var balance: Dictionary = {}
var events: Dictionary = {}   # Keyed by category, each is an Array of events

# Conflict system data
var conflict_types: Array = []
var raid_objectives: Dictionary = {}
var feud_system: Dictionary = {}
var war_traits: Dictionary = {}
var intimidation_data: Dictionary = {}
var engagement_tactics: Dictionary = {}
var conflict_outcomes: Array = []
var morale_data: Dictionary = {}
var defensive_preparations: Dictionary = {}
var era_conflict_scaling: Dictionary = {}
var raid_flows: Dictionary = {}

# Lookup dictionaries for fast access by ID
var _canoe_by_id: Dictionary = {}
var _building_by_id: Dictionary = {}
var _chief_by_id: Dictionary = {}
var _crest_by_id: Dictionary = {}
var _pole_type_by_id: Dictionary = {}
var _era_by_id: Dictionary = {}
var _event_by_id: Dictionary = {}
var _conflict_type_by_id: Dictionary = {}
var _outcome_by_id: Dictionary = {}

# ============================================================
# LOADING
# ============================================================

const DATA_PATH := "res://data/"

func _ready() -> void:
	load_all_data()

## Load all game data from JSON files.
func load_all_data() -> void:
	print("[DataLoader] Loading game data...")
	
	# Load canoes
	var canoe_data = _load_json("canoes.json")
	if canoe_data:
		canoe_types = canoe_data.get("canoe_types", [])
		canoe_upgrades = canoe_data.get("canoe_upgrades", [])
		_build_lookup(_canoe_by_id, canoe_types)
		print("[DataLoader]   Canoes: %d types, %d upgrades" % [canoe_types.size(), canoe_upgrades.size()])
	
	# Load buildings
	var building_data = _load_json("buildings.json")
	if building_data:
		buildings = building_data.get("buildings", [])
		_build_lookup(_building_by_id, buildings)
		print("[DataLoader]   Buildings: %d types" % buildings.size())
	
	# Load chiefs
	var chief_data = _load_json("chiefs.json")
	if chief_data:
		chiefs = chief_data.get("chiefs", [])
		_build_lookup(_chief_by_id, chiefs)
		print("[DataLoader]   Chiefs: %d archetypes" % chiefs.size())
	
	# Load crests and moieties
	var crest_data = _load_json("crests.json")
	if crest_data:
		moieties = crest_data.get("moieties", {})
		crests = crest_data.get("crests", [])
		pole_types = crest_data.get("pole_types", [])
		_build_lookup(_crest_by_id, crests)
		_build_lookup(_pole_type_by_id, pole_types)
		print("[DataLoader]   Moieties: %d, Crests: %d, Pole types: %d" % [moieties.size(), crests.size(), pole_types.size()])
	
	# Load eras
	var era_data = _load_json("eras.json")
	if era_data:
		eras = era_data.get("eras", [])
		balance = era_data.get("balance_constants", {})
		_build_lookup(_era_by_id, eras, "id")
		print("[DataLoader]   Eras: %d, Balance constants: %d" % [eras.size(), balance.size()])
	
	# Load conflict system data
	var conflict_data = _load_json("conflict.json")
	if conflict_data:
		conflict_types = conflict_data.get("conflict_types", [])
		raid_objectives = conflict_data.get("raid_objectives", {})
		feud_system = conflict_data.get("feud_system", {})
		war_traits = conflict_data.get("war_traits", {})
		intimidation_data = conflict_data.get("intimidation", {})
		engagement_tactics = conflict_data.get("engagement_tactics", {})
		conflict_outcomes = conflict_data.get("outcomes", [])
		morale_data = conflict_data.get("morale", {})
		defensive_preparations = conflict_data.get("defensive_preparations", {})
		era_conflict_scaling = conflict_data.get("era_conflict_scaling", {})
		_build_lookup(_conflict_type_by_id, conflict_types)
		_build_lookup(_outcome_by_id, conflict_outcomes)
		print("[DataLoader]   Conflict: %d types, %d outcomes" % [conflict_types.size(), conflict_outcomes.size()])

	# Load raid flows
	var flow_data = _load_json("events/raid_flows.json")
	if flow_data:
		raid_flows = flow_data
		print("[DataLoader]   Raid flows: offensive=%s, defensive=%s" % [
			"loaded" if flow_data.has("offensive_raid_flow") else "missing",
			"loaded" if flow_data.has("defensive_raid_flow") else "missing"
		])

	# Load events (from events/ subdirectory)
	_load_events()
	
	print("[DataLoader] All data loaded successfully.")

## Load event files from the events subdirectory.
func _load_events() -> void:
	var event_dir = DATA_PATH + "events/"
	var dir = DirAccess.open(event_dir)
	if dir == null:
		print("[DataLoader]   WARNING: Could not open events directory: %s" % event_dir)
		return
	
	var event_count := 0
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".json"):
			var event_file_data = _load_json("events/" + file_name)
			if event_file_data and event_file_data.has("events"):
				for event in event_file_data["events"]:
					var category = event.get("category", "general")
					if not events.has(category):
						events[category] = []
					events[category].append(event)
					
					# Add to ID lookup
					var event_id = event.get("id", "")
					if event_id != "":
						_event_by_id[event_id] = event
					
					event_count += 1
		file_name = dir.get_next()
	dir.list_dir_end()
	
	print("[DataLoader]   Events: %d across %d categories" % [event_count, events.size()])

# ============================================================
# LOOKUP FUNCTIONS
# ============================================================

## Get a canoe type by its ID.
func get_canoe(canoe_id: String) -> Dictionary:
	return _canoe_by_id.get(canoe_id, {})

## Get a building type by its ID.
func get_building(building_id: String) -> Dictionary:
	return _building_by_id.get(building_id, {})

## Get a chief archetype by its ID.
func get_chief(chief_id: String) -> Dictionary:
	return _chief_by_id.get(chief_id, {})

## Get a crest by its ID.
func get_crest(crest_id: String) -> Dictionary:
	return _crest_by_id.get(crest_id, {})

## Get a pole type by its ID.
func get_pole_type(pole_type_id: String) -> Dictionary:
	return _pole_type_by_id.get(pole_type_id, {})

## Get an era by its numeric ID.
func get_era(era_id: int) -> Dictionary:
	return _era_by_id.get(era_id, {})

## Get a specific event by its ID.
func get_event(event_id: String) -> Dictionary:
	return _event_by_id.get(event_id, {})

## Get all events for a given category.
func get_events_by_category(category: String) -> Array:
	return events.get(category, [])

## Get all events matching given tags.
func get_events_by_tag(tag: String) -> Array:
	var result: Array = []
	for event in _event_by_id.values():
		if tag in event.get("tags", []):
			result.append(event)
	return result

## Get a moiety definition.
func get_moiety(moiety_id: String) -> Dictionary:
	return moieties.get(moiety_id, {})

## Get all crests available to a given moiety.
func get_crests_for_moiety(moiety_id: String) -> Array:
	var result: Array = []
	for crest in crests:
		if crest.get("moiety", "") == moiety_id or crest.get("moiety", "") == "BOTH":
			result.append(crest)
	return result

## Get a balance constant with a default value.
func get_balance(key: String, default: Variant = 0) -> Variant:
	return balance.get(key, default)

## Get a conflict type by ID.
func get_conflict_type(type_id: String) -> Dictionary:
	return _conflict_type_by_id.get(type_id, {})

## Get a raid flow by type ("offensive" or "defensive").
func get_raid_flow(flow_type: String) -> Dictionary:
	match flow_type:
		"offensive": return raid_flows.get("offensive_raid_flow", {})
		"defensive": return raid_flows.get("defensive_raid_flow", {})
		_: return {}

## Get an engagement tactic definition.
func get_engagement_tactic(tactic_id: String, is_attacker: bool) -> Dictionary:
	var side = "attacker" if is_attacker else "defender"
	for tactic in engagement_tactics.get(side, []):
		if tactic.get("id", "") == tactic_id:
			return tactic
	return {}

## Get outcome definition by ID.
func get_outcome_data(outcome_id: String) -> Dictionary:
	return _outcome_by_id.get(outcome_id, {})

## Get a feud state definition by ID.
func get_feud_state_def(state_id: String) -> Dictionary:
	for state in feud_system.get("states", []):
		if state.get("id", "") == state_id:
			return state
	return {}

## Get all attacker or defender tactics.
func get_tactics(is_attacker: bool) -> Array:
	return engagement_tactics.get("attacker" if is_attacker else "defender", [])

# ============================================================
# INTERNAL HELPERS
# ============================================================

## Load and parse a JSON file. Returns null on failure.
func _load_json(relative_path: String) -> Variant:
	var full_path = DATA_PATH + relative_path
	
	if not FileAccess.file_exists(full_path):
		print("[DataLoader]   WARNING: File not found: %s" % full_path)
		return null
	
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file == null:
		print("[DataLoader]   ERROR: Could not open: %s" % full_path)
		return null
	
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		print("[DataLoader]   ERROR: JSON parse failed in %s at line %d: %s" % [
			relative_path, json.get_error_line(), json.get_error_message()
		])
		return null
	
	return json.data

## Build a lookup dictionary from an array of objects with an 'id' field.
func _build_lookup(lookup: Dictionary, data_array: Array, id_field: String = "id") -> void:
	lookup.clear()
	for item in data_array:
		var key = item.get(id_field, "")
		if key != "":
			lookup[key] = item
