# Refactoring Techniques

Techniques organized by purpose. Each includes when to use, why, and how (with Python examples where helpful).

---

## Composing Methods

### Extract Function

**When to use:**
- Code block is longer than 2-3 lines
- Code has its own purpose with a nameable intent
- Code is duplicated elsewhere

**Why:**
- Makes intent clear without reading implementation
- Enables reuse
- Easier to test in isolation
- Reduces nesting

**How:**
1. Identify the code block's purpose
2. Create a function named for that purpose
3. Move code into the function, passing parameters
4. Replace original code with function call

```python
# Before
def process_order(order):
    # Calculate total
    total = 0
    for item in order.items:
        total += item.price * item.quantity
    # Apply discount
    if total > 100:
        total *= 0.9
    # Create invoice
    return Invoice(order.id, total)

# After
def calculate_total(order):
    return sum(item.price * item.quantity for item in order.items)

def apply_discount(total):
    return total * 0.9 if total > 100 else total

def process_order(order):
    total = calculate_total(order)
    total = apply_discount(total)
    return Invoice(order.id, total)
```

---

### Inline Function

**When to use:**
- Function body is as clear as its name
- Function is trivial wrapper
- Function is rarely used and inlining simplifies code

**Why:**
- Reduces indirection
- Simplifies code flow
- Removes unnecessary abstraction

**How:**
1. Replace function call with function body
2. Remove function definition

---

### Extract Variable

**When to use:**
- Complex expression is hard to read
- Expression is used multiple times
- Expression needs explanation

**Why:**
- Makes intent explicit
- Reduces duplication
- Enables later extraction to function

**How:**
1. Assign expression to variable with descriptive name
2. Use variable in place of expression

```python
# Before
if order.date.month == 12 and order.total > 1000:
    send_christmas_gift()

# After
is_holiday_season = order.date.month == 12
is_large_order = order.total > 1000

if is_holiday_season and is_large_order:
    send_christmas_gift()
```

---

### Inline Temp

**When to use:**
- Temp variable is simple enough to inline
- Temp is only used once

**Why:**
- Removes unnecessary assignment

---

### Replace Temp with Query

**When to use:**
- Temp variable caches a computation
- Computation could be a method instead
- Temp is used in multiple places

**Why:**
- Method can be called anywhere without passing temps
- Enables extraction of related logic
- Reduces scope issues

**How:**
1. Extract computation to a method
2. Replace temp references with method call

---

### Split Loop

**When to use:**
- Loop does two or more unrelated things
- One part needs to be used without the other

**Why:**
- Each loop has single responsibility
- Easier to understand and test
- Enables optimization per loop

**How:**
1. Identify distinct purposes in the loop
2. Split into separate loops

```python
# Before
for item in items:
    total += item.price
    results.append(transform(item))

# After
total = sum(item.price for item in items)
results = [transform(item) for item in items]
```

---

### Replace Loop with Pipeline

**When to use:**
- Loop is simple iteration (map, filter, reduce)
- Pipeline is more readable in the language
- Chain of operations on collections

**Why:**
- Expresses intent clearly
- Reduces nesting
- Easier to compose

**How:**
Replace loop with chain of `map`, `filter`, comprehension, or library methods.

```python
# Before
results = []
for x in items:
    if x.is_valid:
        results.append(x.compute())

# After
results = [x.compute() for x in items if x.is_valid]
```

---

## Simplifying Conditionals

### Decompose Conditional

**When to use:**
- Complex conditional expression
- Condition used in multiple places
- Condition needs explanation

**Why:**
- Makes condition's intent clear
- Enables reuse
- Simplifies main logic

**How:**
1. Extract condition to a method with descriptive name
2. Use method in condition

```python
# Before
if not aDate.is_before(summer_start) and not aDate.is_after(summer_end):
    charge = quantity * summer_rate
else:
    charge = quantity * regular_rate + regular_service_charge

# After
def is_summer(date):
    return not date.is_before(summer_start) and not date.is_after(summer_end)

def summer_charge(quantity):
    return quantity * summer_rate

def regular_charge(quantity):
    return quantity * regular_rate + regular_service_charge

if is_summer(aDate):
    charge = summer_charge(quantity)
else:
    charge = regular_charge(quantity)
```

