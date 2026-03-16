# TIDELINES: Cedar, Sea & Legacy — ART BIBLE

## Visual Identity Document v1.0

---

# 1. VISUAL PHILOSOPHY

Tidelines must look like the best SNES game never made — the one people swore existed but could never find. Every pixel should feel intentional, every palette grounded in the real Pacific Northwest coast, every animation crafted with the love and precision of a 1994 first-party title.

**Three visual commandments:**
1. **Atmosphere over flash.** Fog, rain, firelight, dusk — mood is more important than spectacle.
2. **Groundedness over fantasy.** This is NOT a generic fantasy game with tribal skin. Every visual element should feel rooted in the real coastal world.
3. **Craftsmanship over quantity.** Fewer environments done perfectly > many environments done generically.

---

# 2. TECHNICAL SPECIFICATIONS

## Resolution
- **Native render:** 256×224 pixels (SNES standard)
- **Display scaling:** Integer scale to modern resolutions (×4 = 1024×896, ×5 = 1280×1120)
- **Widescreen option:** 320×224 (extended horizontal for modern displays, optional)
- **No sub-pixel rendering.** All art must be pixel-perfect at native resolution.

## Tile System
- **Base tile:** 16×16 pixels
- **Meta-tile:** 32×32 (2×2 tiles for terrain variation)
- **Map chunk:** 256×224 (one screen) with scrolling

## Sprite Sizes (approximate, can vary)
| Element | Size (pixels) | Notes |
|---------|--------------|-------|
| Character (walking) | 16×24 | 4-direction, 4-frame walk cycle minimum |
| Character (portrait) | 64×64 to 96×96 | Event screen close-ups |
| Fishing canoe | 32×16 | Smallest canoe class |
| Travel canoe | 48×20 | Standard canoe |
| War canoe | 64×24 | Large, intimidating |
| Prestige canoe | 72×28 | Largest, most decorated |
| Monumental pole | 16×64 to 24×128 | Modular stacking |
| Longhouse | 64×48 | With smoke animation |
| Trees (cedar) | 32×48 to 32×64 | Multiple variations |
| Animals (eagle, raven) | 16×16 to 24×24 | Flight animation |
| UI icons | 8×8 to 16×16 | Consistent style |

## Color
- **256-color indexed palette per scene** (SNES-era constraint respected for authenticity)
- **Master palette:** 512 colors total across the game, with scene-specific 256-color subsets
- **Palette swaps:** Used for time-of-day, weather, and seasonal variations
- **No true gradients.** All shading through dithering and color stepping.

## Animation Framerates
- **Character walk:** 4 frames per direction (8 fps effective)
- **Canoe paddling:** 6-8 frames cycle (rhythmic, satisfying)
- **Water tiles:** 4-frame loop (subtle, constant)
- **Fire/smoke:** 4-6 frame loop
- **Weather particles:** 2-3 frame loop per particle type
- **Ceremony animations:** 8-12 frames for key moments (pole-raising, dance)

---

# 3. MASTER COLOR PALETTE

## Philosophy
The palette is the soul of the game's visual identity. Tidelines should feel like rain-soaked cedar and cold ocean and warm firelight — not like candy or cartoons.

## Core Palette Families

### Ocean Blues (The Sea)
```
Deep Ocean:    #0B1628  #142840  #1E3A5C  #2A5278  #3B7094
Surface Blue:  #4A88A8  #5CA0BC  #72B8D0  #8CD0E4  #A8E0F0
Whitecap:      #C8ECF4  #E0F4F8  #F0FCFF
```
The ocean should never be one flat blue. Depth, reflection, and weather change its character completely.

### Forest Greens (The Land)
```
Deep Forest:   #0A1A0A  #142814  #1E3C1E  #285028  #326432
Canopy Green:  #3C7832  #4A8C3C  #5AA048  #6EB45A  #84C870
Moss/Fern:     #5A7840  #6E8C4A  #82A058  #98B86A
```
Cedar forests are DARK. Deep, layered, shadowed. Understory is moss-covered. Light filters through.

