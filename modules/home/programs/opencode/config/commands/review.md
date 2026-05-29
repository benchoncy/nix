---
description: Multi-lens review with synthesized findings
agent: pr-review-orchestrator
---
Run the repo's multi-lens review workflow.

Goal:
- produce a bounded, high-signal review for PRs, final spot checks, and pre-merge sanity checks
- let the review orchestrator choose the smallest useful reviewer roster
- keep extra review lenses and local validation conditional so `/review` stays fast by default
- synthesize reviewer output without inventing any new findings

User input:
$ARGUMENTS

Execution requirements:
1. Resolve a single canonical review scope before launching reviewers.
2. Use the same scope and context for every reviewer.
3. Always include the balanced reviewer.
4. Add the critical reviewer only when the diff is non-trivial, risky, broad, or regression-prone.
5. Add the security reviewer only when the diff suggests it is relevant.
6. Add the tester reviewer only when the user explicitly opts in or validation is necessary for merge readiness.
7. Synthesize, dedupe, and rank findings.
8. Do not introduce any finding that did not come from a reviewer.
9. Return only the final findings in this exact form:

<filepath>#<line range>:
Finding

1. <point that is not associated with a specific line>

Fallback behavior:
- If no valid findings remain after synthesis, return exactly `No findings.`
- If the user wants validation, they can say so explicitly, for example: `/review with test`.