---

### Consolidate Conditional Expression

**When to use:**
- Series of checks that lead to the same result
- Each check returns early for same value

**Why:**
- Single entry point for special case
- Reduces duplication
- Makes addition of new conditions easier

**How:**
1. Combine conditions with logical operators
2. Extract to method with descriptive name

```python
# Before
if seniority < 2:
    return 0
if months_disabled > 12:
    return 0
if is_part_time:
    return 0

# After
def is_not_eligible():
    return seniority < 2 or months_disabled > 12 or is_part_time

if is_not_eligible():
    return 0
```

---

### Replace Nested Conditional with Guard Clauses

**When to use:**
- Deep nesting of conditionals
- Special cases at the beginning that should return early
- Normal case is buried in else branches

**Why:**
- Makes special cases explicit at start
- Flattens the code
- Makes normal flow clear

**How:**
1. Identify guard conditions (invalid states, edge cases)
2. Return early for each guard
3. Keep normal case unindented at the end

```python
# Before
def get_pay_amount():
    if is_dead:
        result = dead_amount()
    else:
        if is_separated:
            result = separated_amount()
        else:
            if is_retired:
                result = retired_amount()
            else:
                result = normal_pay_amount()
    return result

# After
def get_pay_amount():
    if is_dead:
        return dead_amount()
    if is_separated:
        return separated_amount()
    if is_retired:
        return retired_amount()
    return normal_pay_amount()
```

---

### Replace Conditional with Polymorphism

**When to use:**
- Same type-based switch appears in multiple places
- Adding new type requires changing all switches
- Logic depends on type

**Why:**
- Eliminates duplication
- Adds new types easily
- Each type owns its behavior

**How:**
1. Create classes for each case
2. Move behavior to appropriate class
3. Replace switch with polymorphic call

```python
# Before
class Employee:
    def pay(self):
        if self.type == 'ENGINEER':
            return self.salary * 1.1
        elif self.type == 'MANAGER':
            return self.salary * 1.2
        else:
            return self.salary

# After
class Employee(ABC):
    @abstractmethod
    def pay(self):
        pass

class Engineer(Employee):
    def pay(self):
        return self.salary * 1.1

class Manager(Employee):
    def pay(self):
        return self.salary * 1.2

class Regular(Employee):
    def pay(self):
        return self.salary
```

---

### Introduce Special Case

**When to use:**
- Same null/special handling repeated
- Null checks scattered throughout code
- Null represents a case, not absence

**Why:**
- Centralizes special case handling
- Eliminates scattered checks
- Makes null explicit as a type

**How:**
1. Create special case object/module
2. Replace null checks with special case
3. Handle at creation point where possible

```python
# Before
if user is None:
    name = 'Anonymous'
else:
    name = user.name

# After (Null Object pattern)
class NullUser:
    name = 'Anonymous'

def get_user(id):
    user = db.find(id)
    return user or NullUser()

name = user.name  # works for both
```

---

### Reverse Conditional

**When to use:**
- Condition has negation that makes it hard to read
- Switching branches makes intent clearer

**Why:**
- Positive conditions are easier to understand
- Reduces cognitive load

**How:**
1. Remove negation from condition
2. Swap then/else branches

---

## Moving Features Between Objects

### Move Function

**When to use:**
- Method uses another class more than its own
- Method would make more sense on another class
- Method is rarely used where it currently is

**Why:**
- Behavior lives with the data it operates on
- Reduces coupling
- Makes API cleaner

**How:**
1. Identify the class that has most data used
2. Move method to that class
3. Update callers

```python
# Before
class Order:
    def calculate_total(self):
        return sum(item.price * item.quantity for item in self.items)

# After - method belongs on the collection
class Order:
    items: list[OrderItem]

class OrderItems:
    def total(self):
        return sum(item.price * item.quantity for item in self)

# Or simply use built-in sum with key
total = sum((item.price * item.quantity for item in order.items), start=0)
```

---

### Move Field

**When to use:**
- Field is used more by another class
- Field makes more sense on another class

**Why:**
- Data lives where it's used
- Reduces parameter passing

---

### Hide Delegate

**When to use:**
- Client navigates through object chain (`a.getB().getC()`)
- Object exposes internal structure

