---
description: Create handoff document for transferring work to another session
agent: plan
model: openai/gpt-5.2-codex
subtask: false
---

# Create Handoff

You are tasked with writing a handoff document to hand off your work to another agent in a new session. You will create a handoff document that is thorough but **concise**. The goal is to compact and summarize your context without losing key details of what you're working on.

## Process

### 1. Filepath and Metadata

Create your file under:

```
.agents/handoffs/<slug>-YYYY-MM-DD_HH-MM-SS.md
```

- `slug` is a brief kebab-case description (include ticket if available).
- `YYYY-MM-DD` is today's date.
- `HH-MM-SS` is 24-hour time.

Examples:

- `eng-2166-some-feature-name-2025-01-08_13-55-22.md`
- `some-feature-name-2025-01-08_13-55-22.md`

### 2. Handoff Writing

Using the above conventions, write your document with the following YAML frontmatter pattern. Use the template structure below:

```markdown
---
date: [Current date and time with timezone in ISO format]
author: [Author name]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[Feature/Task Name] Implementation Strategy"
tags: [implementation, strategy, relevant-component-names]
status: complete
last_updated: [Current date in YYYY-MM-DD format]
last_updated_by: [Author name]
type: implementation_strategy
---

# Handoff: {very concise description}

## Task(s)

{Description of the task(s) you were working on, along with the status of each (completed, work in progress, planned/discussed). If you are working on an implementation plan, call out which phase you are on. Reference the plan document and/or research document(s) you were working from.}

## Critical References

{List any critical specification documents, architectural decisions, or design docs that must be followed. Include only 4-5 most important file paths. Leave blank if none.}

## Recent Changes

{Describe recent changes made to the codebase that you made using file:line references}

## Learnings

{Describe important learnings - patterns, root causes of bugs, or other important context. Include explicit file paths when helpful.}

## Artifacts

{An exhaustive list of artifacts you produced or updated as filepaths and/or file:line references - e.g. plans, research docs, specs.}

## Action Items and Next Steps

{A list of action items and next steps for the next agent to accomplish based on your tasks and their statuses}

## Other Notes

{Other notes, references, or useful information - e.g. relevant sections of the codebase, related documents, or other context}
```

### 3. Respond With Resume Command

Once complete, respond with:

```
Handoff created and saved. You can resume from this handoff with:

/resume-handoff .agents/handoffs/<slug>-YYYY-MM-DD_HH-MM-SS.md
```

Example:

```
Handoff created and saved. You can resume from this handoff with:

/resume-handoff .agents/handoffs/eng-2166-create-context-compaction-2025-01-08_13-55-22.md
```

## Additional Notes and Instructions

- **More information, not less**: this is a minimum bar; include more if it helps continuity.
- **Be thorough and precise**: include both top-level objectives and key details.
- **Avoid excessive code snippets**: prefer `/path/to/file.ext:line` references; include snippets only when necessary.
