# TIDELINES — GRAPHICS 2.0 DESIGN

## Visual Upgrade Plan for the Web Prototype and Beyond

**Version:** 0.1  
**Date:** March 15, 2026  
**Status:** Active design draft  
**Scope:** Current React single-file prototype in `web/react/tidelines.html`, with forward compatibility for a future Godot / canvas / Pixi scene renderer.

---

# 1. PURPOSE

This document defines the next-level graphics and animation direction for **TIDELINES**.

It exists to solve a specific problem:

> The current prototype already has tone, atmosphere, and dramatic pacing, but its visuals are still largely built from CSS shapes, UI-style compositions, and lightweight DOM animation. To reach a premium-feeling visual identity, the project needs a clearer rendering language, reusable scene systems, and a disciplined asset plan.

This is **not** a rewrite proposal. It is a staged visual design that can begin inside the existing web prototype and later transfer into a more specialized renderer.

---

# 2. DESIGN GOALS

## Primary Goal
Create a visual presentation that feels like **the best 16-bit historical coastal strategy-action game never released**, while preserving the prototype's strengths: clarity, emotional beats, and strong atmospheric framing.

## Secondary Goals
- Improve scene readability without flattening mood
- Make the ocean, shoreline, and witness spaces feel more alive
- Replace abstract geometric visuals with authored silhouettes and layered art
- Give every phase a stronger animation identity
- Build a reusable scene language instead of one-off visual tricks
- Keep mobile performance and responsiveness practical during the upgrade path

## Non-Goals
- Do not turn the game into a particle-heavy spectacle
- Do not pursue realism at the expense of readability
- Do not add visual systems that fight the cultural tone of the project
- Do not require an immediate engine migration to begin visual improvement

---

# 3. CURRENT STATE ASSESSMENT

## What Already Works
- Strong palette discipline and phase-based color moods
- Good dramatic framing in battle, withdrawal, and aftermath
- A useful layered scene mindset already exists
- Route/map identity and UI story framing are much stronger than a typical prototype
- Mobile/fullscreen presentation is already being treated as a first-class concern

## What Currently Limits the Visual Ceiling
- Scene objects are still mostly geometric approximations
- Animation language is inconsistent across components
- There is no formal camera system, only layout emphasis
- Backgrounds and foregrounds are not yet authored as composable art bands
- Water, fog, smoke, and fire are evocative but not yet premium
- Important beats do not yet have true key-pose silhouettes

## Root Creative Problem
The prototype often looks like **a beautifully art-directed interface pretending to be a game scene**.

Graphics 2.0 should make it look like **a real game scene that also happens to have a strong interface**.

---

# 4. VISUAL PILLARS

## Pillar 1 — Silhouette First
Every important object should read instantly in silhouette:
- war canoe
- longhouse
- witness crowd
- pole
- shoreline landing
- battle surge
- homecoming return

If the player can understand the scene in black-and-color blocks before any detail is added, the art direction is working.

## Pillar 2 — Atmosphere Over Density
The scene should feel full because of:
- fog bands
- firelight wash
- water reflection
- drifting smoke
- layered shoreline depth
- implied crowd motion

Not because every inch is packed with detail.

## Pillar 3 — Motion Hierarchy
At any moment:
- 1 element should dominate
- 2 to 3 elements should support
- everything else should be subtle idle motion

This prevents scenes from becoming noisy.

## Pillar 4 — The Coast Is Alive
The ocean and shoreline must always feel active:
- water drift
- wake response
- foam/surf motion
- low cloud or fog movement
- branch sway or distant shore shift

The world should never feel frozen.

## Pillar 5 — Ceremony Has Weight
Homecoming, mourning, witness, and prestige moments must feel deliberate and dignified.
Animation for these beats should emphasize:
- rhythm
- breath
- pause
- firelight
- crowd witness
- arrival and stillness

## Pillar 6 — Restraint Feels Expensive
A premium look here comes from timing, palette control, and staging.
Not from excess.

---

# 5. RENDERING STRATEGY

## Recommendation: Three-Stage Technical Path

### Stage A — Enhanced DOM / React Scenes
**Immediate path for the current prototype**

Keep the current structure, but transition scene art from CSS-only shapes to layered authored assets.

Use DOM layers for:
- sky gradients
- parallax background bands
- fog overlays
- sprite sheets or transparent PNG/WebP objects
- scene lighting overlays
- animated highlights / wake / embers

