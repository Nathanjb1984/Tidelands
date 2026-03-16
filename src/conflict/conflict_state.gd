# conflict_state.gd — Runtime state for one active conflict operation
# TIDELINES: Cedar, Sea & Legacy
#
# Holds all mutable state for a conflict flowing through the 6 phases.
# Created by ConflictFlowController, passed to engine subsystems.

class_name ConflictState
extends RefCounted

# ============================================================
# IDENTITY
# ============================================================

var id: String = ""
var flow_type: String = ""            # "offensive" or "defensive"
var flow_data: Dictionary = {}        # Full raid flow JSON
var conflict_type_id: String = ""     # e.g. "offensive_raid", "defensive_village_raid"

# ============================================================
# PHASE TRACKING
# ============================================================

var phases: Array = []
var current_phase_index: int = -1
var sub_step: int = 0                 # Sub-step within multi-part phases
var choices_made: Dictionary = {}     # phase_id -> choice_id
var phase_log: Array[Dictionary] = [] # {phase, choice, effects, narrative}

# ============================================================
# FORCES — Attacker & Defender stat blocks
# ============================================================

var attacker: Dictionary = {
	"community_id": "",
	"community_name": "",
	"chief_id": "",
	"chief_traits": [],
	"crew_size": 15,
	"crew_quality": 55,
	"morale": 60,
	"stamina": 70,
	"canoe_combat_rating": 60,
	"prestige": 200,
	"conflict_reputation": 10,
	"war_canoe_rating": 12,
	"crest_display": 6,
	"chief_leadership": 50,
	"recent_victory_seasons": 99,
	"has_war_song": false,
	"blessed": false,
	"war_traits": [],
	"named_crew": []
}

var defender: Dictionary = {
	"community_id": "",
	"community_name": "",
	"chief_id": "",
	"chief_traits": [],
	"crew_size": 12,
	"crew_quality": 45,
	"morale": 60,
	"stamina": 65,
	"canoe_combat_rating": 40,
	"canoe_count": 3,
	"prestige": 150,
	"community_size": 35,
	"chief_leadership": 40,
	"fortification_level": 0,
	"alliance_strength": 5,
	"alert_level": 0,
	"recent_victory_seasons": 99,
	"desperate": false,
	"war_traits": [],
	"named_crew": []
}

# ============================================================
# ACCUMULATED MODIFIERS (built across phases)
# ============================================================

var surprise_bonus: float = 0.0
var stealth_bonus: float = 0.0
var intimidation_bonus: float = 0.0
var intel_quality: String = "VAGUE"
var weather_advantage: String = ""     # "attacker", "defender", or ""
var fortification_active: bool = false
var ambush_enabled: bool = false
var flanking_active: bool = false
var approach_time: String = "dawn"
var formation: String = "single"

# ============================================================
# ENGAGEMENT — set during phases 3-4
# ============================================================

var attacker_tactic: String = "measured_push"
var defender_tactic: String = "hold_the_beach"

# ============================================================
# RESOLUTION RESULTS
# ============================================================

var rounds: Array[Dictionary] = []
var turning_point: Dictionary = {}
var outcome: String = ""               # "DECISIVE_VICTORY", "VICTORY", etc.
var outcome_ratio: float = 1.0
var attacker_score_total: float = 0.0
var defender_score_total: float = 0.0

# ============================================================
# TRACKING — changes during the operation
# ============================================================

var morale_current: int = 60
var crew_alive: int = 15
var crew_wounded_list: Array[Dictionary] = []
var crew_killed_list: Array[Dictionary] = []
var crew_captured_list: Array[Dictionary] = []
var canoe_damage: float = 0.0
var canoe_captured: bool = false
var prestige_change: int = 0
var spoils: Array[Dictionary] = []
var captives_taken: int = 0

# ============================================================
# FEUD & TRAITS
# ============================================================

var feud_escalation_total: int = 0
var feud_state_before: String = ""
var feud_state_after: String = ""
var traits_earned: Array[String] = []

# ============================================================
# LEGACY
# ============================================================

var legacy_entry: String = ""
var pole_opportunity: String = ""
var song_created: bool = false

# ============================================================
# INTIMIDATION CHECK RESULTS
# ============================================================

var intimidation_score: int = 0
var resolve_score: int = 0
var intimidation_delta: int = 0
var intimidation_result: String = ""   # "overwhelming", "dominant", "strong", etc.
var defender_fled: bool = false
var negotiation_offered: bool = false

# ============================================================
# HELPERS
# ============================================================

func get_current_phase() -> Dictionary:
	if current_phase_index >= 0 and current_phase_index < phases.size():
		return phases[current_phase_index]
	return {}

func get_phase_id() -> String:
	return get_current_phase().get("phase", "unknown")

func record_choice(phase_id: String, choice_id: String, effects: Array, narrative: String) -> void:
	choices_made[phase_id] = choice_id
	phase_log.append({
		"phase": phase_id,
		"choice": choice_id,
		"effects": effects,
		"narrative": narrative
	})

func get_status_summary() -> Dictionary:
	return {
		"morale": morale_current,
		"crew_alive": crew_alive,
		"crew_wounded": crew_wounded_list.size(),
		"crew_killed": crew_killed_list.size(),
		"canoe_damage": canoe_damage,
		"prestige_change": prestige_change,
		"feud_escalation": feud_escalation_total,
		"outcome": outcome,
		"traits_earned": traits_earned,
		"intel_quality": intel_quality,
		"intimidation_delta": intimidation_delta,
	}

func get_debug_snapshot() -> Dictionary:
	return {
		"phase": get_phase_id(),
		"attacker_morale": attacker.get("morale", 0),
		"defender_morale": defender.get("morale", 0),
		"surprise": surprise_bonus,
		"stealth": stealth_bonus,
		"intim_score": intimidation_score,
		"resolve_score": resolve_score,
		"intim_delta": intimidation_delta,
		"intim_result": intimidation_result,
		"atk_tactic": attacker_tactic,
		"def_tactic": defender_tactic,
		"atk_total": attacker_score_total,
		"def_total": defender_score_total,
		"ratio": outcome_ratio,
		"outcome": outcome,
		"rounds": rounds,
		"feud_esc": feud_escalation_total,
		"traits": traits_earned,
		"spoils": spoils,
		"prestige": prestige_change,
	}
