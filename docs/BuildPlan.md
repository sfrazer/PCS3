# Build Plan

Each task has **one output** and **one verification step**. Tasks are sub-feature level. Do not combine tasks. Complete and verify each task before starting the next.

Status: `[ ]` not started · `[x]` done · `[-]` in progress

---

## Phase 0 — CLAUDE.md (before any code)

Branch: `phase-0-claude-md`

- [ ] **0.1** Create `CLAUDE.md` at project root containing: what we're building (one paragraph), GDScript conventions, the 5 critical design rules, git basics, task discipline rules.
  - *Verify:* File exists at repo root; all five critical rules are present and numbered.

---

## Phase 1 — Project Scaffold + Visual Validation

Branch: `phase-1-scaffold`

- [ ] **1.1** Create `project.godot` with correct settings: viewport 640×360, dev window 2000×1200, stretch mode `canvas_items` / aspect `keep` / scale `integer`, version `0.1.0`, FPS cap 60, `untyped declaration = warn`.
  - *Verify:* Project opens in Godot 4 editor without errors; window is 2000×1200 in editor; version shows `0.1.0`.

- [ ] **1.2** Create the physics layer names in Project Settings: World, Ball, Part, Trigger (2D Physics and 2D Render).
  - *Verify:* Layer names visible in Project Settings → Layer Names → 2D Physics.

- [ ] **1.3** Add input actions to Input Map: `flip_left` (Z), `flip_right` (/), `launch` (Space), `restart` (Ctrl+R), `debug_quit` (Escape). Map each to keyboard.
  - *Verify:* All 5 actions visible in Project Settings → Input Map with correct key bindings.

- [ ] **1.4** Create `source/core/main.tscn` as a **Control** root (not Node2D — HBoxContainer anchors require a Control parent) containing an HBoxContainer child that fills the viewport. Left child: 440px wide (playfield placeholder). Right child: 200px wide (panel placeholder). Set `process_mode = 3` (ALWAYS) on root.
  - *Verify:* Scene opens; two columns visible at correct proportions.

- [ ] **1.5** Create `source/gameplay/construction/playfield.tscn` as a **Control** (not Node2D — must be Control to anchor-fill inside the HBoxContainer). In `_draw()`: fill the background black; draw a 3px magenta border inset from the edges. Set `mouse_filter = 0` (STOP) in the scene; do not set it again in `_ready()`.
  - *Verify:* Screenshot shows black playfield with magenta border. Run: `source/debug/tests/godot_screenshot.sh --preview res://source/core/main.tscn /tmp/phase1.png`

- [ ] **1.6** Draw a bumper (filled circle, ring outline, highlight dot) and a left flipper (tapered wedge) directly in `playfield.gd _draw()` as hardcoded shapes at fixed positions.
  - *Verify:* Screenshot shows two recognisable shapes on the playfield. Aesthetic confirmed before proceeding to Phase 2. **This is the go/no-go gate for the visual approach.**

- [ ] **1.7** Remove the hardcoded shapes from `playfield.gd` once aesthetic is confirmed.
  - *Verify:* Playfield shows border only; no leftover draw calls.

- [ ] **1.8** Create `source/debug/tests/godot_screenshot.sh` (copy template from `docs/claude-godot-generic.md`).
  - *Verify:* Script is executable; running it with no args produces a screenshot without errors.

---

## Phase 2 — Parts Panel

Branch: `phase-2-parts-panel`

- [ ] **2.1** Create `source/gameplay/construction/parts_panel.tscn` as a VBoxContainer (200px wide). Add three child sections: PartsGrid (220px tall), InfoPanel (60px tall), IconCommands (80px tall).
  - *Verify:* Panel visible in editor at correct proportions alongside the playfield.

- [ ] **2.2** Add 13 placeholder buttons to PartsGrid in a GridContainer (3 columns). Each button is 60×60px, labeled with the part type name.
  - *Verify:* All 13 buttons visible, none overflow their container.

- [ ] **2.3** Create `source/gameplay/construction/parts_panel.gd`. On mouse-enter for each button, update InfoPanel label with part name and a hardcoded one-line description. InfoPanel retains last-hovered content on mouse-exit.
  - *Verify:* Hovering each button updates the info panel; moving mouse away keeps the last content.