### Cedar & Wood (Material Culture)
```
Raw Cedar:     #6E3420  #8C4428  #A85A38  #C47048  #D88A60
Aged Cedar:    #584030  #6E5040  #846850  #9A8068  #B09880
Fresh Cut:     #D4A070  #E0B888  #ECD0A0
Charcoal:      #282018  #3C3028  #504838
```
Cedar is the defining material. Its warm red-brown must be instantly recognizable and never confused with generic brown.

### Smoke & Fog (Atmosphere)
```
Dense Fog:     #A0A8B0  #B0B8C0  #C0C8D0  #D0D8E0
Light Mist:    #D8E0E8  #E4E8EC  #F0F4F8
Smoke:         #787880  #8C8C94  #A0A0A8  #B4B4BC
```

### Sky Palettes (Time of Day)
```
Dawn:          #1A1428  #3C2848  #6E3858  #A05040  #D07838  #F0A048  #F8C870
Midday:        #4080C0  #58A0D8  #78B8E8  #98D0F0  #B8E0F8  #E0F0FC
Overcast:      #606878  #788090  #9098A8  #A8B0C0  #C0C8D4
Dusk:          #0A0820  #1E1440  #3C2060  #6E2858  #A83848  #D85838  #F88038
Night:         #040810  #081420  #0C2030  #142840  #1E3C58
Storm:         #282830  #383840  #484850  #585868  #686878
```

### Fire & Ceremony (Warmth)
```
Flame Core:    #F8F0A0  #F8D860  #F8B838  #E89020  #D06818
Ember:         #A04810  #803008  #602008
Firelight Wash:#F8E8C0  #F0D8A0  #E0C480  (applied as overlay on nearby surfaces)
```

### Formline Colors (Poles & Art)
```
Formline Black: #101018  #181820  #282830
Formline Red:   #8C2020  #A83030  #C84040  #D85050
Formline Blue-Green: #205848  #287058  #308868  #40A080
Formline White: #E8E0D8  #F0E8E0  #F8F0E8  (natural/bone white, not pure white)
```

---

# 4. ENVIRONMENT ART

## 4.1 — The Ocean

The ocean is the most important visual element in the game. It must feel alive, dangerous, beautiful, and ever-changing.

### Water Rendering Approach
- **Tile-based animated water** with 4-frame loop
- **Multiple water tile sets:**
  - Calm (gentle ripple)
  - Moderate (visible waves, wind lines)
  - Rough (whitecaps, spray particles)
  - Storm (large wave shapes, heavy spray, foam)
- **Depth indication:**
  - Shallow: lighter blue, visible seabed through transparency
  - Medium: mid blue, kelp visible
  - Deep: dark blue/black, no transparency
  - Very deep (open ocean): deep blue-black, large swell patterns
- **Foam/surf line** where water meets shore: animated white line, 4 frames
- **Wake effect** behind canoes: V-shaped sprite trail, 2-3 pixel white lines
- **Reflection:** Simplified — poles and buildings near shore get 2-3 pixel reflection lines on calm water

### Water Palette Shifts
| Condition | Palette Adjustment |
|-----------|-------------------|
| Clear day | Standard ocean blues + sky reflection |
| Overcast | Desaturated, greyer blues |
| Fog | Very desaturated, low contrast, water/sky nearly merge |
| Storm | Dark blue-greens, heavy whitecap overlay |
| Dawn | Pink/gold reflection highlights mixed with blue |
| Dusk | Orange/purple reflection, dark water body |
| Night | Near-black with moonlight silver highlights |
| Moonlight | Silver-blue highlights on dark water |

## 4.2 — Shoreline & Beach

The liminal space between ocean and land. Critical for village scenes, beaching, and landing.

### Elements
- **Sand/gravel beach:** Warm grey-tan tiles, shells and driftwood detail sprites
- **Rocky shore:** Dark wet rock tiles, tide pool detail, barnacle texture
- **Log-strewn beach:** Driftwood sprites scattered, grey-white wood
- **Surf line:** Animated foam where water meets beach, receding/advancing with tide
- **Beached canoes:** Canoe sprites at rest angle, partially on sand
- **Landing ramp:** Log ramp for canoe launching, practical and visual

