# Dedicated Android Application

Build this only after the [POC](poc.md) proves useful in everyday use.

## Intended interaction

```mermaid
flowchart TD
    A[Tap Learning Tracker in lock-screen Quick Corner] --> B[Android app opens]
    B --> C[Record one voice capture]
    C --> D[Save local capture file first]
    D --> E[Transcribe and classify]
    E --> F{Capture kind}
    F --> G[Learning topic]
    F --> H[Gotcha or epiphany]
    F --> I[Project idea]
    G --> J[Create repository Markdown change]
    H --> J
    I --> J
    J --> K[Create GitHub pull request]
    K --> L[Mark local capture as synced]
    K --> M{Sync failed?}
    M -- Yes --> N[Keep local capture and retry]
```

## Local-first record

Before contacting a model or GitHub, save each capture in app-private storage:

```text
captures/
└── 2026-09-09T10-15-30Z-uuid.json
```

Each record contains the capture ID, timestamp, cleaned transcript, inferred type and confidence, Markdown payload, sync state (`pending`, `synced`, or `failed`), and GitHub pull-request URL after sync. Failed captures remain queued for retry.

The Android app contains no OpenAI or GitHub credentials. A backend owns transcription, classification, validation, GitHub authentication, and serialized repository writes.

## Synchronization rule

Start with pull requests as in the POC. A future opt-in auto-commit mode may be considered only after consistently correct, non-sensitive captures have been demonstrated.

## App-specific open questions

- How long should the app retain synced local capture files?
- What accuracy and weekly usage threshold should trigger the dedicated-app build?
- Should synced local captures be deleted automatically, archived locally, or exported by the user?
- What authentication method should protect the phone-to-backend connection?
- Should low-confidence captures use the same gotchas default as the POC, or first remain in a local review queue?
