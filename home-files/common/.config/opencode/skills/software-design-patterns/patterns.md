# Design Patterns Catalog

A comprehensive catalog of patterns for software engineering work. Each pattern includes intent, problem solved, when to use, when NOT to use, and Python example.

---

# Part 1: Gang of Four (GoF) Patterns

## Creational Patterns

Creational patterns provide object creation mechanisms that increase flexibility and reuse of existing code.

---

### Factory Method

**Intent:** Define an interface for creating an object, but let subclasses decide which class to instantiate.

**Problem:** A class can't anticipate which subclass it needs to create.

**When to use:**
- A class can't anticipate which objects it must create
- Subclasses should specify the objects they create
- You want to delegate responsibility to helper subclasses

**When NOT to use:**
- Simple object creation (no flexibility needed)
- Only one subclass is ever needed
- Simpler alternatives (direct instantiation) work fine

```python
from abc import ABC, abstractmethod

class DataSource(ABC):
    @abstractmethod
    def connect(self):
        pass

class DatabaseConnection(DataSource):
    def connect(self):
        return "Connecting to database"

class APIClient(DataSource):
    def connect(self):
        return "Connecting to API"

class DataSourceFactory:
    @staticmethod
    def create_source(source_type: str) -> DataSource:
        if source_type == "database":
            return DatabaseConnection()
        elif source_type == "api":
            return APIClient()
        raise ValueError(f"Unknown source type: {source_type}")

# Usage
factory = DataSourceFactory()
db = factory.create_source("database")
api = factory.create_source("api")
```

---

### Abstract Factory

**Intent:** Provide an interface for creating families of related objects without specifying concrete classes.

**Problem:** You need to create families of related objects that must be used together.

**When to use:**
- System should be independent of how products are created
- You need to work with various families of related products
- You want to provide a library without exposing implementation

**When NOT to use:**
- Simple, independent objects
- No need for consistency across product families
- Simpler factory method works

```python
from abc import ABC, abstractmethod

class Cache(ABC):
    @abstractmethod
    def get(self, key: str): pass
    @abstractmethod
    def set(self, key: str, value: str): pass

class Logger(ABC):
    @abstractmethod
    def log(self, message: str): pass

class RedisCache(Cache):
    def get(self, key: str): return f"redis_get({key})"
    def set(self, key: str, value: str): return f"redis_set({key}, {value})"

class FileLogger(Logger):
    def log(self, message: str): return f"file_log: {message}"

class ConsoleLogger(Logger):
    def log(self, message: str): return f"console: {message}"

class AbstractFactory(ABC):
    @abstractmethod
    def create_cache(self) -> Cache: pass
    @abstractmethod
    def create_logger(self) -> Logger: pass

class DevFactory(AbstractFactory):
    def create_cache(self) -> Cache: return RedisCache()
    def create_logger(self) -> Logger: return ConsoleLogger()

class ProdFactory(AbstractFactory):
    def create_cache(self) -> Cache: return RedisCache()
    def create_logger(self) -> Logger: return FileLogger()

# Usage
def create_infrastructure(factory: AbstractFactory):
    cache = factory.create_cache()
    logger = factory.create_logger()
    return cache, logger

dev_setup = create_infrastructure(DevFactory())
```

---

### Builder

**Intent:** Separate the construction of a complex object from its representation.

**Problem:** Object creation involves many steps or parameters.

**When to use:**
- Object creation has many optional parameters
- Construction logic should be separated from representation
- Same construction for different representations

**When NOT to use:**
- Simple objects with few parameters
- Object is always created the same way
- Constructor or factory is simpler

```python
class DatabaseConfig:
    def __init__(self):
        self.host = None
        self.port = None
        self.database = None
        self.username = None
        self.password = None
        self.pool_size = 10
        self.ssl_enabled = False

    def __repr__(self):
        return (f"DatabaseConfig(host={self.host}, port={self.port}, "
                f"db={self.database}, pool={self.pool_size}, ssl={self.ssl_enabled})")

class DatabaseConfigBuilder:
    def __init__(self):
        self._config = DatabaseConfig()

    def host(self, host: str):
        self._config.host = host
        return self

    def port(self, port: int):
        self._config.port = port
        return self

    def database(self, database: str):
        self._config.database = database
        return self

    def credentials(self, username: str, password: str):
        self._config.username = username
        self._config.password = password
        return self

    def pool_size(self, size: int):
        self._config.pool_size = size
        return self

    def ssl_enabled(self, enabled: bool = True):
        self._config.ssl_enabled = enabled
        return self

    def build(self) -> DatabaseConfig:
        return self._config

# Usage
config = (DatabaseConfigBuilder()
    .host("localhost")
    .port(5432)
    .database("myapp")
    .credentials("admin", "secret")
    .pool_size(20)
    .ssl_enabled()
    .build())

print(config)  # DatabaseConfig(host=localhost, port=5432, db=myapp, pool=20, ssl=True)
```

---

### Prototype

**Intent:** Create new objects by copying an existing object (prototype).

**Problem:** Creating objects is expensive or complex.

**When to use:**
- Object creation is expensive (database calls, network requests)
- Objects have many possible states
- Avoiding subclassing for object creation

**When NOT to use:**
- Simple object creation is cheap
- Object has no complex state to copy
- Direct instantiation is simpler

```python
import copy
from dataclasses import dataclass
from typing import List

@dataclass
class ServiceConfig:
    name: str
    replicas: int
    environment: dict
    ports: List[int]

    def clone(self) -> 'ServiceConfig':
        return copy.deepcopy(self)

# Usage
base_config = ServiceConfig(
    name="api-service",
    replicas=3,
    environment={"ENV": "dev", "DEBUG": "true"},
    ports=[8080, 8081]
)

# Clone and modify for staging
staging_config = base_config.clone()
staging_config.name = "api-service-staging"
staging_config.environment["ENV"] = "staging"
staging_config.replicas = 5

print(f"Base: {base_config.name}, Replicas: {base_config.replicas}")
print(f"Staging: {staging_config.name}, Replicas: {staging_config.replicas}")
```

