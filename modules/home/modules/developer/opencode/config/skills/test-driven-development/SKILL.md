---
name: test-driven-development
description: Drive implementation through a test list and Red-Green-Refactor loops
---
## What I do
- Drive implementation through test-first development instead of code-first guessing.
- Keep changes small, verifiable, and shaped by behavior.
- Use tests and checks as design feedback, not just regression coverage.

## When to use me
- Use this for new features, bug fixes, behavior changes, and refactors.
- Use this when you want the next implementation step to be driven by a failing test or verification step.
- For declarative or config-heavy work, use the smallest meaningful failing verification instead of forcing a shallow unit test.

## Start with a test list
- Write a short list of behaviors, examples, bug repros, and edge cases before the first cycle.
- Pick the next smallest test or check that drives the interface or design forward.
- Add newly discovered cases to the list as you learn.

## Core loop
1. Write one small failing test or verification for the next behavior.
2. Run it and confirm it fails for the expected reason.
3. Write the minimum production code or configuration needed to make it pass.
4. Re-run the focused test or verification, then run any broader checks needed to catch regressions.
5. Refactor code and tests while staying green.
6. Return to the test list and pick the next item.

## Per-cycle rules
- One behavior per cycle.
- Prefer testing real behavior over mock setup.
- Do not add behavior the current failing test did not require.
- If the test is hard to write, treat that as design feedback and simplify the interface or seams.
- For existing bugs, start by writing the smallest repro that fails before fixing the bug.

## Refactoring rules
- Refactor only after reaching green.
- Refactor both production code and tests when they need cleanup.
- Remove duplication, improve names, and simplify structure while keeping behavior unchanged.
- Keep the relevant checks green throughout refactoring.

## Anti-pattern guardrails
- Do not write tests after implementation and call it TDD.
- Do not test mock behavior when the real behavior should be tested.
- Do not mock away the side effects or flows the test depends on.
- Do not add production-only hooks, branches, or methods just to satisfy tests.
- Do not jump across multiple behaviors in one cycle; shrink the step.
- Do not stop at green when the code or tests still need refactoring.
- For config or infra changes, do not invent shallow assertions just to satisfy test-first; use the smallest meaningful failing verification for the target behavior.

## Completion checks
- Every changed behavior is covered by a test or meaningful verification step.
- Each new test or check was observed failing before implementation.
- Failures happened for the expected reason, not because of typos or broken setup.
- Focused checks pass and relevant broader validation is green.
- Code and tests were refactored where needed.

## Output format
1. Test list
2. Current cycle
3. Verification status
4. Refactoring note
5. Open follow-ups

Keep the output concise, concrete, and executable.
