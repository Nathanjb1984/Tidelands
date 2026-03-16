# event_bus.gd — Global Event Bus (Autoload Singleton)
# TIDELINES: Cedar, Sea & Legacy
#
# Central signal hub for decoupled system communication.
# Register this as an autoload in Project Settings → AutoLoad.
# All systems emit and listen to signals through this bus.

extends Node

# ============================================================
# CORE GAME SIGNALS
# ============================================================

## Emitted when a new season begins.
signal season_changed(new_season: String, year: int)

## Emitted when the game transitions to a new historical era.
signal era_changed(new_era: int, era_data: Dictionary)

## Emitted at the end of each player turn after all resolution.
signal turn_ended(turn_number: int)

## Emitted when the game is saved or loaded.
signal game_saved(slot: int)
signal game_loaded(slot: int)

# ============================================================
# VILLAGE SIGNALS
# ============================================================

## Emitted when any resource amount changes.
signal resource_changed(resource_type: String, amount: int, total: int)

## Emitted when a building is completed or upgraded.
signal building_completed(building_data: Dictionary)

## Emitted when village population changes (birth, death, migration).
signal population_changed(delta: int, total: int, reason: String)

## Emitted when labor is reassigned.
signal labor_assigned(person_id: String, role: String)

## Emitted when food status crosses a threshold (surplus/adequate/shortage/starvation).
signal food_status_changed(new_status: String)

# ============================================================
# NAVIGATION SIGNALS
# ============================================================

## Emitted when a canoe departs on a voyage.
signal voyage_started(canoe_id: String, destination: String, crew: Array)

## Emitted when a voyage reaches its destination or returns home.
signal voyage_completed(canoe_id: String, outcome: Dictionary)

## Emitted when weather changes during navigation.
signal weather_changed(new_weather: String, severity: int)

## Emitted when the tidal cycle advances.
signal tide_changed(new_tide: String)

## Emitted when a new location is discovered on the map.
signal location_discovered(location_id: String, location_data: Dictionary)

## Emitted when an encounter occurs during navigation.
signal sea_encounter(encounter_data: Dictionary)

## Emitted when a canoe takes damage.
signal canoe_damaged(canoe_id: String, damage_amount: int, new_condition: float)

## Emitted when a canoe is completed (construction finished).
signal canoe_built(canoe_data: Dictionary)

# ============================================================
# SOCIAL / PRESTIGE SIGNALS
# ============================================================

## Emitted when prestige score changes.
signal prestige_changed(delta: int, total: int, source: String)

## Emitted when a new alliance is formed with another village.
signal alliance_formed(ally_id: String, alliance_type: String)

## Emitted when an alliance breaks down.
signal alliance_broken(ally_id: String, reason: String)

## Emitted when a marriage is completed.
signal marriage_completed(person_a: String, person_b: String, alliance_data: Dictionary)

## Emitted when the current chief dies.
signal chief_died(chief_data: Dictionary)

## Emitted when succession process begins.
signal succession_started(candidates: Array)

## Emitted when a new chief is selected.
signal succession_completed(new_chief: Dictionary)

## Emitted when a diplomatic relationship changes.
signal relationship_changed(village_id: String, old_standing: int, new_standing: int)

# ============================================================
# CEREMONY SIGNALS
# ============================================================

## Emitted when potlatch preparation begins.
signal potlatch_started(potlatch_data: Dictionary)

## Emitted when a potlatch ceremony concludes.
signal potlatch_completed(results: Dictionary)

## Emitted when a pole is commissioned (carving begins).
signal pole_commissioned(pole_data: Dictionary)

## Emitted when a pole carving is finished.
signal pole_completed(pole_data: Dictionary)

## Emitted when a pole-raising ceremony occurs.
signal pole_raised(pole_data: Dictionary)

## Emitted when a blessing is received.
signal blessing_received(blessing_type: String, target: String, duration: int)

# ============================================================
# CONFLICT & RAID SIGNALS
# ============================================================

## Emitted when a conflict operation begins (any type).
signal conflict_started(conflict_data: Dictionary)

## Emitted when the final resolution of a conflict is determined.
signal conflict_resolved(results: Dictionary)

## Emitted when raiders are detected approaching the village.
signal raid_incoming(attacker_data: Dictionary, warning_turns: int)

## Emitted when morale changes significantly.
signal morale_changed(new_morale: int, reason: String)

## Emitted when scouting/intelligence gathering is completed before a raid.
signal scouting_completed(conflict_id: String, intel: Dictionary)

## Emitted when an intimidation check succeeds (opponent flees, negotiates, or takes morale penalty).
signal intimidation_success(conflict_id: String, effect_type: String)

## Emitted when the engagement phase begins with the chosen tactic.
signal engagement_begun(conflict_id: String, tactic: String)

## Emitted when a turning point event fires during engagement resolution.
signal turning_point_triggered(conflict_id: String, event_data: Dictionary)

## Emitted after the withdrawal/pursuit phase completes.
signal withdrawal_completed(conflict_id: String, withdrawal_data: Dictionary)

## Emitted when all aftermath processing is done (casualties, spoils, feud updates).
signal aftermath_completed(conflict_id: String, aftermath_data: Dictionary)

## Emitted when a named crew member is killed in action.
signal crew_member_lost(character_id: String, cause: String)

## Emitted when a named crew member is wounded.
signal crew_member_wounded(character_id: String, severity: String)

## Emitted when a named crew member is captured by the enemy.
signal crew_member_captured(character_id: String)

## Emitted when an enemy canoe is captured during a raid.
signal canoe_captured(conflict_id: String)

## Emitted when a feud state changes (new feud, escalation, de-escalation).
signal feud_state_changed(feud_key: String, feud_data: Dictionary)

## Emitted when a feud is inherited by a new chief after succession.
signal feud_inherited(feud_key: String, feud_data: Dictionary)

## Emitted when a feud is formally resolved through ceremony/diplomacy.
signal feud_resolved(feud_key: String, feud_data: Dictionary)

## Emitted when a retaliation raid is expected (timer started).
signal retaliation_expected(target_community: String, turns_until: int)

## Emitted when a character earns a war trait through conflict experience.
signal war_trait_earned(character_id: String, trait_id: String)

## Emitted when a battle song is composed after a great victory.
signal battle_song_created(song_data: Dictionary)

## Emitted when a fallen warrior becomes an ancestral memory (dream trigger).
signal ancestral_memory_registered(character_id: String, memory_data: Dictionary)

# ============================================================
# EVENT SYSTEM SIGNALS
# ============================================================

## Emitted when an event is triggered from the event system.
signal event_triggered(event_data: Dictionary)

## Emitted when the player makes a choice in an event.
signal event_choice_made(event_id: String, choice_index: int, effects: Array)

## Emitted when an omen is received.
signal omen_received(omen_data: Dictionary)

## Emitted when a dream sequence starts (winter inter-season).
signal dream_started(dream_data: Dictionary)

## Emitted when a game state flag is set.
signal flag_set(flag_name: String, value: Variant)

# ============================================================
# UI SIGNALS
# ============================================================

## Emitted when a screen transition is requested.
signal screen_transition_requested(target_screen: String, transition_data: Dictionary)

## Emitted when a notification should be shown to the player.
signal notification_requested(message: String, category: String, duration: float)

## Emitted when the player opens/closes the pause menu.
signal pause_toggled(is_paused: bool)
