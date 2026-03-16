# TIDELINES: Cedar, Sea & Legacy — AUDIO BIBLE

## Music & Sound Direction Document v1.0

---

# 1. AUDIO PHILOSOPHY

The sound of Tidelines is **the sound of the Pacific Northwest coast heard through the ears of someone who belongs there.** Ocean is the constant. Cedar is the resonance. Rhythm is the heartbeat. Silence and space are as important as sound.

**Three audio commandments:**
1. **The ocean is always present.** Even in village scenes, you should feel the proximity of water — distant surf, shore birds, the creak of beached canoes. The ocean is the basso continuo of the entire game.
2. **Music is atmospheric, not decorative.** Every track must earn its presence. If ambient sound alone creates the right mood, music should step back. When music plays, it should feel essential — not wallpaper.
3. **Rhythm is cultural, melody is emotional.** Percussion grounds the music in physicality (paddles, carving, drums, heartbeat). Melody carries the emotional weight (wonder, danger, sorrow, triumph).

---

# 2. MUSIC DIRECTION

## 2.1 — Instrument Palette

The soundtrack uses a **limited, distinctive instrument palette** that feels organic, grounded, and evocative without attempting to replicate specific sacred instruments.

### Primary Instruments

| Instrument | Role | Sound Character |
|-----------|------|----------------|
| **Wooden percussion** | Rhythmic foundation | Hollow, resonant — like cedar being struck. NOT standard drum kit. |
| **Frame drum** | Ceremony, intensity | Deep, skin-over-wood tone. Steady heartbeat pulse. |
| **Breathy woodwind (flute-like)** | Melody, loneliness, wonder | Airy, slightly haunting. Not a tin whistle — something lower, breathier. |
| **Low strings (drone)** | Atmosphere, tension, vastness | Cello or contrabass tone. Sustained, oceanic. |
| **Plucked strings** | Texture, detail, intimacy | Sparse, clear notes. Harp-like but not a harp — more like individual string plucks. |
| **Voice (wordless)** | Emotional peaks, ceremony | Solo voice, sustained tones or simple phrases. Reverent, not operatic. |
| **Shell/bone rattles** | Ceremony, spiritual moments | Organic, shimmering texture. Subtle. |
| **Ocean sounds (musical)** | Integration into compositions | Wave rhythms incorporated as musical elements, not just background. |

### Avoided Sounds
- ❌ Electric guitar
- ❌ Standard drum kit / hi-hat
- ❌ Synthesizer pads (unless very carefully disguised as natural)
- ❌ Generic orchestral bombast
- ❌ "New Age" clichés (pan flutes over synth pads)
- ❌ Specific sacred instruments that belong to particular ceremonies (out of respect)

## 2.2 — Adaptive Music System

Music in Tidelines is **layered and adaptive**, responding to game state rather than simply looping:

### Layer Architecture
Each scene has up to 4 music layers that fade in/out based on conditions:

```
Layer 1: BASE (always present when music is playing)
         - Typically drone/atmosphere + gentle rhythm
         - Sets the fundamental mood

Layer 2: MELODIC (fades in during key moments or sustained engagement)
         - Main melody or melodic fragments
         - Carries the emotional theme

Layer 3: RHYTHMIC INTENSIFIER (fades in during action/tension)
         - Additional percussion, faster pulse
         - Drives urgency or excitement

Layer 4: EMOTIONAL PEAK (triggered by specific events)
         - Voice, additional instruments, full arrangement
         - Reserved for major moments
```

### Transition Rules
- Layer changes cross-fade over 2-4 seconds (smooth, never jarring)
- Music never cuts abruptly except for dramatic effect (e.g., sudden storm)
- Transitioning between scenes fades current music down, ambient bridge, new music fades up
- Silence is a valid state — some moments should have no music, only ambience

## 2.3 — Track List by Context

### Village Themes

