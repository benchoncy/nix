# Code Smells

A code smell is a surface indication that usually corresponds to a deeper problem. Smells are prompts to investigate—not mandates to refactor. Trust your judgment.

---

## Bloaters

Code, methods, and classes that have grown too large to work with easily.

### Long Method

**Indicators:**
- Method exceeds ~10 lines
- Hard to see the purpose at a glance
- Requires scrolling to read
- Too many local variables or parameters

**Why it's a problem:** Long methods hide logic, make testing harder, and often contain duplicate code. They resist change because understanding requires reading everything.

**When acceptable:** Brief utility methods, data transformations with clear single purpose, generated code.

---

### Large Class

**Indicators:**
- Class has many fields (10+)
- Many methods (10+)
- Class does too many things (violates Single Responsibility)
- Hard to name without "And" or "Or"

**Why it's a problem:** Hard to understand, test, and reason about. Changes often affect unrelated functionality.

**When acceptable:** Data transfer objects, generated code, facade classes intentionally delegating to many components.

---

### Primitive Obsession

**Indicators:**
- Using primitives for domain concepts (e.g., `String` for phone number, `int` for currency)
- Constants scattered for coding information (e.g., `ADMIN_ROLE = 1`)
- Groups of primitives passed together repeatedly

**Why it's a problem:** No type safety, easy to pass wrong values, behavior scattered across the codebase.

**When acceptable:** Simple DTOs, temporary prototypes, when domain is genuinely simple.

---

### Long Parameter List

**Indicators:**
- Method takes 4+ parameters
- Parameters often passed together from the same source
- Adding a new parameter requires changing all call sites

**Why it's a problem:** Hard to remember order, easy to pass wrong value, often indicates function does too much.

**When acceptable:** Functions in functional paradigms, truly orthogonal parameters, builder patterns.

---

### Data Clumps

**Indicators:**
- Same groups of variables appear together in multiple places
- Often passed together as parameters
- Treated as a unit but not encapsulated

**Why it's a problem:** Duplicate data, easy to forget to update all places, violates DRY.

**When acceptable:** When the grouping is purely incidental, not meaningful in the domain.

---

## Object-Orientation Abusers

Incomplete or incorrect application of OOP principles.

### Switch Statements

**Indicators:**
- Same switch/if-else on same type appears in multiple places
- Adding a new type requires changing all switches
- Switch operates on type code or enum

**Why it's a problem:** Duplication, violates Open/Closed Principle, easy to miss cases.

**When acceptable:** Once, in factory/creation code, when type set is truly fixed.

---

### Temporary Field

**Indicators:**
- Field only set and used under certain conditions
- Field is empty/null most of the time
- Object seems to have two different purposes

**Why it's a problem:** Confusing to users, indicates class does multiple things.

**When acceptable:** Builder patterns, objects in transitional states.

---

### Refused Bequest

**Indicators:**
- Subclass inherits methods it doesn't use
- Subclass overrides methods to throw exceptions
- Hierarchy doesn't model "is-a" relationship

**Why it's a problem:** Misleading type hierarchy, violates Liskov Substitution.

**When acceptable:** When inheritance is used for code reuse only (consider composition instead).

---

### Alternative Classes with Different Interfaces

**Indicators:**
- Two classes do the same thing but have different method names
- Must convert between them or write adapter code
- Similar responsibility but incompatible APIs

**Why it's a problem:** Confusion, duplication, forces awkward calling code.

**When acceptable:** When classes come from different libraries that can't be unified.

---

## Change Preventers

Changes require modifications in many places.

### Divergent Change

**Indicators:**
- Changing one thing requires changing the same class for different reasons
- Class has multiple reasons to change
- Related changes are scattered

**Why it's a problem:** Violates Single Responsibility, hard to understand impact of changes.

**When acceptable:** When complexity is truly incidental and inseparable.

---

### Shotgun Surgery

**Indicators:**
- One change requires making the same change in many classes
- Same logic duplicated across classes
- Changes are mechanical, not logical

**Why it's a problem:** Easy to miss places, error-prone, violates DRY.

