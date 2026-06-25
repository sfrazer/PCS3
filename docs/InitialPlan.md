# Pinball Construction Set — Godot 4 Recreation Plan

## Context

A faithful-mechanics recreation of Bill Budge's 1983 Pinball Construction Set for Godot 4, with a modern vector visual style. This is the third attempt. Previous attempts failed due to poor task scoping, relying on assumed knowledge instead of the manual, entangling editor and physics concerns, and losing workflow rules after context clears.

**This attempt's fixes:**
- Phase 0 creates `CLAUDE.md` before any code, so rules survive context clears
- Tasks are broken at sub-feature level — one output, one verification step each
- Phases 1–5 are editor-only; physics never appears before Phase 6
- All part behavior is derived from the manual, not assumed

**Win condition for this attempt:** open the editor, drag parts onto the playfield, and have it look like a real pinball table. Play mode is secondary. Phase 3 (part rendering) is the most critical phase.

---

## What the Manual Establishes

**Icon commands (right panel, lower section):**
| Icon | Role |
|---|---|
| Hand | Primary tool: pick up / drag / place parts from palette or board |
| Arrow / Scissors / Hammer | Create and edit custom polygon shapes |
| Paintbrush + Colors | Change a part's fill/border color |
| Play | Switch to Play Game mode |
| Magnifier | Freehand pixel-paint decorations onto the board surface |
| World | Set gravity, bounce, kick (impulse strength), ball speed — 4 sliders |
| AND gate | Assign targets to bonus groups; set bonus point value |
| Disk | Save / load game tables |

**Parts inventory (13 types from the manual):**
1. **Polygon** — custom static wall/guide; drawn with the arrow/scissors/hammer tool
2. **Bumper** — round pop bumper; bounces ball in all directions; score per hit
3. **Slingshot** — triangular kicker; applies directional impulse on the long face
4. **Drop target** — drops (hides) when hit; resets at start of each ball
5. **Half-bumper** — like a bumper but only bounces on one face
6. **Spinner** — rotates when ball passes through; scores per rotation
7. **Tunnel** — ball passes through a channel; scores on entry/exit
8. **Collector / Deflector** — redirects ball left or right
9. **Left Flipper** — player-controlled, `flip_left` action (Z key)
10. **Right Flipper** — player-controlled, `flip_right` action (/ key)
11. **Plunger** — ball launcher; hold `launch` action (Space) to compress, release to fire
12. **Rollover** — flat switch the ball rolls over; scores on contact
13. **Rollover edge target** — angled edge version of rollover

**World settings:** gravity scale (0–2×), restitution/bounce (0–1), kick multiplier (0–2×), ball speed multiplier (0–2×)

**AND gate scoring:** Any number of AND gates can exist. Each gate has a list of assigned target parts. When ALL assigned targets are hit in a single ball, a configurable bonus fires.

**Play controls (named by intent, not by button):**
| Action | Default Key |
|---|---|
| `flip_left` | Z |
| `flip_right` | / |
| `launch` | Space |
| `restart` | Ctrl+R |
| `debug_quit` | Escape |

---

## Architecture

### Project Settings (apply before writing gameplay code)

- **Version:** `0.1.0`
- **Viewport:** 640×360. Dev window: 2000×1200.
- **Stretch:** Mode = `canvas_items`, Aspect = `keep`, Scale Mode = `integer`
- **Physics layer names:** World, Ball, Part, Trigger
- **Input map:** all actions named by intent (see table above)
- **Debug overlay:** FPS and version string at startup; FPS cap during development
- **Static typing warnings:** `untyped declaration = warn`

The 640×360 base scales to 1280×720 at 2×. The playfield column is ~440px and parts panel ~200px at base resolution.

### Scene Tree Layer Order

| Layer | Node type | Process Mode |
|---|---|---|
| MainGame | Node2D | Always |
| World | Node2D | Pausable |
| HUD | CanvasLayer | Pausable |
| Pause | CanvasLayer | When Paused |
| Transition | CanvasLayer | Always |
| Debug | CanvasLayer | Always |

Set process modes explicitly — never rely on inherited defaults.