**Why:**
- Reduces coupling to object structure
- Centralizes navigation logic

**How:**
1. Add method on delegator that delegates to delegate
2. Update client to use new method

```python
# Before
customer.get_manager().get_department().get_name()

# After
class Customer:
    def department_name(self):
        return self._manager.department.name
```

---

### Remove Middle Man

**When to use:**
- Class is just delegation without adding value
- Client needs access to delegate anyway

**Why:**
- Reduces indirection
- Simplifies call chain

---

### Introduce Foreign Method

**When to use:**
- Using a library class that needs a method it doesn't have
- Can't modify the library

**Why:**
- Adds needed behavior to external class

**How:**
1. Create a function that takes the object as first parameter
2. Call it as a standalone function

```python
# Instead of monkey-patching
def new_booking_date(service):
    return service.start_date + timedelta(days=30)

booking_date = new_booking_date(external_service)
```

---

### Introduce Local Extension

**When to use:**
- Need multiple methods on a library class
- Foreign method approach is getting messy

**Why:**
- Groups extensions cleanly

**How:**
Create a subclass or wrapper class that adds the needed methods.

---

## Organizing Data

### Change Value to Reference

**When to use:**
- Multiple objects with same data that should be one object
- Objects are modified and changes should be visible everywhere

**Why:**
- Single source of truth
- Ensures consistency

**How:**
1. Create single instance
2. Replace construction with lookup

---

### Change Reference to Value

**When to use:**
- Object doesn't need identity
- Objects should be compared by contents, not identity

**Why:**
- Simpler, immutable objects
- No shared state issues

---

### Replace Primitive with Object

**When to use:**
- Primitive carries domain meaning (e.g., String for phone number)
- Primitive needs validation or behavior

**Why:**
- Type safety
- Encapsulates behavior
- Self-documenting

**How:**
```python
# Before
def send_email(to: str, body: str):
    validate_email(to)
    # ...

# After
class Email:
    def __init__(self, address: str):
        if '@' not in address:
            raise ValueError('Invalid email')
        self.address = address

def send_email(to: Email, body: str):
    # no validation needed, Email guarantees validity
```

---

### Introduce Parameter Object

**When to use:**
- Parameters always passed together
- Parameter list is too long
- Parameters represent a concept

**Why:**
- Groups related data
- Enables method movement
- Makes signatures cleaner

**How:**
```python
# Before
def create_report(start_date, end_date, include_charts, include_summary):
    ...

# After
class ReportConfig:
    def __init__(self, start_date, end_date, include_charts, include_summary):
        ...

def create_report(config: ReportConfig):
    ...
```

---

### Encapsulate Collection

**When to use:**
- Returning raw collection allows modification
- Collection should be read-only from outside
- Want to add collection behavior later

**Why:**
- Prevents external modification
- Can add validation/transformation
- Hides internal structure

**How:**
```python
# Before
class Order:
    @property
    def items(self):
        return self._items  # returns list directly

# After
class Order:
    @property
    def items(self):
        return tuple(self._items)  # immutable copy
    
    def add_item(self, item):
        self._items.append(item)
```

---

### Replace Data Value with Object

**When to use:**
- Field needs behavior
- Field has related data that should move with it

**Why:**
- Encapsulates related behavior
- Makes field more than just data

---

## Simplifying Method Calls

### Rename Function

**When to use:**
- Name doesn't reveal intent
- Name is confusing or misleading
- Name is too long or too short

**Why:**
- Self-documenting code
- Reduces need for comments

**How:**
1. Rename function
2. Update all callers

---

### Add Parameter / Remove Parameter

**When to use:**
- Function needs more/less context
- Parameter is no longer used
- Splitting function would be better

---

### Separate Query from Modifier

**When to use:**
- Method returns a value AND has side effects
- Calling code doesn't need side effect
- Method is used in condition

**Why:**
- Enables safe optimization
- Makes effects explicit
- Follows Command-Query Separation

**How:**
```python
# Before
def get_total_and_send():
    total = calculate()
    send_invoice()
    return total

# After
def get_total():
    return calculate()

def send_invoice():
    # side effect only
```

---

### Replace Parameter with Method Call

