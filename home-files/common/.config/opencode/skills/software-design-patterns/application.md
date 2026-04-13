# Design Pattern Application Guide

Quick reference for selecting the right pattern based on the problem.

---

## Quick Decision Tree

### Problem: Object Creation

| Situation | Pattern |
|-----------|---------|
| Need to delegate creation to subclasses | Factory Method |
| Need families of related objects | Abstract Builder |
| Complex object with many parameters | Builder |
| Clone existing object instead of creating new | Prototype |
| Only one instance needed globally | Singleton |

---

### Problem: Class/Object Structure

| Situation | Pattern |
|-----------|---------|
| Incompatible interfaces between components | Adapter |
| Abstraction and implementation need to vary independently | Bridge |
| Treat individual objects and compositions uniformly | Composite |
| Add behavior to objects at runtime | Decorator |
| Simplify complex subsystem access | Facade |
| Share common state across many objects | Flyweight |
| Control access to an object (lazy loading, etc.) | Proxy |

---

### Problem: Object Communication/Behavior

| Situation | Pattern |
|-----------|---------|
| Pass request along chain of handlers | Chain of Responsibility |
| Encapsulate operations for queuing/undo | Command |
| Traverse collection without exposing structure | Iterator |
| Centralize communication between objects | Mediator |
| Save/restore object state | Memento |
| One object changes, many need to be notified | Observer |
| Behavior changes based on internal state | State |
| Switch algorithms at runtime | Strategy |
| Define algorithm skeleton, let subclasses fill steps | Template Method |
| Perform operations on elements without changing them | Visitor |

---

### Problem: Backend/DevOps

| Situation | Pattern |
|-----------|---------|
| Pass dependencies rather than create them | Dependency Injection |
| Abstract data access layer | Repository |
| Prevent cascade failures from service failures | Circuit Breaker |
| Manage reusable database/service connections | Connection Pool |
| Automatically retry failed operations | Retry Pattern |

---

### Problem: Concurrency

| Situation | Pattern |
|-----------|---------|
| Decouple production/consumption with different speeds | Producer-Consumer |
| Reuse threads for many tasks | Thread Pool |
| Handle async results | Future/Promise |
| Concurrent reads, exclusive writes | Read-Write Lock |

---

## Pattern Selection Heuristics

### Start Here (Most Common Patterns)

1. **Strategy** - When you need to swap algorithms at runtime
2. **Observer** - When one change should update many objects
3. **Factory Method** - When subclasses should decide what to create
4. **Decorator** - When you need to add behavior dynamically
5. **Command** - When you need to queue operations or support undo

### Then Expand

6. **Adapter** - When integrating incompatible interfaces
7. **Facade** - When simplifying complex systems
8. **State** - When object behavior depends on state
9. **Composite** - When building tree structures
10. **Builder** - When constructing complex objects

### Advanced Patterns

The remaining patterns are valuable but less frequently needed:
- Bridge, Flyweight, Proxy (Structural)
- Chain of Responsibility, Mediator, Memento, Template Method, Visitor (Behavioral)

---

## Anti-Patterns to Avoid

### Pattern Worship
- Using patterns to demonstrate knowledge rather than solve problems
- Applying patterns before a clear need exists

### Over-Engineering
- Adding abstraction layers that aren't needed
- Creating flexibility that will never be used

### Wrong Pattern
- Using Singleton where a regular class is fine
- Using Observer when direct calls are clearer
- Using Visitor when simple method dispatch works

### Over-Composition
- Nesting too many decorators
- Creating chains that are hard to debug

---

## Relationship to Refactoring

Patterns often **emerge** during refactoring rather than being applied upfront:

1. **Replace Conditional with Polymorphism** → Strategy/State patterns
2. **Extract Class** → May reveal Builder or Factory needs
3. **Hide Delegate** → Facade or Mediator patterns
4. **Replace Inheritance with Delegation** → Composition over Inheritance
5. **Introduce Parameter Object** → May lead to Builder pattern

**Rule**: Let patterns emerge from refactoring. Don't pre-plan patterns for hypothetical future needs.

---

## Pattern Combinations That Work Well

| Combination | Use Case |
|-------------|----------|
| Factory + Singleton | Registry of factories |
| Composite + Visitor | Tree traversal with operations |
| Command + Memento | Undo/redo with command history |
| State + Strategy | State-dependent algorithms |
| Observer + Mediator | Centralized event handling |
| Decorator + Builder | Complex object construction with optional features |
| Circuit Breaker + Retry | Resilience with fallback |

---

## Language Considerations

### Python-Specific

- **Singleton**: Often not needed - use module as singleton
- **Iterator**: Built-in (`for`, comprehensions) - rarely need custom
- **Strategy**: Use duck typing, not inheritance
- **Observer**: Consider `asyncio` or `dispatch` library
- **Visitor**: Rarely needed - use `visit` methods or pattern matching

### When Language Features Replace Patterns

- **Factory Method** → Static methods, `__init_subclass__`
- **Strategy** → First-class functions
- **Observer** → Event systems, callbacks
- **Template Method** → Functions, inheritance with overrides
- **Chain of Responsibility** → Middleware pattern (FastAPI, etc.)

---

## Quick Reference: Pattern Purpose

| Pattern | Primary Purpose |
|---------|-----------------|
| Factory | Object creation with flexibility |
| Builder | Complex object construction |
| Singleton | One instance |
| Adapter | Interface conversion |
| Decorator | Add behavior dynamically |
| Facade | Simplify complex systems |
| Observer | Event propagation |
| Strategy | Swappable algorithms |
| Command | Encapsulated operations |
| State | State-dependent behavior |
| Repository | Data access abstraction |
| Circuit Breaker | Fault tolerance |

---

## Decision Checklist

Before applying a pattern, ask:

1. [ ] Do I have an actual problem this pattern solves?
2. [ ] Will my team understand this pattern?
3. [ ] Does the pattern make the code clearer?
4. [ ] Am I adding complexity that's justified?
5. [ ] Can I test this pattern easily?
6. [ ] Is there a simpler solution?

If you answer "no" to 1 or answer "yes" to 5 or 6, consider not using the pattern.

---

## Further Reading

- **Refactoring.Guru**: https://refactoring.guru/design-patterns
- **Design Patterns**: Gang of Four (GoF) - original reference
- **Head First Design Patterns** - approachable introduction
- **Patterns of Enterprise Application Architecture** - Martin Fowler (beyond GoF)