### Tidal Variation
The beach should visually change with tide:
- **High tide:** Water closer to buildings, beach narrow, some logs floating
- **Low tide:** Beach wide, tide pools exposed, reef visible, mud flats

## 4.3 — Cedar Forest

The forest is the second most important natural environment. Cedar groves provide critical resources and define the land's character.

### Rendering Approach
- **Parallax layers:**
  - Background: distant mountain/hill silhouette (1-2 colors)
  - Mid-background: dense canopy layer (dark greens, minimal detail)
  - Mid-ground: individual tree trunks, ferns, undergrowth
  - Foreground: occasional close tree or branch framing the scene
- **Tree sprites:**
  - Old-growth cedar: massive trunk (8-12 px wide), spreading branches, distinctive silhouette
  - Second-growth: thinner, denser
  - Snag (dead standing tree): grey, bare branches, moss
  - Fallen log: ground-level obstacle/detail
- **Undergrowth:** Fern sprites, moss covering (green overlay on ground tiles), salal bushes
- **Light shafts:** Rare, beautiful — 2-3 pixel diagonal lines of lighter color through canopy
- **Rain in forest:** Drops visible in gaps between trees, dripping from branches

## 4.4 — Village Environment

The village scene is the player's home — it must be warm, detailed, and visually growing.

### Layout (Left to Right)
```
[Forest BG] [Buildings Layer] [Ceremonial Ground] [Poles] [Beach] [Canoes] [Water]
```

### Longhouse Design
- **Base shape:** Rectangular, low-pitched gable roof, cedar plank walls
- **Size:** 64×48 pixels for main house
- **Details:**
  - Roof: overlapping plank texture, slight sag with age
  - Walls: vertical plank lines, darker at base (moisture)
  - Doorway: dark opening, sometimes with painted surround
  - Smoke: rising from roof holes, 4-frame wispy animation
  - Firelight: warm glow through doorway at night, flicker animation
- **Variants:**
  - Chief's House: larger (80×56), painted front, crest designs
  - Common House: standard size, simpler
  - Deteriorating House: missing planks, grey wood, no smoke (Era 4)

### Other Buildings
- **Canoe House:** Open-sided shelter, canoes visible inside, tools on rack
- **Smoke House:** Smaller building, heavy smoke output, hanging fish visible
- **Carving Shed:** Open side, pole-in-progress visible, wood shavings on ground
- **Weaving House:** Indoor work, occasionally visible through door
- **Cache/Storage:** Raised platform style (keeps food away from animals), boxes stacked

### Village Life Animations
- **Smoke:** Constant gentle animation from occupied houses
- **Figures:** Small character sprites moving between buildings (2-3 on screen at a time)
- **Dogs:** 1-2 small dog sprites near houses
- **Fish drying:** Hanging fish sprites on racks near smoke house
- **Canoe work:** If canoe is under construction, visible figure working in canoe house
- **Children:** Small sprites playing near beach (1-2, subtle)

### Village Growth Visualization
The village should visually densify across eras:
- **Era 1:** 2-3 buildings, sparse, lots of forest visible
- **Era 2:** 5-6 buildings, canoe house active, first pole standing
- **Era 3:** 8-10 buildings, multiple poles, busy beach, impressive chief's house
- **Era 4:** Some buildings empty, fewer people, some deterioration, but poles endure

## 4.5 — Monumental Poles

Poles are among the most visually distinctive and important elements.

### Modular Construction System

Each pole is built from stackable **figure modules** — sprite blocks that combine vertically:

```
┌──────────┐
│  Top Cap  │  (Optional: bird wings spread, hat, etc.)
├──────────┤
│ Figure 1  │  (e.g., Eagle — 16×24 sprite block)
├──────────┤
│ Figure 2  │  (e.g., Raven — 16×24 sprite block)
├──────────┤
│ Figure 3  │  (e.g., Bear — 16×20 sprite block)
├──────────┤
│   Base    │  (Ground mount, possibly with base figure)
└──────────┘
```