### Screen Layout (at 640×360 base)
```
┌──────────────────────────┬──────────────┐
│                          │  Parts Grid  │  ← part icons, visual draw_* thumbnails
│   Playfield (440×360)    │  (200×220)   │
│   (black bg, border)     ├──────────────┤
│                          │  Info Panel  │  ← name, score, behavior of hovered part
│                          │  (200×60)    │
│                          ├──────────────┤
│                          │  Icon Cmds   │  ← 8 tool icon buttons
│                          │  (200×80)    │
└──────────────────────────┴──────────────┘
```

The **info panel** is a persistent strip that updates live as the mouse moves over any part icon or icon command. It shows: part name, default score value, one-line behavior description. It does not flash empty — it retains the last-hovered item.

### File Structure

```
PCS3/
├── CLAUDE.md                 # Always-read rules: conventions, design rules, git basics
├── project.godot
├── .gitignore
├── .gitattributes            # Git LFS for .png, .wav, .ogg, .mp3, .mp4
├── assets/
│   ├── audio/
│   └── fonts/
├── source/
│   ├── core/
│   │   ├── main.tscn
│   │   └── main.gd
│   ├── data/
│   │   ├── world_settings.gd       # Resource: gravity, bounce, kick, ball_speed
│   │   ├── and_gate_data.gd        # Resource: target_ids[], bonus_value
│   │   ├── table_data.gd           # Resource: parts[], world_settings, and_gates[], version
│   │   └── save_load.gd            # JSON serialize/deserialize; versioned schema
│   ├── gameplay/
│   │   ├── construction/
│   │   │   ├── editor.tscn / editor.gd
│   │   │   ├── playfield.tscn / playfield.gd
│   │   │   ├── parts_panel.tscn / parts_panel.gd
│   │   │   └── tools/
│   │   │       ├── hand_tool.gd
│   │   │       ├── polygon_tool.gd
│   │   │       ├── paint_tool.gd
│   │   │       ├── world_tool.gd
│   │   │       └── and_gate_tool.gd
│   │   ├── parts/
│   │   │   ├── part_base.gd
│   │   │   ├── polygon_wall.tscn / polygon_wall.gd
│   │   │   ├── bumper.tscn / bumper.gd
│   │   │   ├── slingshot.tscn / slingshot.gd
│   │   │   ├── drop_target.tscn / drop_target.gd
│   │   │   ├── half_bumper.tscn / half_bumper.gd
│   │   │   ├── spinner.tscn / spinner.gd
│   │   │   ├── tunnel.tscn / tunnel.gd
│   │   │   ├── flipper.tscn / flipper.gd
│   │   │   ├── plunger.tscn / plunger.gd
│   │   │   ├── rollover.tscn / rollover.gd
│   │   │   └── rollover_edge.tscn / rollover_edge.gd
│   │   └── play/
│   │       ├── game.tscn / game.gd
│   │       ├── ball.tscn / ball.gd
│   │       └── drain.tscn / drain.gd
│   ├── ui/
│   │   ├── score_display.tscn / score_display.gd
│   │   └── save_load_dialog.tscn / save_load_dialog.gd
│   └── debug/
│       └── tests/
│           ├── godot_screenshot.sh
│           ├── test_save_load.gd
│           ├── test_and_gate.gd
│           └── test_tool_state.gd
└── docs/
    ├── InitialPlan.md
    ├── ProductBrief.md
    ├── UserStories.md
    ├── ArchitecturePlan.md
    ├── PlatformDelivery.md
    ├── MemoryContextSchema.md
    ├── BuildPlan.md
    ├── SCHEMA.md             # .pcs file format spec (versioned; for export reuse)
    ├── Claude-git-workflow.md
    ├── claude-godot-generic.md
    └── codereviews/
```

---

## GDScript Conventions

- **Always use static typing.** Enable `untyped declaration = warn`.
- **Script section order:** signals → enums → constants → `@export` vars → regular vars → `@onready` vars → built-in overrides → public functions → private functions
- Use `@onready` for all node references.

---

## Critical Design Rules

