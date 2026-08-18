---
description: Summarize recent work journal entries into standup points
agent: zk
---

Create a concise standup update from the recent work journal.

Scope:
- Read the vault's `AGENTS.md` first, as required by your operating rules.
- Use the Obsidian MCP for all vault reads and searches.
- Read only `work/journal` and its descendants. Do not read personal notes under `journal`.
- Focus on recent entries, using note dates and journal content to determine recency.

Output:
- `$ARGUMENTS` may contain one positive integer. Treat it as the maximum number of
  synthesized standup points; for example, `/standup 5` returns the top 5 points.
- With no argument, return the top 5 points.
- If fewer than the requested number of meaningful points can be supported by the
  journal, return only those points.
- Rank points by recentness and standup usefulness: completed progress, current work,
  next actions, blockers, and important decisions.
- Return only a numbered list of concise, first-person-ready standup points.
- Include a source date or note name in parentheses when it adds confidence or useful
  context.
- Do not invent work, infer unsupported outcomes, expose unrelated personal context,
  or modify any vault content.
- If the argument is not empty and is not a positive integer, explain the accepted
  format briefly instead of treating it as a search term.

$ARGUMENTS
