
Preparing Pi...
Checking Pi installation...
Checking Pi web search package...

Launching Pi...

I've reviewed the Phase 1 scaffold against `CLAUDE.md`, `docs/BuildPlan.md`, `docs/ArchitecturePlan.md`, and `docs/Claude-Godot-Generic.md`, and verified the Godot-specific concerns against the official docs. Findings below, ordered by severity.

## 🔴 Bugs (functionality broken)

### 1. `godot_screenshot.sh` uses a non-existent CLI flag — scene selection never works
`source/debug/tests/godot_screenshot.sh`
```bash
ARGS+=("--main-scene" "$SCENE")
```
There is no `--main-scene` flag in Godot 4. Per the command-line reference, the valid option is `--scene <path>` (or pass the scene as a positional arg). Godot silently ignores unknown flags, so the script always runs the project's default main scene regardless of the `scene_path` argument. This defeats the entire purpose of the per-scene screenshot workflow used by tasks 1.5–1.6.
**Fix:** `ARGS+=("--scene" "$SCENE")`

### 2. `run/max_fps=60` is in the wrong section — FPS cap isn't applied
`project.godot`
```ini
[rendering]
renderer/rendering_method="gl_compatibility"
...
run/max_fps=60
```
The FPS cap project setting lives at `application/run/max_fps` (confirmed in the ProjectSettings reference). Placed under `[rendering]`, the key `run/max_fps` is unrecognized, so the cap silently does nothing — task 1.1's "FPS cap 60" requirement is unmet.
**Fix:** move it to `[application]` as `run/max_fps=60` (i.e. full key `application/run/max_fps`).

### 3. `process_mode = 1` does not match the "Always" requirement
`source/core/main.tscn` (root Main node) and the BuildPlan task 1.4 / Claude-Godot-Generic table both say root should be **Always**. In Godot 4 the enum is `PROCESS_MODE_ALWAYS = 3`; `1` is `PAUSABLE`. The scene currently sets:
```
process_mode = 1
```
**Fix:** `process_mode = 3`

## 🟠 Plan divergences (need an architect decision, not a silent deviation)

Per `CLAUDE.md` task discipline: *"Never make architectural decisions inside a task… If something seems wrong with the plan, stop and discuss rather than improvising."* The following look like unannounced deviations:

### 4. `main.tscn` and `playfield.tscn` roots are `Control`, not `Node2D`
- BuildPlan 1.4: *"`source/core/main.tscn` as a **Node2D** (MainGame)"*
- BuildPlan 1.5: *"`source/gameplay/construction/playfield.tscn` as a **Node2D**"*
- `ArchitecturePlan.md` also says `main.gd` "Owns the scene tree layer structure (World, HUD, Transition, Debug CanvasLayers)" — a CanvasLayer-based design, which is incompatible with a `Control` + `HBoxContainer` root.

Both `main.gd` and `playfield.gd` `extend Control`, and `main.tscn`/`playfield.tscn` are `Control` nodes. Using `Control` is arguably *more practical* here (an HBoxContainer can't anchor-fill under a Node2D), but it contradicts two plan documents. This needs to be raised with the plan owner and reconciled, not quietly shipped.

### 5. `playfield.gd` already implements Phase 4 input logic
`source/gameplay/construction/playfield.gd` declares `part_clicked`/`empty_clicked` signals and a `_gui_input` + `_part_at` hit-test — that's Phase 4 (hand tool) territory, not the Phase 1 visual scaffold (tasks 1.5–1.7 only ask for `_draw()` background + border). It also hardcodes a 40px-radius circle hit test as a placeholder:
```gdscript
if local.length() < 40.0:
    return child as Node2D
```
This pre-empts architecture (the plan says the playfield converts mouse→local and emits signals for the active *tool* to consume; it doesn't own hit-testing). Suggest removing the `_gui_input`/`_part_at`/signal stubs now and re-introducing them in Phase 4.

## 🟡 Convention / minor issues

### 6. `screenshot_helper.gd` violates script section order
`CLAUDE.md` requires: signals → enums → **constants** → @export → vars → @onready → built-ins → public → private. Here the var precedes the constant:
```gdscript
var _frames_waited: int = 0
const WAIT_FRAMES: int = 8
```
**Fix:** move `const WAIT_FRAMES` above `var _frames_waited`.

### 7. `main.gd` has dead/duplicated code
- `signal mode_changed(mode: String)` is emitted by `switch_to_play`/`switch_to_editor` but never connected anywhere.
- `switch_to_editor()` and `_enter_editor_mode()` are identical bodies; `_ready()` calls the private one while the public one duplicates it. Pick one. Also note `switch_to_play()`/`switch_to_editor()` don't actually hide/show the panel or instantiate a game scene — fine for a scaffold, but worth a `# TODO Phase 9` comment so it's not mistaken for complete behavior.

### 8. `playfield.tscn` redundantly sets `mouse_filter`
The scene sets `mouse_filter = 0` (STOP) and `_ready()` re-sets `mouse_filter = Control.MOUSE_FILTER_STOP`. Harmless but redundant — pick one (prefer keeping it in the scene and dropping the line in code, since CLAUDE.md favors declarative scene config).

### 9. `config/features` claims `4.7`
`PackedStringArray("4.7", "GL Compatibility")` — Godot 4.7 isn't a released version at time of writing. If this was written by the editor it's fine, but if hand-edited it may cause import warnings on teammates' editors. Worth verifying against the installed Godot.

## 🟢 Observations (not requiring change)

- `.gitignore` ignores `*.import`. With Git LFS configured for `*.png` (in `.gitattributes`), the Godot-recommended flow is to **commit** `.import` files so binary↔metadata pairing is stable across machines. Ignoring them risks "missing imported files" re-import churn on every clone. Confirm this is intentional.
- `_part_at` uses `child.to_local(pos + global_position)`. The math is correct for direct `Node2D` children, but it will break the moment parts are nested or the playfield is scaled — another reason to defer this code to Phase 4 where it belongs.
- `.DS_Store` is committed under `source/` despite `.gitignore` ignoring it (it was added before the ignore rule took effect for tracked files). `git rm --cached source/.DS_Store` would clean it up.

---

### Suggested fix priority
1. Fix #1 (`--scene` flag) and #2 (`application/run/max_fps`) — both directly break the Phase 1 verification steps.
2. Fix #3 (`process_mode = 3`).
3. Resolve #4/#5 with the plan owner before proceeding to Phase 2.
4. Clean up #6–#9.

Want me to apply fixes #1, #2, #3, #6, and #7 now (they're unambiguous) and leave #4/#5 for you to take to the architect?
