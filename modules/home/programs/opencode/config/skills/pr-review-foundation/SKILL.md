---
name: pr-review-foundation
description: Shared operating contract for high-signal pull request and diff review
---
## What I do
- Define the baseline method for reviewing code changes with high signal and low noise.
- Standardize how reviewers determine scope, gather context, judge bug-worthiness, and format findings.
- Keep reviewers focused on issues the author would likely want to fix.

## When to use me
- Use this for one-shot review of pull requests, branch diffs, commits, staged changes, or working tree changes.
- Use this before applying any reviewer-specific lens such as balanced, critical, security, or tester.

## Review objective
- Review the supplied change for production-relevant issues introduced by the change.
- Prefer no findings over weak findings.

## Scope rules
- Review one canonical scope only.
- If the caller supplies an explicit scope, use it.
- Otherwise review the single diff or artifact selected by the caller or orchestrator.
- Only flag issues introduced by the reviewed change, not pre-existing problems unless the change makes them materially worse.

## Context-gathering protocol
- Diffs alone are not enough.
- Start from the changed lines, then inspect enough surrounding code to understand control flow, data flow, interfaces, and error handling.
- Read the full changed file when needed to avoid misreading local patterns.
- Check nearby tests, config, docs, and calling code when they are relevant to the changed behavior.
- Check repository instruction and convention files when present, including files like `AGENTS.md`, `README*`, `CONTRIBUTING*`, CI configs, and task/build files.

## What to look for
Prioritize:
- Bugs and correctness issues
- Regression risk
- Broken or missing error handling
- Security problems
- Mismatch with requirements or likely intent
- Missing or misleading tests when behavior changed
- Operational or rollout hazards
- Maintainability problems only when they create a concrete defect or hazard

## Bug-worthiness standard
Only report an issue when all of these are true:
- It is discrete and actionable.
- It is supported by evidence in the reviewed change and surrounding context.
- It would likely matter to the original author.
- It does not depend on an unstated assumption or a speculative downstream effect.
- It is not merely a style preference or generic hardening advice.

If you are unsure, investigate more or return no finding.

## Severity guidance
- High: likely correctness, security, or operational issue with strong evidence
- Medium: plausible regression or maintenance hazard with concrete rationale
- Low: actionable but lower-impact issue; use sparingly

## Comment quality bar
- Be direct and matter-of-fact.
- Explain why the issue is a problem and when it manifests.
- Keep line ranges tight and choose the smallest range that supports the finding.
- Do not pad with praise, filler, or vague advice.
- Do not suggest a fix unless it is necessary to explain the problem.

## Intermediate output contract
Return only this structure unless the caller asks for a different final format:

```yaml
findings:
  - dedupe_key: <stable short key>
    filepath: <repo-relative path>
    start_line: <1-based line>
    end_line: <1-based line>
    severity: high|medium|low
    confidence: high|medium|low
    finding: <one short paragraph>
    rationale: <why this matters>
general:
  - <non-line-specific point>
```

If there are no findings, return:

```yaml
findings: []
general: []
```

## Silence rules
- Do not invent repository facts.
- Do not report hypothetical issues without a concrete failure mode.
- Do not ask conversational follow-up questions in one-shot review unless explicitly requested.
- Prefer silence over low-confidence noise.