---

### Singleton

**Intent:** Ensure a class has only one instance and provide a global access point.

**Problem:** Only one instance of a class is needed (configuration, connection pools, logging).

**When to use:**
- Exactly one instance is needed
- Global access point is required
- Single resource (database, logger, config)

**When NOT to use:**
- Multiple instances are actually needed
- Testing requires multiple instances
- Creates hidden global state

```python
class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._connected = False
        return cls._instance

    def connect(self, host: str):
        print(f"Connecting to {host}...")
        self._connected = True

    def is_connected(self) -> bool:
        return self._connected

# Usage - same instance everywhere
db1 = DatabaseConnection()
db2 = DatabaseConnection()

db1.connect("localhost")
print(f"db1 connected: {db1.is_connected()}")
print(f"db2 connected: {db2.is_connected()}")  # True - same instance
print(f"Same instance: {db1 is db2}")  # True
```

---

## Structural Patterns

Structural patterns explain how to assemble objects and classes into larger structures while keeping these structures flexible and efficient.

---

### Adapter

**Intent:** Convert the interface of a class into another interface that clients expect.

**Problem:** Incompatible interfaces between components.

**When to use:**
- Integrating with existing code that has different interface
- Creating reusable class that works with unrelated classes
- Converting data formats

**When NOT to use:**
- Interface already compatible
- Simpler solution (wrapper, direct change)
- Don't need to adapt - create new interface instead

```python
class LegacyLogger:
    def log_message(self, level: str, msg: str):
        print(f"[{level}] {msg}")

class ModernLogger:
    def debug(self, message: str): pass
    def info(self, message: str): pass
    def warning(self, message: str): pass
    def error(self, message: str): pass

class LoggerAdapter(ModernLogger):
    def __init__(self, legacy_logger: LegacyLogger):
        self._legacy = legacy_logger

    def _map_level(self, level: str) -> str:
        mapping = {"debug": "DEBUG", "info": "INFO", "warning": "WARN", "error": "ERROR"}
        return mapping.get(level.upper(), "INFO")

    def debug(self, message: str):
        self._legacy.log_message(self._map_level("debug"), message)

    def info(self, message: str):
        self._legacy.log_message(self._map_level("info"), message)

    def warning(self, message: str):
        self._legacy.log_message(self._map_level("warning"), message)

    def error(self, message: str):
        self._legacy.log_message(self._map_level("error"), message)

# Usage - modern interface with legacy implementation
legacy = LegacyLogger()
adapter = LoggerAdapter(legacy)
adapter.info("Application started")
adapter.error("Connection failed")
```

---

### Bridge

**Intent:** Decouple an abstraction from its implementation so both can vary independently.

**Problem:** Both abstraction and implementation need to change independently.

**When to use:**
- Abstraction and implementation need to be extended independently
- Avoid permanent binding between abstraction and implementation
- Changes in implementation shouldn't affect clients

**When NOT to use:**
- Simple abstraction with single implementation
- Both rarely change
- Inheritance is sufficient

```python
from abc import ABC, abstractmethod

class MessageSender(ABC):
    @abstractmethod
    def send(self, message: str, recipient: str): pass

class EmailSender(MessageSender):
    def send(self, message: str, recipient: str):
        print(f"Email to {recipient}: {message}")

class SMSSender(MessageSender):
    def send(self, message: str, recipient: str):
        print(f"SMS to {recipient}: {message}")

class WebhookSender(MessageSender):
    def send(self, message: str, recipient: str):
        print(f"Webhook to {recipient}: {message}")

class Notification:
    def __init__(self, sender: MessageSender):
        self._sender = sender

    def notify(self, message: str, recipient: str):
        self._sender.send(message, recipient)

# Usage - mix and match independently
email_notification = Notification(EmailSender())
sms_notification = Notification(SMSSender())
webhook_notification = Notification(WebhookSender())

email_notification.notify("Hello via email", "user@example.com")
sms_notification.notify("Hello via SMS", "+1234567890")
```

---

### Composite

**Intent:** Compose objects into tree structures to represent part-whole hierarchies.

**Problem:** Need to treat individual objects and compositions uniformly.

**When to use:**
- Objects form tree structures
- Need uniform interface for individual and composite objects
- Client should ignore difference between individual and composite

**When NOT to use:**
- Simple hierarchy (no nested structures)
- Different treatment needed for leaf vs composite
- Simple containment is sufficient

```python
from abc import ABC, abstractmethod

class FileSystemItem(ABC):
    @abstractmethod
    def get_size(self) -> int:
        pass

    @abstractmethod
    def list_contents(self, indent: int = 0) -> None:
        pass

class File(FileSystemItem):
    def __init__(self, name: str, size: int):
        self.name = name
        self.size = size

    def get_size(self) -> int:
        return self.size

    def list_contents(self, indent: int = 0):
        print(" " * indent + f"📄 {self.name} ({self.size} KB)")

class Folder(FileSystemItem):
    def __init__(self, name: str):
        self.name = name
        self.children: list[FileSystemItem] = []

    def add(self, item: FileSystemItem):
        self.children.append(item)

    def get_size(self) -> int:
        return sum(child.get_size() for child in self.children)

    def list_contents(self, indent: int = 0):
        print(" " * indent + f"📁 {self.name}/")
        for child in self.children:
            child.list_contents(indent + 2)

# Usage
project = Folder("project")
src = Folder("src")
src.add(File("main.py", 50))
src.add(File("utils.py", 30))
project.add(File("README.md", 10))
project.add(src)

project.list_contents()
print(f"Total size: {project.get_size()} KB")
```