- [ ] **2.4** Add 8 icon command buttons to IconCommands section. Labels: Hand, Polygon, Paint, Play, Magnifier, World, ANDGate, Disk.
  - *Verify:* All 8 buttons visible and labeled.

- [ ] **2.5** `parts_panel.gd` emits `part_type_selected(type: String)` when a palette button is clicked, and `tool_selected(tool_name: String)` when an icon command button is clicked.
  - *Verify:* Print statements in `main.gd` confirm signals fire with correct values when buttons are clicked.

---

## Phase 3 — Part Rendering (Primary Success Milestone)

Branch: `phase-3-part-rendering`

- [ ] **3.1** Create `source/gameplay/parts/part_base.gd` with: `signal scored(value: int)`, `signal target_hit(part_id: int)`, `@export var color: Color`, `@export var score_value: int`, `var part_id: int`, and stub functions `_draw()`, `activate_physics()`, `deactivate_physics()`, `to_dict() -> Dictionary`, `from_dict(data: Dictionary) -> void`. Use static typing throughout.
  - *Verify:* Script parses without errors; no untyped declarations.

- [ ] **3.2** Create `bumper.tscn` / `bumper.gd` extending `PartBase`. `_draw()`: filled circle (radius 20), ring outline (radius 24, 2px), small highlight dot offset from center. Default color: white.
  - *Verify:* Place bumper.tscn in a test scene; screenshot shows recognisable pop bumper shape.

- [ ] **3.3** Create `flipper.tscn` / `flipper.gd` (left flipper) extending `PartBase`. `_draw()`: tapered wedge — wide at pivot end, narrow at tip. Length ~60px. Default color: cyan.
  - *Verify:* Screenshot shows recognisable left flipper shape.

- [ ] **3.4** Add `var is_right: bool` to `flipper.gd`. When `is_right` is true, mirror the wedge horizontally in `_draw()` using a flipped transform — **not** `scale.x = -1`. The collision shape (added later) will also be explicitly mirrored.
  - *Verify:* Two flippers (one with `is_right = false`, one with `is_right = true`) appear as mirror images; no scale.x manipulation.

- [ ] **3.5** Create `slingshot.tscn` / `slingshot.gd`. `_draw()`: isoceles triangle, wide base at bottom, point at top. Default color: cyan.
  - *Verify:* Screenshot shows recognisable triangular slingshot.

- [ ] **3.6** Create `drop_target.tscn` / `drop_target.gd`. `_draw()`: small rectangle with a horizontal line across the top (the face that gets hit). Default color: yellow.
  - *Verify:* Screenshot shows recognisable drop target.

- [ ] **3.7** Create `half_bumper.tscn` / `half_bumper.gd`. `_draw()`: semicircle, flat face forward. Default color: white.
  - *Verify:* Screenshot shows semicircle with flat face.

- [ ] **3.8** Create `spinner.tscn` / `spinner.gd`. `_draw()`: thin rectangle (the blade) centered on the node. Default color: green.
  - *Verify:* Screenshot shows a thin horizontal bar (spinner at rest).

- [ ] **3.9** Create `tunnel.tscn` / `tunnel.gd`. `_draw()`: two parallel lines with end caps forming a channel. Default color: grey.
  - *Verify:* Screenshot shows a recognisable tunnel channel.

- [ ] **3.10** Create `collector.tscn` / `collector.gd`. `_draw()`: right-pointing wedge/arrow shape. Default color: orange.
  - *Verify:* Screenshot shows a directional deflector shape.

- [ ] **3.11** Create `plunger.tscn` / `plunger.gd`. `_draw()`: a vertical rectangle (the lane) with a semicircle at the bottom (the spring). Default color: white.
  - *Verify:* Screenshot shows plunger lane and spring.

- [ ] **3.12** Create `rollover.tscn` / `rollover.gd`. `_draw()`: small filled oval. Default color: yellow.
  - *Verify:* Screenshot shows a small oval target.

- [ ] **3.13** Create `rollover_edge.tscn` / `rollover_edge.gd`. `_draw()`: same oval, rotated 45°. Default color: yellow.
  - *Verify:* Screenshot shows an angled oval.

