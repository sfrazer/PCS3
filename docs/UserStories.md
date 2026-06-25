# User Stories — Pinball Construction Set

Priority tiers:
- **P0** — required for the win condition (visual editor milestone)
- **P1** — required for a complete editor experience
- **P2** — required for a complete play experience
- **P3** — future / long-term

---

## P0 — Visual Editor (Win Condition)

**US-01** As a table designer, I want to see a recognisable visual representation of each part type in the palette so I can identify what I'm selecting without reading labels.

**US-02** As a table designer, I want to hover over a palette icon and see the part's name, default score, and a one-line description in the info panel so I know what it does before placing it.

**US-03** As a table designer, I want to click a part in the palette and have it follow my cursor so I can position it before committing to placement.

**US-04** As a table designer, I want to click on the playfield to place the part I'm holding so it appears exactly where I clicked.

**US-05** As a table designer, I want to click on a placed part to pick it up and reposition it so I can adjust my layout without deleting and re-placing.

**US-06** As a table designer, I want to right-click a placed part to delete it so I can remove mistakes quickly.

**US-07** As a table designer, I want the playfield to have a clearly visible border so I can see the boundaries of the table.

---

## P1 — Complete Editor

**US-08** As a table designer, I want to choose a color from a picker and apply it to any placed part so I can customise the look of my table.

**US-09** As a table designer, I want to open a World Settings panel and adjust gravity, bounce, kick strength, and ball speed with sliders so I can tune how the ball will behave before entering play mode.

**US-10** As a table designer, I want to assign specific targets to an AND gate and set a bonus point value so the player earns a bonus when all assigned targets are hit in one ball.

**US-11** As a table designer, I want to draw a custom polygon wall by clicking corners on the playfield so I can create guide rails and barriers in any shape I need.

**US-12** As a table designer, I want to insert a corner into an existing polygon edge so I can refine a shape without starting over.

**US-13** As a table designer, I want to close a polygon by pressing the hammer tool so it becomes a solid shape on the playfield.

**US-14** As a table designer, I want to save my table to a named file so I can come back to it later.

**US-15** As a table designer, I want to load a previously saved table from a list of saved files so I can continue working on it.

**US-16** As a table designer, I want the table file to include a version number so future versions of the tool can detect and handle older files correctly.

---

## P2 — Play Mode

**US-17** As a player, I want to press the Play icon to switch from the editor to play mode so I can test my table without leaving the application.

**US-18** As a player, I want to hold Space to compress the plunger and release it to launch the ball so I can control launch power.

**US-19** As a player, I want to press Z to activate the left flipper and / to activate the right flipper so I can keep the ball in play.

**US-20** As a player, I want to see my current score displayed on screen so I know how I'm doing.

**US-21** As a player, I want the ball to bounce off bumpers with a pop and earn points so hitting bumpers feels rewarding.

**US-22** As a player, I want slingshots to kick the ball away sharply when the ball hits their active face so the ball moves unpredictably and excitingly.

**US-23** As a player, I want drop targets to fall when hit and reset at the start of each new ball so I have a reason to aim for them on every ball.

**US-24** As a player, I want to earn a bonus when I hit all targets in an AND gate group during one ball so completing the set feels like an achievement.

**US-25** As a player, I want the ball to drain at the bottom and be replaced with a new ball (up to 3 per game) so the game has a natural structure.

**US-26** As a player, I want to press Ctrl+R to restart the game so I can start a fresh run without going back to the editor.

**US-27** As a player, I want to press the editor icon (or equivalent) during play mode to return to the editor so I can iterate on the table design.

---

## P3 — Future

**US-28** As a table designer, I want to paint freehand pixel decorations on the board surface so I can add labels, art, and personality to my table.

**US-29** As a table designer, I want to zoom into a section of the board to paint fine detail so I have precise control over the decoration.

**US-30** As a developer, I want to export my table in a documented, versioned format so I can load it into a different Godot project that implements its own physics and rendering.

**US-31** As a player, I want spinners to spin and score points per rotation so there's a satisfying skill-shot mechanic.

**US-32** As a developer, I want to export a macOS and Windows build of my table as a standalone game so I can share it on itch.io.