---

### Decorator

**Intent:** Attach additional responsibilities to an object dynamically.

**Problem:** Need to add behavior to objects without subclassing.

**When to use:**
- Add behavior to objects at runtime
- Avoid subclass explosion for simple additions
- Responsibility can be added/removed dynamically

**When NOT to use:**
- Fixed behavior needed
- Inheritance is simpler
- Too many decorators cause complexity

```python
from abc import ABC, abstractmethod

class DataProcessor(ABC):
    @abstractmethod
    def process(self, data: str) -> str:
        pass

class BaseProcessor(DataProcessor):
    def process(self, data: str) -> str:
        return data

class ProcessorDecorator(DataProcessor):
    def __init__(self, processor: DataProcessor):
        self._processor = processor

    def process(self, data: str) -> str:
        return self._processor.process(data)

class UppercaseDecorator(ProcessorDecorator):
    def process(self, data: str) -> str:
        return super().process(data).upper()

class TrimDecorator(ProcessorDecorator):
    def process(self, data: str) -> str:
        return super().process(data).strip()

class PrefixDecorator(ProcessorDecorator):
    def __init__(self, processor: DataProcessor, prefix: str):
        super().__init__(processor)
        self.prefix = prefix

    def process(self, data: str) -> str:
        return self.prefix + super().process(data)

# Usage - stack decorators at runtime
processor = BaseProcessor()
processor = TrimDecorator(UppercaseDecorator(processor))
processor = PrefixDecorator(processor, "[DATA] ")

result = processor.process("  hello world  ")
print(result)  # [DATA] HELLO WORLD
```

---

### Facade

**Intent:** Provide a unified interface to a set of interfaces in a subsystem.

**Problem:** Complex subsystem with many components needs simplified access.

**When to use:**
- Complex subsystem needs simple interface
- Client only needs subset of subsystem functionality
- Coupling should be minimized

**When NOT to use:**
- Need full access to subsystem
- Facade adds unnecessary layer
- Direct access is clearer

```python
class AuthService:
    def authenticate(self, token: str) -> dict:
        return {"user": "admin", "role": "admin"}

class DatabaseService:
    def query(self, sql: str) -> list:
        return [{"id": 1, "name": "Item"}]

class CacheService:
    def get(self, key: str): return None
    def set(self, key: str, value: str): pass

class NotificationService:
    def send(self, message: str, recipient: str):
        print(f"Sending to {recipient}: {message}")

class ApplicationFacade:
    def __init__(self):
        self.auth = AuthService()
        self.db = DatabaseService()
        self.cache = CacheService()
        self.notifier = NotificationService()

    def get_user_data(self, token: str, user_id: int):
        user = self.auth.authenticate(token)
        if not user:
            raise ValueError("Invalid token")

        cache_key = f"user:{user_id}"
        cached = self.cache.get(cache_key)
        if cached:
            return cached

        data = self.db.query(f"SELECT * FROM users WHERE id = {user_id}")
        self.cache.set(cache_key, data)
        return data

    def notify_user(self, token: str, user_id: int, message: str):
        user = self.auth.authenticate(token)
        if not user:
            raise ValueError("Invalid token")
        self.notifier.send(message, f"user_{user_id}")

# Usage - simple interface to complex system
app = ApplicationFacade()
users = app.get_user_data("token123", 1)
app.notify_user("token123", 1, "Your order shipped!")
```

---

### Flyweight

**Intent:** Use sharing to support large numbers of fine-grained objects efficiently.

**Problem:** Large number of similar objects consume too much memory.

**When to use:**
- Large number of similar objects
- Most object state can be made extrinsic
- Memory efficiency is critical

**When NOT to use:**
- Objects are unique (no sharing)
- Object count is low
- Simpler solutions work

```python
class TreeType:
    def __init__(self, name: str, color: str, texture: str):
        self.name = name
        self.color = color
        self.texture = texture

    def draw(self, x: int, y: int):
        print(f"Drawing {self.color} {self.name} at ({x}, {y})")

class TreeFactory:
    _types: dict = {}

    @classmethod
    def get_tree_type(cls, name: str, color: str, texture: str) -> TreeType:
        key = (name, color, texture)
        if key not in cls._types:
            cls._types[key] = TreeType(name, color, texture)
            print(f"Created new TreeType: {name}")
        else:
            print(f"Reusing existing TreeType: {name}")
        return cls._types[key]

class Tree:
    def __init__(self, x: int, y: int, tree_type: TreeType):
        self.x = x
        self.y = y
        self.type = tree_type

    def draw(self):
        self.type.draw(self.x, self.y)

class Forest:
    def __init__(self):
        self.trees: list[Tree] = []

    def plant_tree(self, x: int, y: int, name: str, color: str, texture: str):
        tree_type = TreeFactory.get_tree_type(name, color, texture)
        tree = Tree(x, y, tree_type)
        self.trees.append(tree)

    def draw_all(self):
        for tree in self.trees:
            tree.draw()

# Usage - shared tree types, many instances
forest = Forest()
forest.plant_tree(1, 2, "Oak", "green", "rough")
forest.plant_tree(3, 4, "Oak", "green", "rough")  # Reuses type
forest.plant_tree(5, 6, "Pine", "dark green", "smooth")  # New type
forest.draw_all()
```

---

### Proxy

**Intent:** Provide a surrogate or placeholder for another object to control access to it.

**Problem:** Need to control access to an object (lazy loading, access control, logging).

**When to use:**
- Lazy initialization needed
- Access control required
- Remote object representation needed
- Logging/monitoring access

**When NOT to use:**
- Direct access is fine
- No access control needed
- Proxy adds unnecessary indirection