**"Cedar Smoke at Dawn" — Village Morning Theme**
- **Mood:** Peaceful, warm, home
- **Instruments:** Low string drone, gentle plucked strings, distant bird calls (musical, not SFX), very soft wooden percussion
- **Tempo:** Slow, breathing pace
- **Structure:** Minimal melody, mostly texture and atmosphere
- **Duration:** 3-4 minutes, loops seamlessly
- **Adaptive:** Melodic layer fades in when player is actively managing village (not idle)

**"Longhouse Hearth" — Village Evening/Winter Theme**
- **Mood:** Intimate, warm, contemplative
- **Instruments:** Frame drum (very soft, heartbeat pace), breathy woodwind melody, fire-crackle integrated, plucked strings
- **Tempo:** Very slow, meditative
- **Structure:** Simple melody that repeats with subtle variation
- **Duration:** 4-5 minutes
- **Adaptive:** Voice layer adds during ceremony preparation or story events

**"The Work Song" — Village Active/Construction Theme**
- **Mood:** Industrious, purposeful, communal
- **Instruments:** Rhythmic wooden percussion (steady work pace), plucked strings providing energy, occasional woodwind motif
- **Tempo:** Moderate, steady, the pace of labor
- **Structure:** Rhythmic focus, melody fragments that come and go
- **Duration:** 3-4 minutes
- **Adaptive:** Intensifies during canoe construction or carving scenes

### Navigation Themes

**"Open Water" — Main Navigation Theme**
- **Mood:** Vast, awe-inspiring, slightly dangerous
- **Instruments:** Low string ocean-swell drone, paddle-rhythm percussion (matches paddling cadence), woodwind melody (wide intervals suggesting distance), occasional voice
- **Tempo:** Moderate — paddle pace
- **Structure:** Long phrases, expansive. The melody should make the player feel the SIZE of the ocean.
- **Duration:** 5-6 minutes (longest track — player spends the most time here)
- **Adaptive:**
  - Layer 1 (drone + paddle rhythm): always
  - Layer 2 (melody): fades in on open water, fades out near shore
  - Layer 3 (intensity): fades in during strong currents or challenging conditions
  - Layer 4 (danger): fades in during storms or when approaching hostile waters

**"Through the Fog" — Fog Navigation Theme**
- **Mood:** Mysterious, tense, beautiful, disorienting
- **Instruments:** Sustained string harmonics (high, eerie), very soft rattles, no clear rhythm (deliberately disorienting), distant foghorn-like woodwind tone, occasional plucked note (like a sonar ping)
- **Tempo:** Amorphous, floating, no strong pulse
- **Structure:** Evolving texture, no repeating melody — the player should feel lost
- **Duration:** 4-5 minutes, seamless loop
- **Note:** This track is critical. Fog navigation should be one of the most atmospheric experiences in the game. The music must make the player lean forward.

**"Inside Passage" — Sheltered Channel Navigation**
- **Mood:** Protected but alert, intimate, green
- **Instruments:** Plucked strings (closer, more intimate than open water), soft wooden percussion, bird-call musical motifs, gentle bass drone
- **Tempo:** Moderate, slightly faster than open water (more detail to observe)
- **Duration:** 3-4 minutes

**"The Strait Crossing" — Dangerous Open Crossing Theme**
- **Mood:** Epic, dangerous, determined, breathtaking
- **Instruments:** Full palette — driving frame drum, deep ocean string drone, soaring woodwind, building percussion, voice at peak
- **Tempo:** Building. Starts moderate, builds to driving
- **Structure:** Clear arc — departure tension → mid-crossing vastness → approaching shore relief
- **Duration:** 4-5 minutes
- **Note:** This should be one of the most memorable tracks. The player should FEEL the danger and grandeur of committing to an open-ocean crossing.

### Ceremony Themes

**"The Gathering" — Potlatch Preparation/Arrival**
- **Mood:** Anticipation, pride, grandeur building
- **Instruments:** Frame drum (gathering pulse), rattles, plucked strings arpeggio, growing woodwind melody
- **Tempo:** Building from slow to moderate
- **Duration:** 2-3 minutes (transition into main potlatch theme)

