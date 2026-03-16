# TIDELINES — GRAPHICS ASSET PACK M2

## Structure + Battlefront Asset Specification

**Date:** March 15, 2026  
**Status:** Draft for production planning

---

# 1. PURPOSE

This pack defines the second asset-family rollout for Graphics 2.0.

Milestone 2 expands the first canoe / witness pass into two higher-value families:
- home and ceremony structures
- hostile shore / battlefront props

The goal is to raise scene credibility in village, aftermath, encounter, and battle compositions without changing gameplay systems.

---

# 2. INCLUDED FAMILIES

## Family A — Structure Silhouettes

### Required Variants
- `longhouse_main`
- `pole_totem`
- `pole_ceremonial`
- `pole_memorial`

### Current Usage Targets
- `VillageScene`
- `AftermathScene`
- `WithdrawalScene`
- supporting shoreline helpers such as `HomeShore` and `MemoryShore`

### Notes
- silhouettes must stay readable on portrait mobile
- ceremonial and memorial poles must feel related, not identical
- longhouse art should read as mass and roofline first, façade detail second
- glow and smoke remain runtime overlays, not baked into the base silhouette

---

## Family B — Battlefront Shore Props

### Required Variants
- `battle_shield_wall`
- `battle_burning_debris`
- `battle_weapon_cache`

### Current Usage Targets
- `BattleScene`
- future hostile shoreline staging in `EncounterScene`
- future battle outcome variants if the scene branches further

### Notes
- props should support both victorious and losing reads through placement and overlay, not separate redraws yet
- burning debris must remain legible behind smoke and sparks
- shield walls should read as barricade mass, not individual collectible items
- caches should suggest readiness or plunder depending on context

---

# 3. RUNTIME GUIDANCE

## Preferred Use Pattern
- keep core silhouettes in SVG for the web prototype
- layer atmosphere, glow, smoke, sparks, and pulses in CSS / DOM at runtime
- treat each family as a reusable scene unit, not a one-scene illustration

## Composition Rules
- use asset families through shared helpers whenever possible
- avoid rebuilding props inline inside scene bodies
- preserve current parallax and animation language around the assets

---

# 4. READABILITY RULES

- battle props must never obscure the central clash read
- structure silhouettes must still read at reduced scale in mobile portrait
- smoke should deepen depth and aftermath feeling, not erase silhouettes
- props should support emotional tone shifts via overlays, not excessive detail

---

# 5. IMPLEMENTATION ORDER

1. structure silhouettes
2. battlefront shoreline props
3. hostile settlement frontage assets
4. dedicated battle outcome prop variants
5. richer shoreline debris / trophy / memorial families

---

# 6. NEXT TARGETS AFTER M2

- hostile longhouse frontage variants for `EncounterScene` and `BattleScene`
- dedicated victory / loss debris states for the battle shoreline
- more ceremonial settlement modules for larger village compositions
- optional FX sheets for sparks, embers, and denser shoreline smoke

---

# 7. DONE DEFINITION

The pack is ready when structure and battle scenes can be upgraded using family-based assets and shared helpers instead of introducing new bespoke geometric compositions for each scene.
