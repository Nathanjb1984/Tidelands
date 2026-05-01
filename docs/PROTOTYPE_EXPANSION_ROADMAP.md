# TIDELINES — Prototype Expansion Roadmap

## Purpose

This roadmap turns the current audit into a practical build order for the React prototype in `web/react/tidelines.html`.

The goal is not to abandon the existing raid slice. The goal is to grow outward from it so the raid becomes one meaningful activity inside a larger chiefdom loop.

---

## 1. Current Reality of the Prototype

The current playable experience is strongest as a **single-expedition raid loop**:

1. Village preparation
2. Outbound travel
3. Shore encounter
4. Battle resolution
5. Withdrawal
6. Homecoming / aftermath

This is clearly reflected in:

- `PHASES` in `web/react/tidelines.html`
- `Scene(...)` scene routing
- the command area logic keyed around `vil_*`, `trv_*`, `enc_*`, `res_*`, `wth_*`, and `aft_show`

What is already strong:

- excellent phase mood and scene presentation
- readable command-driven flow
- good consequence reporting through prestige, feud, casualties, spoils, and legacy log
- strong atmosphere in travel, battle, withdrawal, and aftermath

What is still missing relative to the GDD:

- real village management
- meaningful navigation systems
- non-raid expeditions
- ceremony / potlatch as a primary progression loop
- pole commissioning as a true system
- lineage / succession / generational structure
- retaliation / defense from the other side of the feud

---

## 2. Build Order Recommendation

## Priority 1 — Village Management Layer

### Why this comes first

Right now the village is mostly a framing device for raid setup.

If the village becomes playable, then every later activity matters more:

- voyages cost something real
- raids compete with trade and ceremony
- losses hurt because labor and lineage matter at home
- return scenes gain weight because the player understands what they are returning to

### What this should add

- food stores and seasonal readiness
- canoe provisioning and repair readiness
- labor assignment or simplified work priorities
- carving / pole progress
- visible pre-expedition tradeoff between village growth and war preparation

### Prototype target

Add a new **pre-raid village management scene** before the current `vil_intel` step.

---

## Priority 2 — Real Voyage Gameplay

### Why this comes second

The GDD says the sea is the world, but in the current slice travel is mostly atmosphere plus two decisions.

This is the next biggest gap between the prototype and the game fantasy.

### What this should add

- route choice with safer vs faster water
- tide and current windows
- weather risk and forecast uncertainty
- canoe loadout affecting speed, stealth, and safety
- travel events that are not combat-only

### Prototype target

Extend phase 1 into a lightweight navigation layer rather than a pure dialogue-choice phase.

---

## Priority 3 — Ceremony / Potlatch Loop

### Why this comes third

This is where Tidelines becomes distinct instead of just “beautiful canoe raid game.”

The current aftermath already hints at witness fires, prestige, poles, memorials, and public memory. That should become a real loop.

### What this should add

- feast preparation
- goods redistribution
- invitation / guest prestige logic
- pole commissioning and raising as capstone moments
- generosity converting wealth into standing

### Village work scene backlog

These should become real preparation scenes that feed ceremony and survival, not flavor-only labels:

- **Gathering:** beach foods, berries, roots, cedar bark, medicines, and basket loads. Rewards food, village readiness, and weaving material. Bad choices can overwork families, miss tides, or damage next-season supplies.
- **Fishing:** smoke racks, halibut hooks, salmon runs, oil rendering, and canoe crews close to home. Rewards feast stores and food. Bad weather or rushing can cost canoe condition, morale, or a full day.
- **Hunting:** forest and shoreline hunting for feast meat, hide, bone, and prestige gifts. Rewards feast stores and standing. Failure can wound a hunter, lower morale, or create a food shortfall.
- **Weaving:** cedar bark, mats, baskets, blankets, regalia, and gift goods. Rewards woven goods for potlatch, trade, diplomacy, and peace offerings. Neglect should make ceremonies smaller and trade weaker.
- **Carving:** poles, house posts, boxes, canoe work, and speaking gifts. Rewards carved works, pole progress, prestige, and memory. Rushing can waste cedar or delay the voyage.

Prototype target for this backlog: add a **Village Work** screen before expedition selection, then make potlatch / pole / peace choices spend feast stores, woven goods, and carved works.

### Prototype target

Add a **ceremony scene** after successful returns, with choices that spend cargo for prestige, alliance, memory, or future stability.

---

## Priority 4 — Trade and Diplomacy Expeditions

### Why this comes fourth

The game should not train the player to think every voyage is a raid.

Peaceful and tense non-raid travel adds variety and makes war a strategic choice rather than the only interesting content.

### What this should add

- trade voyages
- alliance visits
- marriage or kinship-linked diplomacy beats
- neutral / rival settlements with different tones than Cedar Creek

### Prototype target

Add an expedition selection step so the player chooses between raid, trade, diplomacy, or ceremony travel goals.

---

## Priority 5 — Retaliation and Defense

### Why this comes fifth

This grows naturally out of the existing feud system.

The prototype already tracks feud escalation well, but that pressure mainly exists as text. Retaliation would make the feud systemic.

### What this should add

- incoming raid warnings
- rushed village defense prep
- shore defense scene or night alert scene
- protection of goods, poles, and people at home