```python
from abc import ABC, abstractmethod

class ExpensiveResource(ABC):
    @abstractmethod
    def get_data(self) -> str:
        pass

class RealResource(ExpensiveResource):
    def __init__(self):
        print("Initializing expensive resource...")
        self._data = None

    def get_data(self) -> str:
        if self._data is None:
            self._data = "Expensive data loaded from source"
        return self._data

class ProxyResource(ExpensiveResource):
    def __init__(self):
        self._real_resource: RealResource | None = None

    def get_data(self) -> str:
        if self._real_resource is None:
            self._real_resource = RealResource()
        return self._real_resource.get_data()

# Usage - lazy loading via proxy
print("Creating proxy...")
data = ProxyResource().get_data()  # Initializes real resource on first use
print(f"Data: {data}")
```

---

## Behavioral Patterns

Behavioral patterns are concerned with algorithms and the assignment of responsibilities between objects.

---

### Chain of Responsibility

**Intent:** Pass a request along a chain of handlers. Each handler decides to process or pass along.

**Problem:** More than one object might handle a request.

**When to use:**
- Multiple handlers possible for a request
- Handler shouldn't know about other handlers
- Request should be handled by one of several handlers

**When NOT to use:**
- Single handler is sufficient
- Handler needs to know all other handlers
- Request should go to all handlers

```python
from abc import ABC, abstractmethod

class Request:
    def __init__(self, data: dict):
        self.data = data
        self.handled = False

class Handler(ABC):
    def __init__(self, next_handler: 'Handler | None' = None):
        self._next = next_handler

    def handle(self, request: Request):
        if self._can_handle(request):
            self._process(request)
        elif self._next:
            self._next.handle(request)

    @abstractmethod
    def _can_handle(self, request: Request) -> bool:
        pass

    @abstractmethod
    def _process(self, request: Request):
        pass

class AuthHandler(Handler):
    def _can_handle(self, request: Request) -> bool:
        return "token" in request.data

    def _process(self, request: Request):
        print(f"Authenticating with token: {request.data['token'][:10]}...")
        request.handled = True

class LoggingHandler(Handler):
    def _can_handle(self, request: Request) -> bool:
        return True  # Always log

    def _process(self, request: Request):
        print(f"Logging request: {request.data}")

class ValidationHandler(Handler):
    def _can_handle(self, request: Request) -> bool:
        return "data" in request.data

    def _process(self, request: Request):
        print(f"Validating data: {request.data['data']}")
        request.handled = True

# Usage - chain of handlers
chain = AuthHandler(LoggingHandler(ValidationHandler(None)))
request = Request({"token": "abc123xyz", "data": "test"})
chain.handle(request)
```

---

### Command

**Intent:** Encapsulate a request as an object, allowing parameterization and queuing.

**Problem:** Need to parameterize objects with operations, queue operations, or support undo.

**When to use:**
- Parameterize objects with operations
- Queue operations for later execution
- Support undo/redo
- Log operations

**When NOT to use:**
- Simple operations that don't need parameterization
- No need for queuing or undo
- Simpler function calls work

```python
from abc import ABC, abstractmethod

class Command(ABC):
    @abstractmethod
    def execute(self): pass
    @abstractmethod
    def undo(self): pass

class Light:
    def __init__(self):
        self._is_on = False

    def on(self):
        self._is_on = True
        print("Light is ON")

    def off(self):
        self._is_on = False
        print("Light is OFF")

    def get_state(self) -> str:
        return "ON" if self._is_on else "OFF"

class LightOnCommand(Command):
    def __init__(self, light: Light):
        self._light = light

    def execute(self):
        self._light.on()

    def undo(self):
        self._light.off()

class LightOffCommand(Command):
    def __init__(self, light: Light):
        self._light = light

    def execute(self):
        self._light.off()

    def undo(self):
        self._light.on()

class RemoteControl:
    def __init__(self):
        self._history: list[Command] = []

    def execute(self, command: Command):
        command.execute()
        self._history.append(command)

    def undo_last(self):
        if self._history:
            command = self._history.pop()
            command.undo()

# Usage - encapsulate operations
light = Light()
remote = RemoteControl()

remote.execute(LightOnCommand(light))
remote.execute(LightOffCommand(light))
remote.undo_last()  # Turns light back on
```

---

### Iterator

**Intent:** Provide a way to access elements of a collection without exposing its underlying representation.

**Problem:** Need to traverse a collection without knowing its internal structure.

**When to use:**
- Traverse different collections uniformly
- Hide internal structure from clients
- Multiple traversal simultaneous

**When NOT to use:**
- Built-in iteration is sufficient
- Simple collection (list, dict)
- Don't need multiple traversals

```python
from abc import ABC, abstractmethod

class Iterator(ABC):
    @abstractmethod
    def has_next(self) -> bool: pass
    @abstractmethod
    def next(self): pass

class ListIterator(Iterator):
    def __init__(self, items: list):
        self._items = items
        self._position = 0

    def has_next(self) -> bool:
        return self._position < len(self._items)

    def next(self):
        item = self._items[self._position]
        self._position += 1
        return item

class Collection(ABC):
    @abstractmethod
    def create_iterator(self) -> Iterator: pass

class OrderedCollection(Collection):
    def __init__(self, items: list):
        self._items = items

    def create_iterator(self) -> Iterator:
        return ListIterator(self._items)

    def add(self, item):
        self._items.append(item)

# Usage - uniform traversal
collection = OrderedCollection([1, 2, 3, 4, 5])
iterator = collection.create_iterator()

while iterator.has_next():
    print(iterator.next(), end=" ")
print()  # 1 2 3 4 5
```

---

### Mediator

**Intent:** Define an object that encapsulates how a set of objects interact.

**Problem:** Objects communicate directly, creating tight coupling.

**When to use:**
- Objects communicate in complex ways
- Tight coupling between objects
- Want to centralize communication logic

