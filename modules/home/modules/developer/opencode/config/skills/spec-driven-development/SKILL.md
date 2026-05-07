---
name: spec-driven-development
description: Define a change through a concise spec before implementation and keep it current during execution
---
## What I do
- Turn an intended change into a small, structured spec before implementation begins.
- Keep requirements, constraints, design intent, validation, and task slices explicit.
- Use the spec as the source of truth for the active change while work is in progress.

## When to use me
- Use this for non-trivial features, bug fixes, behavior changes, refactors, and config or infra changes that benefit from a clear change definition.
- Use this when the direction is mostly chosen, but the exact change still needs to be made precise before implementation.
- Use this before implementation starts, and keep the spec updated as the work evolves.

## When not to use me
- Do not use this for trivial edits where a full change spec would add more ceremony than clarity.
- Do not use this as a substitute for `consensus-plan` when the solution is still contested or unclear.
- Do not use this as a substitute for `test-driven-development` once implementation should be driven by failing tests or checks.

## Spec artifact
Produce a concise change spec with these sections:
1. Goal
2. Scope
3. Non-goals
4. Requirements and constraints
5. Design intent
6. Validation
7. Task breakdown

Section guidance:
- Goal: the behavior or outcome being changed.
- Scope: what is included in this change.
- Non-goals: what is intentionally excluded.
- Requirements and constraints: functional expectations, invariants, compatibility needs, platform limits, safety constraints.
- Design intent: why this approach is being taken and what boundaries or tradeoffs matter.
- Validation: how we will know the change is correct.
- Task breakdown: small implementation slices in a sensible order.

## Workflow
1. Start from the requested change and current repo context.
2. Write the smallest spec that makes the intended change precise.
3. Check the spec against repo conventions, existing architecture, and platform constraints.
4. Break the work into small executable tasks.
5. Implement from the spec.
6. Update the spec if implementation reveals a wrong assumption, missing constraint, or better task split.
7. Keep the spec and the implementation aligned until the change is complete.

## Infra/config guidance
- For config, infra, or declarative work, focus the spec on behavior, constraints, migration risk, and validation steps rather than forcing application-style design sections.
- Validation may be evaluation, build, targeted checks, or focused manual verification when strong automated tests are not available.
- Prefer explicit rollout, compatibility, and safety notes when the change affects environments or system behavior.

## Guardrails
- Do not create verbose ceremony when a short spec is enough.
- Do not confuse requirements with implementation details unless the technical constraint is essential.
- Do not duplicate large amounts of code or markdown into the spec.
- Do not let the spec become stale; update it when reality changes.
- Do not treat the spec as permanent truth beyond the active change unless the user explicitly wants a long-lived spec.
- Prefer small, reviewable task slices over large speculative task lists.

## Exit criteria
- The change goal, scope, constraints, validation, and task slices are explicit.
- The spec is precise enough to guide implementation without repeated ambiguity.
- The spec reflects any material design or scope changes discovered during execution.
- Validation is defined in a way that fits the kind of change being made.

## Output format
1. Change spec
2. Current task slice
3. Validation plan
4. Open questions or assumptions

Keep the output concise, concrete, and executable.
