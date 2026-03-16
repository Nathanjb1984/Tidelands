# TIDELINES — GRAPHICS ASSET PACK M5

## Named-Role Figure Specification

**Date:** March 15, 2026  
**Status:** Draft for production planning

---

# 1. PURPOSE

This pack defines the first named-role figure family for the Graphics 2.0 realism pass.

Milestone 5 upgrades the most visible special characters so key beats stop relying on generic crowd sprites.

The focus is not ornate decoration. The focus is clarity of role, posture, and presence.

---

# 2. INCLUDED FAMILIES

## Family A — Ceremony / Leadership Figures

### Required Variants
- `figure_ceremonial_leader`
- `figure_home_elder`

### Current Usage Targets
- `VillageCeremonyFront`
- `AftermathScene`
- future home-side ceremony and council moments

### Notes
- leadership should read through stance, gesture, and placement
- elder figures should feel grounded and authoritative, not fragile caricatures
- avoid speculative sacred costume invention

---

## Family B — Canoe Role Figures

### Required Variants
- `figure_canoe_leader`
- `figure_canoe_steersman`

### Current Usage Targets
- `ReturnCanoe`
- `TravelHeroCanoe`
- `ApproachWarCanoe`

### Notes
- these figures should reinforce command and navigation roles
- leader and steersman should remain readable at reduced scale
- animation should continue to come from runtime motion rather than many art variants

---

## Family C — Hostile Focal Figures

### Required Variants
- `figure_hostile_champion`
- future `figure_hostile_guard`
- future `figure_hostile_chief`

### Current Usage Targets
- `HostileShore`
- `BattleScene`
- future confrontation-state moments and turning points

### Notes
- hostile focal figures should feel severe and dangerous without turning into fantasy villains
- red accents should stay restrained and structural

---

# 3. RUNTIME GUIDANCE

- route named-role figures through reusable helpers instead of inline one-off geometry
- use glow and motion sparingly so role clarity comes from silhouette and position first
- keep special figures slightly larger or more isolated than crowd sprites, not dramatically oversized

---

# 4. READABILITY RULES

- named-role figures must still read on portrait mobile
- role identity should survive at glance: leader, elder, steersman, champion
- these figures should sharpen story beats, not clutter them

---

# 5. IMPLEMENTATION ORDER

1. ceremonial leader
2. canoe leader and steersman
3. elder
4. hostile champion
5. future named chiefs / singers / champions

---

# 6. NEXT TARGETS AFTER M5

- named chief and war singer figures tied to story text
- dedicated turning-point duel variants
- leader-specific witness/council staging
- close-up character portrait family for major event cards

---

# 7. DONE DEFINITION

The pack is ready when the prototype's most important people no longer share the same generic role-neutral silhouette language.
