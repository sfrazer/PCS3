# Platform & Delivery Plan

## Primary Target: macOS

All development and testing happens on macOS. This is the only platform that must work at every phase.

- **Godot version:** 4.x (latest stable)
- **Renderer:** Compatibility (works on all Mac GPUs; no Vulkan required)
- **Export:** Godot macOS export template; code-signed if distributing publicly
- **Input:** Keyboard and mouse only (no touch, no controller required)
- **Window size:** Dev window 2000×1200. Shipped window: resizable from 1280×720 minimum, integer-scaled from 640×360 base
- **Performance floor:** Any Mac capable of running Godot 4. No GPU-intensive effects.

## Secondary Target: Windows

Added when the macOS build is stable and the project warrants public release.

- **No Windows-specific code** — Godot's cross-platform export handles this
- **Testing:** Run the Windows export in a VM or secondary machine before any itch.io release
- **Input:** Same as macOS (keyboard + mouse)
- **No platform-specific UX differences** — the game UI is identical on both platforms

## Explicitly Out of Scope

- **Web (HTML5):** No web export. Physics and file I/O behavior in the browser adds complexity that isn't justified for a personal project.
- **Mobile (iOS/Android):** No touch input design in the editor. Not planned.
- **Linux:** Not a target, but Godot 4 exports to Linux; could be trivially added if needed.
- **Console:** Not planned.

## Distribution

| Channel | When | Notes |
|---|---|---|
| Local only | Now | Primary target — personal use |
| itch.io | If project succeeds | PC + Mac builds; no app store review |
| Steam | Not planned | Out of scope |

## itch.io Preparation (when relevant)

- Export macOS `.app` (zipped) and Windows `.exe` (zipped)
- Set minimum OS versions in Godot export settings
- Include `SCHEMA.md` in the distribution so third parties can consume `.pcs` files
- Ensure save files write to `user://` (Godot handles OS-appropriate paths automatically)

## Performance Envelope

- Target 60 fps on mid-range Mac hardware (M1 or equivalent Intel)
- No 3D, no particles, no post-processing — all 2D draw calls
- Part count on a typical table: 20–50 nodes. Well within Godot 2D performance budget.
- Set an FPS cap during development to avoid fan noise (`Engine.max_fps = 60`)

## File System

- Save files: `user://saves/<name>.pcs` (JSON text, <1 KB per table)
- Godot resolves `user://` to the OS-appropriate application support directory automatically
- No server, no network requests, no cloud sync — fully offline