**When NOT to use:**
- Simple communication
- Objects rarely interact
- Direct communication is clearer

```python
from abc import ABC, abstractmethod

class Mediator(ABC):
    @abstractmethod
    def notify(self, sender: object, event: str): pass

class ChatRoom(Mediator):
    def __init__(self):
        self._users: list['User'] = []

    def notify(self, sender: object, event: str):
        for user in self._users:
            if user != sender:
                user.receive(event)

    def add_user(self, user: 'User'):
        self._users.append(user)

class User:
    def __init__(self, name: str, mediator: Mediator):
        self.name = name
        self._mediator = mediator

    def send(self, message: str):
        print(f"{self.name} sends: {message}")
        self._mediator.notify(self, f"{self.name}: {message}")

    def receive(self, message: str):
        print(f"{self.name} receives: {message}")

# Usage - centralize communication
chat = ChatRoom()
alice = User("Alice", chat)
bob = User("Bob", chat)
charlie = User("Charlie", chat)

chat.add_user(alice)
chat.add_user(bob)
chat.add_user(charlie)

alice.send("Hello everyone!")
bob.send("Hi Alice!")
```

---

### Memento

**Intent:** Capture and externalize an object's internal state for later restoration.

**Problem:** Need to save and restore object state without violating encapsulation.

**When to use:**
- Need to save/restore state
- Undo functionality needed
- Checkpoint/restore capability

**When NOT to use:**
- Simple state (no need for encapsulation)
- Too much memory for mementos
- State changes frequently

```python
class EditorMemento:
    def __init__(self, content: str):
        self._content = content

    def get_content(self) -> str:
        return self._content

class Editor:
    def __init__(self):
        self._content = ""

    def type(self, text: str):
        self._content += text

    def get_content(self) -> str:
        return self._content

    def save(self) -> EditorMemento:
        return EditorMemento(self._content)

    def restore(self, memento: EditorMemento):
        self._content = memento.get_content()

class History:
    def __init__(self):
        self._mementos: list[EditorMemento] = []

    def push(self, memento: EditorMemento):
        self._mementos.append(memento)

    def pop(self) -> EditorMemento | None:
        if self._mementos:
            return self._mementos.pop()
        return None

# Usage - save and restore state
editor = Editor()
history = History()

editor.type("Hello ")
history.push(editor.save())

editor.type("World!")
print(f"Current: {editor.get_content()}")  # Hello World!

editor.restore(history.pop())
print(f"Restored: {editor.get_content()}")  # Hello
```

---

### Observer

**Intent:** Define a one-to-many dependency so that when one object changes, all dependents are notified.

**Problem:** Changes in one object need to be reflected in others automatically.

**When to use:**
- One object changes need to update many others
- Event handling needed
- Loose coupling between subject and observers

**When NOT to use:**
- Simple one-to-one relationship
- Direct calls are simpler
- Synchronous updates not acceptable

```python
from abc import ABC, abstractmethod

class Observer(ABC):
    @abstractmethod
    def update(self, message: str): pass

class Subject(ABC):
    def __init__(self):
        self._observers: list[Observer] = []

    def attach(self, observer: Observer):
        self._observers.append(observer)

    def detach(self, observer: Observer):
        self._observers.remove(observer)

    def notify(self, message: str):
        for observer in self._observers:
            observer.update(message)

class NewsAgency(Subject):
    def __init__(self):
        super().__init__()
        self._latest_news = ""

    def set_news(self, news: str):
        self._latest_news = news
        self.notify(f"Breaking: {news}")

    def get_news(self) -> str:
        return self._latest_news

class NewsChannel(Observer):
    def __init__(self, name: str):
        self.name = name

    def update(self, message: str):
        print(f"{self.name} broadcasting: {message}")

# Usage - event-driven updates
news_agency = NewsAgency()
cnn = NewsChannel("CNN")
bbc = NewsChannel("BBC")

news_agency.attach(cnn)
news_agency.attach(bbc)

news_agency.set_news("New discovery in AI!")
# Both CNN and BBC receive the update
```

---

### State

**Intent:** Allow an object to alter its behavior when its internal state changes.

**Problem:** Object behavior depends on its state, and state can change at runtime.

**When to use:**
- Object behavior depends on state
- State transitions are complex
- Avoid large conditionals

**When NOT to use:**
- Simple state (few states, simple transitions)
- State rarely changes
- Hardcoded behavior is fine

```python
from abc import ABC, abstractmethod

class State(ABC):
    @abstractmethod
    def handle(self, context: 'OrderContext'): pass

class OrderContext:
    def __init__(self):
        self._state: State = PendingState()

    def set_state(self, state: State):
        self._state = state

    def request(self):
        self._state.handle(self)

class PendingState(State):
    def handle(self, context: OrderContext):
        print("Order is pending - processing payment")
        context.set_state(ConfirmedState())

class ConfirmedState(State):
    def handle(self, context: OrderContext):
        print("Order confirmed - preparing shipment")
        context.set_state(ShippedState())

class ShippedState(State):
    def handle(self, context: OrderContext):
        print("Order shipped - delivered to customer")
        context.set_state(DeliveredState())

class DeliveredState(State):
    def handle(self, context: OrderContext):
        print("Order completed")

# Usage - behavior changes with state
order = OrderContext()
order.request()
order.request()
order.request()
order.request()
```

---

### Strategy

**Intent:** Define a family of algorithms, encapsulate each one, and make them interchangeable.

**Problem:** Need to switch algorithms at runtime or avoid conditionals.

**When to use:**
- Multiple algorithms for a task
- Need to switch algorithms at runtime
- Avoid complex conditionals for algorithm selection

**When NOT to use:**
- Single algorithm needed
- Algorithms rarely change
- Simple function selection works

