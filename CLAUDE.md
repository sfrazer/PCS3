# PCS3 — Always-On Rules

Read this file at the start of every session. It contains rules that apply to every task.
For detail on any topic, see the referenced document in `docs/`.

---

## What We're Building

A Godot 4 recreation of Bill Budge's 1983 Pinball Construction Set with modern vector visuals.
Two modes: **Make Game** (drag-and-drop editor) and **Play Game** (live ball physics).
Win condition for this build: open the editor, place parts, have it look like a real pinball table.
All part behavior is derived from `docs/InitialPlan.md` and the source manual — never assumed.

---

## GDScript Conventions

- **Always use static typing.** Declare all variable types explicitly.
- **Script section order** — follow this in every script, every time:
  1. signals
  2. enums
  3. constants
  4. `@export` vars
  5. regular vars
  6. `@onready` vars
  7. built-in overrides (`_ready`, `_process`, `_input`, `_draw`, …)
  8. public functions
  9. private functions (prefix with `_`)
- Use `@onready` for all node references.

---

## Critical Design Rules

1. **No physics in editor mode.** Physics nodes are never active during Phases 0–7. Each part implements `activate_physics()` / `deactivate_physics()`. Do not add `RigidBody2D`, active `StaticBody2D`, or monitoring `Area2D` nodes during editor phases.

2. **Never use `scale.x = -1` for mirroring.** This silently breaks Area2D, collision shapes, and raycasts in all children. For the right flipper and any mirrored part: use `Sprite2D.flip_h = true` for the visual and explicitly reposition the collision shape.

3. **Use `offset` not `position` for sprite alignment.** `position` is physics truth and is inherited by all children. `offset` only moves the texture.

4. **No top-level `preload` in long-lived nodes.** The editor, playfield, and parts panel are never freed. Use `load()` per-instance so assets are freed with the node that owns them.

5. **Save schema is versioned; part type strings never change.** Every `.pcs` file has a `"version"` field. Part types are identified by stable string keys (`"bumper"`, `"flipper_left"`, etc.) that are permanent — never rename them. See `docs/SCHEMA.md`.

---

## Git Rules

- **Never commit directly to `main`.** All work on feature branches.
- **Branch naming:** `phase-X-description` (e.g. `phase-1-scaffold`).
- **Commit when** something works that didn't before, or before attempting something experimental.
- **Pre-PR checklist** (see `docs/Claude-git-workflow.md` for full detail):
  1. Run full GUT test suite — all tests must pass
  2. Run Ollama code review; save output to `docs/codereviews/<name>.md`
  3. Address findings
  4. Only then open the PR

---

## Task Discipline

- Tasks are **sub-feature level**: one output, one verification step. Never combine tasks.
- Always cite the relevant `docs/BuildPlan.md` task ID in the task description.
- Never make architectural decisions inside a task — those are settled in `docs/ArchitecturePlan.md`.
- If something seems wrong with the plan, stop and discuss rather than improvising.

---

## Key Reference Documents

| Need | Read |
|---|---|
| What are we building? | `docs/InitialPlan.md` |
| What task is next? | `docs/BuildPlan.md` |
| How does this system work? | `docs/ArchitecturePlan.md` |
| What parts exist and how do they behave? | `docs/InitialPlan.md` → Parts inventory |
| Save file format | `docs/SCHEMA.md` |
| Full git / PR workflow | `docs/Claude-git-workflow.md` |
| GUT testing commands and gotchas | `docs/claude-godot-generic.md` |