1. **Hand tool is always available.** Other tools change secondary behavior, not the ability to pick up/place.
2. **No grid snapping** — freeform placement, matching the original.
3. **Physics only in Play mode.** Each part implements `activate_physics()` / `deactivate_physics()`. No physics nodes are active during editor phases.
4. **One ball at a time; 3 balls per game.** Score persists across balls.
5. **Never flip with negative `scale.x`.** For the right flipper: use `Sprite2D.flip_h = true` (or mirror via draw transform) and explicitly reposition the collision shape. Negative scale silently breaks Area2D and collision children.
6. **Use `offset` not `position` for sprite alignment.** Position is physics truth.
7. **No top-level `preload` in long-lived nodes.** Use `load()` per-instance.
8. **Save schema is versioned from day one.** Every `.pcs` file includes a `version` field. Part types use stable string keys. See `docs/SCHEMA.md`.

---

## Build Phases (high-level)

See `docs/BuildPlan.md` for the granular task breakdown. Each task in that document has one output and one verification step.

### Phase 0 — CLAUDE.md (before any code)
Create `CLAUDE.md` at project root. Contains all always-on rules so they survive context clears.

### Phase 1 — Project scaffold + visual validation
- `project.godot` with all settings from above
- Main layout scene (two-column split)
- Playfield with border
- **Visual mockup: draw a bumper and a flipper on the playfield to validate the aesthetic before building the rest of the editor**

### Phase 2 — Parts panel
- Parts grid with 13 placeholder icons
- Info panel strip (persistent, updates on hover)
- Icon command buttons (8 tools, stubs)

### Phase 3 — Part rendering (primary success milestone)
- `_draw()` for all 13 part types as clean modern vectors
- Per-instance `color: Color` support
- Right flipper: mirror via draw transform, not `scale.x = -1`
- Parts panel icons use the same draw code at thumbnail scale

### Phase 4 — Hand tool: place and move
- Click palette icon → part follows cursor
- Click playfield → place part
- Click placed part → pick it up again
- Right-click → delete

### Phase 5 — Color tool
- Paintbrush icon activates color picker panel
- Clicking a placed part applies the chosen color

### Phase 6 — World settings + AND gate tools
- World tool: 4-slider panel → `WorldSettings` resource
- AND gate tool: click targets to assign; set bonus value

### Phase 7 — Save / Load
- `TableData` serialization to versioned JSON (`.pcs`)
- `docs/SCHEMA.md` written alongside the code
- Save/load dialog
- GUT tests: round-trip produces identical `TableData`; empty-string guard; typed array guard

### Phase 8 — Play mode physics
- Mode switch: editor freezes, physics activates via `activate_physics()`
- Ball (`RigidBody2D`), flippers (`AnimatableBody2D`), plunger
- Score HUD CanvasLayer
- Ball drain and reset

### Phase 9 — Active part behaviors
- Bumpers, slingshots, drop targets, spinners, rollovers, tunnels
- AND gate bonus logic
- GUT test: bonus fires only when all gate targets hit in one ball

### Phase 10 — Polygon tool
- Arrow (corners), Scissors (insert), Hammer (close)

### Phase 11 — Magnifier + Paint
- Freehand board decoration

### Phase 12 — Export (long-term)
- Stable, documented export format for use in other Godot projects
- Separate from internal save format; schema in `docs/SCHEMA.md`

---

## Git Workflow

- **Never commit to `main` directly.** Feature branches only.
- **Branch naming:** `phase-0-claude-md`, `phase-1-scaffold`, etc.
- **Commit timing:** when something works, or before something experimental.
- **`.gitattributes`:** Git LFS for `.png`, `.wav`, `.ogg`, `.mp3`, `.mp4`.
- **Merge:** squash merge via PR only.
- **Pre-PR:** run GUT suite → run Ollama review → save to `docs/codereviews/` → address findings → open PR.

---

## Verification Milestones

**Phase 1:** Screenshot shows a bumper and flipper on the playfield with the correct border. Aesthetic is confirmed before proceeding.

**Phase 3 (primary win condition):** All 13 parts render correctly in the playfield. Parts panel shows matching thumbnails. Info panel shows correct name and description on hover.

**Phase 4:** Drag a bumper from palette → place it → move it → delete it.

**Phase 7:** Place parts, save, quit, reload — identical table restored.

**Phase 8:** Press Play — ball drops, flippers respond to `flip_left`/`flip_right`, ball drains after 3 balls.

**Full integration:** Build a table with 2 flippers, 3 bumpers, 2 slingshots, 1 AND gate across 3 drop targets — save, reload, play — score correct, bonus fires when all 3 drop targets hit.