**"Great Giving" — Potlatch Main Theme**
- **Mood:** Triumphant, generous, powerful, communal
- **Instruments:** Full ensemble — frame drum, voice (wordless, powerful), woodwind melody (broad, generous phrases), strings (warm, full), rattles
- **Tempo:** Moderate-fast, celebratory but dignified (not frantic)
- **Structure:** The main potlatch melody should be **the most memorable melody in the game** — the one players hum afterward. It should evoke pride and the power of giving.
- **Duration:** 4-5 minutes
- **Adaptive:** Intensity scales with potlatch size/prestige

**"The Pole Rises" — Pole-Raising Theme**
- **Mood:** Awe, permanence, memory, emotional climax
- **Instruments:** Starts sparse (single drum, voice), builds as pole rises — strings swell, woodwind joins, percussion intensifies, full voice at the moment of standing
- **Tempo:** Very slow start → building → powerful climax → gentle resolution
- **Structure:** A single dramatic arc. The musical climax should coincide exactly with the pole reaching vertical.
- **Duration:** 2-3 minutes (scripted to the animation)
- **Note:** This is the most important single musical moment in the game. It should give the player chills. It should feel like witnessing something ancient and permanent being born.

**"Dream of the Ancestor" — Spiritual/Dream Theme**
- **Mood:** Mysterious, intimate, slightly otherworldly, reverent
- **Instruments:** Sustained voice tone, harmonics (string or glass-like), very soft rattles, no percussion, breathing space
- **Tempo:** Nearly still — floating
- **Duration:** 2-3 minutes
- **Note:** Less is more. The silence and space in this track are as important as the sound.

### Conflict Themes

**"War Canoes on the Horizon" — Conflict Approach Theme**
- **Mood:** Tense, determined, dangerous, adrenaline
- **Instruments:** Driving wooden percussion (faster than paddle rhythm — urgent), low string tension drones, staccato plucked strings, no melody (pure tension)
- **Tempo:** Fast, driving, heartbeat-like
- **Duration:** 2-3 minutes
- **Adaptive:** Builds in intensity as conflict approaches

**"The Engagement" — Battle Resolution Theme**
- **Mood:** Chaotic, intense, high-stakes
- **Instruments:** Maximum percussion intensity, dissonant string stabs, sharp rattles, voice (short, powerful calls)
- **Tempo:** Fast, complex rhythm
- **Duration:** 1-2 minutes (conflicts resolve relatively quickly)
- **Note:** Even at maximum intensity, this should feel strategic and weighted, not gleeful or chaotic.

**"After the Battle" — Post-Conflict Theme**
- **Mood:** Somber, exhausted, reflective, costly
- **Instruments:** Solo woodwind, single sustained string note, very soft drum (slowing heartbeat), silence
- **Tempo:** Very slow, decelerating
- **Duration:** 1-2 minutes, fades into ambient
- **Note:** Win or lose, conflict in this game should feel heavy. The post-battle music should make the player feel the cost.

### Era-Specific Themes

**"The Flourishing" — Era 1 Theme (plays during era introduction)**
- **Mood:** Hopeful, rich, full of possibility
- **Instruments:** Warm woodwind, gentle percussion, bright plucked strings
- **Palette:** Warm, major-leaning tonality

**"Rising Tide" — Era 2 Theme**
- **Mood:** Ambitious, expanding, powerful
- **Instruments:** Fuller arrangement, more percussion, broader melody
- **Palette:** Bold, building, wider dynamic range

**"The Great House" — Era 3 Theme**
- **Mood:** Majestic, complex, peak but with undercurrents
- **Instruments:** Full ensemble, most complex arrangement
- **Palette:** Rich but with minor-key undertones suggesting impermanence

