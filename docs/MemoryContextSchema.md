# Memory & Context Store Schema

This document defines what information lives where, when it is read, and who reads it. The goal is to ensure that critical rules and context survive context clears and are available to worker agents without requiring re-derivation.

---

## Read Hierarchy

| Priority | Document | Read when | Contains |
|---|---|---|---|
| Always | `CLAUDE.md` (project root) | Every session, automatically | Core rules, conventions, critical constraints |
| Always | `docs/InitialPlan.md` | Every session start | What we're building and why |
| Phase start | `docs/BuildPlan.md` | When beginning a task | Current phase, specific task definition |
| Implementation | `docs/ArchitecturePlan.md` | When building a specific system | Module responsibilities, data flow, constraints |
| PR time only | `docs/Claude-git-workflow.md` | Before opening any PR | Pre-PR checklist, branch rules, Ollama review |
| PR time only | GUT section of `docs/claude-godot-generic.md` | Before opening any PR | Test run commands, gotchas |
| Schema work | `docs/SCHEMA.md` | When touching save/load or export | `.pcs` format specification |

---

## CLAUDE.md (project root) — Always Read

This file is loaded automatically by Claude Code at every session start. It must be short enough to read in full every time. It contains only rules that apply to every task, not reference material.

**Contents:**
```
# PCS3 — Always-On Rules

## What we're building
[One paragraph: PCS recreation, two modes, editor-first, win condition]

## GDScript conventions
- Static typing always; section order: signals → enums → constants → @export → vars → @onready → overrides → public → private
- @onready for all node references

## Critical design rules (numbered, same as ArchitecturePlan.md)
1. No physics in editor mode (Phases 0–7)
2. Never scale.x = -1 for mirroring
3. Use offset not position for sprite alignment
4. No top-level preload in long-lived nodes
5. Save schema is versioned; part type strings never change

## Git basics
- Never commit to main
- Branch names: phase-X-description
- Commit when something works
- Pre-PR: run GUT, run Ollama review, save to docs/codereviews/
- See docs/Claude-git-workflow.md for full checklist

## Task discipline
- Tasks are sub-feature level: one output, one verification step
- Always cite the relevant plan section in the task description
- Never make architectural decisions inside a task — those are settled in ArchitecturePlan.md
```

---

## docs/ — Reference Documents

These are not read automatically. They are consulted when relevant.

| File | Purpose | When to read |
|---|---|---|
| `InitialPlan.md` | High-level plan, phase overview, verification milestones | Session start; when checking scope |
| `ProductBrief.md` | What the game is, success definition, non-negotiables | When a decision might change scope |
| `UserStories.md` | Prioritised player/designer actions (P0–P3) | When deciding whether a feature is in scope |
| `ArchitecturePlan.md` | Module boundaries, data flow, constraints | When implementing any system |
| `BuildPlan.md` | Granular task list, one task at a time | When starting a task; when checking what's next |
| `PlatformDelivery.md` | Platform targets, export, distribution | When touching export settings or platform-specific code |
| `SCHEMA.md` | `.pcs` file format specification | When touching save/load, export, or part serialization |
| `Claude-git-workflow.md` | Full git workflow, pre-PR checklist | Before opening a PR only |
| `claude-godot-generic.md` | Godot conventions, GUT testing details | When setting up testing; for gotcha reference |
| `codereviews/` | Ollama review outputs | After running Ollama review; when addressing findings |

---

## ~/.claude/projects/ Memory Files — Persistent Across Sessions

These are loaded by the memory system and persist across context clears. They supplement `CLAUDE.md` with information that is too detailed or too contextual to live in the always-read file.

| File | Type | Contains |
|---|---|---|
| `project_failure_modes.md` | project | Why previous attempts failed; the five fixes applied in this attempt |
| `project_future_goals.md` | project | Export feature goal; schema versioning rationale |

**What NOT to store in memory files:**
- Code patterns (derive from the code)
- Current task progress (use BuildPlan.md)
- Git history (use `git log`)
- Anything already in CLAUDE.md or docs/

---

## Worker Agent Briefing Pattern

When delegating a task to a worker agent, the briefing must include:

1. **Cite the task** from `docs/BuildPlan.md` by ID (e.g., "Task 3.2")
2. **State the one output** the task must produce
3. **State the verification step** (what to check to confirm it's done)
4. **Reference the relevant doc** (e.g., "see ArchitecturePlan.md §Part Data Flow")
5. **Repeat any constraints** from CLAUDE.md that apply to this task

Do not assume the worker agent has read any document. Quote the relevant rule directly in the briefing if it matters for this task.

---

## Information Decay

Project memory files become stale. Before acting on a memory:
- If it names a file path: confirm the file exists
- If it names a function: grep for it
- If it describes current work state: check `BuildPlan.md` for the current task

The code is always more authoritative than memory.
