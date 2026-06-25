# Architecture Plan — Pinball Construction Set

## System Boundaries

The application has three clearly separated concerns. They must not bleed into each other:

| Concern | Scope | Active phases |
|---|---|---|
| **Editor** | Part placement, tool state, palette, color, polygon drawing | Phases 0–7 |
| **Physics / Play** | Ball simulation, collision, scoring, flipper input | Phases 8–9 |
| **Data** | Serialization, schema, save/load, future export | Phases 7, 12 |

Physics nodes (`RigidBody2D`, active `StaticBody2D`, `Area2D` monitoring) are **never present or active during editor operation**. Each part owns its own physics activation via `activate_physics()` / `deactivate_physics()`.

---

## Module Responsibilities

### `source/core/main.gd`
- Application root and mode switcher (extends `Control`, not `Node2D`)
- `Control` root is required so HBoxContainer children can use anchor-fill layout; a `Node2D` root does not propagate anchors to Control children
- Owns the scene tree layer structure (World, HUD, Transition, Debug CanvasLayers)
- Calls `editor.activate()` or `game.activate()` on mode switch
- Must not contain game logic — it is a coordinator only

### `source/gameplay/construction/editor.gd`
- Holds `var active_tool: ToolBase` — the tool state machine
- Receives all `_input` events from the playfield and forwards to `active_tool.handle_input(event)`
- Switches active tool when an icon command button is pressed
- Does not implement any tool logic itself

### `source/gameplay/construction/playfield.gd`
- Owns all placed part instances as children
- Converts mouse position to playfield-local coordinates
- Emits `part_clicked(part)` and `empty_clicked(position)` signals for the active tool to consume
- Draws the playfield border and background in `_draw()`
- Enforces the playfield boundary (parts cannot be placed outside it)

### `source/gameplay/construction/parts_panel.gd`
- Renders the parts grid using each part type's draw code at thumbnail scale
- Updates the info panel strip on mouse-enter/mouse-exit for each icon
- Emits `part_type_selected(type: String)` when a palette icon is clicked
- Renders the 8 icon command buttons; emits `tool_selected(tool_name: String)`

### `source/gameplay/construction/tools/hand_tool.gd`
- Maintains `var pending_type: String` and `var held_part: PartBase`
- On `part_type_selected`: sets `pending_type`, spawns a ghost part following the cursor
- On `empty_clicked`: places the pending part at that position via `playfield.place_part()`
- On `part_clicked`: picks up the part (removes from playfield, sets as `held_part`)
- On right-click: deletes the clicked part

### `source/gameplay/parts/part_base.gd`
Base class for all 13 part types. Defines the contract every part must fulfil:

```gdscript
class_name PartBase extends Node2D

signal scored(value: int)
signal target_hit(part_id: int)

@export var color: Color
@export var score_value: int
var part_id: int

func _draw() -> void: pass          # override in each subclass
func activate_physics() -> void: pass
func deactivate_physics() -> void: pass
func to_dict() -> Dictionary: return {}
func from_dict(data: Dictionary) -> void: pass
```

### `source/data/table_data.gd`
Holds the full serializable state of a table:
- `var version: String` — schema version string (e.g. `"1.0"`)
- `var parts: Array[Dictionary]` — each entry is a `part.to_dict()` result
- `var world_settings: Dictionary`
- `var and_gates: Array[Dictionary]`

### `source/data/save_load.gd`
- `save(table: TableData, path: String) -> void` — serializes to JSON, writes file
- `load(path: String) -> TableData` — reads file, guards for empty string before parsing, iterates array elements explicitly (never assigns `JSON.parse_string()` directly to a typed array)
- All file paths use `user://saves/<name>.pcs`

### `source/gameplay/play/game.gd`
- Activates on mode switch: calls `activate_physics()` on all parts, spawns ball
- Listens for `scored(value)` signals from all parts; updates score
- Tracks ball count (3 per game); on drain, decrements, resets drop targets, respawns ball or ends game
- Handles `flip_left`, `flip_right`, `launch`, `restart` input actions

---

## Tool State Machine

```
         ┌──────────────┐
         │   HandTool   │ ← default; always available for pick/place
         └──────┬───────┘
                │  icon command clicked
    ┌───────────┼───────────────────────────┐
    ▼           ▼           ▼               ▼
PolygonTool  PaintTool  WorldTool  AndGateTool  (etc.)
```

Tools are instantiated once at editor startup, not recreated on switch. The hand is not deactivated when another tool is selected — it still handles pick/place, while the secondary tool handles its specific interaction (e.g., color picker on click, polygon corner on click).

---

## Part Data Flow

```
User places part in editor
  → hand_tool calls playfield.place_part(type, position)
  → playfield calls load("res://source/gameplay/parts/<type>.tscn")
  → instantiates PartBase subclass, sets position/color/score
  → adds as child of playfield

User presses Save
  → save_load.save() calls part.to_dict() for each child of playfield
  → writes versioned JSON to user://saves/<name>.pcs

User presses Load
  → save_load.load() reads JSON, iterates parts array
  → for each dict, instantiates the correct .tscn via dict["type"]
  → calls part.from_dict(dict)
  → adds to playfield

User presses Play
  → main.gd switches mode
  → game.gd calls part.activate_physics() on every part
  → ball spawned; physics simulation runs
  → scored(value) signals flow to game.gd
  → game.gd updates HUD

User presses Editor (return)
  → game.gd calls part.deactivate_physics() on every part
  → ball freed
  → editor resumes
```

---

## Physics Layer Assignment

| Layer name | Used by |
|---|---|
| World | Playfield boundary walls |
| Ball | The ball RigidBody2D |
| Part | StaticBody2D parts (bumpers, walls, slingshots) |
| Trigger | Area2D sensors (scoring, AND gate detection) |

Ball collides with: World, Part
Trigger monitors: Ball only

---

## Save Schema (versioned)

Every `.pcs` file has this top-level structure:

```json
{
  "version": "1.0",
  "world": { "gravity": 1.0, "bounce": 0.5, "kick": 1.0, "ball_speed": 1.0 },
  "and_gates": [
    { "id": 0, "target_ids": [2, 5], "bonus": 10000 }
  ],
  "parts": [
    { "type": "bumper", "id": 0, "x": 120.0, "y": 80.0, "color": "#ff00ff", "score": 100 },
    { "type": "flipper_left", "id": 1, "x": 60.0, "y": 300.0, "color": "#00ffff", "score": 0 }
  ]
}
```

`type` values are stable string keys — they never change between versions. A `version` field allows future migration. Full specification: `docs/SCHEMA.md`.

---

## Key Constraints (Do Not Violate)

1. No physics nodes active during editor phases (Phases 0–7).
2. Never use `scale.x = -1` for mirroring — use `Sprite2D.flip_h` and explicit collision repositioning.
3. Never assign `JSON.parse_string()` directly to a typed array — iterate and append.
4. Always guard `JSON.parse_string()` with an empty-string check first.
5. No top-level `preload` in long-lived nodes — use `load()` per-instance.
6. `push_error` must not be called in any code path exercised by GUT tests.
7. Part `type` strings in save files are permanent — never rename them.