```python
from abc import ABC, abstractmethod

class PaymentStrategy(ABC):
    @abstractmethod
    def pay(self, amount: float): pass

class CreditCardPayment(PaymentStrategy):
    def __init__(self, card_number: str):
        self._card = card_number

    def pay(self, amount: float):
        print(f"Paid ${amount:.2f} with Credit Card ending in {self._card[-4:]}")

class PayPalPayment(PaymentStrategy):
    def __init__(self, email: str):
        self._email = email

    def pay(self, amount: float):
        print(f"Paid ${amount:.2f} via PayPal account {self._email}")

class CryptoPayment(PaymentStrategy):
    def __init__(self, wallet: str):
        self._wallet = wallet

    def pay(self, amount: float):
        print(f"Paid ${amount:.2f} in BTC to wallet {self._wallet[:8]}...")

class ShoppingCart:
    def __init__(self):
        self._items: list[tuple[str, float]] = []

    def add_item(self, name: str, price: float):
        self._items.append((name, price))

    def total(self) -> float:
        return sum(price for _, price in self._items)

    def checkout(self, strategy: PaymentStrategy):
        total = self.total()
        strategy.pay(total)

# Usage - interchangeable payment methods
cart = ShoppingCart()
cart.add_item("Laptop", 999.99)
cart.add_item("Mouse", 49.99)

cart.checkout(CreditCardPayment("4111111111111111"))
cart.checkout(PayPalPayment("user@example.com"))
cart.checkout(CryptoPayment("1a2b3c4d5e6f7g8h9i0j"))
```

---

### Template Method

**Intent:** Define the skeleton of an algorithm, deferring some steps to subclasses.

**Problem:** Algorithm structure is the same, but some steps vary.

**When to use:**
- Common algorithm structure with variant parts
- Framework with extension points
- Code reuse through inheritance

**When NOT to use:**
- Simple algorithms
- Too many variations in subclasses
- Composition is better

```python
from abc import ABC, abstractmethod

class DataProcessor(ABC):
    def process(self, data: str) -> str:
        validated = self.validate(data)
        transformed = self.transform(validated)
        return self.save(transformed)

    def validate(self, data: str) -> str:
        return data.strip()

    @abstractmethod
    def transform(self, data: str) -> str:
        pass

    def save(self, data: str) -> str:
        return f"Saved: {data}"

class UppercaseProcessor(DataProcessor):
    def transform(self, data: str) -> str:
        return data.upper()

class LowercaseProcessor(DataProcessor):
    def transform(self, data: str) -> str:
        return data.lower()

class HashProcessor(DataProcessor):
    def transform(self, data: str) -> str:
        import hashlib
        return hashlib.sha256(data.encode()).hexdigest()

# Usage - same algorithm, different implementations
data = "  Hello World  "

upper = UppercaseProcessor()
print(upper.process(data))  # Saved: HELLO WORLD

lower = LowercaseProcessor()
print(lower.process(data))  # Saved: hello world

hashed = HashProcessor()
print(hashed.process(data))  # Saved: [sha256 hash]
```

---

### Visitor

**Intent:** Represent an operation to be performed on elements of an object structure.

**Problem:** Need to perform operations on elements without changing their classes.

**When to use:**
- Operations on elements of different classes
- Elements rarely change, operations often change
- Separate operation from object structure

**When NOT to use:**
- Elements change frequently
- Simple operations
- Single class hierarchy

```python
from abc import ABC, abstractmethod

class Element(ABC):
    @abstractmethod
    def accept(self, visitor: 'Visitor'): pass

class NumberElement(Element):
    def __init__(self, value: int):
        self.value = value

    def accept(self, visitor: 'Visitor'):
        visitor.visit_number(self)

class StringElement(Element):
    def __init__(self, value: str):
        self.value = value

    def accept(self, visitor: 'Visitor'):
        visitor.visit_string(self)

class Visitor(ABC):
    @abstractmethod
    def visit_number(self, element: NumberElement): pass
    @abstractmethod
    def visit_string(self, element: StringElement): pass

class PrintVisitor(Visitor):
    def visit_number(self, element: NumberElement):
        print(f"Number: {element.value}")

    def visit_string(self, element: StringElement):
        print(f"String: {element.value}")

class SumVisitor(Visitor):
    def __init__(self):
        self.total = 0

    def visit_number(self, element: NumberElement):
        self.total += element.value

    def visit_string(self, element: StringElement):
        pass  # Ignore strings for sum

# Usage - operations separated from elements
elements = [NumberElement(10), StringElement("hello"), NumberElement(20)]

print_visitor = PrintVisitor()
for element in elements:
    element.accept(print_visitor)

sum_visitor = SumVisitor()
for element in elements:
    element.accept(sum_visitor)
print(f"Sum: {sum_visitor.total}")  # Sum: 30
```

---

# Part 2: Backend/DevOps Patterns

---

### Dependency Injection

**Intent:** Pass dependencies to objects rather than having them create dependencies.

**Problem:** Hardcoded dependencies make testing difficult and coupling tight.

**When to use:**
- Writing testable code
- Need loose coupling
- Framework requires DI (FastAPI, Spring)

**When NOT to use:**
- Simple scripts
- Testing not needed
- Dependencies are stable

```python
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def query(self, sql: str): pass

class PostgreSQL(Database):
    def query(self, sql: str):
        return f"PostgreSQL executing: {sql}"

class SQLite(Database):
    def query(self, sql: str):
        return f"SQLite executing: {sql}"

class UserService:
    def __init__(self, db: Database):  # Injected dependency
        self._db = db

    def get_user(self, user_id: int):
        return self._db.query(f"SELECT * FROM users WHERE id = {user_id}")

# Usage - dependencies injected, easy to swap
pg_service = UserService(PostgreSQL())
print(pg_service.get_user(1))

sqlite_service = UserService(SQLite())
print(sqlite_service.get_user(1))
```

---