**When to use:**
- Parameter value comes from another method call
- Parameter is derived from receiver

**Why:**
- Removes unnecessary parameter
- Reduces coupling

---

### Remove Flag Argument

**When to use:**
- Boolean parameter splits method into two paths
- Method does different things based on flag

**Why:**
- Makes call sites clearer
- Reveals separate concepts

**How:**
```python
# Before
def process(order, is_premium=False):
    if is_premium:
        # premium processing
    else:
        # regular processing

# After - split into two methods
def process(order):
    # regular processing

def process_premium(order):
    # premium processing
```

---

### Introduce Parameter Object (see Organizing Data)

---

## Dealing with Generalization

### Pull Up Method

**When to use:**
- Subclasses have identical methods
- Method makes sense in superclass

**Why:**
- Eliminates duplication
- Makes common behavior explicit

**How:**
1. Move method to superclass
2. Remove from subclasses

---

### Push Down Method

**When to use:**
- Method is only used by some subclasses
- Method doesn't make sense in superclass

**Why:**
- Removes unnecessary behavior from superclass
- Makes behavior explicit in subclasses

---

### Pull Up Constructor Body

**When to use:**
- Constructors in subclasses have identical code
- Common initialization in all subclasses

---

### Extract Superclass

**When to use:**
- Two classes share behavior
- Shared interface makes sense
- Classes aren't already related

---

### Collapse Hierarchy

**When to use:**
- Subclass is no different from superclass
- Hierarchy adds no value

---

### Replace Inheritance with Delegation

**When to use:**
- Subclass doesn't want to "be" the superclass
- Inheritance used for code reuse, not polymorphism

**Why:**
- Composition over inheritance
- More explicit dependencies

---

### Replace Delegation with Inheritance

**When to use:**
- Delegating class has many forwarding methods
- Delegation is effectively inheritance

---

## Removing Dead Code

### Remove Dead Code

**When to use:**
- Code is never executed
- Function is never called
- Variable is never used

**Why:**
- Reduces confusion
- Removes maintenance burden
- Keeps codebase lean

---

# Quick Decision Tree

When you see specific patterns, use this to find relevant techniques:

## Long Method?
- See also: nested loops, duplicated code
- **Extract Function** - split into named chunks
- **Decompose Conditional** - extract complex conditions
- **Replace Nested Conditional with Guard Clauses** - flatten nesting
- **Replace Loop with Pipeline** - use comprehensions
- **Replace Temp with Query** - move computation to method

## Complex Conditional?
- **Decompose Conditional** - name the condition
- **Consolidate Conditional Expression** - merge checks that lead to same result
- **Replace Nested Conditional with Guard Clauses** - early returns for special cases
- **Introduce Special Case** - handle null specially

## Data Issues?
- Primitive obsession → **Replace Primitive with Object**
- Data clumps → **Introduce Parameter Object**
- Long parameter list → **Introduce Parameter Object** or pass object
- Exposed collection → **Encapsulate Collection**

## Coupling Issues?
- Feature envy → **Move Function** to data class
- Message chains → **Hide Delegate** or **Move Function**
- Middle man → **Remove Middle Man**
- Inappropriate intimacy → **Move Function** or **Change Bidirectional Association to Unidirectional**

## Switch/Type Proliferation?
- **Replace Conditional with Polymorphism** - create classes per type
- **Introduce Special Case** - handle null explicitly

## Duplication?
- Same code in same class → **Extract Function**
- Same code in different classes → **Extract Function** + **Pull Up Method**
- Similar but not identical → consider **Form Template Method**

## Data Class?
- Move behavior into it, or keep as pure DTO if appropriate

## Need to Change One Thing, Affects Many?
- Divergent change → **Move Function** to separate responsibilities
- Shotgun surgery → **Move Function** to bring scattered code together
- Parallel hierarchies → **Collapse Hierarchy** or restructure

## Dead Code?
- **Remove Dead Code** - delete it

---

## Key Principles

1. **Small steps** - Each refactoring should be small and safe
2. **Test after each step** - Verify behavior is preserved
3. **Commit separately** - Refactoring as its own commit makes review easier
4. **Don't over-abstract** - Simple is better until complexity is needed
5. **Names matter** - Rename for clarity, don't rush to create abstractions