### Figure Module Library
Each crest figure exists as a sprite block designed to stack:
- **Eagle:** Wings may extend beyond column width. Strong triangular head shape.
- **Raven:** Distinctive long beak. Compact posture.
- **Killer Whale:** Dorsal fin extends sideways. Curved body.
- **Bear:** Broad face, paws visible, seated posture.
- **Frog:** Compact, wide mouth, crouching.
- **Wolf:** Pointed ears, long snout, alert posture.
- **Thunderbird:** Largest wing extension. Top-of-pole figure.
- **Human figure:** Represents a chief or ancestor. Seated or standing.
- **Shark:** Distinctive forehead shape, angular.
- **Beaver:** Flat tail detail, gnawing pose.

### Pole Color Variants
- **Fresh:** Vivid formline colors (red, black, blue-green on natural cedar)
- **Aged:** Slightly faded colors, grey wood showing through
- **Weathered:** Almost fully grey, paint mostly gone (historical poles, Era 4-5)
- **Night/Firelight:** Warm orange highlights on facing surfaces, deep shadows on reverse

### Pole Placement
- Poles stand in a line facing the water (historically accurate)
- Each pole's position in the village scene is determined by construction order
- Maximum visible poles: 6-8 in the village scene before stacking/overlap management
- Each pole is visually unique due to modular assembly

## 4.6 — Canoe Sprites

### Design Philosophy
Canoes are the player's avatars on the ocean. They must be the most lovingly animated sprites in the game.

### Canoe Visual Classes

**Fishing Canoe (Small)**
- 32×12 pixels
- Simple prow, no decoration
- 2-4 crew visible as small figures
- Low freeboard
- Colors: natural cedar, minimal paint

**Travel Canoe (Medium)**
- 48×16 pixels
- Slightly raised prow and stern
- 6-8 crew visible, rhythmic paddling
- Medium freeboard
- Colors: painted prow design (crest), natural body

**Trade Canoe (Large)**
- 56×18 pixels
- High sides, visible cargo amidships
- 8-12 crew
- Heavy, stable appearance
- Colors: painted prow, visible goods (stacked boxes, bundled furs)

**War Canoe (Large, Aggressive)**
- 64×20 pixels
- High, aggressive prow with carved crest figure
- 12-16 crew, close-packed, shields/weapons visible along gunwale
- Intimidating silhouette
- Colors: bold red and black formline prow, dark body

**Prestige Canoe (Largest)**
- 72×24 pixels
- Magnificent carved prow AND stern
- 16-20+ crew in ceremonial arrangement
- Highest visual prestige
- Colors: full formline painting, the most decorated object in the game

### Canoe Animations

**Paddling Cycle (6-8 frames)**
```
Frame 1: Paddles raised, forward reach
Frame 2: Paddles entering water
Frame 3: Paddles pulling through water
Frame 4: Paddles at midpoint, power stroke
Frame 5: Paddles exiting water
Frame 6: Paddles recovering forward
(Frames 7-8: optional intermediate positions for smoother feel)
```
- Crew paddles should be **synchronized** with slight offset front-to-back (realistic cadence)
- Paddle splash: 1-pixel white spray at entry/exit points

**Rocking Motion (Idle / Ocean State)**
- Gentle: 2-frame oscillation (1-pixel vertical shift)
- Moderate: 4-frame oscillation (1-2 pixel vertical shift + slight rotation)
- Rough: 6-frame oscillation (2-3 pixel shift, spray particles)

**Wake Effect**
- V-shaped trail behind moving canoe
- 2-3 white pixel lines fading behind
- More pronounced at higher speeds
- Dissipates in 8-12 frames

**Beaching Animation (4-6 frames)**
```
Frame 1: Approaching shore at speed
Frame 2: Bow touching sand/gravel (slight spray)
Frame 3: Canoe sliding up beach (crew bracing)
Frame 4: Canoe at rest on beach (crew standing)
Frame 5-6: Crew disembarking (optional detail)
```