**"Grey Waters" — Era 4 Theme**
- **Mood:** Somber, sparse, mourning, resilient
- **Instruments:** Stripped back — solo woodwind, single drum, voice (mournful), minimal strings
- **Palette:** Minor key, much space and silence, rain-like textures
- **Note:** This is the emotional weight of the game. The shift from Era 3's grandeur to Era 4's sparseness should be devastating.

**"What Remains" — Era 5 / Endgame Theme**
- **Mood:** Reflective, bittersweet, ultimately affirming
- **Instruments:** Gradual rebuild from Era 4's sparseness — woodwind returns, strings warm, voice resolves to a gentle major tonality
- **Palette:** Begins minor, resolves to a gentle major. Dawn after storm.
- **Duration:** 5-6 minutes, plays over the legacy review screen
- **Note:** The final track the player hears. It should be beautiful. It should make them feel that everything they did mattered.

### Special / UI Themes

**"The Map" — World Map Theme**
- Light, ambient version of the navigation theme
- Plays under the strategic map view
- Minimal, informational mood

**"Title Screen" — Main Menu Theme**
- **The definitive theme of the game.** Encapsulates everything.
- Starts with ocean ambience, then the main potlatch melody enters slowly on solo woodwind
- Builds to a statement of the full theme
- Should evoke: ocean, legacy, beauty, the weight of history, the power of generosity
- **Duration:** Full loop: 3-4 minutes. Player may sit on the title screen just to listen.

---

# 3. SOUND DESIGN

## 3.1 — Ambient Layers

### Ocean Ambience (Always Present — Foundational)
- **Calm ocean:** Gentle rhythmic wash, 6-8 second cycle. Soft hiss of surf on gravel. Barely audible.
- **Moderate ocean:** More pronounced waves, occasional larger wave crash. White noise component stronger.
- **Rough ocean:** Heavy wave impacts, spray hiss, low rumble. Wind noise layered.
- **Storm ocean:** Constant roar, irregular heavy impacts, spray and wind dominant.
- **Shore break:** Rhythmic crash-hiss-pull cycle. Louder and more rhythmic than open ocean.
- **Calm inlet:** Very gentle lapping. Almost musical. Most peaceful ocean sound.

### Forest Ambience
- **Daytime forest:** Bird calls (varied, realistic intervals), gentle wind through canopy (low frequency), occasional branch creak, insect hum (summer)
- **Rain forest:** Rain on leaves (layered, complex), dripping, reduced bird activity, stream sound if near water
- **Night forest:** Owl calls, frog chorus (spring/summer), insect chorus, wind more prominent

### Village Ambience
- **Daytime village:** Distant voices (murmur, not distinct words), tool sounds, occasional dog bark, fire crackle from smoke house, children (distant), shore birds
- **Evening village:** Fire crackle prominent, fewer voices, wind stronger, ocean more audible
- **Night village:** Fire crackle, very distant ocean, occasional voice, wind, owl

### Ceremony Ambience
- **Pre-ceremony gathering:** Crowd murmur building, fire crackle, excitement
- **During ceremony:** Crowd reactions (gasps, approval sounds), fire, footsteps on ground
- **Post-ceremony:** Crowd dispersing, satisfied murmur, fire settling

## 3.2 — Sound Effects Catalog

### Canoe Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **Paddle stroke (water)** | Rhythmic splash-pull sound. THE most-heard SFX. Must be satisfying and never annoying. Multiple variations to avoid repetition. | CRITICAL |
| **Paddle stroke (air)** | Subtle whoosh of paddle recovery through air between strokes. | High |
| **Hull in water** | Low-frequency water movement sound. Continuous while canoe moves. Pitch/character changes with speed. | CRITICAL |
| **Wave impact (small)** | Light slap of wave against hull. Random timing. | High |
| **Wave impact (large)** | Heavy water impact. Storm/rough seas. Alarming. | High |
| **Beaching** | Grinding crunch of hull on gravel/sand. Single satisfying impact. | High |
| **Canoe creak** | Wood flexing under stress. Occasional, adds character. | Medium |
| **Launch** | Scraping of hull off beach, splash into water. | High |
| **Cargo shift** | Wooden items moving in hull. Trade canoe specific. | Low |

