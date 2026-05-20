---
name: software-design-patterns
description: Identify and apply design patterns to solve common software architecture problems
---

## What I do
- Help identify when a design pattern is needed
- Recommend appropriate patterns based on the problem
- Explain how to implement patterns in Python
- Guide on when NOT to use patterns

## When to use me
- When asked to architect a new system or component
- When code shows structural issues that patterns can solve
- When you need flexibility, extensibility, or reusability
- When refactoring reveals a need for structural patterns

## When NOT to use me
- When code is simple and doesn't need abstraction
- When the problem can be solved more simply
- When it would be over-engineering
- When the code is scheduled for deletion/rewrite
- When team doesn't understand the pattern (creates maintenance burden)

## Core Rule

**Rule of thumb**: Don't force patterns—recognize when they emerge naturally from refactoring. A pattern should solve a real problem, not demonstrate knowledge.

## Philosophy

- **Patterns are tools, not rules** - they exist to solve problems, not to be learned
- **Simpler is better** - until complexity is needed
- **Composition over inheritance** - prefer flexible composition to rigid inheritance
- **Code should reveal intent** - patterns should make code clearer, not more obscure
- **Context matters** - what works in one codebase may not work in another

## Decision Guidance

When considering patterns, ask:
1. What problem am I trying to solve?
2. Does this problem appear elsewhere in the codebase?
3. Will the pattern make the code clearer or more maintainable?
4. Does my team understand this pattern?
5. Am I adding complexity that isn't yet justified?

## Files Reference

- **patterns.md** - Full catalog of patterns organized by category with Python examples
- **application.md** - Quick decision tree and pattern selection heuristics

## Output Format

1. Problem identified
2. Recommended pattern(s) with rationale
3. How to apply (brief implementation guidance)
4. Risks/considerations

Keep output concise and actionable.