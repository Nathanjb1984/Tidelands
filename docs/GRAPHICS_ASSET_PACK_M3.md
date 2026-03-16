# TIDELINES — GRAPHICS ASSET PACK M3

## Hostile Settlement Frontage Specification

**Date:** March 15, 2026  
**Status:** Draft for production planning

---

# 1. PURPOSE

This pack defines the hostile-side settlement family for Graphics 2.0.

Milestone 3 separates enemy-shore identity from home-shore identity so encounter and battle scenes stop reusing friendly settlement language.

The pack focuses on silhouettes that communicate watchfulness, tension, and territorial resistance while remaining readable in the current web prototype.

---

# 2. INCLUDED FAMILIES

## Family A — Hostile Longhouses

### Required Variants
- `longhouse_hostile`
- future `longhouse_hostile_burning`
- future `longhouse_hostile_ruined`

### Current Usage Targets
- `HostileShore`
- `EncounterScene`
- background hostile shoreline staging in `BattleScene`

### Notes
- roofline should feel related to the broader coastal world but darker and less welcoming
- hostile reads should come from shape, tone, and frontage treatment, not cartoon villain cues
- ember and smoke remain runtime overlays where possible

---

## Family B — Watch / Threat Poles

### Required Variants
- `pole_hostile_watch`
- future `pole_hostile_trophy`
- future `pole_hostile_memorial`

### Current Usage Targets
- `HostileShore`
- hostile battle backdrop
- future escalation states in encounter and resolution scenes

### Notes
- poles should feel sharper and more severe than home ceremonial poles
- accent tones should favor ember-red over gold
- silhouettes must remain legible at reduced scale and in fog

---

## Family C — Shoreline Frontage

### Required Variants
- `hostile_frontage`
- future `hostile_frontage_breached`
- future `hostile_frontage_burning`

### Current Usage Targets
- `HostileShore`
- `BattleScene`
- future resolution/beach-assault staging

### Notes
- frontage should imply defended territory and shoreline preparation
- should support layering with warriors, debris, smoke, and impact effects
- must not overwhelm the central action read

---

# 3. RUNTIME GUIDANCE

## Composition Rules
- keep hostile families behind or beside the main action plane
- use shared hostile helpers instead of inline bespoke scene geometry
- separate structure silhouettes from fire, smoke, pulses, and glow overlays

## Mood Control
- encounter should read tense and watchful
- battle should read pressured, damaged, and outcome-responsive
- reuse should come from staging and overlays, not duplicated art families

---

# 4. READABILITY RULES

- enemy frontage must stay readable against dark encounter and battle skies
- hostile silhouettes should remain distinct from home silhouettes even at small scale
- red accents should signal danger without muddying the scene into flat brown-black mass
- atmosphere should deepen emotion, not hide the narrative landmarks

---

# 5. IMPLEMENTATION ORDER

1. hostile longhouse base silhouette
2. hostile watch pole silhouette
3. shoreline frontage / rack silhouette
4. burning and breached hostile variants
5. outcome-specific hostile settlement states

---

# 6. NEXT TARGETS AFTER M3

- resolution-scene hostile beach modules
- dedicated assault-state and aftermath-state enemy frontage variants
- higher-fidelity war canoe figure families for close confrontation scenes
- reusable ember / spark / smoke FX sheets for battle escalation

---

# 7. DONE DEFINITION

The pack is ready when encounter and battle scenes can stage hostile territory through dedicated enemy asset families and shared helpers instead of leaning on home-side settlement silhouettes.