### Village / Construction Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **Axe on cedar** | Sharp, resonant chop. Satisfying wood impact. Different from generic "chop." Cedar has a distinctive sound — slightly hollow, aromatic (convey through brightness). | High |
| **Carving (adze/chisel)** | Rhythmic chip-chip-chip. Wood shaving sound. Steady, meditative. | High |
| **Fire crackle** | Continuous, variable. Pops and snaps. Warm. | CRITICAL |
| **Smoke house hiss** | Low sizzle of fish smoking. Background texture. | Medium |
| **Weaving** | Subtle, rhythmic fiber-pulling sound. | Low |
| **Building construction** | Plank placement, rope tightening, hammer on wood peg. | Medium |
| **Door/plank move** | Heavy wood scraping. Entering longhouse. | Medium |

### Nature Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **Eagle cry** | Distinctive, piercing. Used for omen events. Should give goosebumps. | High |
| **Raven call** | Hoarse, intelligent-sounding. Multiple variants. Common but never annoying. | High |
| **Shore birds** | Background layer. Gulls, oystercatchers. Coastal atmosphere. | Medium |
| **Salmon splash** | Fish leaping from water. Fishing scenes and river mouths. | Medium |
| **Whale blow** | Distant but powerful. Killer whale surfacing. Omen events. | High |
| **Wind** | Multiple intensities. Through trees, over water, through village. Continuous ambient component. | CRITICAL |
| **Rain** | Multiple intensities. On water, on cedar roofs, on leaves. | CRITICAL |
| **Thunder** | Low rumble (distant) to sharp crack (close). Used sparingly for impact. | High |
| **Frog chorus** | Spring/summer night. Layered, rhythmic. Omen-associated. | Medium |

### UI Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **Menu select** | Soft, satisfying. Wooden tap or bone click. Natural material. | CRITICAL |
| **Menu confirm** | Slightly deeper/more resonant than select. Wooden "thunk." | CRITICAL |
| **Menu cancel/back** | Lighter, retreating. Soft wooden slide. | High |
| **Panel open** | Cedar creak — like opening a box lid. Brief. | High |
| **Panel close** | Matching close sound. | High |
| **Resource gained** | Gentle positive chime. Shell-like brightness. | High |
| **Warning/alert** | Low wooden drum tap. Attention-getting but not alarming. | High |
| **Season change** | Distinctive transitional sound. Wind + musical note. Marks time passage. | High |
| **Prestige gained** | Warm, resonant tone. Formline-inspired — like striking a copper. | High |
| **Omen appears** | Subtle, mysterious. Low breath-like tone + rattle hint. Not jumpscare. | High |

### Ceremony Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **Crowd murmur** | Background crowd. Builds and fades. Multiple layers for size variation. | High |
| **Crowd reaction (approval)** | Brief collective sound. Used when gifts given, pole rises, etc. | High |
| **Crowd gasp** | Surprise reaction. Rare, impactful. | Medium |
| **Pole impact (standing)** | THE sound of the pole base hitting its foundation. Deep, resonant, earth-shaking THUD. Then a moment of silence. Then crowd reaction. This single sound should be designed with extraordinary care. | CRITICAL |
| **Copper ring** | Striking or displaying a copper. Metallic, pure, prestigious. Rare and distinctive. | High |
| **Copper breaking** | Shattering/cracking of copper. Dramatic. Used only in rivalry potlatch. | Medium |
| **Fire burst** | Ceremonial fire flaring. Dramatic crackle-whoosh. | Medium |

### Conflict Sounds