- [ ] **3.14** Create `polygon_wall.tscn` / `polygon_wall.gd` extending `PartBase`. Holds a `PackedVector2Array` of points; `_draw()` draws filled polygon + outline. Default color: white.
  - *Verify:* Script parses; a polygon with 4 corners renders correctly.

- [ ] **3.15** Update `parts_panel.gd` so each palette button renders a thumbnail of the part's `_draw()` output (scaled to 50×50px within the button) instead of a text label.
  - *Verify:* All 13 palette buttons show a recognisable mini-shape. **This is the primary success milestone.**

---

## Phase 4 — Hand Tool: Place and Move

Branch: `phase-4-hand-tool`

- [ ] **4.1** Create `source/gameplay/construction/tools/hand_tool.gd`. On `part_type_selected(type)` signal: store `pending_type`, spawn a ghost instance of the part (50% alpha) that follows the cursor.
  - *Verify:* Clicking a palette button causes a ghost part to follow the mouse over the playfield.

- [ ] **4.2** On left-click on an empty area of the playfield: instantiate the part at that position, clear `pending_type`, remove ghost.
  - *Verify:* Click places a solid part on the playfield at the cursor position.

- [ ] **4.3** On left-click on an existing placed part: pick it up (remove from playfield, set as `held_part` following cursor at 50% alpha).
  - *Verify:* Clicking a placed part detaches it and it follows the cursor.

- [ ] **4.4** On left-click on empty area while holding a part: place it at that position.
  - *Verify:* Held part is placed on second click; no longer follows cursor.

- [ ] **4.5** On right-click on a placed part: delete it (`queue_free()`).
  - *Verify:* Right-clicking a placed part removes it.

---

## Phase 5 — Color Tool

Branch: `phase-5-color-tool`

- [ ] **5.1** Create `source/gameplay/construction/tools/paint_tool.gd`. When activated via the Paint icon command, show a `ColorPickerButton` panel.
  - *Verify:* Clicking the Paint icon opens a color picker panel.

- [ ] **5.2** On left-click on a placed part while paint tool is active: set `part.color` to the current picker color and call `part.queue_redraw()`.
  - *Verify:* Clicking a bumper while a color is chosen changes its color immediately.

---

## Phase 6 — World Settings Tool

Branch: `phase-6-world-settings`

- [ ] **6.1** Create `source/data/world_settings.gd` as a `Resource` with typed fields: `var gravity: float = 1.0`, `var bounce: float = 0.5`, `var kick: float = 1.0`, `var ball_speed: float = 1.0`.
  - *Verify:* Resource instantiates without errors; all fields have correct defaults.

- [ ] **6.2** Create `source/gameplay/construction/tools/world_tool.gd`. When activated, show a panel with 4 labeled `HSlider` nodes (ranges: gravity 0–2, bounce 0–1, kick 0–2, ball_speed 0–2).
  - *Verify:* Clicking the World icon opens the slider panel with 4 sliders at their default positions.

- [ ] **6.3** Wire each slider's `value_changed` signal to update the corresponding field on a `WorldSettings` resource instance held by `editor.gd`.
  - *Verify:* Moving a slider updates the resource field (confirmed via print statement or debugger).

---

## Phase 7 — AND Gate Tool

Branch: `phase-7-and-gate`

- [ ] **7.1** Create `source/data/and_gate_data.gd` as a `Resource` with: `var id: int`, `var target_ids: Array[int]`, `var bonus_value: int = 10000`.
  - *Verify:* Resource instantiates; fields are correctly typed.

- [ ] **7.2** Create `source/gameplay/construction/tools/and_gate_tool.gd`. When activated, clicking a placed target-type part (bumper, drop target, rollover) toggles it in/out of the current AND gate's `target_ids`.
  - *Verify:* Clicking a bumper while AND gate tool is active adds its `part_id` to the current gate's `target_ids`.

- [ ] **7.3** Add a visual indicator on parts assigned to a gate (e.g., a small colored dot drawn in their `_draw()`).
  - *Verify:* Assigned parts show the indicator; unassigned parts do not.

- [ ] **7.4** Add a `SpinBox` to the AND gate tool panel for setting `bonus_value`.
  - *Verify:* Changing the SpinBox updates `bonus_value` on the current gate resource.

---

## Phase 8 — Save / Load

Branch: `phase-8-save-load`