**Storm Surfing**
- Canoe tilted at angle
- Spray particles heavy on windward side
- Paddle strokes faster, more urgent animation
- Rocking increased to maximum

## 4.7 — Weather & Atmospheric Effects

### Rain
- **Light rain:** Sparse diagonal lines (NW to SE direction), 2-pixel length, light blue-grey
- **Heavy rain:** Dense diagonal lines, 3-pixel length, plus splash particles on water
- **Rain on surfaces:** Small splash sprites on roofs, ground, water surface

### Fog
- **Implementation:** Translucent overlay layer(s) that partially obscure background
- **Edge treatment:** Fog has soft, irregular edges (dithered transparency)
- **Motion:** Very slow horizontal drift (1 pixel per 30-60 frames)
- **Density variation:** Thicker in valleys and over water, thinner at height
- **Visibility:** Reduces sprite visibility at distance; far objects desaturated and lightened

### Wind
- **Visible indicators:** Tree sway animation, grass/fern movement, water surface chop direction
- **Smoke direction:** Smoke from houses bends with wind
- **Spray:** Horizontal spray particles off wave crests in strong wind

### Snow (Rare, mountain-only)
- Gentle falling particle, 1-pixel white, slow diagonal drift
- Accumulation on horizontal surfaces (thin white line on rooftops, branches)

### Time of Day Transitions
Palette shifts create dramatic mood changes:
- **Dawn:** Gradual warm overlay, eastern sky brightening, mist on water
- **Full day:** Standard palette, strong shadows
- **Dusk:** Warm orange/purple overlay, long shadows, water reflects sunset
- **Night:** Dark palette, moonlight highlights, firelight from buildings, stars (single-pixel sparkle)

### Storm Sequence (Special)
The most dramatic weather event:
- Sky darkens progressively (3-4 palette steps over time)
- Wind increases (tree sway, water chop)
- Rain intensifies
- Lightning flash: entire screen goes bright for 1-2 frames, then dark
- Thunder: screen shake (1-pixel offset, 4-6 frames)
- Wave heights increase on water tiles
- Spray and foam increase dramatically

## 4.8 — Ceremony & Event Scenes

### Potlatch Scene
- **Setting:** Ceremonial ground at night, firelit
- **Fire:** Central fire pit with 6-frame flicker animation, light cast on surrounding sprites
- **Crowd:** 12-20 small character sprites arranged in semicircle
- **Chief figure:** Larger sprite, standing position, gesturing
- **Gifts:** Visible pile of goods (blankets, boxes, food) being distributed
- **Background:** Longhouse facades lit by fire, poles visible as silhouettes against night sky
- **Atmosphere:** Warm palette, particles (sparks rising from fire), rhythmic light flicker

### Pole-Raising Scene
- **Special cinematic moment:** The most visually impressive single event
- **Sequence:**
  1. Pole lying horizontal on ground (full length visible)
  2. Ropes attached, crowd gathered
  3. Progressive raising: 4-6 intermediate angle positions
  4. Pole reaching vertical (crowd cheering sprite animation)
  5. Pole standing against sky (dramatic silhouette moment)
- **Camera:** If engine allows, slow upward pan following the pole as it rises
- **Sky:** Ideally sunset/dramatic sky behind the pole at moment of standing

### Dream Sequence
- **Style shift:** Slightly different palette — more saturated, slightly surreal
- **Elements:** Simpler composition, single central image + text
- **Possible imagery:** An animal figure, a landscape element, an ancestor portrait
- **Edge treatment:** Vignette / soft fade at screen edges (dithered darkness)
- **Animation:** Slow, minimal — breathing motion, eye movement, gentle drift

---

# 5. CHARACTER ART

## 5.1 — Overworld / Village Sprites

### Standard Character (16×24)
- **Head:** 6-8 pixels tall, proportionally large (chibi-adjacent but not exaggerated)
- **Body:** 8-10 pixels tall
- **Feet:** 2-4 pixels, simplified
- **Detail level:** Minimal — silhouette and color must convey identity
- **Direction:** 4-way facing (down, up, left, right)
- **Walk cycle:** 4 frames per direction