| Sound | Description | Priority |
|-------|-------------|----------|
| **War cry / call** | Distant, intimidating. Used in approach phase. NOT a movie scream — more of a rhythmic, powerful call. | High |
| **Shield/weapon impact** | Abstract — wood-on-wood impact. Strategic. Not gory. | Medium |
| **Retreat horn/call** | Signal to withdraw. Distinctive. | Medium |
| **Victory signal** | Triumph call. Brief, powerful. | Medium |
| **Defensive alarm** | Village warning. Distinctive, urgent. Possibly wooden clapper. | High |

---

# 4. AUDIO TECHNICAL SPECIFICATIONS

## 4.1 — Format & Quality
- **Music:** OGG Vorbis, 44.1kHz, stereo, 160-192 kbps (quality/size balance)
- **SFX:** WAV, 44.1kHz, mono (positioned in stereo field by engine), 16-bit
- **Ambient loops:** OGG, 44.1kHz, stereo, 128 kbps
- **Total audio budget target:** 80-120 MB

## 4.2 — Mixing Priorities (Loudest to Quietest)
1. **UI sounds** — always audible, brief
2. **Critical SFX** (paddle stroke, storm impacts, ceremony moments)
3. **Music** — present but not overwhelming
4. **Ambient layers** — always underneath
5. **Detail SFX** (birds, distant sounds) — flavor, can be masked

## 4.3 — Adaptive Music Implementation

```
SCENE: Ocean Navigation
├── Layer 1: Ocean drone + paddle rhythm       [ALWAYS ON]
├── Layer 2: Melodic theme                     [OPEN WATER = ON, NEAR SHORE = FADE OUT]
├── Layer 3: Rhythmic intensity                [ROUGH WEATHER = FADE IN, CALM = OFF]
├── Layer 4: Full emotional peak               [STORM / MAJOR EVENT = FADE IN]
│
├── Transition trigger: ENTER FOG → crossfade to Fog theme over 3 sec
├── Transition trigger: APPROACH CONFLICT → crossfade to Conflict Approach over 2 sec
├── Transition trigger: REACH SHORE → crossfade to destination theme over 4 sec
└── Transition trigger: ENTER VILLAGE → crossfade to Village theme over 4 sec
```

## 4.4 — Audio Occlusion / Distance

- Sounds should attenuate with distance (simple linear falloff)
- **Interior vs exterior:** Entering a longhouse should muffle outside sounds and emphasize fire crackle
- **Underwater muffling:** If capsizing event, brief low-pass filter on all audio (dramatic)
- **Fog muffling:** Fog slightly dampens distant sounds (subtle)

## 4.5 — Silence & Space

**Explicit design rule:** Not every moment needs music. Tidelines should use **purposeful silence** — periods where only ambient sound plays — to create contrast and emotional space.

Key moments that should have NO music, only ambience:
- The moment after a chief dies (before memorial music)
- The quiet beat after a potlatch ends (before village ambient returns)
- First seeing a new coastline during exploration (let the player take it in)
- The beat before a storm hits (calm before the storm, literally)
- Nighttime in the village when nothing is happening (peace, domesticity)

---

# 5. EMOTIONAL AUDIO MAP

A guide for the audio team on the emotional arc:

```
TITLE SCREEN         ──── Majestic, inviting, oceanic. "Come, there is a world here."
ERA 1 START          ──── Warm, hopeful, intimate. "This is home."
FIRST VOYAGE         ──── Exciting, slightly nervous. "The sea is vast."
FIRST STORM          ──── Terrifying, gripping. "Respect the ocean."
FIRST CEREMONY       ──── Proud, communal, warm. "We celebrate."
FIRST CONFLICT       ──── Tense, heavy, consequential. "This costs something."
ERA 2 TRANSITION     ──── Growing, ambitious, powerful. "We reach further."
GREAT POTLATCH       ──── Triumphant, generous, the game's emotional high. "This is who we are."
POLE RAISING         ──── Awe, permanence, tears possible. "This will stand."
ERA 3 PEAK           ──── Majestic, complex, bittersweet undertones. "We have built greatly."
ERA 4 ARRIVAL        ──── Devastating. Sparse. Loss. "The world changes."
EPIDEMIC             ──── Silence → single voice → grief. No percussion. "We endure."
ERA 4 RESILIENCE     ──── Quiet strength. Stripped-back melody returning. "Still here."
ERA 5 REFLECTION     ──── Dawn. Gentle. Memory. Resolution. "It mattered."
CREDITS              ──── Full theme, gentle arrangement. Ocean. "The tide comes in."
```

