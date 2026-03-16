# TIDELINES — GRAPHICS ASSET PACK M1

## Withdrawal / Homecoming Showcase Asset Specification

**Date:** March 15, 2026  
**Status:** Draft for production planning

---

# 1. PURPOSE

This pack defines the first family of assets needed to move the web prototype toward Graphics 2.0.

These assets should support the withdrawal / homecoming showcase first, but be reusable in aftermath and travel scenes.

---

# 2. ASSET FAMILIES

## Family A — Return Canoes

### Required Variants
- `canoe_return_standard`
- `canoe_return_victory`
- `canoe_return_damaged`
- `canoe_return_burdened`

### States
- idle float
- glide
- homeward settle

### Notes
- silhouette clarity matters more than decorative detail
- victory should read through weight / cargo / posture, not flashy ornament alone
- damaged variant should remain dignified, not exaggerated

---

## Family B — Home Shoreline Bands

### Required Variants
- `shore_home_far`
- `shore_home_mid`
- `shore_home_receiving`
- `shore_hostile_memory_far`

### Notes
- should support parallax layering
- must read both on desktop and in portrait mobile
- warm receiving light needs a separate overlay-ready region

---

## Family C — Witness Groups

### Required Variants
- `witness_warm_small`
- `witness_warm_medium`
- `witness_solemn_small`
- `witness_grief_small`

### States
- idle sway
- arrival lean
- solemn stillness

### Notes
- groups should read as collective bodies first, individuals second
- avoid over-busy animation

---

## Family D — Atmosphere FX

### Required Variants
- `fog_band_soft`
- `fog_band_dense`
- `wake_long`
- `wake_soft`
- `fire_glow_warm`
- `shore_beacon_warm`
- `shore_beacon_solemn`

---

# 3. WEB PROTOTYPE FORMAT GUIDANCE

## Preferred Runtime Formats
- PNG or WebP with transparency for composed sprite layers
- horizontal strips for looping effects if needed
- dimensions optimized for the existing scene boxes, not full-screen illustration sheets

## Authoring Guidance
- preserve layered source files
- separate glow overlays from hard silhouettes where possible
- name files by function and mood, not just by version number

---

# 4. READABILITY RULES

- the canoe must remain readable at small portrait sizes
- witness groups must remain recognizable as living presence, not debris
- home lights should never overwhelm the canoe silhouette
- fog should shape depth, not obscure core play readability

---

# 5. IMPLEMENTATION ORDER

1. return canoe family
2. home-shore bands
3. witness groups
4. wake and beacon FX

---

# 6. DONE DEFINITION

The pack is ready when the withdrawal showcase can be built without inventing one-off art behavior per element.
