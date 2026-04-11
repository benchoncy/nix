---
name: refactoring
description: Identify code smells and apply refactoring techniques to improve code quality
---

## What I do
- Help identify when code needs refactoring (code smells)
- Guide how to apply specific refactoring techniques
- Balance refactoring with delivering value

## When to use me
- When writing or modifying code that has obvious quality concerns
- When asked to "clean up", "improve", or "refactor" code
- When inheriting code that needs work before adding features
- When reviewing code with quality issues that impair understanding

## When NOT to use me
- When the human explicitly says "don't refactor" or "just fix the bug"
- When the task is a quick fix and refactoring would delay delivery
- When code is scheduled for deletion/replacement

## Core Rule

**Rule of thumb**: Don't refactor existing committed code unless explicitly asked or deemed in critical need of rework. Refactoring your own uncommitted work is encouraged.

## Philosophy

- **Write first, refactor second** - often better than trying to design perfectly upfront
- **Heuristics over formulas** - smells are prompts to investigate, not mandates
- **Context matters** - a smell in one codebase may be acceptable in another

## Decision Guidance

When considering refactoring, ask:
1. Does the smell clearly impair understanding or modification?
2. Is the code likely to change again soon?
3. Does refactoring risk introducing bugs?
4. Is there test coverage to verify behavior?
5. Does the refactoring serve a clear purpose (feature work, bug fix, readability)?

## Files Reference

- **code-smells.md** - Catalog of smells, organized by category, with indicators for when to investigate
- **techniques.md** - Refactoring methods with guidance on when to use and how to perform them, including a quick decision tree

## Output Format

1. Identified smells and their severity
2. Recommended refactorings to apply
3. Risk/benefit assessment
4. Suggested order (if multiple refactorings)

Keep output concise and actionable.