# Personal Notes Capture GPT Implementation

This guide specifies the private ChatGPT custom GPT used by the [POC](poc.md). It does not create the GPT, backend, GitHub App, or any credentials.

## Purpose

`Personal Notes Capture` accepts one short, dictated message beginning with `Log this:`. It forwards the text to the capture backend, which classifies it with a low-cost model and opens a pull request in `parjanay/personal-notes`.

The GPT does not decide the category itself, write to GitHub directly, or handle long brainstorming conversations.

## Configuration summary

| GPT editor field | Value |
| --- | --- |
| Name | `Personal Notes Capture` |
| Visibility | Private / only me |
| Description | Capture one short thought into my personal-notes repository by saying `Log this:`. |
| Conversation starter | `Log this: I learned something useful about TypeScript callbacks.` |
| Apps | Do not enable apps. |
| Actions | Enable one custom Action: `captureNote`. |
| Web search, image generation, Canvas, data analysis | Disable unless a later use case specifically needs them. |

A GPT can use either apps or Actions, not both. This design uses an Action because it must call the dedicated capture backend. [Official OpenAI Actions documentation](https://help.openai.com/en/articles/9442513-gpt-actions-domain-settings-chatgpt-enterprise)

## GPT instructions

Paste the following into the GPT **Instructions** field:

```text
You are Personal Notes Capture, a private assistant for short personal-note captures.

Only take an external action when the user's entire message begins with the exact marker "Log this:".

For a valid capture:
1. Treat all text after "Log this:" as one short capture.
2. Do not ask the user to identify it as a learning topic, gotcha, epiphany, or project idea.
3. Do not classify, rewrite, or summarize the capture yourself before calling the action.
4. Call captureNote exactly once with the text after the marker.
5. After a successful response, say only: "Captured as <classification>. Review: <pullRequestUrl>".
6. If the response says needsClassificationReview is true, add: "It was placed in gotchas for review."

For a message without the marker, reply: "Start a short capture with: Log this: <your thought>". Do not call the action.

For "Log this:" with no meaningful text, ask the user to dictate one short thought after the marker. Do not call the action.

Never expose API keys, backend details, GitHub credentials, raw action responses, or internal errors. Never claim that a pull request was created unless captureNote returned a pullRequestUrl.
```

## Action design

The GPT uses one Action only.

| Field | Value |
| --- | --- |
| Action name | `captureNote` |
| Method | `POST` |
| Path | `/captures` |
| Production server | `https://YOUR-CAPTURE-BACKEND.example.com` |
| Authentication | API key, sent as a bearer token to the backend |

Use the GPT editor's API-key authentication option. The bearer token authorizes ChatGPT to call the capture backend; it is not an OpenAI API key or GitHub credential. The backend holds the GitHub App credentials and any OpenAI API key. OpenAI documents API-key authentication as the server-to-server option for GPT Actions. [Official OpenAI Actions documentation](https://help.openai.com/en/articles/9442513-gpt-actions-domain-settings-chatgpt-enterprise)

### OpenAPI schema template

Replace the placeholder server URL only after the backend is deployed over HTTPS.

```yaml
openapi: 3.1.0
info:
  title: Personal Notes Capture API
  version: 1.0.0
servers:
  - url: https://YOUR-CAPTURE-BACKEND.example.com
paths:
  /captures:
    post:
      operationId: captureNote
      summary: Classify one short capture and open a GitHub pull request
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              additionalProperties: false
              required: [captureText]
              properties:
                captureText:
                  type: string
                  minLength: 1
                  maxLength: 2000
                  description: The text after the Log this marker.
      responses:
        '201':
          description: Pull request created
          content:
            application/json:
              schema:
                type: object
                additionalProperties: false
                required: [status, classification, confidence, needsClassificationReview, pullRequestUrl]
                properties:
                  status:
                    type: string
                    enum: [created]
                  classification:
                    type: string
                    enum: [learning_topic, gotcha_epiphany, project_idea]
                  confidence:
                    type: number
                    minimum: 0
                    maximum: 1
                  needsClassificationReview:
                    type: boolean
                  pullRequestUrl:
                    type: string
                    format: uri
        '400':
          description: Invalid capture text
        '401':
          description: Invalid action credential
        '500':
          description: Capture could not be processed
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
```

## Backend response rules

The backend must return only the fields declared in the schema. The intended responses are:

| Situation | `classification` | `needsClassificationReview` | GitHub result |
| --- | --- | --- | --- |
| Clear learning topic | `learning_topic` | `false` | PR appends to `STUDY.md` |
| Clear gotcha or epiphany | `gotcha_epiphany` | `false` | PR appends to `gotchas/README.md` |
| Clear project idea | `project_idea` | `false` | PR appends to `IDEAS.md` |
| Low confidence | `gotcha_epiphany` | `true` | PR appends to `gotchas/README.md` and asks for review |

## Editor setup steps

1. On ChatGPT web, open **My GPTs** and select **Create** or edit your existing private GPT.
2. Set the name, description, visibility, and conversation starter from the configuration summary.
3. Paste the GPT instructions exactly, then adjust wording only if the action behavior remains unchanged.
4. In **Actions**, select **Create new action** and paste the OpenAPI schema.
5. Set authentication to API key / bearer and enter the backend action token after the backend exists.
6. Save the GPT as private.
7. Use the editor Preview to complete the tests below before opening it on the phone.

The schema tells ChatGPT the endpoint, operation ID, inputs, and expected outputs. OpenAI recommends testing Actions in Preview after configuration. [Official OpenAI Actions documentation](https://help.openai.com/en/articles/9442513-gpt-actions-domain-settings-chatgpt-enterprise)

## Preview tests

Run these after the backend is available:

| Prompt | Expected result |
| --- | --- |
| `What should I learn next?` | No Action call; reminder to start with `Log this:`. |
| `Log this:` | No Action call; ask for one short thought. |
| `Log this: Learn Rust ownership before I build a CLI.` | One Action call and a learning-topic PR. |
| `Log this: This callback narrows the TypeScript variable only inside its body.` | One Action call and a gotchas PR. |
| `Log this: A small app could turn saved articles into recall prompts.` | One Action call and a project-idea PR. |
| `Log this: I should think about that later.` | One Action call; gotchas PR marked for classification review. |

## Security and privacy checklist

- [ ] Keep the GPT private.
- [ ] Use a distinct bearer token for this one Action.
- [ ] Store the GitHub App secret and OpenAI API key only in the backend secret manager.
- [ ] Limit the GitHub App to `parjanay/personal-notes`.
- [ ] Open pull requests only; never commit directly to `main`.
- [ ] Do not send raw audio or full ChatGPT conversation history to the backend.
- [ ] Rotate the Action token immediately if it is exposed.

## Mobile use after setup

1. Long press the Samsung side button to open ChatGPT.
2. Open `Personal Notes Capture` from My GPTs.
3. Stay in text mode and use Android keyboard dictation.
4. Dictate one short message beginning with `Log this:`.
5. Open the returned PR and review it before merging.
