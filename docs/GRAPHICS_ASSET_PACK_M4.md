# TIDELINES — GRAPHICS ASSET PACK M4

## Character Family Sprite Specification

**Date:** March 15, 2026  
**Status:** Draft for production planning

---

# 1. PURPOSE

This pack defines the shared character-family sprite rollout for Graphics 2.0.

Milestone 4 shifts the prototype away from purely geometric person silhouettes and into reusable figure families that can express home presence, hostile presence, solemn witness posture, and canoe crew motion with clearer scene identity.

---

# 2. INCLUDED FAMILIES

## Family A — Home Figures

### Required Variants
- `figure_home_standing`
- `figure_home_warrior`
- future `figure_home_elder`
- future `figure_home_ceremonial_leader`

### Current Usage Targets
- `Figure`
- `WarriorLine`
- village and aftermath foreground figures

### Notes
- home figures should feel grounded, dignified, and readable before they feel detailed
- warrior variants should distinguish themselves through stance and weapon silhouette, not bulk alone

---

## Family B — Hostile Figures

### Required Variants
- `figure_hostile_warrior`
- future `figure_hostile_guard`
- future `figure_hostile_champion`

### Current Usage Targets
- hostile shoreline `WarriorLine`
- `BattleScene`
- future resolution-assault escalation states

### Notes
- hostile variants should feel sharper and more severe than home-side figures
- red accents should remain restrained and atmospheric rather than costume-like

---

## Family C — Solemn / Seated Figures

### Required Variants
- `figure_sitting_solemn`
- future `figure_kneeling_grief`
- future `figure_memorial_attendant`

### Current Usage Targets
- aftermath mourning moments
- future memorial and eulogy compositions

### Notes
- these figures should read as emotional punctuation marks in the composition
- silhouettes should stay clear at very small scale

---

## Family D — Canoe Crew Figures

### Required Variants
- `figure_canoe_near`
- `figure_canoe_far`
- future `figure_canoe_leader`
- future `figure_canoe_steersman`

### Current Usage Targets
- `ApproachWarCanoe`
- future travel-scene crew polish pass

### Notes
- near and far variants should preserve port / starboard readability
- motion should remain runtime-driven by existing animation classes where possible
- crew figures should support layering in front of and behind hull art

---

# 3. RUNTIME GUIDANCE

## Composition Rules
- route as many people as possible through shared helpers before adding scene-specific variants
- use sprite swaps for identity and posture, then use runtime overlays and animation for mood
- avoid returning to bespoke inline figure geometry except for temporary experimentation

## Tone Rules
- home figures: warmer, steadier reads
- hostile figures: harder, more watchful reads
- solemn figures: quieter, lower-energy silhouette language
- canoe crew: maintain clear rowing-side readability

---

# 4. READABILITY RULES

- figures must remain readable on portrait mobile without zooming
- scene identity should survive even when only a few figures are visible
- weapon silhouettes should not become visual noise in dense lines
- seated grief figures must remain distinct from standing crowd sprites

---

# 5. IMPLEMENTATION ORDER

1. home standing / warrior figures
2. hostile warrior figures
3. solemn seated figures
4. canoe crew figures
5. named-role variants and ceremonial leaders

---

# 6. NEXT TARGETS AFTER M4

- named chief / war singer / elder figure families
- close-up battle champion and turning-point figure variants
- dedicated travel-scene leader / steersman sprites
- richer witness-group family variants beyond mood-only swaps

---

# 7. DONE DEFINITION

The pack is ready when shared figure helpers can express home, hostile, solemn, and canoe-crew states through reusable sprite families instead of relying on generic block silhouettes.
