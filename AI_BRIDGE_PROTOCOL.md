# AI BRIDGE PROTOCOL — TECH LEARNING HUB

This repository is worked on by more than one AI/session/computer.

## Core rule
AI_HANDOFF.txt is the bridge.

## Start
The user tells the AI:
"Read AI_HANDOFF.txt first and continue from there."

The AI then checks:
- git status
- git log -5 --oneline
- only the files related to the requested task

## During work
Do not scan the whole repository unless necessary.
Do not re-create features already documented in AI_HANDOFF.txt.
Do not overwrite unrelated work.

## End
Before ending a meaningful session, the AI updates AI_HANDOFF.txt with:
- current HEAD
- changes
- files
- DB changes
- tests
- pending items
- decisions/warnings

Then commit and push.

## Recommended closing commit message
docs: update AI handoff after <task>

or include AI_HANDOFF.txt in the same feature commit when appropriate.

## Token-saving principle
Git is the detailed history.
AI_HANDOFF.txt is the compact state.
PROJECT_REFERENCE.md is deeper architecture.
Only open source files directly needed for the current task.