- [ ] **8.1** Create `source/data/table_data.gd` as a `Resource`: `var version: String = "1.0"`, `var parts: Array[Dictionary]`, `var world_settings: Dictionary`, `var and_gates: Array[Dictionary]`.
  - *Verify:* Resource instantiates; all fields typed correctly.

- [ ] **8.2** Implement `to_dict() -> Dictionary` and `from_dict(data: Dictionary) -> void` in all 13 part scripts. Each dict must include `"type"`, `"id"`, `"x"`, `"y"`, `"color"` (as hex string), `"score"`.
  - *Verify:* `bumper.to_dict()` returns a dict with all required keys; `from_dict()` restores all values.

- [ ] **8.3** Implement `save_load.gd` `save(data: TableData, path: String) -> void`: serialize to JSON string, write to `path`.
  - *Verify:* Calling save() produces a valid `.pcs` file at `user://saves/test.pcs`.

- [ ] **8.4** Implement `save_load.gd` `load(path: String) -> TableData`: guard for empty string, parse JSON, iterate `parts` array explicitly (not direct typed assignment), reconstruct `TableData`.
  - *Verify:* `load()` on the file saved in 8.3 returns a `TableData` with the same part count and values.

- [ ] **8.5** Create `source/ui/save_load_dialog.tscn`: a modal with a `LineEdit` for the file name, Save and Load buttons, and a list of existing `.pcs` files in `user://saves/`.
  - *Verify:* Dialog opens from the Disk icon; typing a name and pressing Save writes a file; the file appears in the list.

- [ ] **8.6** Wire Load: selecting a file from the list and pressing Load clears the current playfield and rebuilds it from the file.
  - *Verify:* Save a table with 3 parts, reload — exactly 3 parts appear at the correct positions.

- [ ] **8.7** Write `docs/SCHEMA.md` documenting the `.pcs` format: version field, all part type strings, all field names and types, and the world/and_gate structures.
  - *Verify:* Document exists and accurately describes the format produced by 8.3.

- [ ] **8.8** Write GUT test `source/debug/tests/test_save_load.gd`: serialize a `TableData` with one of each part type; deserialize; assert all fields equal. Include test for empty-string guard. Include test for typed array iteration.
  - *Verify:* `godot --headless -s res://addons/gut/gut_cmdln.gd` passes all tests.

---

## Phase 9 — Play Mode Setup

Branch: `phase-9-play-mode-setup`

- [ ] **9.1** Create `source/gameplay/play/game.tscn` as a Node2D with a HUD CanvasLayer child. HUD contains a score label and ball count label.
  - *Verify:* Scene opens; labels visible at top of screen.

- [ ] **9.2** `main.gd`: pressing the Play icon command hides the editor UI, instantiates `game.tscn`, and calls `activate_physics()` on all parts in the playfield.
  - *Verify:* Pressing Play hides the palette panel; no crash; physics not yet functional (just activation call stubs).

- [ ] **9.3** Create `source/gameplay/play/ball.tscn`: `RigidBody2D` + `CircleShape2D` (radius 8). Add `PhysicsMaterial` with `bounce` set from `WorldSettings.bounce`. Set physics layer to Ball; mask to World and Part.
  - *Verify:* Ball scene instantiates without errors; PhysicsMaterial is attached.

- [ ] **9.4** `game.gd`: on play start, spawn the ball at the plunger's position.
  - *Verify:* Ball appears at the plunger location when Play is pressed.

- [ ] **9.5** Apply `WorldSettings.gravity` to the scene at play start by scaling `ProjectSettings.physics/2d/default_gravity`.
  - *Verify:* Setting gravity to 0 in World settings causes the ball to float when Play is pressed.

- [ ] **9.6** Create `source/gameplay/play/drain.tscn`: an `Area2D` + `CollisionShape2D` spanning the bottom of the playfield. On `body_entered`: emit `ball_drained` signal.
  - *Verify:* Ball falling to bottom of playfield triggers `ball_drained` signal (confirmed via print).

- [ ] **9.7** `game.gd` handles `ball_drained`: decrement ball count; if count > 0, free ball and respawn; if count == 0, show game over in HUD.
  - *Verify:* Ball drains 3 times; HUD shows ball count decrementing; game over message on 3rd drain.

