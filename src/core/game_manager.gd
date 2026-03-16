# game_manager.gd — Master Game State Controller
# TIDELINES: Cedar, Sea & Legacy
#
# Central game state manager. Tracks current era, season, turn,
# and coordinates between all subsystems via the EventBus.

extends Node

# ============================================================
# CONSTANTS
# ============================================================

enum Season { SPRING, SUMMER, AUTUMN, WINTER }
enum GamePhase { VILLAGE, NAVIGATION, CEREMONY, CONFLICT, EVENT, TRANSITION }

const TURNS_PER_SEASON := 3
const SEASONS_PER_YEAR := 4

# ============================================================
# STATE
# ============================================================

var current_era: int = 1
var current_year: int = 1
var current_season: Season = Season.SPRING
var current_turn: int = 1       # Turn within the season (1..TURNS_PER_SEASON)
var total_turns: int = 0        # Total turns elapsed in the campaign

var current_phase: GamePhase = GamePhase.VILLAGE
var is_paused: bool = false

# Sub-manager references (set during _ready via scene tree)
var village_manager: Node = null
var navigation_manager: Node = null
var event_manager: Node = null
var era_manager: Node = null
var save_manager: Node = null

# Game flags — persistent state flags set by events
var flags: Dictionary = {}

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	# Connect to EventBus signals we need to monitor
	EventBus.event_choice_made.connect(_on_event_choice_made)
	EventBus.flag_set.connect(_on_flag_set)
	EventBus.pause_toggled.connect(_on_pause_toggled)
	
	print("[GameManager] Initialized. Era %d, Year %d, %s" % [current_era, current_year, Season.keys()[current_season]])

# ============================================================
# TURN FLOW
# ============================================================

## Called when the player ends their action phase.
func end_turn() -> void:
	if is_paused:
		return
	
	total_turns += 1
	
	# Resolution phase
	_resolve_turn()
	
	# Advance turn counter
	current_turn += 1
	
	# Check for season transition
	if current_turn > TURNS_PER_SEASON:
		_advance_season()
	
	# Emit turn ended
	EventBus.turn_ended.emit(total_turns)

## Resolve all end-of-turn effects.
func _resolve_turn() -> void:
	# 1. Construction progress
	# 2. Carving progress
	# 3. Voyage progress (if canoes in transit)
	# 4. Food consumption
	# 5. Event resolution
	# 6. Relationship drift
	# 7. Random event check
	pass  # TODO: Each subsystem handles its own resolution via signals

## Advance to the next season. Check for year and era transitions.
func _advance_season() -> void:
	current_turn = 1
	
	var old_season = current_season
	current_season = (current_season + 1) % SEASONS_PER_YEAR as Season
	
	# Year transition
	if current_season == Season.SPRING:
		_advance_year()
	
	EventBus.season_changed.emit(Season.keys()[current_season], current_year)
	print("[GameManager] Season: %s, Year %d" % [Season.keys()[current_season], current_year])

## Advance to a new year. Apply yearly effects.
func _advance_year() -> void:
	current_year += 1
	
	# Apply prestige decay
	# Apply population growth
	# Apply alliance drift
	# Check era transition conditions
	_check_era_transition()

## Check if conditions are met to transition to the next era.
func _check_era_transition() -> void:
	# This will be driven by era_manager checking against eras.json data
	# For now, placeholder logic
	if era_manager:
		pass  # era_manager.check_transition(current_era, current_year, get_game_state())

## Transition to a new era. Major game event.
func transition_era(new_era: int, era_data: Dictionary) -> void:
	var old_era = current_era
	current_era = new_era
	
	EventBus.era_changed.emit(new_era, era_data)
	print("[GameManager] === ERA TRANSITION: Era %d → Era %d ===" % [old_era, new_era])

# ============================================================
# GAME STATE
# ============================================================

## Returns a snapshot of the current game state for save/load or condition checking.
func get_game_state() -> Dictionary:
	return {
		"era": current_era,
		"year": current_year,
		"season": Season.keys()[current_season],
		"turn": current_turn,
		"total_turns": total_turns,
		"phase": GamePhase.keys()[current_phase],
		"flags": flags.duplicate()
	}

## Set a game state flag (used by event system).
func set_flag(flag_name: String, value: Variant = true) -> void:
	flags[flag_name] = value
	EventBus.flag_set.emit(flag_name, value)

## Check if a flag is set.
func has_flag(flag_name: String) -> bool:
	return flags.has(flag_name) and flags[flag_name]

## Get a flag value with a default.
func get_flag(flag_name: String, default: Variant = null) -> Variant:
	return flags.get(flag_name, default)

# ============================================================
# PHASE MANAGEMENT
# ============================================================

## Switch to a new game phase (e.g., VILLAGE → NAVIGATION).
func set_phase(new_phase: GamePhase) -> void:
	var old_phase = current_phase
	current_phase = new_phase
	
	EventBus.screen_transition_requested.emit(
		GamePhase.keys()[new_phase],
		{"from": GamePhase.keys()[old_phase]}
	)

# ============================================================
# SIGNAL HANDLERS
# ============================================================

func _on_event_choice_made(event_id: String, choice_index: int, effects: Array) -> void:
	# Process event effects
	for effect in effects:
		match effect.get("type", ""):
			"SET_FLAG":
				set_flag(effect.get("flag", ""), effect.get("value", true))
			"PRESTIGE":
				EventBus.prestige_changed.emit(
					effect.get("amount", 0), 0, effect.get("reason", "Event")
				)
			# Other effect types handled by their respective managers

func _on_flag_set(flag_name: String, value: Variant) -> void:
	flags[flag_name] = value

func _on_pause_toggled(paused: bool) -> void:
	is_paused = paused
