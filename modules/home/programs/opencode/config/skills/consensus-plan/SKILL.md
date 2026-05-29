---
name: consensus-plan
description: Build an implementation-ready plan by iterating with the consensus-planning agent until concerns converge
---
## What I do
- Turn discussion context into an implementation-ready plan.
- Run an explicit challenge loop with the `consensus-planning` agent to stress-test assumptions and tradeoffs.
- Keep only unresolved high-impact concerns in scope each round.

## When to use me
- Use me when a plan benefits from challenge: ambiguous direction, meaningful tradeoffs, risky sequencing, architecture decisions, or multiple plausible approaches.
- Use me when the user asks for planning, strategy, tradeoffs, or whether an approach is sensible and a quick self-check is not enough.
- Do not use me for tiny edits, obvious implementation steps, routine config changes, or already-approved specs.

## Workflow
1. Draft an initial plan from current conversation context.
2. Run a challenge round with the `consensus-planning` agent.
3. Revise the plan to address feedback and record what changed.
4. Repeat steps 2-3 until convergence or round cap.

Round cap:
- Default maximum: 2 challenge rounds.
- Stop after 1 round when no high-impact concerns remain.
- Use up to 6 rounds only when the user explicitly asks for deep consensus or unresolved high-impact concerns remain.

Convergence criteria (stop when any condition is true):
- The `consensus-planning` agent explicitly indicates convergence.
- No high-impact concerns remain after a challenge round.
- The process reaches 6 rounds.

## Per-round rules
- Use the `consensus-planning` agent each round; do not rely on self-critique alone.
- Ask it to challenge at least one already accepted decision.
- Tag concerns as `new`, `reframed`, or `resolved`.
- Prioritize high-impact risks and sequencing problems first.
- Do not repeat resolved points unless new evidence appears.
- If unknowns remain, choose best-effort defaults and list targeted follow-up questions.

## Output format
1. Recommendation
2. Tasks
3. Risks
4. Validation
5. Open questions

Output should be concise: aim for terse, executable prose over report-shaped structure. Keep the default output under 250 words unless the user asks for detail.

Only include round count, stop reason, or confidence if the user explicitly asks for a formal consensus report or if unresolved high-impact risk remains.