### Prototype target

Create a mirrored “defend home shore” slice using the same scene language as the current raid loop.

---

## Priority 6 — Lineage, Succession, and Era Structure

### Why this comes later

These are essential to the full vision, but they need meaningful underlying loops first.

If added too early, they risk becoming abstract meta-systems attached to a still-narrow core.

### What this should add

- named household members with roles
- inheritance pressure and succession risk
- generational trait carryover
- era changes altering what kinds of expeditions and ceremonies are possible

---

## 3. Best Single Next Scene to Build

## Recommended Scene: **Home Waters**

### Short version

The next scene to build should be a **playable village-management opening scene** that happens before the current raid-prep choices.

This is the highest-value next addition because it:

- expands the game beyond raiding immediately
- reuses the existing village art language
- fits naturally before `vil_intel`
- creates future hooks for trade, ceremony, carving, defense, and seasonal play

---

## 4. Home Waters Scene Concept

### Scene fantasy

It is dawn at Stoneshell Inlet.

The player is not yet committing to a raid. They are standing inside the life of the village:

- canoes on the beach
- fires still low
- carvers at work
- stores being checked
- people waiting for direction

This scene should answer a simple question:

> What kind of season is the player preparing for before they choose conflict?

### Placement in current flow

Insert this scene **before** the current `vil_intel` branch.

Suggested new opening flow:

1. `vil_dawn` — village management scene
2. `vil_intel` — gather information about Cedar Creek
3. `vil_prep` — final war preparation
4. existing travel / encounter / battle / withdrawal / aftermath flow

### Why this placement works

- no rewrite of the later state machine
- current raid slice remains intact
- the new scene becomes a staging ground for future non-raid branches

---

## 5. Home Waters — Player Decisions

The scene should offer 3 to 4 meaningful opening choices.

### Option A — Provision the Village

Focus on stores, fishing, drying racks, and readiness at home.

Possible effects:

- improves food reserve or stability
- lowers immediate war intensity
- unlocks stronger return-state outcomes later

### Option B — Ready the Canoe

Focus on hull repair, paddle crews, and travel readiness.

Possible effects:

- better canoe condition
- better travel safety
- stronger route performance once voyage systems exist

### Option C — Consult the Carver / Elders

Focus on memory, prestige, and communal direction.

Possible effects:

- starts pole progress
- improves morale or prestige
- creates hooks for ceremony content

### Option D — Quiet War Preparation

Focus directly on the coming raid without locking the whole game into war-only identity.

Possible effects:

- modest early bonus to surprise or intimidation
- higher opportunity cost at home

---

## 6. Minimal State Additions for This Scene

To keep scope under control, add only a few new persistent values first.

Recommended first set:

- `foodStores`
- `villageReadiness`
- `canoeReadiness`
- `poleProgress`
- `seasonClock` or `seasonStep`

These are enough to make the village feel alive without forcing a full economy system immediately.

---

## 7. Visual Direction for Home Waters

Reuse the existing `VillageScene` language, but make it feel more active and systemic.

### Add visible beats such as

- a canoe being provisioned on the beach
- a storage or drying-rack cluster
- a carver or pole work area
- 2 to 3 visible labor groups with different tasks
- a stronger sense that the village is preparing for more than battle alone

### Important tone note

This scene should feel deliberate, warm, and lived-in.

It should contrast with the raid phases by emphasizing:

- duty
- preparation
- resource stewardship
- witness and memory

---

## 8. Implementation Hook in the Current Prototype

### Existing code that makes this feasible

- the prototype already has a village phase and `VillageScene`
- the state machine already supports step-based command panels
- the HUD and route banner already communicate contextual values cleanly
- the current opening step is `vil_intel`, so a new opening step can be inserted cleanly in front of it

### Practical implementation suggestion

1. Add a new opening state in `initState()` such as `step:'vil_dawn'`
2. Add a new command panel block before the current `vil_intel` block
3. Add 3 to 4 new transition handlers for the first village-management choice
4. Route those results into the existing `vil_intel` step
5. Add only the minimum new stats needed to make the scene meaningful

This keeps the current raid slice playable while expanding its foundation.

---

## 9. Suggested Roadmap by Milestone

## Milestone A — Home Waters

- new opening village-management scene
- 3 to 4 choices
- 4 to 5 new persistent variables
- visible village work details in scene art

## Milestone B — Voyage Becomes Gameplay

- route risk choice
- tide / weather modifiers
- travel event beat between departure and arrival

## Milestone C — Ceremony Payoff

- potlatch-lite aftermath branch
- spend spoils on prestige vs reserve vs peace-making
- pole progress or memorial progress advancement

## Milestone D — Multi-Expedition Identity

- choose expedition type
- raid vs trade vs diplomacy branch
- feud and prestige now shaped by more than battle

## Milestone E — Retaliation and Generational Pressure

- defense scenes
- household loss / succession hooks
- long-form campaign identity

---

## 10. Final Recommendation

If only one thing is built next, build **Home Waters**.

It is the best next step because it transforms the prototype from:

- “a highly polished raid scenario”

into:

- “the beginning of a chiefdom game where raids are one consequence of village life, not the whole game.”

That shift is the most important step toward the full promise of Tidelines.