---

# 6. MUSIC COMPOSITION NOTES

## Key Signatures & Tonality
- **Avoid:** Major keys for everything (too cheerful). Minor keys for everything (too dour).
- **Preferred:** Modal scales — Dorian, Mixolydian, Aeolian. These create rich, ambiguous emotional textures that feel ancient and grounded without being "sad" or "happy."
- **Specific guidance:**
  - Village themes: Mixolydian (warm, bright but not saccharine)
  - Navigation: Dorian (noble, slightly melancholic, open)
  - Ceremony: Mixolydian → Major at peak moments (triumph)
  - Fog/mystery: Phrygian or chromatic (unsettling, exotic)
  - Conflict: Minor / diminished (tension)
  - Era 4: Aeolian (pure minor, mourning)
  - Era 5: Minor → resolving to Major (grief to acceptance)

## Tempo Guidelines
- Village: 60-72 BPM (breathing, resting)
- Navigation: 80-96 BPM (paddle cadence — this should literally match a comfortable paddling rhythm)
- Ceremony: 72-100 BPM (building to celebration)
- Conflict approach: 100-120 BPM (heart rate rising)
- Conflict engagement: 120-140 BPM (peak intensity)
- Dream/spiritual: No fixed tempo (floating)

## Motif System

### The Tideline Motif (Main Theme)
A 4-bar melodic phrase that represents the game's core identity:
- Should be playable on a single breathy woodwind
- Should evoke ocean and legacy simultaneously
- Should be adaptable: can be played slow and mournful OR fast and triumphant
- Appears in: Title screen, potlatch peak, pole-raising, Era 5 resolution, credits

### The Ocean Motif
A 2-bar rhythmic figure representing the sea:
- Mimics wave rhythm: swell → crest → break → pull back
- Present as rhythmic underpinning in navigation themes
- Can be stretched/compressed for different sea states

### The Legacy Motif
A short 2-bar ascending phrase representing achievement and memory:
- Appears when prestige is gained, poles are raised, great acts are completed
- Ascending contour (low → high) suggests growth and permanence
- In Era 4-5, this motif appears in **descending** form (high → low) suggesting memory and what was

### Character Motifs
Each chief archetype has a 2-bar signature phrase:
- Played during their introduction and at key moments of their chieftainship
- Passed down (in variation) to their successors — creating a musical lineage

---

# 7. REFERENCE AUDIO TOUCHSTONES

### Music References (Spirit, not imitation)
- **Ryuichi Sakamoto** — The spare, emotional piano/ambient work. Restraint and beauty.
- **Yasunori Mitsuda (Chrono Cross OST)** — Natural instrumentation, oceanic atmosphere, emotional depth in a game context
- **Austin Wintory (Journey OST)** — Adaptive, emotional, cello-driven, minimal but powerful
- **Nobuo Uematsu (FF6 OST)** — The ability to create memorable melodies within 16-bit constraints
- **Hildur Guðnadóttir** — Raw, organic texture. Cello and voice as primary instruments. Emotional without being sentimental.

### Sound Design References
- **Firewatch** — Environmental ambient design, natural immersion
- **Outer Wilds** — Adaptive music that responds to world state, emotional exploration audio
- **Return of the Obra Dinn** — Audio as gameplay element, sparse but impactful design
- **Banner Saga** — Nordic-inspired game audio that is culturally evocative without being derivative

---

*End of Audio Bible v1.0*
*TIDELINES: Cedar, Sea & Legacy*
*"Listen. The ocean is speaking."*
