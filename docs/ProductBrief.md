# Product Brief — Pinball Construction Set (Godot 4)

## What It Is

A Godot 4 recreation of Bill Budge's 1983 *Pinball Construction Set* (originally published by Electronic Arts for Apple II). The game gives the player a drag-and-drop editor for building custom pinball tables, then lets them play the tables they create.

It has two modes:
- **Make Game (editor):** place, move, color, and configure pinball parts on a playfield
- **Play Game:** run the table with live ball physics and score tracking

The visual style is modern clean vectors — not a pixel-perfect Apple II port. The mechanics and part inventory are derived directly from the original manual.

---

## Who It's For

**Primary:** The developer (solo project, macOS). This is a personal creative tool first.

**Secondary:** If the editor experience feels right, a public release on itch.io targeting PC/Mac players who enjoy creative/construction games, retro game fans, and pinball enthusiasts.

---

## What Success Looks Like

**This build cycle:** Open the editor, drag parts onto the playfield, and have it look like a real pinball table. The rendering of parts must feel satisfying and recognisable before physics or play mode are built. A text-based prototype does not count.

**Full vision:** A functional construction set where a player can:
1. Build a custom pinball table from a palette of 13 part types
2. Tune physics (gravity, bounce, kick, ball speed)
3. Set up scoring and AND gate bonuses
4. Save and load tables
5. Play the table with working ball physics and score tracking
6. Export the table data for use in other Godot projects

---

## Core Loop

```
Open editor
  → drag parts from palette onto playfield
  → adjust colors, sizes, positions
  → configure world physics and AND gate bonuses
  → save table
  → press Play
  → play pinball on your own table
  → return to editor to iterate
```

---

## Non-Negotiable Day-One Features

These are required for the win condition of this build cycle:

1. All 13 part types render as recognisable vector shapes in the editor
2. Parts can be placed, moved, and deleted via drag-and-drop
3. The info panel shows part name and description on hover
4. The playfield has the correct visual border and proportions

Everything else (physics, scoring, save/load, bonus system) is additive once the editor looks right.

---

## Out of Scope (This Build)

- Web or mobile targets
- Multiplayer
- Sprite-based or pixel-art assets
- Sound design (stubs only in early phases)
- AI opponents or procedural content
- Online save/share

---

## Long-Term Goal

A stable, versioned export format so tables built in this tool can be loaded by other Godot projects. The `.pcs` save schema is versioned from day one to support this without a breaking migration.