### Repository

**Intent:** Mediate between the domain and data mapping layers using a collection-like interface.

**Problem:** Database access logic pollutes domain logic.

**When to use:**
- Need to abstract data access
- Multiple data sources possible
- Testing requires mock data access

**When NOT to use:**
- Simple CRUD operations
- Single data source, always
- ORM already provides abstraction

```python
from abc import ABC, abstractmethod

class Entity:
    def __init__(self, id: int | None = None):
        self.id = id

class User(Entity):
    def __init__(self, id: int | None, name: str, email: str):
        super().__init__(id)
        self.name = name
        self.email = email

class Repository(ABC):
    @abstractmethod
    def get_by_id(self, id: int) -> Entity | None: pass
    @abstractmethod
    def get_all(self) -> list[Entity]: pass
    @abstractmethod
    def save(self, entity: Entity): pass
    @abstractmethod
    def delete(self, id: int): pass

class InMemoryUserRepository(Repository):
    def __init__(self):
        self._users: dict[int, User] = {}
        self._next_id = 1

    def get_by_id(self, id: int) -> User | None:
        return self._users.get(id)

    def get_all(self) -> list[User]:
        return list(self._users.values())

    def save(self, user: User):
        if user.id is None:
            user.id = self._next_id
            self._next_id += 1
        self._users[user.id] = user
        return user

    def delete(self, id: int):
        if id in self._users:
            del self._users[id]

# Usage - abstract data access
repo = InMemoryUserRepository()
repo.save(User(None, "Alice", "alice@example.com"))
repo.save(User(None, "Bob", "bob@example.com"))

all_users = repo.get_all()
for user in all_users:
    print(f"{user.id}: {user.name}")

bob = repo.get_by_id(2)
print(f"Found: {bob.name}")
```

---

### Circuit Breaker

**Intent:** Detect failures and prevent cascading failures by failing fast.

**Problem:** Remote service failures cause system-wide issues.

**When to use:**
- Calling unreliable remote services
- Preventing cascade failures
- Need graceful degradation

**When NOT to use:**
- Local, reliable services
- Simple applications
- Failure is acceptable

```python
import time
from enum import Enum

class CircuitState(Enum):
    CLOSED = "closed"
    OPEN = "open"
    HALF_OPEN = "half_open"

class CircuitBreaker:
    def __init__(self, failure_threshold: int = 3, timeout: float = 5.0):
        self._state = CircuitState.CLOSED
        self._failure_count = 0
        self._failure_threshold = failure_threshold
        self._timeout = timeout
        self._last_failure_time = 0

    def call(self, func, *args, **kwargs):
        if self._state == CircuitState.OPEN:
            if time.time() - self._last_failure_time > self._timeout:
                self._state = CircuitState.HALF_OPEN
            else:
                raise Exception("Circuit is OPEN")

        try:
            result = func(*args, **kwargs)
            self._on_success()
            return result
        except Exception as e:
            self._on_failure()
            raise e

    def _on_success(self):
        self._failure_count = 0
        self._state = CircuitState.CLOSED

    def _on_failure(self):
        self._failure_count += 1
        self._last_failure_time = time.time()
        if self._failure_count >= self._failure_threshold:
            self._state = CircuitState.OPEN

# Usage - fail fast when service is down
def unreliable_service():
    raise Exception("Service unavailable")

breaker = CircuitBreaker(failure_threshold=2, timeout=3)

for i in range(5):
    try:
        breaker.call(unreliable_service)
    except Exception as e:
        print(f"Attempt {i+1}: {e}")
        print(f"Circuit state: {breaker._state.value}")
```

---

### Connection Pool

**Intent:** Reuse and manage a pool of database/service connections efficiently.

**Problem:** Creating new connections is expensive; too many connections overwhelm services.

**When to use:**
- Database connections
- HTTP connection management
- Any resource with creation overhead

**When NOT to use:**
- Stateless, quick operations
- Connection per request is fine
- Simple applications

```python
import threading
import time
from queue import Queue

class Connection:
    def __init__(self, id: int):
        self.id = id
        self.created_at = time.time()

    def is_valid(self) -> bool:
        return True  # Simplified check

class ConnectionPool:
    def __init__(self, min_size: int = 2, max_size: int = 10):
        self._min_size = min_size
        self._max_size = max_size
        self._pool: Queue[Connection] = Queue()
        self._lock = threading.Lock()
        self._created = 0

        for _ in range(min_size):
            self._pool.put(self._create_connection())

    def _create_connection(self) -> Connection:
        with self._lock:
            self._created += 1
            return Connection(self._created)

    def get_connection(self, timeout: float = 5.0) -> Connection:
        try:
            conn = self._pool.get(timeout=timeout)
            if not conn.is_valid():
                conn = self._create_connection()
            return conn
        except:
            with self._lock:
                if self._created < self._max_size:
                    return self._create_connection()
            raise TimeoutError("No available connections")

    def return_connection(self, conn: Connection):
        self._pool.put(conn)

    def close_all(self):
        while not self._pool.empty():
            self._pool.get()

# Usage - connection reuse
pool = ConnectionPool(min_size=2, max_size=5)

conn1 = pool.get_connection()
print(f"Using connection {conn1.id}")
pool.return_connection(conn1)

conn2 = pool.get_connection()
print(f"Using connection {conn2.id}")
pool.return_connection(conn2)
```

---

### Retry Pattern

**Intent:** Automatically retry failed operations with configurable backoff.

**Problem:** Transient failures cause immediate failures without retry.

**When to use:**
- Network operations
- Transient failures expected
- Operations that may succeed on retry

**When NOT to use:**
- Idempotent operations only
- Failures are permanent
- Too many retries cause delays

