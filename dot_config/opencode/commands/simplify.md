---
description: Simplify recent code changes with strict behavior preservation
model: openai/gpt-5.2-codex
subtask: false
---

# Simplify Code

You are tasked with orchestrating a focused simplification pass using a build subagent guided by the `code-simplifier` skill. The goal is to reduce complexity without changing behavior or public contracts.

## Inputs

Capture these from the user invocation when available:

- **File:line ranges** (optional): e.g., `src/foo.ts:10-40` or `src/foo.ts:22`.
- **Change summary** (short, 1-2 sentences): what the recent code change was for.
- **Non-negotiables**: explicit directions that the user requested and must not be removed or altered.

If any of these are missing, infer what you can from the user prompt. Only ask the user if you cannot reasonably infer intent.

## Behavior

- Do not analyze diffs or determine scope here. The subagent and skill handle change detection and scope order.
- Launch a build subagent using the `code-simplifier` skill and pass the captured inputs.
- Wait for subagent completion and present results concisely with file references.

## Subagent Prompt Template

```
You are a subagent using the code-simplifier skill.

Change summary:
<summary>

Non-negotiables:
<list or "none provided">

Target ranges (start here):
<file:line ranges or "none provided">

Instructions:
- Preserve exact behavior, outputs, and side effects.
- Do not change public or exported contracts.
- Only fix clear simplicity violations; if unsure, make no changes.
- Follow the code-simplifier skill for scope order and change detection.
- Report either the minimal changes made with file:line references, or report no changes.
```