### Character Differentiation
Characters are distinguished by:
- **Color:** Clothing/garment colors linked to role or rank
  - Chief: Red and black garments
  - Warriors: Darker tones, weapon silhouette
  - Carvers: Tool in hand, cedar-colored apron
  - Spiritual advisor: Distinctive headgear silhouette
  - Fishers: Simpler garments, net/spear
- **Silhouette:** Headgear, carried objects, posture
- **Size:** Chief slightly larger sprite (18×26) for importance

## 5.2 — Portrait Art (Event Screens)

### Style
- **Size:** 64×64 to 96×96 pixels
- **Style:** Detailed pixel art with strong contour lines
- **Inspiration:** The bold, clear formline aesthetic — strong outlines, defined shapes, powerful expressions
- **NOT:** Generic anime. NOT realistic painting. NOT cartoonishly stylized.

### Portrait Elements
- **Face:** Clear features, strong expression. Eyes are important — convey personality.
- **Hair:** Black, styled distinctively per character (braided, long, tied, etc.)
- **Adornment:** Earrings, labrets (where culturally accurate), painted faces for ceremony
- **Clothing:** Visible at shoulders/chest — woven capes, cedar bark garments, trade blankets
- **Background:** Simple gradient or pattern, moiety-colored (Raven = dark, Eagle = light)

### Expression Variants
Key characters should have 3-4 expression variants:
- Neutral / composed
- Pleased / generous
- Stern / determined
- Concerned / troubled

## 5.3 — Animal / Crest Sprites

### Eagle
- Flight: 4-frame wing cycle, soaring motion
- Perched: Static or subtle head-turn
- Colors: White head, dark body, golden beak
- Size: 24×20 flight, 16×20 perched

### Raven
- Flight: 4-frame, slightly different cadence than eagle (more flap, less soar)
- Perched: More animated, head tilt, occasionally calls (beak open)
- Colors: Pure black with blue-purple highlight pixels
- Size: 20×16 flight, 12×16 perched

### Killer Whale
- Swimming: 4-frame undulation, dorsal fin prominent
- Breaching: 4-frame leap sequence (special event)
- Colors: Black with white markings, distinctive
- Size: 32×16 swimming, 32×28 breaching

### Bear
- Walking: 4-frame heavy walk cycle
- Standing: Rearing up posture
- Colors: Brown-black, bulk is important
- Size: 24×24

### Salmon
- Swimming: 2-3 frame tail cycle
- Leaping: 3-frame arc (used in fishing scenes)
- Colors: Silver with pink/red accents (spawning)
- Size: 8×4 to 12×6

---

# 6. UI ART DIRECTION

## 6.1 — UI Philosophy

The UI should feel like it was carved from the same world — cedar, bone, shell. Not a generic fantasy game UI. Not modern flat design. Tactile, warm, readable, and beautiful.

## 6.2 — UI Frame / Border Design

### Panel Borders
- **Style:** Carved cedar plank frame
- **Implementation:** 9-slice sprite with corner pieces, edge pieces, fill
- **Color:** Cedar brown tones with subtle carved line detail
- **Width:** 4-6 pixels per border edge
- **Variants:**
  - Standard panel (cedar)
  - Important/ceremonial panel (formline-decorated border, red and black accents)
  - Alert/danger panel (darker, slight red tint)

### Window Backgrounds
- **Color:** Dark warm brown (interior of cedar box) — approximately #2A1E14
- **Texture:** Very subtle wood grain (1-2 pixel lines, barely visible)
- **Text readability:** Light text on dark background for all information panels

## 6.3 — Typography

### Font
- **Custom pixel font** inspired by hand-carved lettering
- **NOT:** a generic bitmap font. NOT a sans-serif system font.
- **Characteristics:**
  - Clean and readable at native resolution
  - Slightly organic character shapes (not perfectly geometric)
  - Variable width preferred for readability
  - Heights: 8px for body text, 12px for headers, 6px for small labels