```python
import time
import random

class RetryPolicy:
    def __init__(self, max_attempts: int = 3, base_delay: float = 1.0, max_delay: float = 10.0, backoff_factor: float = 2.0):
        self.max_attempts = max_attempts
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.backoff_factor = backoff_factor

    def get_delay(self, attempt: int) -> float:
        delay = min(self.base_delay * (self.backoff_factor ** attempt), self.max_delay)
        return delay

def retry(policy: RetryPolicy, func, *args, **kwargs):
    last_exception = None
    
    for attempt in range(policy.max_attempts):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            last_exception = e
            if attempt < policy.max_attempts - 1:
                delay = policy.get_delay(attempt)
                print(f"Attempt {attempt + 1} failed: {e}. Retrying in {delay:.1f}s...")
                time.sleep(delay)
    
    raise last_exception

# Usage - retry with exponential backoff
def unreliable_operation():
    if random.random() < 0.7:
        raise ConnectionError("Connection failed")
    return "Success!"

policy = RetryPolicy(max_attempts=3, base_delay=0.5)
result = retry(policy, unreliable_operation)
print(f"Result: {result}")
```

---

# Part 3: Concurrency Patterns

---

### Producer-Consumer

**Intent:** Decouple production and consumption of data across different execution speeds.

**Problem:** Producers and consumers work at different rates.

**When to use:**
- Batch processing
- Async task queues
- Different processing speeds

**When NOT to use:**
- Simple synchronous operations
- Same production/consumption rate
- No buffering needed

```python
import threading
import time
from queue import Queue

def producer(queue: Queue, item_count: int):
    for i in range(item_count):
        time.sleep(0.1)  # Simulate work
        queue.put(f"Item-{i}")
        print(f"Produced: Item-{i}")
    queue.put(None)  # Signal completion

def consumer(queue: Queue):
    while True:
        item = queue.get()
        if item is None:
            break
        time.sleep(0.2)  # Slower consumer
        print(f"Consumed: {item}")
        queue.task_done()

# Usage - balanced production/consumption
queue = Queue(maxsize=5)

producer_thread = threading.Thread(target=producer, args=(queue, 10))
consumer_thread = threading.Thread(target=consumer, args=(queue,))

producer_thread.start()
consumer_thread.start()

producer_thread.join()
queue.join()
print("All done!")
```

---

### Thread Pool

**Intent:** Reuse a fixed number of threads to execute multiple tasks.

**Problem:** Creating threads for each task is expensive.

**When to use:**
- Many short-lived tasks
- Need to limit concurrent threads
- Task submission and execution separation

**When NOT to use:**
- Few, long-running tasks
- Sequential execution needed
- Simple processes

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(task_id: int) -> str:
    time.sleep(0.5)  # Simulate work
    return f"Task {task_id} completed"

# Usage - fixed thread pool
with ThreadPoolExecutor(max_workers=4) as executor:
    futures = [executor.submit(task, i) for i in range(8)]
    
    for future in futures:
        print(future.result())

print("All tasks completed")
```

---

### Future/Promise

**Intent:** Represent a value that will be available in the future.

**Problem:** Need to handle async results and their dependencies.

**When to use:**
- Async operations
- Chaining dependent operations
- Composing async results

**When NOT to use:**
- Simple synchronous code
- No async requirements
- Callbacks are sufficient

```python
import concurrent.futures
import time

def fetch_data(source: str) -> str:
    time.sleep(1)  # Simulate network call
    return f"Data from {source}"

def process_data(data: str) -> str:
    time.sleep(0.5)  # Simulate processing
    return f"Processed: {data}"

# Usage - futures for async operations
with concurrent.futures.ThreadPoolExecutor() as executor:
    future1 = executor.submit(fetch_data, "API")
    future2 = executor.submit(fetch_data, "Database")
    
    results = concurrent.futures.wait([future1, future2])
    
    for f in results.done:
        print(f.result())

# Chaining futures
with concurrent.futures.ThreadPoolExecutor() as executor:
    future = executor.submit(fetch_data, "API")
    chained = future.then(process_data)
    print(chained.result())
```

---

### Read-Write Lock

**Intent:** Allow multiple readers or single writer access to a resource.

**Problem:** Need concurrent read access but exclusive write access.

**When to use:**
- Frequent reads, infrequent writes
- Need to protect shared state
- Performance matters

**When NOT to use:**
- Equal read/write frequency
- Simple operations
- Single thread

```python
import threading
import time

class ReadWriteLock:
    def __init__(self):
        self._read_ready = threading.Condition(threading.Lock())
        self._readers = 0

    def acquire_read(self):
        with self._read_ready:
            self._readers += 1

    def release_read(self):
        with self._read_ready:
            self._readers -= 1
            if self._readers == 0:
                self._read_ready.notify_all()

    def acquire_write(self):
        self._read_ready.acquire()
        while self._readers > 0:
            self._read_ready.wait()

    def release_write(self):
        self._read_ready.release()

class ProtectedData:
    def __init__(self):
        self._data = 0
        self._lock = ReadWriteLock()

    def read(self) -> int:
        self._lock.acquire_read()
        try:
            return self._data
        finally:
            self._lock.release_read()

    def write(self, value: int):
        self._lock.acquire_write()
        try:
            self._data = value
        finally:
            self._lock.release_write()

# Usage - concurrent reads, exclusive writes
data = ProtectedData()

def reader(reader_id: int):
    for _ in range(3):
        val = data.read()
        print(f"Reader {reader_id} read: {val}")
        time.sleep(0.1)

def writer(writer_id: int):
    for i in range(3):
        data.write(i)
        print(f"Writer {writer_id} wrote: {i}")
        time.sleep(0.1)

threads = [
    threading.Thread(target=reader, args=(1,)),
    threading.Thread(target=reader, args=(2,)),
    threading.Thread(target=writer, args=(1,)),
]

for t in threads:
    t.start()
for t in threads:
    t.join()