- [ ] **9.8** `main.gd`: an Editor button in HUD calls `deactivate_physics()` on all parts, frees the ball, and restores the editor UI.
  - *Verify:* Pressing Editor button during play returns to the editor with all parts still in place.

---

## Phase 10 — Flippers

Branch: `phase-10-flippers`

- [ ] **10.1** `flipper.gd` `activate_physics()`: add an `AnimatableBody2D` child with a `CollisionShape2D` matching the wedge shape. For right flipper, explicitly mirror the collision shape position — do not use `scale.x = -1`.
  - *Verify:* Flipper has a collision shape visible in the Godot debugger; ball rests on it without falling through.

- [ ] **10.2** `flipper.gd`: on `flip_left` input action (left flipper) or `flip_right` (right flipper), rotate the `AnimatableBody2D` from rest angle to active angle over 0.08 seconds. Rotate back on input release.
  - *Verify:* Pressing Z rotates the left flipper upward; releasing returns it. Same for / and right flipper.

- [ ] **10.3** Verify ball is deflected by flipper: drop a ball onto a horizontal flipper; it bounces away at an angle.
  - *Verify:* Ball deflects off the flipper surface; does not pass through.

---

## Phase 11 — Plunger

Branch: `phase-11-plunger`

- [ ] **11.1** `plunger.gd` `activate_physics()`: add a `StaticBody2D` lane wall and an `AnimatableBody2D` spring at the bottom.
  - *Verify:* Ball placed in plunger lane stays in the lane.

- [ ] **11.2** On `launch` action held: animate the spring compressing (move it upward). On release: animate it returning quickly, applying an impulse to any ball in contact. Impulse magnitude scales with `WorldSettings.ball_speed`.
  - *Verify:* Holding Space and releasing causes the ball to launch upward from the plunger lane.

---

## Phase 12 — Static Part Collision

Branch: `phase-12-static-collision`

- [ ] **12.1** `polygon_wall.gd` `activate_physics()`: add a `StaticBody2D` + `CollisionPolygon2D` using the stored `PackedVector2Array`. Physics layer: Part.
  - *Verify:* Ball bounces off a polygon wall without passing through.

- [ ] **12.2** `half_bumper.gd` `activate_physics()`: add a `StaticBody2D` + `CollisionShape2D` (semicircle). Only the flat face is in the Part layer; the curved back is layer 0 (no collision).
  - *Verify:* Ball bounces off the flat face; passes through the curved back.

---

## Phase 13 — Active Part Behaviors

Branch: `phase-13-part-behaviors`

- [ ] **13.1** `bumper.gd` `activate_physics()`: add `Area2D` + `CircleShape2D` monitoring the Ball layer. On `body_entered`: apply `apply_central_impulse` away from center, scaled by `WorldSettings.kick`; emit `scored(score_value)`.
  - *Verify:* Ball enters bumper area → bounces away → score increments in HUD.

- [ ] **13.2** `slingshot.gd` `activate_physics()`: add `StaticBody2D` (main body) + face `Area2D` on the long side. On `body_entered`: impulse in face-normal direction × kick; emit `scored(score_value)`.
  - *Verify:* Ball hits the slingshot face → deflects in the correct direction → score increments.

- [ ] **13.3** `drop_target.gd` `activate_physics()`: add `StaticBody2D`. On `body_entered`: disable collision, play drop animation (move downward 20px over 0.2s), emit `scored(score_value)` and `target_hit(part_id)`.
  - *Verify:* Ball hits drop target → it drops → collision disabled → ball passes through.

- [ ] **13.4** `game.gd`: on new ball spawn, call `reset()` on all drop targets — re-enable collision and animate back up.
  - *Verify:* Dropped targets return to position when a new ball is spawned.

- [ ] **13.5** `spinner.gd` `activate_physics()`: add `Area2D` (pass-through, no StaticBody). On `body_entered`: begin rotating the sprite. Emit `scored(spin_score)` for each full 360° revolution. On `body_exited`: decelerate.
  - *Verify:* Ball passes through spinner → spinner rotates → score increments per revolution.

- [ ] **13.6** `rollover.gd` `activate_physics()`: add `Area2D` + `CircleShape2D` (small). On `body_entered`: emit `scored(score_value)`.
  - *Verify:* Ball rolls over the rollover → score increments once per pass.

