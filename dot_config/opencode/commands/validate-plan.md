---
description: Validate implementation against plan, verify success criteria, identify issues
agent: plan
model: github-copilot/claude-opus-4.5
subtask: false
---

# Validate Plan

You are tasked with validating that an implementation plan was correctly executed, verifying all success criteria and identifying any deviations or issues.

## Initial Setup

When invoked:

1. **Context** - Are you in an existing conversation or starting fresh?
   - If existing: review what was implemented in this session.
   - If fresh: discover what was done through git and codebase analysis.

2. **Plan location**:
   - If a plan path is provided, use it.
   - Otherwise, list `.agents/plans/` or search recent commits for plan references, then ask the user.

3. **Implementation evidence**:

   ```bash
   # Check recent commits
   git log --oneline -n 20
   git diff HEAD~N..HEAD  # Where N covers implementation commits

   # Run comprehensive checks (from repo root) per repo instructions, for example:
   dotnet test
   npm test
   make check test
   ```

   - Use **explore** to find WHERE planned changes live.
   - Use **code-analyzer** to explain HOW the implemented changes work.

## Validation Process

### Step 1: Context Discovery

If starting fresh or needing more context:

1. **Read the implementation plan** completely.
2. **Identify what should have changed**:
   - List all files that should be modified.
   - Note all success criteria (automated and manual).
   - Identify key functionality to verify.

3. **Spawn parallel research tasks** to discover implementation:

   ```
   Task 1 - Verify database changes:
   Use explore to locate migrations/schema changes.
   Use code-analyzer to summarize what changed and where.
   Return: What was implemented vs what the plan specified.

   Task 2 - Verify code changes:
   Find all modified files related to [feature].
   Compare actual changes to plan specifications.
   Return: File-by-file comparison of planned vs actual.

   Task 3 - Verify test coverage:
   Check if tests were added/modified as specified.
   Run test commands and capture results.
   Return: Test status and any missing coverage.
   ```

### Step 2: Systematic Validation

For each phase in the plan:

1. **Completion status**:
   - Look for checkmarks in the plan (`- [x]`).
   - Verify the actual code matches claimed completion.

2. **Automated verification**:
   - Execute each command from "Automated Verification".
   - Document pass/fail status.
   - If failures occur, document the failure and context.

3. **Manual criteria**:
   - List what needs manual testing.
   - Provide clear steps for user verification.

4. **Edge cases**:
   - Were error conditions handled?
   - Are there missing validations?
   - Could the implementation break existing functionality?

### Step 3: Generate Validation Report

Create comprehensive validation summary:

```markdown
## Validation Report: [Plan Name]

### Implementation Status

✓ Phase 1: [Name] - Fully implemented
✓ Phase 2: [Name] - Fully implemented
⚠️ Phase 3: [Name] - Partially implemented (see issues)

### Automated Verification Results

✓ Build passes (per repo instructions; e.g., `dotnet build`, `npm run build`, or `make build`)
✓ Tests pass (per repo instructions; e.g., `dotnet test`, `npm test`, or `make test`)
✗ Linting issues (per repo instructions; e.g., `dotnet format`, `npm run lint`, or `make lint`) (3 warnings)

### Code Review Findings

#### Matches Plan:

- Database migration correctly adds [table]
- API endpoints implement specified methods
- Error handling follows plan

#### Deviations from Plan:

- Used different variable names in [file:line]
- Added extra validation in [file:line] (improvement)

#### Potential Issues:

- Missing index on foreign key could impact performance
- No rollback handling in migration

### Manual Testing Required:

1. UI functionality:
   - [ ] Verify [feature] appears correctly
   - [ ] Test error states with invalid input

2. Integration:
   - [ ] Confirm works with existing [component]
   - [ ] Check performance with large datasets

### Recommendations:

- Address linting warnings before merge
- Consider adding integration test for [scenario]
- Document new API endpoints
```

## Working With Existing Context

If you were part of the implementation:

- Review the conversation history.
- Check your todo list for what was completed.
- Focus validation on work done in this session.
- Be honest about any shortcuts or incomplete items.

## Important Guidelines

1. **Be thorough but practical** - focus on what matters.
2. **Run all automated checks** - do not skip verification commands.
3. **Document everything** - both successes and issues.
4. **Think critically** - question if the implementation truly solves the problem.
5. **Consider maintenance** - will this be maintainable long-term?

## Validation Checklist

Always verify:

- [ ] All phases marked complete are actually done
- [ ] Automated tests pass
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] Documentation updated if needed
- [ ] Manual test steps are clear

## Relationship to Other Commands

Recommended workflow:

1. `/implement-plan` - Execute the implementation
2. `/validate-plan` - Verify implementation correctness

The validation works best after commits are made, as it can analyze the git history to understand what was implemented.

Remember: good validation catches issues before they reach production. Be constructive but thorough in identifying gaps or improvements.
