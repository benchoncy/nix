---
name: consensus-plan
description: Build an implementation-ready plan by iterating with the consensus-planning agent until concerns converge
---
## What I do
- Turn discussion context into an implementation-ready plan.
- Run an explicit challenge loop with the `consensus-planning` agent to stress-test assumptions and tradeoffs.
- Keep only unresolved high-impact concerns in scope each round.

## When to use me
- The user needs a robust plan for non-trivial implementation work.
- There are architecture or sequencing decisions with meaningful risk.
- You want convergence through critique, not a one-shot plan.

## Workflow
1. Draft an initial plan from current conversation context.
2. Run a challenge round with the `consensus-planning` agent.
3. Revise the plan to address feedback and record what changed.
4. Repeat steps 2-3 until convergence or round cap.

Round cap:
- Maximum 6 challenge rounds.

Convergence criteria (stop when any condition is true):
- The `consensus-planning` agent explicitly indicates convergence.
- No new high-priority concerns appear for 2 consecutive rounds.
- The process reaches 6 rounds.

## Per-round rules
- Use the `consensus-planning` agent each round; do not rely on self-critique alone.
- Ask it to challenge at least one already accepted decision.
- Tag concerns as `new`, `reframed`, or `resolved`.
- Prioritize high-impact risks and sequencing problems first.
- Do not repeat resolved points unless new evidence appears.
- If unknowns remain, choose best-effort defaults and list targeted follow-up questions.

## Output format
1. Goal
2. Decisions taken
3. Ordered action plan
4. Risks and mitigations
5. Verification checklist
6. Consensus summary (rounds used, stop reason, confidence 1-5)
7. Open questions (if any)

Output should be concise - aim for terse, executable prose over forced structure. More sections only when they actually add clarity.