- [ ] **13.7** `tunnel.gd` `activate_physics()`: add entry and exit `Area2D` nodes. On entry `body_entered`: emit `scored(score_value)`. Ball passes through freely (no StaticBody).
  - *Verify:* Ball enters tunnel → score increments → ball exits the other end.

- [ ] **13.8** `collector.gd` `activate_physics()`: add `StaticBody2D` wedge. Ball contacts it and is directed left or right depending on which face is hit.
  - *Verify:* Ball hits collector → deflects in the correct direction.

---

## Phase 14 — AND Gate Scoring

Branch: `phase-14-and-gate-scoring`

- [ ] **14.1** `game.gd`: on play start, read all `ANDGateData` from `TableData`. Listen for `target_hit(part_id)` signals from all parts.
  - *Verify:* `target_hit` signals from parts are received by `game.gd` (confirmed via print).

- [ ] **14.2** `game.gd`: for each AND gate, track which of its `target_ids` have been hit this ball. When all are hit, add `bonus_value` to score and display bonus message in HUD.
  - *Verify:* Assign 2 targets to a gate; hit both → bonus fires and appears in HUD.

- [ ] **14.3** `game.gd`: on new ball spawn, reset the hit-tracking state for all AND gates.
  - *Verify:* Hit one target, drain ball, start new ball — gate is not triggered by hitting only the remaining target.

- [ ] **14.4** Write GUT test `source/debug/tests/test_and_gate.gd`: assert bonus fires only when all targets in a gate are hit; assert partial hit does not fire; assert reset clears state.
  - *Verify:* `godot --headless -s res://addons/gut/gut_cmdln.gd` passes.

---

## Phase 15 — Polygon Tool

Branch: `phase-15-polygon-tool`

- [ ] **15.1** `polygon_tool.gd` arrow mode: each left-click on the playfield appends a point to `in_progress_points: PackedVector2Array`. Draw a preview line from each point to the next, and from the last point to the cursor.
  - *Verify:* Clicking 3 times produces a visible 3-point preview polygon in progress.

- [ ] **15.2** `polygon_tool.gd` scissors mode: clicking near any segment of an in-progress polygon inserts a new midpoint corner between its two endpoints.
  - *Verify:* Clicking near a segment adds a new draggable corner at the midpoint.

- [ ] **15.3** `polygon_tool.gd` hammer mode: clicking closes the polygon — connects the last point back to the first, creates a `polygon_wall` instance with those points, adds it to the playfield.
  - *Verify:* Clicking hammer with 3+ points creates a filled polygon visible on the playfield.

---

## Phase 16 — Magnifier + Paint Tools

Branch: `phase-16-magnifier-paint`

- [ ] **16.1** `paint_tool.gd` magnifier mode: clicking the Magnifier icon opens a `SubViewport` panel showing 8× zoom of the playfield center.
  - *Verify:* Magnifier panel opens showing a zoomed view of the playfield.

- [ ] **16.2** Freehand mouse drawing in the magnifier panel writes to an `Image` / `ImageTexture` that is drawn on the playfield below all parts.
  - *Verify:* Drawing in the magnifier panel produces visible brush strokes on the playfield.

- [ ] **16.3** The painted texture is serialized as a base64-encoded PNG string in `TableData` and restored on load.
  - *Verify:* Save a table with painting; reload — painting is restored.

---

## Phase 17 — Export

Branch: `phase-17-export`

- [ ] **17.1** Define the export schema (separate from the internal `.pcs` schema) in `docs/SCHEMA.md`. The export format is a stable, versioned superset of the save format with documented semantics for external consumers.
  - *Verify:* `docs/SCHEMA.md` has a dedicated Export section with all field definitions and examples.

- [ ] **17.2** Add an Export button to the Disk tool panel. On press: serialize the table to the export format, write to a user-chosen path (`.pcs_export` extension).
  - *Verify:* Export produces a valid JSON file matching the export schema.

---

## Phase 18 — Windows Export + itch.io

Branch: `phase-18-export-windows`

- [ ] **18.1** Add Windows export template in Godot export settings. Configure app name and version.
  - *Verify:* Export produces a runnable `.exe` (test in VM or secondary machine).

- [ ] **18.2** Create itch.io page with macOS and Windows zips.
  - *Verify:* Both builds downloadable and launchable from itch.io page.