This gives the biggest quality jump with the lowest engineering risk.

### Stage B — Hybrid UI + Canvas Scene Renderer
**Medium-term upgrade path**

Keep UI and game logic in React, but render the main scene area on a `canvas`.

Use canvas for:
- layered sprite rendering
- parallax camera motion
- particles
- additive lighting tricks
- wave distortion / fog drift
- hit-stop / screen shake / scene tint moments

This is the recommended long-term path for the web version.

### Stage C — Full Dedicated 2D Renderer
**Only after the visual language is proven**

If the project evolves into a larger production, move the scene system to:
- PixiJS for web-first delivery, or
- Godot for full game scope

The important thing is that the visual language should be designed now so it ports cleanly later.

---

# 6. CORE GRAPHICS 2.0 SYSTEMS

## 6.1 Scene Layer Stack
Every scene should be composed from the same basic depth model.

### Standard Layer Order
1. Sky gradient / celestial layer
2. Distant land silhouette
3. Far shoreline band
4. Midground water / terrain
5. Main subject layer
6. Foreground framing layer
7. Atmosphere overlays
8. Light / vignette / impact overlays

### Benefits
- Consistent authoring rules across all phases
- Easier parallax and animation reuse
- Cleaner mobile scaling rules
- Better future portability to canvas or Godot

## 6.2 Visual Primitives
Define a reusable library of art elements.

### Environment Primitives
- Sky band
- Cloud bank
- Fog bank
- Distant mountain line
- Forest silhouette band
- Shoreline silhouette
- Surf strip
- Water body layer
- Reflection band
- Firelight glow patch

### Structural Primitives
- Longhouse
- Canoe house
- Smoke house
- Pole silhouette
- Landing posts / beach stakes
- Driftwood cluster
- Canoe rack

### Character Primitives
- Witness crowd cluster
- Paddler row silhouette
- Standing chief silhouette
- War line silhouette
- Mourning group silhouette
- Carver / villager utility silhouettes

### FX Primitives
- Wake trail
- Ember drift
- Smoke plume
- Spray burst
- Impact ring
- Oar stroke splash
- Banner pulse
- Ash / dust / mist sweep

---

# 7. ASSET STRATEGY

## Art Direction Rule
Replace prototype geometry with authored art in **families**, not one object at a time.

The first milestone should not be "make one canoe prettier."  
It should be "establish the canoe art family."

## Asset Families for Phase 1

### Family A — Canoes
Needed variants:
- travel canoe
- war canoe
- homecoming canoe
- cargo-heavy canoe silhouette
- damaged canoe silhouette

Motion states:
- idle float
- forward glide
- hard surge
- recoil / slow drift

### Family B — Shore / Village Structures
Needed variants:
- main longhouse
- background longhouse silhouettes
- canoe shed / house
- ceremonial pole silhouette
- shoreline stake or post set

### Family C — Human Groupings
Needed variants:
- witness cluster warm
- witness cluster solemn
- war line left
- war line right
- returning crew cluster

### Family D — Coast Atmosphere
Needed variants:
- fog layers
- smoke plumes
- wake strips
- foam lines
- firelight glows
- ember drift sprites

## Preferred Formats
For the current prototype:
- transparent PNG or WebP for scene art
- optional sprite sheets for looping elements
- tightly cropped atlases for repeated units

For future migration:
- layered source files should preserve named parts and animation states

---

# 8. ANIMATION LANGUAGE

Graphics 2.0 needs a formal motion vocabulary.
Every scene animation should belong to one of these categories.

## 8.1 Idle
Subtle perpetual movement.
Examples:
- canoe bob
- fire flicker
- smoke rise
- fog drift
- witness sway
- shoreline shimmer

**Rule:** Idle motion should be slow, breathable, and non-distracting.

## 8.2 Travel
Movement that expresses distance and persistence.
Examples:
- canoe glide
- wake trailing
- shoreline parallax
- weather passing laterally

**Rule:** Travel motion should feel rhythmic and directional.

## 8.3 Surge
Short acceleration emphasizing force.
Examples:
- battle advance
- canoe push into shore
- crowd lean forward

**Rule:** Surge needs anticipation, push, and slight recovery.

## 8.4 Impact
A decisive visual punctuation.
Examples:
- clash flash
- screen tint hit
- impact ring
- banner slam
- recoil stop

**Rule:** Use sparingly. Impact should interrupt motion briefly, not become constant noise.

