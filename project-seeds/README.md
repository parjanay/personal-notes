# Project Seeds

A project seed is the working space for an idea that has moved beyond the inbox but is not ready for implementation. Use it for raw thinking, AI-assisted brainstorming, research, decisions, and scope refinement.

## Starting a seed

1. Create a lowercase, hyphenated folder named after the idea.
2. Add a `README.md` using the template below.
3. Update the matching entry in [`IDEAS.md`](../IDEAS.md) to `EXPLORING` and link it to the folder.
4. Add supporting Markdown files only when they make the discussion easier to navigate.

Suggested supporting files include `notes.md` for brain dumps, `research.md` for findings, and `decisions.md` for important choices. They are optional; start with only a `README.md`.

## Seed README template

````markdown
# Project name

**Status:** EXPLORING

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

When every checklist item is complete, change the status at the top of the seed README from `EXPLORING` to `READY TO BUILD`. Then:

1. Create the project's dedicated GitHub repository.
2. Add its URL under **Handoff**.
3. Give Linear the finalized seed and create the project and tickets there.
4. Add the Linear project URL under **Handoff**.
5. Perform implementation and all subsequent product work in the dedicated repository.

Keep the seed in this repository as the record of how the project was shaped.