- **Color:** Warm white (#F0E8D8) for body, cream-gold (#F0D898) for headers, red (#C84040) for alerts

## 6.4 — Iconography

### Resource Icons (16×16)
Each resource has a clear, distinctive icon:
- **Salmon:** Side-view fish silhouette, pink-silver
- **Halibut:** Flat fish shape, distinctive
- **Eulachon Oil:** Small jar/container, golden
- **Berries:** Cluster of dots, red-purple
- **Cedar Log:** Brown cylinder with rings
- **Cedar Bark:** Flat strip, lighter brown
- **Woven Blanket:** Folded rectangle, striped pattern
- **Carved Object:** Small box/mask silhouette
- **Copper:** Shield shape, distinctive copper color
- **Prestige:** Stylized formline eye or crest (not a generic star)

### Status Icons (12×12)
- **Morale:** Face icon (happy/neutral/unhappy)
- **Food status:** Bowl icon (full/half/empty)
- **Season:** Leaf/sun/acorn/snowflake
- **Blessing active:** Small spiritual symbol (soft glow)
- **Warning:** Exclamation in triangle

## 6.5 — Screen Layouts

### Village Screen
```
┌──────────────────────────────────────────────┐
│  [Season/Year] [Resources Bar]    [Menu]     │  <- Top HUD (16px high)
│                                              │
│                                              │
│     ┌─────────────────────────────────┐      │
│     │                                 │      │
│     │     VILLAGE SCENE               │      │
│     │     (scrollable)                │      │
│     │                                 │      │
│     └─────────────────────────────────┘      │
│                                              │
│  ┌────────┐ ┌────────┐ ┌────────┐            │
│  │ Build  │ │ People │ │ Canoes │            │  <- Bottom action bar
│  └────────┘ └────────┘ └────────┘            │
└──────────────────────────────────────────────┘
```

### Navigation Screen
```
┌──────────────────────────────────────────────┐
│  [Canoe Name] [Crew] [Cargo] [Weather] [Map] │  <- Top HUD
│                                              │
│                                              │
│     ┌─────────────────────────────────┐      │
│     │                                 │      │
│     │     OCEAN / MAP VIEW            │      │
│     │     (scrolling, canoe center)   │      │
│     │                                 │      │
│     └─────────────────────────────────┘      │
│                                              │
│  [Speed] [Direction] [Tide] [Action Menu]    │  <- Bottom nav bar
└──────────────────────────────────────────────┘
```

### Event / Dialogue Screen
```
┌──────────────────────────────────────────────┐
│                                              │
│  ┌──────────┐  ┌──────────────────────────┐  │
│  │          │  │                          │  │
│  │ PORTRAIT │  │  EVENT TEXT              │  │
│  │  96×96   │  │  Description and         │  │
│  │          │  │  narrative...            │  │
│  └──────────┘  │                          │  │
│                └──────────────────────────┘  │
│                                              │
│  ┌─────────────┐  ┌─────────────┐            │
│  │  Choice 1   │  │  Choice 2   │            │
│  └─────────────┘  └─────────────┘            │
│  ┌─────────────┐                             │
│  │  Choice 3   │                             │
│  └─────────────┘                             │
└──────────────────────────────────────────────┘
```

### Potlatch Preparation Screen
```
┌──────────────────────────────────────────────┐
│  POTLATCH PLANNING         [Type] [Season]   │
│                                              │
│  ┌─────────────────┐ ┌────────────────────┐  │
│  │ GIFT INVENTORY  │ │ GUEST LIST         │  │
│  │                 │ │                    │  │
│  │ 🐟 Salmon: 340 │ │ ☐ Chief Koyah     │  │
│  │ 🧺 Blankets:24 │ │ ☐ Chief Ninstints  │  │
│  │ 📦 Boxes: 12   │ │ ☐ Eagle Clan Elder │  │
│  │ 🛡️ Copper: 1   │ │ ...               │  │
│  │                 │ │                    │  │
│  └─────────────────┘ └────────────────────┘  │
│                                              │
│  ┌─────────────────────────────────────────┐ │
│  │ ESTIMATED PRESTIGE: ████████░░ HIGH     │ │
│  └─────────────────────────────────────────┘ │
│           [PREPARE]    [CANCEL]              │
└──────────────────────────────────────────────┘
```

### Pole Design Screen
```
┌──────────────────────────────────────────────┐
│  POLE COMMISSION                             │
│                                              │
│  ┌──────┐  ┌──────────────────────────────┐  │
│  │ POLE │  │ CREST SELECTION              │  │
│  │ PREV │  │                              │  │
│  │      │  │  [Eagle]  [Raven]  [Bear]    │  │
│  │ ╔══╗ │  │  [Whale]  [Frog]   [Wolf]   │  │
│  │ ║🦅║ │  │                              │  │
│  │ ╠══╣ │  │ TYPE: History Pole           │  │
│  │ ║🐻║ │  │ COMMEMORATING: Victory at    │  │
│  │ ╠══╣ │  │ Cumshewa Strait              │  │
│  │ ║🐸║ │  │                              │  │
│  │ ╚══╝ │  │ CARVER: Master Kwaani        │  │
│  │      │  │ EST. TIME: 3 seasons         │  │
│  └──────┘  │ CEDAR REQUIRED: 1 great log  │  │
│            └──────────────────────────────┘  │
│           [COMMISSION]    [CANCEL]           │
└──────────────────────────────────────────────┘
```

---

# 7. ANIMATION PRIORITY LIST

Ranked by importance to the game's feel:

### CRITICAL (Must be excellent)
1. **Canoe paddling cycle** — the most-seen animation, must feel rhythmic and satisfying
2. **Water tile animation** — constant, atmospheric, sets the tone
3. **Smoke/fire animation** — village warmth, ceremony atmosphere
4. **Pole-raising sequence** — the emotional peak, must be cinematic
5. **Weather effects (rain, fog, storm)** — defines atmosphere

### HIGH PRIORITY
6. **Canoe wake effect** — movement feedback
7. **Character walk cycles** — village life, expedition
8. **Beaching animation** — transition between sea and shore
9. **Ceremony crowd scenes** — potlatch, pole-raising
10. **Dawn/dusk palette transitions** — time passage, beauty
11. **Eagle/raven flight** — omen events, atmosphere

### MEDIUM PRIORITY
12. **Fish movement (salmon leaping, halibut)** — fishing scenes
13. **Canoe rocking (idle on water)** — idle atmosphere
14. **Cedar carving details** — carving shed activity
15. **Storm-specific canoe behavior** — drama
16. **Longhouse firelight flicker** — night village scene
17. **Tree sway in wind** — forest environment

### LOWER PRIORITY (Polish Phase)
18. **Children playing** — village life detail
19. **Dog movement** — village flavor
20. **Bird flight (shore birds)** — coastal atmosphere
21. **Kelp movement** — underwater/coastal detail
22. **Tidal water level change** — environmental detail
23. **Copper gleam effect** — prestige object highlight

---

# 8. REFERENCE STYLE TOUCHSTONES

The art should evoke the quality and craftsmanship of these SNES-era pixel art games (while having its own unique identity):

- **Chrono Trigger** — character expressiveness, environmental variety, cinematic moments
- **Final Fantasy VI** — atmospheric environments, weather effects, emotional visual storytelling
- **Secret of Mana** — lush natural environments, water rendering, warm palette
- **Treasure of the Rudras** — detailed sprite work, strong world-building
- **Ogre Battle: March of the Black Queen** — strategic map + detailed unit sprites
- **Uncharted Waters: New Horizons** — naval travel, port towns, ocean atmosphere

**Modern pixel art references:**
- **Octopath Traveler** — lighting, atmosphere, "HD-2D" approach (scaled up for modern displays)
- **Sea of Stars** — natural environments, water, coastal settings
- **Eastward** — detailed environments, warm palette, strong character design

---

*End of Art Bible v1.0*
*TIDELINES: Cedar, Sea & Legacy*
