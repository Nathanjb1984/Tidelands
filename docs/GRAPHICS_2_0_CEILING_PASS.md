# Graphics 2.0 Ceiling Pass

## Goal
Raise the overall presentation ceiling of TIDELINES scenes through shared motion and depth systems rather than isolated one-off asset upgrades.

## Implemented
- Added shared motion primitives in `web/react/tidelines.html` for:
  - soft figure breath
  - deeper solemn idle motion
  - role-figure poise
  - structure settle drift
  - ember pulse
  - heat haze
  - water depth drift
  - wake shimmer
  - moon halo pulse
- Extended the shared motion language with:
  - shoreline surf/foam drift
  - surf lace shimmer at water edges
  - restrained arrival-camera drift
  - restrained battle-pressure camera drift
- Upgraded shared helpers so the new motion language propagates automatically:
  - `Figure`
  - `RoleFigure`
  - `Longhouse`
  - `HostileLonghouse`
  - `SimpleCanoe`
  - `CeremonialFire`
  - `WakeTrail`
  - `SceneMoon`
  - `WaterBody`
- Added reusable `SurfBand` for shoreline transition scenes.
- Replaced the custom wake strip in `EncounterScene` with the shared `WakeTrail` system.

## Visual Intent
- Keep the look SNES-readable and silhouette-first.
- Favor restrained motion that suggests weight, ceremony, breath, surf, and heat.
- Improve scene cohesion so every location feels more alive even when no new bespoke art is added.

## Result
The prototype now relies less on static SVG swaps alone and more on a shared presentation layer, giving scenes more depth, shoreline energy, and continuity in motion.

## Next Likely Upgrades
- Add stronger foreground surf and shoreline foam passes.
- Introduce scene-specific ambient particle sheets for embers, mist, and drizzle.
- Add moment-specific camera language for battle impacts and ceremonial arrivals.
- Expand figure posture families for witnesses, elders, and warriors.
