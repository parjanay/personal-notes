# Mobile Interface

~~The Learning Tracker mobile work has two stages:~~

1. ~~[ChatGPT capture POC](poc.md) - test one short, voice-originated capture at a time.~~ **Cancelled.**
2. ~~[Dedicated Android application](dedicated-app.md) - build only after the POC proves useful.~~

## Current strategy

Build the [native Android application](dedicated-app.md) now. It will own voice capture and local-first storage, then use a backend for transcription, classification, repository writes, and GitHub pull-request creation. The phone must not require the user to declare whether a capture is a learning topic, gotcha, or project idea.

The ChatGPT POC documents remain as historical context only; no POC task should be implemented.

No double-press shortcut is part of either stage.
