# TIDELINES: Cedar, Sea & Legacy

> *A premium 16-bit strategy game of ocean mastery, ceremony, and civilization.*

---

## Playable Prototype

A self-contained vertical-slice prototype lives in `web/react/`.

### Quick Start (Local)

```bash
cd web/react
python -m http.server 8771
# Open http://localhost:8771
```

### Files

| File | Purpose |
|------|---------|
| `web/react/tidelines.html` | **The game** — self-contained single-file React app (v1.1) |
| `web/react/index.html` | Redirects to `tidelines.html` (static hosting entrypoint) |

### Static Hosting Deployment (Cloudflare Pages, Netlify, etc.)

| Setting | Value |
|---------|-------|
| **Deploy directory** | `web/react` |
| **Build command** | *(none)* |
| **Entrypoint** | `index.html` → redirects to `tidelines.html` |

- No build step, no bundler, no environment variables
- All dependencies (React 18, Babel, Press Start 2P font) load from CDN
- Works on any static file host

---

## Project Structure

```
HaidaGame/
├── web/
│   └── react/
│       ├── index.html          ← hosting entrypoint (redirects)
│       └── tidelines.html      ← the game (single-file React app)
│
├── docs/                       # Design documents
│   ├── GDD.md                  # Game Design Document
│   ├── ART_BIBLE.md            # Visual direction
│   ├── AUDIO_BIBLE.md          # Audio direction
│   └── TECHNICAL_ARCHITECTURE.md
│
├── data/                       # JSON game data
│   ├── canoes.json
│   ├── buildings.json
│   ├── chiefs.json
│   └── ...
│
└── src/                        # Godot GDScript (future)
```

---

## Design Pillars

1. **The Sea Is the World** — Ocean navigation is the primary game space
2. **Canoes Are Sacred Technology** — Building and mastering canoes is central
3. **Generosity Is Power** — Potlatch redistribution inverts normal strategy game hoarding
4. **Poles Record History** — Monumental poles are the game's memory and legacy system
5. **Beauty Is Not Optional** — Premium 16-bit art capturing the Pacific Northwest coast
6. **Respect Is the Foundation** — Cultural representation handled with reverence and care

---

## Cultural Note

This game draws inspiration from Haida history, culture, and worldview. Development should include consultation with Haida cultural advisors, review of representation at key milestones, and willingness to modify elements that are inappropriate. This is a core design requirement, not an optional addition.

---

*"The sea remembers. The poles remember. Will you?"*
