---
description: Generate comprehensive PR descriptions following repository templates
model: github-copilot/gemini-3-flash-preview
agent: plan
subtask: false
---

# Generate PR Description

You are tasked with generating a comprehensive pull request description following the repository's standard template.

## Steps to follow

1. **Read the PR description template**:
   - Use the repository's PR template if present.
   - If no template is present, use this default:

     ```md
     ## Summary

     {What problem's were solved, include ticket numbers if known}

     ## User Impact

     {What user impacting changes are there}

     ## Implementation Plan

     {Implementation plan followed with rational why backed by research}

     ## Decision Rationale (Optional)

     {Only include if there are decisions that might raise questions; explain the rationale}

     ## Testing

     ### Automated Testing

     {List of test cases added/updated/removed with summary of change and rational}

     ### Manual Testing

     {What manual testing was performed}
     ```

   - Read the template carefully to understand all sections and requirements.

2. **Identify the PR to describe**:
   - Check if the current branch has an associated PR: `gh pr view --json url,number,title,state 2>/dev/null`.
   - If no PR exists for the current branch, or if on main/master:
     - List open PRs: `gh pr list --limit 10 --json number,title,headRefName,author`.
     - Ask the user whether to describe an existing PR or create a new PR.
   - Keep the human in the loop for PR selection.

3. **Check for existing description**:
   - Fetch the current PR body: `gh pr view {number} --json body`.
   - Review what has changed since the last description was written.

4. **Gather comprehensive PR information**:
   - Get the full PR diff: `gh pr diff {number}`.
   - If you get an error about no default remote repository, instruct the user to run `gh repo set-default` and select the appropriate repository.
   - Get commit history: `gh pr view {number} --json commits`.
   - Review the base branch: `gh pr view {number} --json baseRefName`.
   - Get PR metadata: `gh pr view {number} --json url,title,number,state`.

5. **Analyze the changes thoroughly**:
   - Read through the entire diff carefully.
   - For context, read any files that are referenced but not shown in the diff.
   - Understand the purpose and impact of each change.
   - Identify user-facing changes vs internal implementation details.
   - Look for breaking changes or migration requirements.

6. **Handle verification requirements**:
   - Look for any checklist items in the "How to verify it" section of the template.
   - For each verification step:
- If it's a command you can run (like `dotnet test`, `npm test`, or `make check test`), run it.
     - If it passes, mark the checkbox as checked: `- [x]`.
     - If it fails, keep it unchecked and note what failed: `- [ ]` with explanation.
     - If it requires manual testing (UI interactions, external services), leave unchecked and note for the user.
   - Document any verification steps you couldn't complete.

7. **Generate the description**:
   - Fill out each section from the template thoroughly.
   - Be specific about problems solved and changes made.
   - Focus on user impact where relevant.
   - Include technical details in appropriate sections.
   - Write a concise changelog entry.
   - Ensure all checklist items are addressed (checked or explained).

8. **Present the description**:
   - Show the user the generated description.

9. **Create a PR if needed**:
   - If the user wants a new PR, confirm the target branch and base branch.
   - Ensure the correct feature branch is checked out.
   - If the branch is not pushed, push it with upstream tracking.
   - Create the PR with `gh pr create` and the generated description.
   - After creation, re-run `gh pr view` to confirm the PR number and URL.

10. **Update the PR**:

- Update the PR description directly: `gh pr edit {number} --body "<description>"`.
- Confirm the update was successful.
- If any verification steps remain unchecked, remind the user to complete them before merging.

## Important Notes

- This command works across different repositories - always read the local template.
- Be thorough but concise - descriptions should be scannable.
- Focus on the "why" as much as the "what".
- Include any breaking changes or migration notes prominently.
- If the PR touches multiple components, organize the description accordingly.
- Always attempt to run verification commands when possible.
- Clearly communicate which verification steps need manual testing.
