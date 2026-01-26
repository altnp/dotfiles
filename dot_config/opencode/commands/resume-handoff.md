---
description: Resume work from handoff document with context analysis and validation
agent: plan
model: github-copilot/gemini-3-flash-preview
subtask: false
---

# Resume Work From a Handoff Document

You are tasked with resuming work from a handoff document through an interactive process. These handoffs contain critical context, learnings, and next steps from previous work sessions that need to be understood and continued.

## Initial Response

When this command is invoked:

1. **If a handoff document path was provided**:
   - Skip the default message.
   - Immediately read the handoff document fully.
   - Immediately read any research or plan documents it links to under `.agents/plans/` or `.agents/research/`.
   - Do NOT use a sub-agent to read these critical files.
   - Begin the analysis process by ingesting relevant context from the handoff document and reading additional files it mentions.
   - Then propose a course of action to the user and confirm, or ask for clarification on direction.

2. **If a ticket identifier (e.g., Jira/Linear) or slug was provided**:
   - Locate the most recent matching handoff under `.agents/handoffs/`.
   - Handoffs are stored as `<slug>-YYYY-MM-DD_HH-MM-SS.md`.
   - **IMPORTANT**: List the directory contents before selecting a file.
   - There may be zero, one, or multiple files.
   - If there are zero files or the directory does not exist, tell the user: "I can't find that handoff document. Please provide a path to it."
   - If there is only one match, proceed with that handoff.
   - If there are multiple matches, use the most recent by date/time in the filename.
   - Immediately read the handoff document fully.
   - Immediately read any research or plan documents it links to under `.agents/plans/` or `.agents/research/`.
   - Do NOT use a sub-agent to read these critical files.
   - Begin the analysis process by ingesting relevant context from the handoff document and reading additional files it mentions.
   - Then propose a course of action to the user and confirm, or ask for clarification on direction.

3. **If no parameters provided**, respond with:

```
I'll help you resume work from a handoff document. Let me find the available handoffs.

Which handoff would you like to resume from?

Tip: You can invoke this command directly with a handoff path:
/resume-handoff .agents/handoffs/<slug>-YYYY-MM-DD_HH-MM-SS.md

Or use a ticket/slug to resume from the most recent matching handoff:
/resume-handoff <ticket-or-slug>
```

Use the question tool to provide the user a quick select of the three most recent handoff documents. Only show the latest document per slug.

## Process Steps

### Step 1: Read and Analyze Handoff

1. **Read handoff document completely**:
   - **IMPORTANT**: Use the Read tool without limit/offset parameters.
   - Extract all sections:
     - Task(s) and their statuses
     - Recent changes
     - Learnings
     - Artifacts
     - Action items and next steps
     - Other notes

2. **Spawn focused research tasks**:
   - Based on the handoff content, spawn parallel research tasks to verify current state.
   - Use **explore** to find WHERE relevant files and components live.
   - Use **code-analyzer** to explain HOW key paths work.

   ```
   Task 1 - Gather artifact context:
   Read all artifacts mentioned in the handoff.
   1. Read feature documents listed in "Artifacts"
   2. Read implementation plans referenced
   3. Read any research documents mentioned
   4. Extract key requirements and decisions
   Use tools: Read
   Return: Summary of artifact contents and key decisions
   ```

3. **Wait for ALL sub-tasks to complete** before proceeding.

4. **Read critical files identified**:
   - Read files from "Learnings" completely.
   - Read files from "Recent changes" to understand modifications.
   - Read any new related files discovered during research.

### Step 2: Synthesize and Present Analysis

1. **Present comprehensive analysis**:

   ```
   I've analyzed the handoff from [date] by [author]. Here's the current situation:

   **Original Tasks:**
   - [Task 1]: [Status from handoff] -> [Current verification]
   - [Task 2]: [Status from handoff] -> [Current verification]

   **Key Learnings Validated:**
   - [Learning with file:line reference] - [Still valid/Changed]
   - [Pattern discovered] - [Still applicable/Modified]

   **Recent Changes Status:**
   - [Change 1] - [Verified present/Missing/Modified]
   - [Change 2] - [Verified present/Missing/Modified]

   **Artifacts Reviewed:**
   - [Document 1]: [Key takeaway]
   - [Document 2]: [Key takeaway]

   **Recommended Next Actions:**
   Based on the handoff's action items and current state:
   1. [Most logical next step based on handoff]
   2. [Second priority action]
   3. [Additional tasks discovered]

   **Potential Issues Identified:**
   - [Any conflicts or regressions found]
   - [Missing dependencies or broken code]

   Shall I proceed with [recommended action 1], or would you like to adjust the approach?
   ```

2. **Get confirmation** before proceeding.

### Step 3: Create Action Plan

1. **Use TodoWrite to create task list**:
   - Convert action items from the handoff into todos.
   - Add any new tasks discovered during analysis.
   - Prioritize based on dependencies and handoff guidance.

2. **Present the plan**:

   ```
   I've created a task list based on the handoff and current analysis:

   [Show todo list]

   Ready to begin with the first task: [task description]?
   ```

### Step 4: Begin Implementation

1. **Start with the first approved task**.
2. **Reference learnings from the handoff** throughout implementation.
3. **Apply patterns and approaches documented** in the handoff.
4. **Update progress** as tasks are completed.

## Guidelines

1. **Be Thorough in Analysis**:
   - Read the entire handoff document first.
   - Verify ALL mentioned changes still exist.
   - Check for regressions or conflicts.
   - Read all referenced artifacts.

2. **Be Interactive**:
   - Present findings before starting work.
   - Get buy-in on the approach.
   - Allow course corrections.
   - Adapt based on current state vs handoff state.

3. **Leverage Handoff Wisdom**:
   - Pay special attention to the "Learnings" section.
   - Apply documented patterns and approaches.
   - Avoid repeating mistakes mentioned.
   - Build on discovered solutions.

4. **Track Continuity**:
   - Use TodoWrite to maintain task continuity.
   - Reference the handoff document in commits.
   - Document deviations from original plan.
   - Consider creating a new handoff when done.

5. **Validate Before Acting**:
   - Never assume handoff state matches current state.
   - Verify all file references still exist.
   - Check for breaking changes since handoff.
   - Confirm patterns are still valid.

## Common Scenarios

### Scenario 1: Clean Continuation

- All changes from handoff are present
- No conflicts or regressions
- Clear next steps in action items
- Proceed with recommended actions

### Scenario 2: Diverged Codebase

- Some changes missing or modified
- New related code added since handoff
- Need to reconcile differences
- Adapt plan based on current state

### Scenario 3: Incomplete Handoff Work

- Tasks marked as "in_progress" in handoff
- Need to complete unfinished work first
- May need to re-understand partial implementations
- Focus on completing before new work

### Scenario 4: Stale Handoff

- Significant time has passed
- Major refactoring has occurred
- Original approach may no longer apply
- Need to re-evaluate strategy

## Example Interaction Flow

```
User: /resume-handoff .agents/handoffs/handoff-0-2026-01-25_13-55-22.md
Assistant: Let me read and analyze that handoff document...

[Reads handoff completely]
[Spawns research tasks]
[Waits for completion]
[Reads identified files]

I've analyzed the handoff from [date]. Here's the current situation...

[Presents analysis]

Shall I proceed with implementing the webhook validation fix, or would you like to adjust the approach?

User: Yes, proceed with the webhook validation
Assistant: [Creates todo list and begins implementation]
```
