# Project Seeds

A project seed is the working space for an idea that has moved beyond the inbox. Its parent folder shows its current stage:

- [`EXPLORING/`](EXPLORING/) holds active brainstorming and scope discovery.
- [`READY-TO-BUILD/`](READY-TO-BUILD/) holds finalized scopes awaiting handoff to Linear and a dedicated repository.

## Starting a seed

1. Remove the matching entry from [`IDEAS.md`](../IDEAS.md).
2. Create a lowercase, hyphenated folder under `EXPLORING/` named after the idea.
3. Add a `README.md` using the template below.
4. Add supporting Markdown files only when they make the discussion easier to navigate.

Suggested supporting files include `notes.md` for brain dumps, `research.md` for findings, and `decisions.md` for important choices. They are optional; start with only a `README.md`.

## Seed README template

````markdown
# Project name

## One-line summary

What the project may become.

## Problem

Who experiences the problem, what happens, and why it matters.

## Brain dump

Capture rough thoughts, questions, AI discussion summaries, and possible directions.

## Proposed scope

### In scope

- The smallest useful capabilities for the first version.

### Out of scope

- Capabilities intentionally deferred or rejected.

## Key decisions

- Record decisions and the reasoning behind them.

## Open questions

- List anything that still prevents the scope from being final.

## Build-readiness checklist

- [ ] The problem and intended user are clear.
- [ ] The first version has a concrete outcome.
- [ ] In-scope and out-of-scope boundaries are written down.
- [ ] Major assumptions and dependencies are identified.
- [ ] Important open questions are resolved.
- [ ] The work can be translated into Linear tickets.
- [ ] A dedicated repository name has been chosen.

## Handoff

- **Dedicated repository:** Not created
- **Linear project:** Not created
````

## Marking a seed ready

When every checklist item is complete, move the entire project folder from `EXPLORING/` to `READY-TO-BUILD/`. Its location is its status; no separate status label is needed. Then:

1. Create the project's dedicated GitHub repository.
2. Copy the finalized scope and essential decisions into that repository.
3. Give Linear the finalized scope and create the project and tickets there.
4. Verify the dedicated repository and Linear project both contain what is needed.
5. Remove the project folder from `READY-TO-BUILD/`.
6. Perform implementation and all subsequent product work in the dedicated repository.

The deleted seed remains available in this repository's Git history if its earlier thinking is ever needed.