**When acceptable:** When the "surgery" is trivial and consistent, or when separating would create worse coupling.

---

### Parallel Inheritance Hierarchies

**Indicators:**
- For each subclass in one hierarchy, there's a corresponding subclass in another
- Adding a subclass requires adding one in each hierarchy

**Why it's a problem:** Duplication, rigidity, couples hierarchies unnecessarily.

**When acceptable:** When true independence exists, or hierarchies will never grow.

---

## Dispensables

Pointless or unnecessary code that could be removed.

### Comments

**Indicators:**
- Comment explains bad code instead of fixing it
- Comment is outdated
- Comment states the obvious
- Comment blocks that could be functions

**Why it's a problem:** Comments lie over time, can hide rot, often indicate code needs clarification instead.

**When acceptable:** Architectural explanations, regulatory requirements, tricky business logic that can't be expressed in code.

---

### Duplicate Code

**Indicators:**
- Identical or nearly identical code in multiple places
- Same algorithm repeated
- Copy-paste logic

**Why it's a problem:** Hard to maintain, easy to fix in one place and forget others, bloats codebase.

**When acceptable:** When duplication is intentional for performance (rare), or when true independence exists.

---

### Data Class

**Indicators:**
- Class with only fields and getters/setters
- No behavior
- Other classes operate on its data extensively

**Why it's a problem:** "Anemic" objects, behavior scattered elsewhere, violates encapsulation.

**When acceptable:** Pure data transfer objects, serialization targets.

---

### Dead Code

**Indicators:**
- Code never executed
- Variables never used
- Methods never called
- Classes never instantiated

**Why it's a problem:** Confusion, maintenance burden, indicates rot.

**When acceptable:** Feature flags, deliberate "unused" placeholders for future use.

---

### Lazy Class

**Indicators:**
- Class does too little to justify its existence
- Class only delegates to others
- Cost of maintaining class exceeds its value

**Why it's a problem:** Indirection without benefit, confusion.

**When acceptable:** When serving as stable interface for future expansion, simple delegating facades.

---

### Speculative Generality

**Indicators:**
- Abstract classes/interfaces never used
- Parameters for hypothetical future features
- Elaborate infrastructure for simple problem
- "Just in case" abstractions

**Why it's a problem:** Over-engineering, complexity without benefit, harder to understand.

**When acceptable:** When clear, near-term need exists, when building reusable libraries.

---

## Couplers

Excessive coupling between classes.

### Feature Envy

**Indicators:**
- Method accesses another object's data more than its own
- Excessive parameter passing where object could be passed
- "Train wrecks" (`a.getB().getC().getD()`)

**Why it's a problem:** Logic in wrong place, tight coupling, hard to change object structure.

**When acceptable:** Data structure accessors, clear cases where behavior truly belongs with data.

---

### Inappropriate Intimacy

**Indicators:**
- Class accesses another class's internal fields/methods
- Classes are overly aware of each other's internals
- Friendship that crosses boundaries

**Why it's a problem:** High coupling, changes in one class break another, violates encapsulation.

**When acceptable:** Very tightly related domain concepts, when refactoring would create worse coupling.

---

### Message Chains

**Indicators:**
- Long chain of calls: `a.b().c().d().e()`
- Client navigates through multiple objects to get what it needs

**Why it's a problem:** Coupling to structure, changing one link breaks clients, violates Law of Demeter.

**When acceptable:** When chain is stable, when navigation is the domain (e.g., file systems).

---

### Middle Man

**Indicators:**
- Class exists only to delegate to another
- No added value in the middle layer
- Adding methods means adding more delegation

**Why it's a problem:** Indirection without benefit, extra hops, maintenance burden.

**When acceptable:** When middleman adds caching, logging, access control, or other transformation.

---

## Using This Catalog

When encountering code, scan for smells as prompts:
1. Don't refactor just because a smell exists
2. Consider context: code lifespan, change frequency, team size
3. When in doubt, prefer small, safe refactorings (extract function, rename)
4. Test coverage enables bolder refactoring
5. Commit quality improvements separately from feature work