## 8.5 Settle
The scene exhales after a beat.
Examples:
- returning to idle after clash
- fog re-filling a space
- witness line calming after a reveal

## 8.6 Witness
Animation specifically for ceremonial or emotional observation.
Examples:
- crowd sway
- firelit breathing
- slow collective head turn
- canoe arrival watched from shore

This is one of Tidelines' defining animation categories.

---

# 9. CAMERA LANGUAGE

The current prototype has no formal camera, but it already implies one through layout and scaling.
Graphics 2.0 should make that intentional.

## Camera Modes

### Wide Witness
Used for:
- village
- homecoming
- aftermath
- route transitions

Purpose:
- establish place
- show crowd / environment / dignity

### Medium Action
Used for:
- encounter
- approach
- withdrawal tension

Purpose:
- emphasize movement and stakes

### Compressed Clash
Used for:
- battle turning points
- outcome emphasis

Purpose:
- make opposing lines feel close and dangerous

### Reverent Focus
Used for:
- mourning
- prestige trait reveals
- ceremonial witness moments

Purpose:
- reduce visual noise and increase emotional weight

## Camera Techniques for the Web Prototype
Without a full camera system, simulate camera language via:
- scaling subject layers
- shifting parallax offsets
- changing vignette/fog density
- altering scene crop composition
- using timed overlays during transitions

---

# 10. PHASE-BY-PHASE VISUAL TARGETS

## 10.1 Village
### Emotional Goal
Warm, inhabited, materially grounded.

### Upgrade Targets
- replace block longhouse forms with authored silhouettes
- add layered shoreline / beach depth
- improve smoke, dogs, villagers, and canoe-house life hints
- make witness firelight affect nearby surfaces

### Key Animation Notes
- smoke and fire always active
- small villager movement occasional, not busy
- subtle flags / cedar bough / ember life at dusk and night

## 10.2 Travel
### Emotional Goal
Distance, exposure, mastery of water.

### Upgrade Targets
- authored water bands with proper parallax drift
- weather-specific fog, dawn, dusk, and night passes
- clearer canoe wake and paddling cadence
- shoreline depth bands for route identity

### Key Animation Notes
- paddling rhythm matters
- water motion must never feel static
- weather layers should travel with intent

## 10.3 Encounter
### Emotional Goal
Another shoreline answers back.

### Upgrade Targets
- clearer rival shoreline silhouette
- more distinct beach landing composition
- defenders visible as a true line, not just implied figures
- pre-battle tension via stillness and slight motion

## 10.4 Battle
### Emotional Goal
Compressed force, danger, turning momentum.

### Upgrade Targets
- proper attack/recoil silhouettes for opposing lines
- stronger charge timing and collision punctuation
- better separation between front line, crowd mass, and environment
- occasional debris, spray, or ash depending on scene tone

### Key Animation Notes
- battle should alternate between pressure and freeze
- use hit-stop and recoil more than constant jitter
- outcome should change posture language immediately

## 10.5 Withdrawal
### Emotional Goal
Motion homeward under stress.

### Upgrade Targets
- stronger directional composition toward home waters
- better home shoreline readability in the distance
- cargo vs loss conveyed through canoe silhouette and crew posture
- wake, waterline, and witness firelight should do narrative work

## 10.6 Aftermath
### Emotional Goal
The village witnesses what returned.

### Upgrade Targets
- true homecoming and mourning variants
- witness crowd grouping with readable emotional tone
- firelight glow on shore and architecture
- better beach composition for arrival and distribution of goods

---

# 11. ATMOSPHERE STACKS

These are reusable visual packages for scene mood.

## Dawn Crossing Stack
- cool blue water base
- pale gold horizon band
- light mist pass
- sparse silver wake highlights

## Fogbound Passage Stack
- desaturated water
- low-contrast shore silhouette
- moving fog front and rear layers
- reduced highlight contrast

## Hostile Shore Stack
- darker shoreline band
- warmer red-brown accents in midground
- reduced crowd warmth
- tighter vignette

## Homecoming Firelight Stack
- cool dusk or night base
- warm shore glow pockets
- ember drift near village fires
- soft witness-side illumination

## Mourning Stack
- reduced saturation
- minimal gold highlights
- calmer fire / smoke rhythm
- slightly heavier vignette and shore haze

---

# 12. MOBILE VISUAL PRINCIPLES

Graphics upgrades must preserve portrait viability.

