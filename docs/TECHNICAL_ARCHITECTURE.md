# TIDELINES: Cedar, Sea & Legacy — TECHNICAL ARCHITECTURE

## Technical Design & Implementation Guide v1.0

---

# 1. ENGINE RECOMMENDATION

## Primary Recommendation: Godot 4.x

### Why Godot

| Factor | Godot 4.x | Unity | Web (Custom) |
|--------|-----------|-------|-------------|
| **2D pixel art** | Excellent native support, pixel-perfect rendering | Good but requires more config | Requires custom renderer |
| **Tilemap system** | Built-in, powerful | Third-party or Tilemap package | Custom implementation |
| **Adaptive audio** | AudioStreamPlayer with bus system | Excellent (FMOD/Wwise integration) | Web Audio API (good) |
| **Data-driven design** | JSON/Resource system native | ScriptableObjects + JSON | Native JSON |
| **Cost** | Free, MIT license | Free tier + revenue share | Free |
| **Export targets** | Windows, Mac, Linux, Web, Mobile | All platforms | Web native |
| **Community** | Growing rapidly, strong 2D community | Massive | N/A |
| **Performance for 2D** | Excellent | Overkill (but fine) | Depends on implementation |
| **Learning curve** | Moderate (GDScript is Python-like) | Moderate-High (C#) | High (everything custom) |
| **Sprite atlas** | Built-in atlas generation | Built-in | Custom or library |
| **Save system** | File + Resource serialization | PlayerPrefs + File | LocalStorage + File |

**Verdict:** Godot 4.x is the best fit. It excels at 2D, has excellent pixel-art support, its node-based architecture maps naturally to the game's layered systems, and GDScript is highly productive. The built-in tilemap, animation, and audio systems cover most needs without plugins.

### Alternative: Web Stack (Phaser.js / Custom)
If web-first distribution is critical:
- **Framework:** Phaser 3 or custom TypeScript engine
- **Renderer:** WebGL via PixiJS
- **Audio:** Howler.js + Web Audio API
- **Data:** JSON + IndexedDB for save/load
- **Advantage:** Instant play in browser, no install
- **Disadvantage:** More custom infrastructure needed, less tooling

---

# 2. PROJECT ARCHITECTURE

## 2.1 — Directory Structure (Godot)

```
tidelines/
├── project.godot                 # Godot project config
├── README.md                     # Project overview
│
├── assets/                       # All raw/imported assets
│   ├── sprites/
│   │   ├── canoes/              # Canoe sprite sheets
│   │   ├── characters/          # Character sprites & portraits
│   │   ├── buildings/           # Village building sprites
│   │   ├── poles/               # Modular pole figure sprites
│   │   ├── environment/         # Tiles, terrain, water, trees
│   │   ├── ui/                  # UI elements, icons, frames
│   │   ├── effects/             # Weather, particles, transitions
│   │   └── animals/             # Eagle, raven, whale, etc.
│   ├── audio/
│   │   ├── music/               # Music tracks (OGG)
│   │   ├── sfx/                 # Sound effects (WAV)
│   │   └── ambient/             # Ambient loops (OGG)
│   ├── fonts/                   # Custom pixel fonts
│   └── shaders/                 # Custom shader files
│
├── data/                         # Data-driven content (JSON)
│   ├── canoes.json              # Canoe type definitions
│   ├── buildings.json           # Building definitions
│   ├── resources.json           # Resource type definitions
│   ├── events/                  # Event definitions
│   │   ├── exploration.json
│   │   ├── weather.json
│   │   ├── ceremony.json
│   │   ├── diplomacy.json
│   │   ├── conflict.json
│   │   ├── spiritual.json
│   │   ├── village.json
│   │   └── historical.json
│   ├── chiefs.json              # Chief archetype definitions
│   ├── crests.json              # Crest/moiety definitions
│   ├── poles.json               # Pole type & figure definitions
│   ├── eras.json                # Era definitions & transitions
│   ├── map/                     # Map data
│   │   ├── regions.json
│   │   ├── locations.json
│   │   ├── routes.json
│   │   └── hazards.json
│   └── balance.json             # Tuning constants
│
├── src/                          # Source code (GDScript)
│   ├── core/                    # Core systems
│   │   ├── game_manager.gd      # Master game state controller
│   │   ├── save_manager.gd      # Save/load system
│   │   ├── event_bus.gd         # Global event bus (signals)
│   │   ├── data_loader.gd       # JSON data loading & caching
│   │   ├── turn_manager.gd      # Season/turn progression
│   │   └── era_manager.gd       # Era state & transitions
│   │
│   ├── village/                 # Village management systems
│   │   ├── village.gd           # Village state container
│   │   ├── building.gd          # Building base class
│   │   ├── labor_manager.gd     # Population & labor assignment
│   │   ├── resource_manager.gd  # Resource tracking & economy
│   │   ├── food_manager.gd      # Food production & preservation
│   │   └── construction.gd      # Building & canoe construction
│   │
│   ├── navigation/              # Ocean navigation systems
│   │   ├── canoe.gd             # Canoe entity
│   │   ├── navigation.gd        # Navigation controller
│   │   ├── weather_system.gd    # Weather generation & state
│   │   ├── tide_system.gd       # Tidal cycle
│   │   ├── current_system.gd    # Ocean currents
│   │   └── voyage_planner.gd    # Expedition loadout & planning
│   │
│   ├── social/                  # Social systems
│   │   ├── lineage.gd           # Lineage/family tree
│   │   ├── clan.gd              # Clan/moiety system
│   │   ├── marriage.gd          # Marriage alliance system
│   │   ├── prestige.gd          # Prestige tracking
│   │   ├── diplomacy.gd         # Inter-village relations
│   │   └── succession.gd        # Chief succession
│   │
│   ├── ceremony/                # Ceremony systems
│   │   ├── potlatch.gd          # Potlatch planning & execution
│   │   ├── pole_system.gd       # Pole commissioning & carving
│   │   ├── blessing.gd          # Blessing/spiritual system
│   │   └── ceremony_scene.gd    # Ceremony visual controller
│   │
│   ├── conflict/                # Conflict systems
│   │   ├── conflict_manager.gd  # Conflict resolution engine
│   │   ├── encounter.gd         # Encounter generation
│   │   ├── morale.gd            # Morale tracking
│   │   └── defense.gd           # Village defense
│   │
│   ├── events/                  # Event system
│   │   ├── event_manager.gd     # Event queue & triggering
│   │   ├── event.gd             # Event base class
│   │   ├── event_conditions.gd  # Condition evaluation
│   │   └── event_effects.gd     # Effect application
│   │
│   ├── world/                   # World/map systems
│   │   ├── world_map.gd         # World map state
│   │   ├── location.gd          # Location data
│   │   ├── route.gd             # Travel route
│   │   └── discovery.gd         # Exploration/discovery tracking
│   │
│   └── ui/                      # UI controllers
│       ├── hud.gd               # Main HUD
│       ├── village_screen.gd    # Village management UI
│       ├── navigation_screen.gd # Navigation UI
│       ├── event_dialog.gd      # Event/choice dialog
│       ├── potlatch_screen.gd   # Potlatch planning UI
│       ├── pole_design.gd       # Pole design UI
│       ├── lineage_screen.gd    # Lineage/family tree UI
│       ├── loadout_screen.gd    # Expedition loadout UI
│       └── legacy_screen.gd     # Endgame legacy review
│
├── scenes/                       # Godot scene files (.tscn)
│   ├── main.tscn                # Root scene
│   ├── title_screen.tscn
│   ├── village/
│   ├── navigation/
│   ├── ui/
│   ├── ceremony/
│   └── transitions/
│
├── docs/                         # Design documents
│   ├── GDD.md
│   ├── ART_BIBLE.md
│   ├── AUDIO_BIBLE.md
│   └── TECHNICAL_ARCHITECTURE.md
│
└── tests/                        # Unit & integration tests
    ├── test_economy.gd
    ├── test_navigation.gd
    ├── test_prestige.gd
    └── test_events.gd
```

## 2.2 — Architecture Pattern

**Pattern: Component-Based with Event Bus**

Tidelines uses Godot's node-based scene tree as its structural backbone, with an **Event Bus** (global signal system) for decoupled communication between systems.

### Why Event Bus?
Many systems need to react to each other without direct coupling:
- When a potlatch is hosted → prestige system updates → diplomacy system recalculates → village visual system updates → legacy system records
- When a chief dies → succession system activates → lineage system updates → event system may trigger memorial events → UI transitions

The Event Bus allows these cascading effects without tangled dependencies.

### Event Bus Design

```gdscript
# event_bus.gd — Autoload singleton
extends Node

# Core game signals
signal season_changed(new_season: String, year: int)
signal era_changed(new_era: int, era_data: Dictionary)
signal turn_ended()

# Village signals
signal resource_changed(resource_type: String, amount: int, total: int)
signal building_completed(building_data: Dictionary)
signal population_changed(delta: int, total: int)
signal labor_assigned(person_id: String, role: String)

# Navigation signals
signal voyage_started(canoe_id: String, destination: String)
signal voyage_completed(canoe_id: String, outcome: Dictionary)
signal weather_changed(new_weather: String)
signal tide_changed(new_tide: String)
signal location_discovered(location_id: String)
signal sea_encounter(encounter_data: Dictionary)

# Social signals
signal prestige_changed(delta: int, total: int, source: String)
signal alliance_formed(ally_id: String, type: String)
signal alliance_broken(ally_id: String, reason: String)
signal marriage_completed(person_a: String, person_b: String)
signal chief_died(chief_data: Dictionary)
signal succession_started(candidates: Array)
signal succession_completed(new_chief: Dictionary)

# Ceremony signals
signal potlatch_started(potlatch_data: Dictionary)
signal potlatch_completed(results: Dictionary)
signal pole_commissioned(pole_data: Dictionary)
signal pole_completed(pole_data: Dictionary)
signal pole_raised(pole_data: Dictionary)
signal blessing_received(blessing_type: String, target: String)

# Conflict signals
signal conflict_started(conflict_data: Dictionary)
signal conflict_resolved(results: Dictionary)
signal raid_incoming(attacker_data: Dictionary)

# Event system signals
signal event_triggered(event_data: Dictionary)
signal event_choice_made(event_id: String, choice_index: int)
signal omen_received(omen_data: Dictionary)
signal dream_started(dream_data: Dictionary)
```

---

# 3. DATA-DRIVEN CONTENT SYSTEM

## 3.1 — Philosophy

All game content that might change during development (and especially during balancing) should live in **data files**, not in code. This includes:
- Events and their choices/outcomes
- Canoe definitions and stats
- Building definitions and costs
- Resource definitions
- Chief archetypes
- Crest figures and their properties
- Era definitions and triggers
- Balance constants

This allows:
- Content creators to add events without touching code
- Rapid balancing through number tweaks in JSON
- Potential modding support
- Clean separation of engine logic from content

## 3.2 — Data Format: JSON

All data files use JSON for simplicity, readability, and universal tooling support.

### Naming Conventions
- Files: `snake_case.json`
- Keys: `snake_case`
- IDs: `snake_case` (unique per type)
- Enums: `UPPER_CASE`

### Schema Validation
Each data type has a schema (documented in code comments or a separate schema file). The `DataLoader` validates JSON against expected schemas at load time, producing clear error messages for malformed data.

## 3.3 — Event System Architecture

Events are the most complex data-driven system. Each event is a JSON object with:

```json
{
  "id": "fog_bank_approach",
  "category": "exploration",
  "title": "Fog Bank Approaches",
  "description": "Dense fog rolls in during your voyage, obscuring the coastline and disorienting your crew.",
  "portrait": "fog_scene",
  "music_override": "fog_navigation",
  
  "conditions": {
    "context": "NAVIGATION",
    "weather_not": ["STORM", "GALE"],
    "season": ["SPRING", "AUTUMN"],
    "min_distance_from_shore": 2,
    "probability": 0.15
  },
  
  "choices": [
    {
      "text": "Navigate by landmarks and memory.",
      "tooltip": "Requires navigation skill. Risky in unknown waters.",
      "conditions": { "chief_trait": "NAVIGATOR" },
      "checks": [
        {
          "type": "SKILL_CHECK",
          "skill": "navigation",
          "difficulty": 12,
          "success": {
            "effects": [
              { "type": "CONTINUE_VOYAGE" },
              { "type": "PRESTIGE", "amount": 2, "reason": "Masterful fog navigation" },
              { "type": "CREW_MORALE", "amount": 5 }
            ],
            "narrative": "Your knowledge of the coastline guides you true. The crew's confidence swells as you emerge from the grey wall into clear water."
          },
          "failure": {
            "effects": [
              { "type": "DELAY_VOYAGE", "turns": 1 },
              { "type": "CREW_MORALE", "amount": -10 },
              { "type": "CANOE_DAMAGE", "amount": 5, "chance": 0.3 }
            ],
            "narrative": "The landmarks blur together in the grey. You push forward but strike a submerged rock. The canoe shudders. Hours are lost before you find your bearings."
          }
        }
      ]
    },
    {
      "text": "Stop and wait for the fog to lift.",
      "tooltip": "Safe but costs time. May miss tidal window.",
      "conditions": {},
      "effects": [
        { "type": "DELAY_VOYAGE", "turns": 1 },
        { "type": "CREW_MORALE", "amount": -3 },
        { "type": "FOOD_CONSUMED", "multiplier": 1.5 }
      ],
      "narrative": "You beach in a sheltered cove and wait. The fog clings to the water for hours. When it finally lifts, you've lost a day and the tidal window you needed."
    },
    {
      "text": "Turn back to the last known safe point.",
      "tooltip": "Safest option. Voyage delayed significantly.",
      "conditions": {},
      "effects": [
        { "type": "RETURN_TO_LAST_LOCATION" },
        { "type": "CREW_MORALE", "amount": -5 },
        { "type": "PRESTIGE", "amount": -1, "reason": "Turned back from fog" }
      ],
      "narrative": "Wisdom or cowardice? The crew's faces are unreadable as you order the turn. Better cautious than drowned. The village can wait."
    }
  ],
  
  "tags": ["fog", "navigation", "risk", "weather"],
  "era_availability": [1, 2, 3, 4],
  "cooldown_seasons": 4,
  "max_occurrences_per_campaign": -1
}
```

### Event Condition Types

| Condition | Description |
|-----------|-------------|
| `context` | Where the event can fire: NAVIGATION, VILLAGE, CEREMONY, TRADE, CONFLICT |
| `season` | Which seasons the event is available |
| `era` | Which eras |
| `weather` / `weather_not` | Weather conditions |
| `min_prestige` / `max_prestige` | Prestige range |
| `has_building` | Village has specific building |
| `has_canoe_type` | Fleet includes specific canoe type |
| `chief_trait` | Chief has specific trait |
| `moiety` | Chief's moiety |
| `alliance_with` | Has alliance with specific village type |
| `probability` | Base probability of firing per eligible turn |
| `cooldown_seasons` | Minimum turns between re-occurrences |
| `prerequisite_event` | A specific event must have occurred first |

### Event Effect Types

| Effect | Description |
|--------|-------------|
| `PRESTIGE` | Add/remove prestige |
| `RESOURCE` | Add/remove specific resource |
| `FOOD_CONSUMED` | Modify food consumption |
| `CREW_MORALE` | Modify crew morale |
| `CANOE_DAMAGE` | Damage canoe |
| `DELAY_VOYAGE` | Add turns to voyage |
| `RETURN_TO_LAST_LOCATION` | Abort voyage |
| `CONTINUE_VOYAGE` | Continue normally |
| `DISCOVER_LOCATION` | Reveal new map location |
| `RELATIONSHIP_CHANGE` | Modify diplomatic relationship |
| `POPULATION` | Add/remove population |
| `TRIGGER_EVENT` | Chain to another event |
| `SET_FLAG` | Set a game state flag |
| `OMEN` | Grant an omen |
| `BLESSING` | Grant a blessing |
| `TRAIT_CHECK` | Test chief trait for modified outcome |

---

# 4. SAVE/LOAD SYSTEM

## 4.1 — Save Data Structure

```json
{
  "save_version": "1.0.0",
  "timestamp": "2026-03-14T12:00:00Z",
  "campaign": {
    "era": 2,
    "year": 47,
    "season": "SUMMER",
    "turn": 3,
    "difficulty": "NORMAL"
  },
  "village": {
    "name": "Kayung",
    "population": 156,
    "buildings": [
      { "id": "chief_longhouse", "level": 3, "condition": 0.95 },
      { "id": "canoe_house_1", "level": 2, "condition": 1.0 }
    ],
    "resources": {
      "salmon_preserved": 450,
      "halibut_preserved": 120,
      "eulachon_oil": 85,
      "cedar_logs": 12,
      "cedar_bark": 40,
      "woven_blankets": 24,
      "carved_objects": 18,
      "coppers": 1
    },
    "labor_assignments": {
      "fishers": 28,
      "builders": 12,
      "carvers": 6,
      "weavers": 8,
      "warriors": 15,
      "ceremonial": 2,
      "unassigned": 10
    }
  },
  "canoes": [
    {
      "id": "canoe_001",
      "name": "Wave Cutter",
      "type": "TRAVEL",
      "condition": 0.85,
      "voyages_completed": 12,
      "blessed": true,
      "upgrades": ["reinforced_hull", "crest_prow"]
    }
  ],
  "poles": [
    {
      "id": "pole_001",
      "type": "HOUSE_FRONTAL",
      "figures": ["eagle", "raven", "bear"],
      "commemorates": "Founding of Kayung",
      "carver": "Master Kwaani",
      "year_raised": 38,
      "era_raised": 1,
      "condition": 0.90,
      "prestige_value": 45
    }
  ],
  "chief": {
    "id": "chief_002",
    "name": "Skaay",
    "moiety": "RAVEN",
    "traits": ["ORATOR", "DIPLOMAT"],
    "age": 42,
    "prestige": 340,
    "years_as_chief": 8
  },
  "lineage": {
    "family_tree": [],
    "past_chiefs": [
      {
        "name": "K'aad",
        "years": "1-35",
        "era": 1,
        "legacy_score": 280,
        "poles_raised": 1,
        "potlatches_hosted": 3
      }
    ]
  },
  "diplomacy": {
    "relationships": [
      { "village": "Skidegate", "standing": 75, "alliance": true, "marriage_tie": true },
      { "village": "Cumshewa", "standing": 30, "alliance": false, "marriage_tie": false }
    ]
  },
  "world": {
    "discovered_locations": ["loc_001", "loc_002", "loc_015"],
    "active_trade_routes": ["route_north_1"],
    "weather_state": { "current": "OVERCAST", "forecast": ["RAIN", "CLEAR"] },
    "tide_phase": "FALLING"
  },
  "events": {
    "occurred": ["fog_bank_approach", "eagle_sighting_dawn"],
    "active_flags": ["met_tsimshian_chief", "epidemic_rumor"],
    "cooldowns": { "fog_bank_approach": 3 }
  },
  "legacy": {
    "total_prestige_earned": 620,
    "total_wealth_redistributed": 2400,
    "voyages_completed": 34,
    "potlatches_hosted": 5,
    "poles_raised": 2,
    "alliances_formed": 4,
    "conflicts_survived": 3
  }
}
```

## 4.2 — Save System Implementation

### Save Slots
- 3 save slots per campaign
- Auto-save at each season transition
- Manual save from pause menu
- Save file stored in user data directory

### Save Integrity
- Version number for migration support
- Checksum to detect corruption
- Backup of previous save (auto-rotate: keep last 2)

### Migration
When save format changes between versions:
- `SaveMigrator` class handles upgrades
- Each version bump has a migration function
- Old saves are always upgradable (forward migration chain)

---

# 5. SPRITE ATLAS STRATEGY

## 5.1 — Atlas Organization

Sprites are organized into themed atlas sheets for efficient GPU batching:

| Atlas | Contents | Estimated Size |
|-------|----------|---------------|
| **atlas_terrain** | Water tiles, ground tiles, beaches, rocks | 512×512 |
| **atlas_vegetation** | Trees, ferns, moss, grass, kelp | 512×512 |
| **atlas_buildings** | All village building sprites | 512×512 |
| **atlas_canoes** | All canoe types, all animation frames | 512×512 |
| **atlas_characters** | All character sprites (walk cycles, etc.) | 512×512 |
| **atlas_poles** | All pole figure modules | 256×256 |
| **atlas_ui** | UI frames, icons, buttons | 512×512 |
| **atlas_effects** | Weather particles, splash, fire, smoke | 256×256 |
| **atlas_portraits** | Character portraits (larger sprites) | 512×512 |
| **atlas_animals** | Eagle, raven, whale, bear, salmon, etc. | 256×256 |

## 5.2 — Animation Sheet Format

Animated sprites use horizontal strip format:
```
[Frame1][Frame2][Frame3][Frame4]... → packed left-to-right
```

Frame data stored in accompanying `.json`:
```json
{
  "sprite": "canoe_travel_paddle",
  "frame_width": 48,
  "frame_height": 20,
  "frame_count": 8,
  "fps": 10,
  "loop": true
}
```

## 5.3 — Modular Pole Assembly

Poles use a special modular system rather than pre-baked full-pole sprites:

```
POLE ATLAS (256×256):
┌────────────────────────────┐
│ [Eagle 16×24] [Raven 16×24] │
│ [Bear 16×20]  [Whale 16×24] │
│ [Frog 16×16]  [Wolf 16×20]  │
│ [Human 16×20] [T-bird 16×28]│
│ [Shark 16×20] [Beaver 16×16]│
│ [Top caps...]  [Bases...]    │
│ [Paint overlays...]          │
└────────────────────────────┘
```

At runtime, the `PoleRenderer` stacks these modules vertically to create the player's designed pole, applies paint color tinting, and optionally applies a weathering shader based on pole age.

---

# 6. DIALOGUE / EVENT AUTHORING

## 6.1 — Content Authoring Pipeline

### For Designers (Non-Programmers)
1. Write event in a **spreadsheet** or **dedicated event editor** (built as a tool during pre-production)
2. Export to JSON format
3. JSON validated by `DataLoader` at game startup
4. Events are live-reloadable during development (hot reload from JSON)

### Event Editor Tool (Pre-Production Deliverable)
A simple desktop tool (could be web-based — HTML/JS) that provides:
- Form-based event creation (fields for ID, title, description, conditions, choices)
- Choice tree visualization
- Condition builder (dropdown menus for condition types)
- Effect builder (dropdown + number inputs)
- Preview panel (shows how the event will look in-game)
- Export to JSON
- Batch validation

This tool pays for itself quickly — event content is the game's largest data set.

## 6.2 — Narrative Text Guidelines

### Voice
- **Second person, present tense** for event descriptions: "You see...", "The fog rolls in..."
- **Past tense** for outcome narratives: "You navigated through...", "The crew was shaken..."
- **Formal but not stiff.** Poetic where appropriate. Never chatty or modern-sounding.
- **Short paragraphs.** 2-3 sentences maximum per text block. This is pixel-art screen real estate.

### Formatting
- Event descriptions: 2-3 sentences
- Choice text: 1 short sentence (imperative mood: "Navigate by landmarks.", "Wait for the fog.")
- Choice tooltips: 1 sentence of mechanical information
- Outcome narratives: 2-4 sentences

---

# 7. KEY SYSTEM ARCHITECTURES

## 7.1 — Turn / Season System

```
GAME TIME:
1 Campaign = 5 Eras
1 Era = ~6-12 Years
1 Year = 4 Seasons (Spring, Summer, Autumn, Winter)
1 Season = 3-4 Turns (each turn = player action phase + resolution)
```

### Turn Flow
```
1. TURN START
   ├── Weather update
   ├── Tide cycle advance
   ├── Event check (may trigger pre-turn event)
   └── Resource production (seasonal rates)

2. PLAYER ACTION PHASE
   ├── Village: assign labor, start/continue projects
   ├── Navigation: plan/continue/complete voyages
   ├── Diplomacy: send messages, respond to proposals
   ├── Ceremony: prepare potlatch, advance carving
   └── Defense: assign patrols, fortify

3. RESOLUTION PHASE
   ├── Construction progress
   ├── Carving progress
   ├── Voyage progress (if in transit)
   ├── Food consumption
   ├── Event resolution
   ├── Relationship drift
   └── Random event check

4. TURN END
   ├── Check season transition
   ├── Check era transition triggers
   ├── Auto-save (if season changed)
   └── Advance to next turn
```

## 7.2 — Prestige System

Prestige is tracked as an integer score with multiple sub-components:

```gdscript
class_name PrestigeTracker

var total_prestige: int = 0

# Sub-scores (feed into total)
var potlatch_prestige: int = 0     # From hosting potlatches
var pole_prestige: int = 0         # From standing poles
var diplomatic_prestige: int = 0   # From alliances and marriages
var conflict_prestige: int = 0     # From victories and intimidation
var voyage_prestige: int = 0       # From successful expeditions
var canoe_prestige: int = 0        # From fleet quality
var spiritual_prestige: int = 0    # From ceremony and omens honored

# Prestige decays slowly if not maintained
var decay_rate: float = 0.02  # 2% per year baseline

func calculate_total() -> int:
    total_prestige = (
        potlatch_prestige + pole_prestige + diplomatic_prestige +
        conflict_prestige + voyage_prestige + canoe_prestige +
        spiritual_prestige
    )
    return total_prestige

func apply_yearly_decay():
    # Prestige requires active maintenance
    # Potlatch and pole prestige decay slower (they're permanent acts)
    diplomatic_prestige = int(diplomatic_prestige * (1.0 - decay_rate * 2.0))
    conflict_prestige = int(conflict_prestige * (1.0 - decay_rate * 1.5))
    voyage_prestige = int(voyage_prestige * (1.0 - decay_rate * 1.5))
    canoe_prestige = int(canoe_prestige * (1.0 - decay_rate))
    # Potlatch and pole prestige decay much slower
    potlatch_prestige = int(potlatch_prestige * (1.0 - decay_rate * 0.5))
    pole_prestige = int(pole_prestige * (1.0 - decay_rate * 0.25))
```

### Prestige Thresholds

| Level | Score Range | Title | Unlocks |
|-------|-------------|-------|---------|
| 1 | 0-50 | Newcomer | Basic systems |
| 2 | 51-150 | Respected | Marriage proposals, minor trade partners |
| 3 | 151-300 | Honored | Major alliances, war canoe commissioning |
| 4 | 301-500 | Renowned | Rivalry potlatch, distant trade routes |
| 5 | 501-750 | Great Chief | Prestige canoe, copper acquisition |
| 6 | 751-1000 | Legendary | Peak diplomatic power, maximum legacy scoring |

## 7.3 — Weather Generation

```gdscript
class_name WeatherSystem

enum Weather { CLEAR, OVERCAST, RAIN, HEAVY_RAIN, FOG, STORM, GALE }
enum Season { SPRING, SUMMER, AUTUMN, WINTER }

# Probability weights per season (higher = more likely)
var weather_weights = {
    Season.SPRING: {
        Weather.CLEAR: 20, Weather.OVERCAST: 25, Weather.RAIN: 25,
        Weather.HEAVY_RAIN: 10, Weather.FOG: 15, Weather.STORM: 4, Weather.GALE: 1
    },
    Season.SUMMER: {
        Weather.CLEAR: 40, Weather.OVERCAST: 25, Weather.RAIN: 15,
        Weather.HEAVY_RAIN: 5, Weather.FOG: 8, Weather.STORM: 5, Weather.GALE: 2
    },
    Season.AUTUMN: {
        Weather.CLEAR: 15, Weather.OVERCAST: 20, Weather.RAIN: 25,
        Weather.HEAVY_RAIN: 15, Weather.FOG: 10, Weather.STORM: 10, Weather.GALE: 5
    },
    Season.WINTER: {
        Weather.CLEAR: 10, Weather.OVERCAST: 15, Weather.RAIN: 20,
        Weather.HEAVY_RAIN: 20, Weather.FOG: 5, Weather.STORM: 20, Weather.GALE: 10
    }
}

var current_weather: Weather = Weather.CLEAR
var forecast: Array[Weather] = []

func generate_weather(season: Season) -> Weather:
    var weights = weather_weights[season]
    var total_weight = 0
    for w in weights.values():
        total_weight += w
    
    var roll = randi() % total_weight
    var cumulative = 0
    for weather_type in weights:
        cumulative += weights[weather_type]
        if roll < cumulative:
            return weather_type
    
    return Weather.OVERCAST  # Fallback

func generate_forecast(season: Season, days: int = 3) -> Array[Weather]:
    forecast.clear()
    for i in range(days):
        forecast.append(generate_weather(season))
    return forecast
```

## 7.4 — Conflict Resolution Engine

The conflict system is a **multi-phase strategic engine** that processes raids, defenses, and sea encounters through distinct phases, each with player decisions and calculated outcomes. It integrates with the Feud Tracker, Intimidation Engine, and Aftermath Processor.

### Architecture Overview

```
ConflictManager (orchestrator)
├── IntelligenceGatherer      — scouting / pre-raid info
├── IntimidationEngine        — fear & reputation calculations
├── EngagementResolver        — multi-round force calculation
├── AftermathProcessor        — casualties, spoils, feud updates
├── FeudTracker               — persistent inter-community feuds
└── WarTraitManager           — trait earning and application
```

### ConflictManager — Orchestrator

```gdscript
class_name ConflictManager

var intelligence_gatherer: IntelligenceGatherer
var intimidation_engine: IntimidationEngine
var engagement_resolver: EngagementResolver
var aftermath_processor: AftermathProcessor
var feud_tracker: FeudTracker
var war_trait_manager: WarTraitManager

var active_conflicts: Array[Dictionary] = []

## Launches a full multi-phase conflict operation
func initiate_conflict(conflict_data: Dictionary) -> Dictionary:
    var conflict_id = _generate_conflict_id()
    var state = {
        "id": conflict_id,
        "type": conflict_data.get("type", "sea_encounter"),
        "attacker": conflict_data.get("attacker", {}),
        "defender": conflict_data.get("defender", {}),
        "conditions": conflict_data.get("conditions", {}),
        "phase": "intelligence",
        "objective": conflict_data.get("objective", "resource_seizure"),
        "secondary_objectives": conflict_data.get("secondary_objectives", []),
        "rounds": [],
        "result": {}
    }
    active_conflicts.append(state)
    EventBus.conflict_started.emit(state)
    return state

## Advances the conflict to the next phase based on player choice
func advance_phase(conflict_id: String, player_choice: Dictionary) -> Dictionary:
    var state = _get_conflict(conflict_id)
    if state.is_empty():
        return {"error": "conflict_not_found"}
    
    match state["phase"]:
        "intelligence":
            state = _process_intelligence(state, player_choice)
        "approach":
            state = _process_approach(state, player_choice)
        "engagement":
            state = _process_engagement(state, player_choice)
        "resolution":
            state = _process_resolution(state)
        "withdrawal":
            state = _process_withdrawal(state, player_choice)
        "aftermath":
            state = _process_aftermath(state, player_choice)
    
    return state

func _process_intelligence(state: Dictionary, choice: Dictionary) -> Dictionary:
    var intel = intelligence_gatherer.gather(state, choice.get("method", "scouts"))
    state["intelligence"] = intel
    state["phase"] = "approach"
    EventBus.scouting_completed.emit(state["id"], intel)
    return state

func _process_approach(state: Dictionary, choice: Dictionary) -> Dictionary:
    state["approach"] = {
        "time_of_day": choice.get("time", "dawn"),
        "formation": choice.get("formation", "single"),
        "vector": choice.get("vector", "open_water"),
        "weather": state["conditions"].get("weather", "clear")
    }
    # Intimidation check at approach
    var intim_result = intimidation_engine.check(state)
    state["intimidation_result"] = intim_result
    if intim_result["defender_flees"]:
        state["phase"] = "aftermath"
        state["result"]["outcome"] = "INTIMIDATION_VICTORY"
        EventBus.intimidation_success.emit(state["id"], "flee")
    elif intim_result["negotiation_offered"]:
        state["negotiation_available"] = true
        state["phase"] = "engagement"
        EventBus.intimidation_success.emit(state["id"], "negotiate")
    else:
        state["phase"] = "engagement"
    return state

func _process_engagement(state: Dictionary, choice: Dictionary) -> Dictionary:
    state["attacker_tactic"] = choice.get("tactic", "measured_push")
    state["defender_tactic"] = choice.get("defender_tactic", "hold_the_beach")
    state["phase"] = "resolution"
    EventBus.engagement_begun.emit(state["id"], state["attacker_tactic"])
    return state

func _process_resolution(state: Dictionary) -> Dictionary:
    var result = engagement_resolver.resolve(state)
    state["result"] = result
    state["rounds"] = result.get("rounds", [])
    state["phase"] = "withdrawal"
    EventBus.conflict_resolved.emit(result)
    return state

func _process_withdrawal(state: Dictionary, choice: Dictionary) -> Dictionary:
    var withdrawal = {
        "pursue": choice.get("pursue", false),
        "orderly": state["result"].get("winner_is_attacker", true),
        "rearguard_volunteer": choice.get("rearguard_volunteer", "")
    }
    if withdrawal["rearguard_volunteer"] != "":
        var survived = randf() > 0.35  # 65% survival for rearguard
        withdrawal["rearguard_survived"] = survived
        if survived:
            war_trait_manager.award_crew_trait(
                withdrawal["rearguard_volunteer"], "loyal_to_the_death"
            )
        else:
            EventBus.crew_member_lost.emit(withdrawal["rearguard_volunteer"], "rearguard_action")
    state["withdrawal"] = withdrawal
    state["phase"] = "aftermath"
    EventBus.withdrawal_completed.emit(state["id"], withdrawal)
    return state

func _process_aftermath(state: Dictionary, choice: Dictionary) -> Dictionary:
    var aftermath = aftermath_processor.process(state, choice)
    state["aftermath"] = aftermath
    state["phase"] = "complete"
    
    # Update feud state
    feud_tracker.update_from_conflict(state)
    
    # Check for war trait awards
    war_trait_manager.evaluate_conflict(state)
    
    # Remove from active conflicts
    active_conflicts.erase(state)
    EventBus.aftermath_completed.emit(state["id"], aftermath)
    return state
```

### IntelligenceGatherer — Pre-Raid Scouting

```gdscript
class_name IntelligenceGatherer

enum Method { SCOUTS, TRADERS, OMENS, FEUD_HISTORY }
enum Quality { VAGUE, ACCURATE, PRECISE }

func gather(conflict_state: Dictionary, method: String) -> Dictionary:
    var base_quality = _get_base_quality(method)
    var roll = randf()
    
    var quality: Quality
    if roll < base_quality["precise_chance"]:
        quality = Quality.PRECISE
    elif roll < base_quality["precise_chance"] + base_quality["accurate_chance"]:
        quality = Quality.ACCURATE
    else:
        quality = Quality.VAGUE
    
    var intel = {
        "quality": quality,
        "method": method,
        "crew_strength": _assess_strength(conflict_state["defender"], quality),
        "defenses": _assess_defenses(conflict_state["defender"], quality),
        "canoe_count": _assess_canoes(conflict_state["defender"], quality),
        "alert_level": _assess_alertness(conflict_state["defender"], quality),
        "surprise_possible": quality >= Quality.ACCURATE and _assess_alertness(conflict_state["defender"], quality) == "unaware"
    }
    return intel

func _get_base_quality(method: String) -> Dictionary:
    match method:
        "scouts":
            return {"precise_chance": 0.25, "accurate_chance": 0.45, "time_cost": 1}
        "traders":
            return {"precise_chance": 0.15, "accurate_chance": 0.40, "time_cost": 0}
        "omens":
            return {"precise_chance": 0.10, "accurate_chance": 0.35, "time_cost": 0}
        "feud_history":
            return {"precise_chance": 0.05, "accurate_chance": 0.50, "time_cost": 0}
        _:
            return {"precise_chance": 0.10, "accurate_chance": 0.30, "time_cost": 0}

func _assess_strength(defender: Dictionary, quality: Quality) -> String:
    var actual = defender.get("crew_size", 10)
    match quality:
        Quality.PRECISE: return str(actual)
        Quality.ACCURATE:
            # ±20% estimate
            var estimate = actual + randi_range(int(-actual * 0.2), int(actual * 0.2))
            return "~" + str(max(estimate, 1))
        _: # VAGUE
            if actual < 8: return "few warriors"
            elif actual < 16: return "moderate force"
            else: return "many warriors"

func _assess_defenses(defender: Dictionary, quality: Quality) -> String:
    var fortified = defender.get("fortification_level", 0)
    match quality:
        Quality.PRECISE: return "level_" + str(fortified)
        Quality.ACCURATE:
            if fortified == 0: return "none_seen"
            elif fortified <= 2: return "some_fortification"
            else: return "heavily_defended"
        _:
            return "unknown"

func _assess_canoes(defender: Dictionary, quality: Quality) -> String:
    var count = defender.get("canoe_count", 2)
    match quality:
        Quality.PRECISE: return str(count) + " canoes"
        Quality.ACCURATE:
            if count <= 1: return "few"
            elif count <= 3: return "several"
            else: return "war_fleet_present"
        _:
            return "unknown"

func _assess_alertness(defender: Dictionary, quality: Quality) -> String:
    if quality == Quality.VAGUE:
        return "unknown"
    var alert = defender.get("alert_level", 0)
    if alert == 0: return "unaware"
    elif alert == 1: return "cautious"
    else: return "expecting_attack"
```

### IntimidationEngine — Fear & Reputation

```gdscript
class_name IntimidationEngine

func check(conflict_state: Dictionary) -> Dictionary:
    var attacker = conflict_state["attacker"]
    var defender = conflict_state["defender"]
    
    var intim_score = calculate_intimidation(attacker)
    var resolve_score = calculate_resolve(defender, conflict_state)
    var delta = intim_score - resolve_score
    
    var result = {
        "intimidation_score": intim_score,
        "resolve_score": resolve_score,
        "delta": delta,
        "defender_flees": delta >= 50,
        "negotiation_offered": delta >= 30 and delta < 50,
        "defender_morale_penalty": _calculate_morale_penalty(delta),
        "attacker_morale_penalty": _calculate_morale_penalty(-delta) if delta < 0 else 0
    }
    return result

func calculate_intimidation(force: Dictionary) -> int:
    var score = 0
    # War canoe fleet (0-25)
    score += mini(force.get("war_canoe_rating", 0), 25)
    # Conflict reputation (0-30)
    score += mini(force.get("conflict_reputation", 0), 30)
    # Chief war trait (0-15)
    if force.get("chief_traits", []).has("fearsome"):
        score += 15
    elif force.get("chief_traits", []).has("battle_tested"):
        score += 8
    # Crest display (0-10)
    score += mini(force.get("crest_display", 0), 10)
    # General prestige (0-10)
    score += mini(force.get("prestige", 0) / 100, 10)
    # Recent victory (0-10)
    if force.get("recent_victory_seasons", 99) <= 2:
        score += 10
    # War song (0-5)
    if force.get("has_war_song", false):
        score += 5
    return score

func calculate_resolve(defender: Dictionary, state: Dictionary) -> int:
    var score = 0
    # Base community resolve (20-60)
    score += clampi(defender.get("community_size", 30), 20, 60)
    # Chief leadership (0-15)
    score += mini(defender.get("chief_leadership", 0), 15)
    # Defending home (flat +20)
    if state.get("type", "") in ["defensive_village_raid"]:
        score += 20
    # Alliance strength (0-15)
    score += mini(defender.get("alliance_strength", 0), 15)
    # Recent victory (0-10)
    if defender.get("recent_victory_seasons", 99) <= 2:
        score += 10
    # Fortification (0-15)
    score += mini(defender.get("fortification_level", 0) * 5, 15)
    # Desperation (0-15)
    if defender.get("desperate", false):
        score += 15
    return score

func _calculate_morale_penalty(delta: int) -> int:
    if delta >= 50: return 0  # They fled, no penalty needed
    elif delta >= 30: return 0  # Negotiation, no penalty
    elif delta >= 15: return randi_range(15, 25)
    elif delta >= 1: return randi_range(5, 10)
    else: return 0
```

### EngagementResolver — Multi-Round Combat

```gdscript
class_name EngagementResolver

func resolve(conflict_state: Dictionary) -> Dictionary:
    var attacker = conflict_state["attacker"]
    var defender = conflict_state["defender"]
    var conditions = conflict_state["conditions"]
    var attacker_tactic = conflict_state.get("attacker_tactic", "measured_push")
    var defender_tactic = conflict_state.get("defender_tactic", "hold_the_beach")
    
    # Get tactic modifiers
    var atk_mod = _get_tactic_modifier(attacker_tactic, true)
    var def_mod = _get_tactic_modifier(defender_tactic, false)
    
    # Apply intimidation morale penalties
    var intim = conflict_state.get("intimidation_result", {})
    var defender_morale_penalty = intim.get("defender_morale_penalty", 0)
    var attacker_morale_penalty = intim.get("attacker_morale_penalty", 0)
    
    # === ROUND 1: Opening Clash ===
    var r1_atk = _calculate_round_score(attacker, conditions, true, "opening", atk_mod)
    var r1_def = _calculate_round_score(defender, conditions, false, "opening", def_mod)
    r1_def -= defender_morale_penalty * 0.3
    r1_atk -= attacker_morale_penalty * 0.3
    
    # Surprise bonus (only in opening)
    if conditions.get("surprise", false):
        r1_atk *= 1.25
    if conditions.get("fortified", false):
        r1_def *= 1.20
    
    var round_1 = {"attacker": r1_atk, "defender": r1_def, "name": "Opening Clash"}
    
    # === ROUND 2: Sustained Engagement ===
    var r2_atk = _calculate_round_score(attacker, conditions, true, "sustained", atk_mod)
    var r2_def = _calculate_round_score(defender, conditions, false, "sustained", def_mod)
    
    var round_2 = {"attacker": r2_atk, "defender": r2_def, "name": "Sustained Engagement"}
    
    # === ROUND 3: Turning Point ===
    var turning_point_event = _generate_turning_point(conflict_state)
    var r3_atk = _calculate_round_score(attacker, conditions, true, "turning", atk_mod)
    var r3_def = _calculate_round_score(defender, conditions, false, "turning", def_mod)
    r3_atk += turning_point_event.get("attacker_bonus", 0)
    r3_def += turning_point_event.get("defender_bonus", 0)
    
    var round_3 = {
        "attacker": r3_atk, "defender": r3_def,
        "name": "Turning Point",
        "event": turning_point_event
    }
    
    # === ROUND 4: Resolution ===
    var cumulative_atk = r1_atk + r2_atk + r3_atk
    var cumulative_def = r1_def + r2_def + r3_def
    
    # Add randomness (±12% swing on final total)
    cumulative_atk *= randf_range(0.88, 1.12)
    cumulative_def *= randf_range(0.88, 1.12)
    
    var ratio = cumulative_atk / max(cumulative_def, 1.0)
    var outcome = _determine_outcome(ratio)
    
    var result = {
        "outcome": outcome,
        "ratio": ratio,
        "rounds": [round_1, round_2, round_3],
        "turning_point": turning_point_event,
        "attacker_losses": _calculate_losses(ratio, attacker, true, atk_mod),
        "defender_losses": _calculate_losses(ratio, defender, false, def_mod),
        "prestige_shift": _calculate_prestige_shift(outcome),
        "captured_goods": _calculate_capture(outcome, defender),
        "narrative_key": _determine_narrative(outcome, conditions),
        "winner_is_attacker": ratio > 1.0
    }
    return result

func _calculate_round_score(force: Dictionary, conditions: Dictionary, is_attacker: bool, round_type: String, tactic_mod: float) -> float:
    var score = 0.0
    
    match round_type:
        "opening":
            # Surprise, positioning, initial morale matter most
            score += force.get("morale", 50) * 0.40
            score += force.get("crew_quality", 50) * 0.20
            score += force.get("crew_size", 10) / 20.0 * 100.0 * 0.20
            score += force.get("canoe_combat_rating", 50) * 0.10
            if force.get("blessed", false): score *= 1.05
        "sustained":
            # Crew quality, stamina, and leadership dominate
            score += force.get("crew_quality", 50) * 0.35
            score += force.get("crew_size", 10) / 20.0 * 100.0 * 0.25
            score += force.get("stamina", 50) * 0.20
            score += force.get("chief_leadership", 50) * 0.15
            score += force.get("canoe_combat_rating", 50) * 0.05
        "turning":
            # Morale, named character actions, and randomness
            score += force.get("morale", 50) * 0.35
            score += force.get("crew_quality", 50) * 0.25
            score += force.get("chief_leadership", 50) * 0.20
            # Larger random swing in turning point
            score *= randf_range(0.80, 1.20)
    
    score *= tactic_mod
    
    # Weather advantage
    if conditions.get("weather_advantage", "") == ("attacker" if is_attacker else "defender"):
        score *= 1.10
    
    # War trait bonuses
    for trait in force.get("war_traits", []):
        score += _get_trait_bonus(trait, round_type, is_attacker)
    
    return score

func _generate_turning_point(state: Dictionary) -> Dictionary:
    var events = [
        {"id": "warrior_falls", "text": "A named warrior falls in the fighting.", "attacker_bonus": 0, "defender_bonus": 10, "triggers_grief": true},
        {"id": "chief_rallies", "text": "The chief rallies their crew with a battle cry.", "attacker_bonus": 15, "defender_bonus": 0},
        {"id": "canoe_captured", "text": "A canoe is seized in the chaos.", "attacker_bonus": 12, "defender_bonus": -8},
        {"id": "fire_breaks_out", "text": "Fire erupts — smoke and confusion everywhere.", "attacker_bonus": -5, "defender_bonus": -5},
        {"id": "reinforcements", "text": "Allied canoes appear on the horizon.", "attacker_bonus": 0, "defender_bonus": 20},
        {"id": "war_song", "text": "A war song rises above the clash — hearts harden.", "attacker_bonus": 10, "defender_bonus": 0},
        {"id": "fog_rolls_in", "text": "Sudden fog. Both sides lose cohesion.", "attacker_bonus": -8, "defender_bonus": -3},
        {"id": "champion_duel", "text": "Two warriors face each other between the lines.", "attacker_bonus": 8, "defender_bonus": 8}
    ]
    return events[randi() % events.size()]

func _get_tactic_modifier(tactic: String, is_attacker: bool) -> float:
    if is_attacker:
        match tactic:
            "overwhelming_assault": return 1.30
            "measured_push": return 1.10
            "feint_and_probe": return 0.80
            "intimidation_display": return 0.50
            "encirclement": return 1.40
            "negotiation_under_arms": return 0.0
            _: return 1.0
    else:
        match tactic:
            "hold_the_beach": return 1.25
            "meet_at_sea": return 1.10
            "fighting_withdrawal": return 0.80
            "concentrated_defense": return 1.40
            "surrender_terms": return 0.0
            _: return 1.0

func _determine_outcome(ratio: float) -> String:
    if ratio > 1.8: return "DECISIVE_VICTORY"
    elif ratio > 1.3: return "VICTORY"
    elif ratio > 0.85: return "STALEMATE"
    elif ratio > 0.55: return "DEFEAT"
    else: return "DEVASTATING_DEFEAT"

func _calculate_prestige_shift(outcome: String) -> int:
    match outcome:
        "DECISIVE_VICTORY": return 30
        "VICTORY": return 15
        "STALEMATE": return 0
        "DEFEAT": return -15
        "DEVASTATING_DEFEAT": return -30
        _: return 0

func _get_trait_bonus(trait: String, round_type: String, is_attacker: bool) -> float:
    match trait:
        "veteran": return 3.0
        "shieldbearer":
            return 5.0 if not is_attacker else 0.0
        "war_singer":
            return 5.0 if round_type == "turning" else 2.0
        "loyal_to_the_death":
            return 3.0 if round_type == "turning" else 0.0
        _: return 0.0
```

### FeudTracker — Persistent Multi-Generational Conflicts

```gdscript
class_name FeudTracker

# All active feuds indexed by community pair
var feuds: Dictionary = {}  # "community_a:community_b" -> feud_state

func get_feud(community_a: String, community_b: String) -> Dictionary:
    var key = _make_key(community_a, community_b)
    return feuds.get(key, {})

func update_from_conflict(conflict_state: Dictionary) -> void:
    var attacker_id = conflict_state["attacker"].get("community_id", "")
    var defender_id = conflict_state["defender"].get("community_id", "")
    if attacker_id == "" or defender_id == "":
        return
    
    var key = _make_key(attacker_id, defender_id)
    if not feuds.has(key):
        feuds[key] = _create_feud(attacker_id, defender_id)
    
    var feud = feuds[key]
    var result = conflict_state.get("result", {})
    
    # Base escalation from conflict occurring
    feud["escalation"] += conflict_state.get("objective_feud_escalation", 2)
    
    # Additional escalation from outcomes
    var losses = result.get("defender_losses", {})
    if losses.get("named_killed", 0) > 0:
        feud["escalation"] += 3 * losses["named_killed"]
    if conflict_state.get("secondary_objectives", []).has("steal_crest_objects"):
        feud["escalation"] += 5
        feud["crest_theft"] = true
    
    # Update feud state based on escalation level
    feud["state"] = _determine_state(feud["escalation"])
    feud["last_conflict_turn"] = conflict_state.get("turn", 0)
    feud["conflict_count"] += 1
    
    EventBus.feud_state_changed.emit(key, feud)

func on_chief_succession(community_id: String) -> void:
    for key in feuds:
        var feud = feuds[key]
        if community_id in [feud["community_a"], feud["community_b"]]:
            if feud["state"] in ["ACTIVE_FEUD", "BLOOD_FEUD"]:
                feud["state"] = "INHERITED_FEUD"
                feud["new_chief_pending"] = true
                EventBus.feud_inherited.emit(key, feud)

func attempt_deescalation(key: String, action: String) -> bool:
    if not feuds.has(key):
        return false
    var feud = feuds[key]
    var action_data = _get_deescalation_value(action)
    feud["escalation"] = max(0, feud["escalation"] + action_data["value"])
    feud["state"] = _determine_state(feud["escalation"])
    
    if feud["escalation"] <= 0:
        feud["state"] = "RESOLVED"
        EventBus.feud_resolved.emit(key, feud)
    else:
        EventBus.feud_state_changed.emit(key, feud)
    return true

func apply_yearly_decay() -> void:
    for key in feuds:
        var feud = feuds[key]
        if feud["state"] == "SMOULDERING":
            feud["escalation"] = max(0, feud["escalation"] - 1)
            if feud["escalation"] <= 0:
                feud["state"] = "RESOLVED"

func _create_feud(a: String, b: String) -> Dictionary:
    return {
        "community_a": a, "community_b": b,
        "state": "GRIEVANCE", "escalation": 1,
        "conflict_count": 0, "last_conflict_turn": 0,
        "crest_theft": false, "new_chief_pending": false,
        "history": []
    }

func _determine_state(escalation: int) -> String:
    if escalation <= 0: return "RESOLVED"
    elif escalation <= 3: return "SMOULDERING"
    elif escalation <= 5: return "GRIEVANCE"
    elif escalation <= 12: return "ACTIVE_FEUD"
    else: return "BLOOD_FEUD"

func _make_key(a: String, b: String) -> String:
    var sorted = [a, b]
    sorted.sort()
    return sorted[0] + ":" + sorted[1]

func _get_deescalation_value(action: String) -> Dictionary:
    match action:
        "return_captives": return {"value": -2}
        "pay_reparations": return {"value": -3}
        "marriage_alliance": return {"value": -4}
        "joint_potlatch": return {"value": -3}
        "reconciliation_pole": return {"value": -5}
        _: return {"value": -1}
```

### WarTraitManager — Character Progression Through Conflict

```gdscript
class_name WarTraitManager

# Track conflict participation counts per character
var chief_conflict_log: Dictionary = {}  # chief_id -> {wins, losses, decisive, raids, defenses, ...}
var crew_conflict_log: Dictionary = {}   # crew_id -> {conflicts_survived, rearguard, wounds, ...}

func evaluate_conflict(conflict_state: Dictionary) -> void:
    var chief_id = conflict_state["attacker"].get("chief_id", "")
    var outcome = conflict_state["result"].get("outcome", "STALEMATE")
    var conflict_type = conflict_state.get("type", "")
    
    # Update chief log
    if not chief_conflict_log.has(chief_id):
        chief_conflict_log[chief_id] = _new_chief_log()
    var log = chief_conflict_log[chief_id]
    log["total"] += 1
    
    match outcome:
        "DECISIVE_VICTORY":
            log["decisive_wins"] += 1
            log["wins"] += 1
        "VICTORY":
            log["wins"] += 1
        "DEFEAT", "DEVASTATING_DEFEAT":
            log["losses"] += 1
    
    if conflict_type in ["offensive_raid", "retaliatory_strike"]:
        log["offensive_raids"] += 1
    if conflict_type == "defensive_village_raid":
        log["village_defenses"] += 1
    if conflict_type == "sea_encounter":
        log["sea_encounters_won"] += 1 if outcome in ["DECISIVE_VICTORY", "VICTORY"] else 0
    
    # Check for trait awards
    _check_chief_traits(chief_id, log, outcome, conflict_state)

func _check_chief_traits(chief_id: String, log: Dictionary, outcome: String, state: Dictionary) -> void:
    var awarded: Array[String] = []
    
    if log["total"] >= 3 and not _has_trait(chief_id, "battle_tested"):
        awarded.append("battle_tested")
    if log["decisive_wins"] >= 3 and not _has_trait(chief_id, "fearsome"):
        awarded.append("fearsome")
    if log["offensive_raids"] >= 3 and not _has_trait(chief_id, "raider"):
        awarded.append("raider")
    if log["village_defenses"] >= 2 and not _has_trait(chief_id, "defender_of_the_people"):
        awarded.append("defender_of_the_people")
    if log["sea_encounters_won"] >= 2 and not _has_trait(chief_id, "sea_wolf"):
        awarded.append("sea_wolf")
    if outcome == "DEVASTATING_DEFEAT" and state.get("attacker_tactic") == "overwhelming_assault":
        if not _has_trait(chief_id, "reckless"):
            awarded.append("reckless")
    
    for trait in awarded:
        EventBus.war_trait_earned.emit(chief_id, trait)

func award_crew_trait(crew_id: String, trait_id: String) -> void:
    EventBus.war_trait_earned.emit(crew_id, trait_id)

func _new_chief_log() -> Dictionary:
    return {
        "total": 0, "wins": 0, "decisive_wins": 0, "losses": 0,
        "offensive_raids": 0, "village_defenses": 0, "sea_encounters_won": 0,
        "feuds_resolved": 0
    }

func _has_trait(character_id: String, trait_id: String) -> bool:
    # Placeholder — checks character data for existing trait
    return false
```

### AftermathProcessor — Post-Conflict Resolution

```gdscript
class_name AftermathProcessor

func process(conflict_state: Dictionary, player_choice: Dictionary) -> Dictionary:
    var result = conflict_state.get("result", {})
    var aftermath = {}
    
    # === IMMEDIATE AFTERMATH ===
    aftermath["casualties"] = _process_casualties(conflict_state)
    aftermath["damage"] = _process_damage(conflict_state)
    aftermath["spoils"] = _process_spoils(conflict_state, result)
    aftermath["captives"] = _process_captives(conflict_state, player_choice)
    
    # === SHORT-TERM EFFECTS (queued for next 1-3 turns) ===
    aftermath["short_term"] = {
        "wound_recovery_turns": _calculate_recovery_turns(aftermath["casualties"]),
        "morale_change": _calculate_morale_ripple(result),
        "reputation_update": _calculate_reputation_spread(result, conflict_state),
        "retaliation_timer": _start_retaliation_clock(conflict_state, result)
    }
    
    # === LONG-TERM EFFECTS ===
    aftermath["long_term"] = {
        "feud_escalation": result.get("feud_escalation", 0),
        "pole_opportunity": _check_pole_opportunity(result),
        "song_opportunity": _check_song_opportunity(result),
        "ancestral_memory": _check_ancestral_memory(aftermath["casualties"]),
        "legacy_entry": _generate_legacy_entry(conflict_state, result)
    }
    
    return aftermath

func _process_casualties(state: Dictionary) -> Dictionary:
    var losses = state["result"].get("attacker_losses", {})
    var killed = []
    var wounded = []
    var captured = []
    
    # Named character loss chance based on loss ratio
    var loss_ratio = losses.get("crew_loss_ratio", 0.1)
    for crew_member in state["attacker"].get("named_crew", []):
        var roll = randf()
        if roll < loss_ratio * 0.3:  # Killed
            killed.append(crew_member)
            EventBus.crew_member_lost.emit(crew_member["id"], "killed_in_action")
        elif roll < loss_ratio * 0.6:  # Wounded
            wounded.append(crew_member)
            EventBus.crew_member_wounded.emit(crew_member["id"], _determine_wound_severity())
        elif roll < loss_ratio * 0.15:  # Captured
            captured.append(crew_member)
            EventBus.crew_member_captured.emit(crew_member["id"])
    
    return {"killed": killed, "wounded": wounded, "captured": captured}

func _process_spoils(state: Dictionary, result: Dictionary) -> Dictionary:
    var outcome = result.get("outcome", "STALEMATE")
    if outcome in ["DEFEAT", "DEVASTATING_DEFEAT", "STALEMATE"]:
        return {"goods": [], "canoes_captured": 0}
    
    var objective = state.get("objective", "resource_seizure")
    var spoils = {"goods": [], "canoes_captured": 0, "captives": []}
    
    match objective:
        "resource_seizure":
            spoils["goods"] = _generate_resource_spoils(result, state["defender"])
        "canoe_capture":
            spoils["canoes_captured"] = 1 if outcome == "DECISIVE_VICTORY" else 0
            if spoils["canoes_captured"] > 0:
                EventBus.canoe_captured.emit(state["id"])
        "captive_taking":
            spoils["captives"] = _generate_captive_list(result, state["defender"])
    
    return spoils

func _check_pole_opportunity(result: Dictionary) -> String:
    match result.get("outcome", ""):
        "DECISIVE_VICTORY": return "war_memorial_pole"
        "VICTORY": return "history_pole"
        _: return ""

func _check_song_opportunity(result: Dictionary) -> bool:
    return result.get("outcome", "") == "DECISIVE_VICTORY"

func _check_ancestral_memory(casualties: Dictionary) -> Array:
    var memories = []
    for fallen in casualties.get("killed", []):
        if fallen.get("heroic_death", false):
            memories.append({
                "character": fallen["id"],
                "type": "heroic_ancestor",
                "dream_trigger": true
            })
    return memories

func _start_retaliation_clock(state: Dictionary, result: Dictionary) -> Dictionary:
    if state.get("type", "") in ["offensive_raid", "retaliatory_strike"]:
        var outcome = result.get("outcome", "")
        var urgency = 3  # turns until retaliation likely
        if outcome == "DECISIVE_VICTORY":
            urgency = 6  # Enemies need time to recover
        elif outcome == "VICTORY":
            urgency = 4
        return {"active": true, "turns_until_likely": urgency, "target": state["attacker"].get("community_id", "")}
    return {"active": false}

func _calculate_morale_ripple(result: Dictionary) -> int:
    match result.get("outcome", ""):
        "DECISIVE_VICTORY": return 20
        "VICTORY": return 10
        "STALEMATE": return -2
        "DEFEAT": return -15
        "DEVASTATING_DEFEAT": return -25
        _: return 0

func _calculate_reputation_spread(result: Dictionary, state: Dictionary) -> Dictionary:
    return {
        "outcome": result.get("outcome", ""),
        "spread_range": 3,  # number of communities that hear about it
        "intimidation_change": result.get("prestige_shift", 0) / 2
    }

func _generate_legacy_entry(state: Dictionary, result: Dictionary) -> String:
    var outcome = result.get("outcome", "STALEMATE")
    var target = state["defender"].get("community_name", "an unknown village")
    match outcome:
        "DECISIVE_VICTORY":
            return "A great victory against " + target + ". The enemy was routed and their wealth seized."
        "VICTORY":
            return "A hard-fought victory against " + target + ". The crew returned with honor."
        "STALEMATE":
            return "An indecisive clash with " + target + ". Neither side could claim victory."
        "DEFEAT":
            return "A bitter defeat at " + target + ". The crew returned diminished."
        "DEVASTATING_DEFEAT":
            return "A devastating loss at " + target + ". Many did not return."
        _:
            return "A conflict with " + target + "."

func _determine_wound_severity() -> String:
    var roll = randf()
    if roll < 0.3: return "light"
    elif roll < 0.7: return "moderate"
    else: return "severe"

func _process_damage(state: Dictionary) -> Dictionary:
    return {"canoe_damage": state["result"].get("attacker_losses", {}).get("canoe_damage", 0)}

func _process_captives(state: Dictionary, choice: Dictionary) -> Array:
    return []

func _generate_resource_spoils(result: Dictionary, defender: Dictionary) -> Array:
    return []

func _generate_captive_list(result: Dictionary, defender: Dictionary) -> Array:
    return []
```

---

# 8. PERFORMANCE CONSIDERATIONS

## 8.1 — Rendering Budget (SNES-Style Constraints)
- **Max sprites on screen:** ~128 (soft limit for authenticity)
- **Max unique tiles per scene:** 256-512
- **Parallax layers:** 3-4 maximum
- **Weather particles:** 30-50 concurrent maximum
- **Animation updates:** Stagger non-critical animations (not everything updates every frame)

## 8.2 — Memory Budget
- **Sprite atlases in VRAM:** ~8-12 MB total
- **Audio in memory:** ~20-30 MB (music streams from disk, SFX pre-loaded)
- **Game state data:** ~1-2 MB (save files, active state)
- **Target total:** <100 MB RAM usage

## 8.3 — Load Times
- **Initial load:** <3 seconds
- **Scene transition:** <1 second (with transition animation masking)
- **Save/Load:** <1 second

---

# 9. MODDING & EXTENSIBILITY

## 9.1 — Mod-Friendly Data
Because content is data-driven (JSON), modding is naturally supported:
- Custom events: add JSON files to `data/events/`
- Custom canoe types: extend `canoes.json`
- Custom pole figures: add sprite modules + entries in `poles.json`
- Custom chiefs: extend `chiefs.json`
- Balance mods: modify `balance.json`

## 9.2 — Mod Loading
- Mods live in a `mods/` directory
- Each mod is a folder with a `mod.json` manifest
- Game loads base data first, then merges/overrides with mod data
- Mods can add content but not modify engine code (data mods only for safety)

---

# 10. TESTING STRATEGY

## 10.1 — Unit Tests
- **Economy simulation:** Run 100 game-years without player input, verify no resource overflow/underflow
- **Event conditions:** Test each condition type with known state
- **Conflict resolution:** Run 1000 battles with known inputs, verify outcome distribution
- **Prestige calculation:** Test all sub-components
- **Succession logic:** Test matrilineal selection with various family configurations

## 10.2 — Integration Tests
- **Full season cycle:** Village start → labor → production → consumption → season end
- **Full voyage cycle:** Load → launch → navigate → encounter → return
- **Full potlatch cycle:** Accumulate → prepare → invite → host → resolve
- **Full pole cycle:** Commission → carve → raise → standing
- **Era transition:** Trigger transition, verify state changes

## 10.3 — Playtest Metrics
Track and log:
- Time per turn (target: 30-60 seconds)
- Turns per session (target: 15-30)
- Resources at each season end (balance check)
- Events triggered per era (variety check)
- Prestige trajectory (should rise with good play)
- Player choice distribution (are all choices viable?)

---

*End of Technical Architecture v1.0*
*TIDELINES: Cedar, Sea & Legacy*
