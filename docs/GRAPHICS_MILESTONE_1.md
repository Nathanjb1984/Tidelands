# TIDELINES — GRAPHICS 2.0 MILESTONE 1

## Withdrawal / Homecoming Showcase

**Date:** March 15, 2026  
**Status:** Ready for implementation  
**Primary Runtime Target:** `web/react/tidelines.html`

---

# 1. MILESTONE GOAL

Deliver the first true Graphics 2.0 vertical slice inside the web prototype.

This milestone upgrades the **Withdrawal / Homecoming** presentation from a strong prototype composition into a reusable, art-direction-driven scene system.

The milestone succeeds if one scene clearly demonstrates:
- stronger silhouette readability
- deeper scene layering
- a more formal animation language
- reusable atmosphere systems
- better emotional distinction between victory, stalemate, and loss

---

# 2. WHY WITHDRAWAL FIRST

Withdrawal is the best first showcase because it combines:
- water motion
- canoe silhouette
- home-shore anticipation
- witness presence
- cargo vs loss storytelling
- atmosphere and ceremony in the same frame

It communicates the core identity of Tidelines better than a combat-only pass.

---

# 3. MILESTONE DELIVERABLES

## Runtime Deliverables
- Scene-layer foundation inside `web/react/tidelines.html`
- Reusable atmosphere helpers for fog, glow, and layered shoreline emphasis
- Reusable return-canoe composition helper or equivalent layer grouping
- Reusable home-shore beacon / witness settlement composition helper or equivalent layer grouping
- Upgraded `WithdrawalScene` using the new foundation

## Design Deliverables
- Asset pack specification for Milestone 1
- Layer map for the showcase scene
- Animation rules for idle / travel / settle / witness motion

## Validation Deliverables
- Mobile portrait remains readable
- Fullscreen portrait remains supported
- No editor errors in modified files

---

# 4. SCENE BREAKDOWN

## 4.1 Visual Story
The canoe is returning from hostile water.
Home is visible but not yet reached.
The coast is watching.

The scene should answer three questions instantly:
1. Are we coming back in strength, uncertainty, or grief?
2. How close are we to home?
3. Is the shoreline receiving us warmly, cautiously, or solemnly?

## 4.2 Composition Priorities
1. Return canoe silhouette
2. Home-shore witness light and settlement presence
3. Directional water and wake
4. Distant coast / former hostile shore memory
5. Fog and atmospheric framing

---

# 5. LAYER MAP

## Standard Z Order
1. Sky field
2. Distant mountains
3. Forest band
4. Cedar Creek memory shore
5. Home shore structures / pole / beacon lights
6. Fog bands
7. Water body
8. Wake trail
9. Return canoe subject
10. Witness cluster / shoreline receiving layer
11. Foreground darkening
12. Vignette / emotional tint

---

# 6. VISUAL STATE MATRIX

## Victory Return
- Canoe silhouette reads heavier with goods
- Home lights are warmer and more numerous
- Witness grouping is larger and more active
- Wake trail is brighter and longer
- Warm shore glow supports the arrival

## Stalemate Return
- Canoe reads steady but less triumphant
- Shore receives the crew with restrained light
- Witness count is smaller
- Wake and glow intensity are moderate

## Defeat / Mourning Return
- Canoe reads barer and colder
- Shore light is sparse or solemn
- Witness cluster is minimal and subdued
- Water and vignette skew colder / heavier
- Memorial cues or absence cues should read quickly

---

# 7. IMPLEMENTATION STEPS

## Step 1 — Foundation
- Add generic scene-layer wrapper helper
- Add reusable atmosphere helpers
- Add a compact home-shore composition helper

## Step 2 — Subject Upgrade
- Create a reusable return-canoe composition helper
- Centralize wake and cargo/loss dressing
- Preserve existing outcome-aware logic

## Step 3 — Showcase Pass
- Rebuild `WithdrawalScene` around the new layer system
- Tune mood states for victory / stale / defeat
- Verify readability on phone portrait and fullscreen portrait

## Step 4 — Reuse Pass
- Identify which new helpers can immediately carry over into `AftermathScene`
- Keep public behavior unchanged while improving scene quality

---

# 8. ACCEPTANCE CRITERIA

Milestone 1 is complete when:
- `WithdrawalScene` feels visibly more premium than the rest of the prototype
- the new helper layer system is reusable and not scene-specific spaghetti
- homecoming emotional states read at a glance
- portrait mobile still presents the scene clearly
- no editor errors remain

---

# 9. FOLLOW-UP AFTER THIS MILESTONE

If Milestone 1 lands well, Milestone 2 should target:
- `AftermathScene`
- shared ceremony/witness systems
- art-family replacement of geometric canoe and crowd shapes
- optional migration of the scene area toward a hybrid canvas renderer