## Rules
- scenes must read clearly in portrait first, not only landscape
- subject silhouette should remain legible even when width is constrained
- atmosphere layers should scale down before main subject detail is removed
- text/UI compression should protect the scene, not compete with it
- animation count should adapt downward on smaller devices

## Practical Priority Order for Mobile
1. main subject silhouette
2. shoreline / spatial readability
3. atmospheric color story
4. witness or secondary figures
5. tertiary FX layers

If performance drops, cut tertiary FX first.

---

# 13. PERFORMANCE BUDGET GUIDELINES

For the current web prototype, premium feel must still remain light enough for phones.

## DOM / CSS Phase Budget
- keep simultaneous major animated layers modest
- prefer transform / opacity animation over layout-changing animation
- reuse fog/smoke/wake systems instead of creating bespoke ones everywhere
- limit high-frequency animations during battle and mobile portrait mode

## Canvas Phase Budget
- fixed layer order
- batched sprite draws where possible
- capped particle counts by device class
- no effect should be mandatory if it harms readability

---

# 14. IMPLEMENTATION ROADMAP

## Phase 1 — Art Language Lock
**Goal:** define how the game should look before building too much.

Deliverables:
- scene layer spec
- animation language spec
- asset family list
- mood boards / reference sheet
- one polished target composition per major phase

## Phase 2 — Prototype Scene Kit
**Goal:** upgrade the current web prototype visually without changing core architecture.

Deliverables:
- reusable scene layer helpers inside `tidelines.html`
- first art family imported: canoes + witness groups + shoreline bands
- upgraded water / wake / fog stack
- one fully upgraded showcase phase, recommended: `Withdrawal` or `Aftermath`

## Phase 3 — Premium Web Pass
**Goal:** make the prototype look shippable for a vertical slice.

Deliverables:
- all phases converted to layered scene kit
- consistent animation timing across phases
- refined transitions and impact moments
- device-aware animation scaling

## Phase 4 — Renderer Decision
**Goal:** decide whether to remain DOM-based or move the scene area to canvas.

Decision triggers:
- too many layers for DOM performance
- desire for camera motion / particles / tint control
- need for sprite batching and more expressive animation

---

# 15. FIRST CONCRETE BUILD TARGET

## Recommended Next Visual Milestone
Create a **Withdrawal / Homecoming showcase scene** as the first Graphics 2.0 target.

### Why This Scene First
- combines ocean, canoe, shoreline, village glow, and emotional tone
- showcases both travel motion and ceremonial witness
- is visually distinct from generic battle spectacle
- expresses the game's identity better than a raw combat-only scene

### Required Deliverables
- authored canoe silhouette set
- layered home shoreline background
- witness cluster sprite set
- upgraded wake and water shimmer
- firelight glow overlay
- improved arrival timing and settle animation

If this scene works, the rest of the game's visual identity will become easier to systematize.

---

# 16. OPEN DESIGN QUESTIONS

These do not block progress, but should be resolved during the next design pass.

1. Should the web prototype remain pixel-perfect, or pursue a painterly-pixel hybrid look?
2. Should scene assets be single large compositions, or modular layered pieces?
3. How much camera motion is appropriate before it starts feeling too cinematic for the tone?
4. How many character-level animation states are worth supporting in the web version?
5. Do we want one master weather system for all phases, or per-phase atmosphere tuning?

---

# 17. IMMEDIATE NEXT STEPS

## Design Tasks
1. Build a reference board for canoe, shoreline, witness, and firelight silhouettes
2. Define the first asset pack: `canoes`, `shoreline bands`, `witness clusters`, `fog/wake/fire FX`
3. Sketch the reusable scene-layer component API for the current web prototype
4. Pick the showcase phase for the first true Graphics 2.0 implementation

## Implementation Tasks
1. Add a dedicated scene-layer abstraction in the prototype
2. Replace one CSS-built canoe with an authored layered sprite
3. Introduce reusable fog, wake, and firelight overlays
4. Re-block one full scene using the new kit

---

# 18. SUMMARY

The next level for Tidelines graphics is not just prettier sprites.

It is the move from:
- clever prototype composition

To:
- a formal scene language built from silhouettes, depth layers, disciplined motion, atmosphere stacks, and reusable asset families.

The recommended path is:
1. lock the visual system
2. upgrade the current web prototype with layered art assets
3. prove the look in one showcase scene
4. only then decide whether the scene renderer should migrate to canvas or a dedicated engine
