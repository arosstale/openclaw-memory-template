# OpenClaw Observational Memory API Reference

Complete API reference for the Observational Memory system.

---

## Classes

### `ObservationalMemory`

Main Observational Memory system.

#### Constructor

```python
ObservationalMemory(config: Optional[ObservationConfig] = None)
```

**Parameters:**
- `config` (Optional[ObservationConfig]): Configuration object. If None, uses defaults.

#### Methods

##### `process_messages()`

Process new messages through observational memory pipeline.

```python
process_messages(
    thread_id: str,
    messages: List[Dict],
    existing_observations: str = ""
) -> ObservationalMemoryRecord
```

**Parameters:**
- `thread_id` (str): Thread identifier
- `messages` (List[Dict]): List of message dicts with `role`, `content`, `timestamp`
- `existing_observations` (str): Existing observations text (optional)

**Returns:**
- `ObservationalMemoryRecord`: Updated memory record

**Example:**
```python
messages = [
    {"role": "user", "content": "Hello!", "timestamp": datetime.now()},
]
record = om.process_messages("thread-123", messages)
```

##### `get_context()`

Get formatted context for main agent.

```python
get_context(thread_id: str) -> str
```

**Parameters:**
- `thread_id` (str): Thread identifier

**Returns:**
- `str`: Formatted context string

**Example:**
```python
context = om.get_context("thread-123")
print(context)
```

##### `get_stats()`

Get statistics about observational memory.

```python
get_stats(thread_id: str) -> Dict
```

**Parameters:**
- `thread_id` (str): Thread identifier

**Returns:**
- `Dict`: Statistics dictionary

**Example:**
```python
stats = om.get_stats("thread-123")
print(stats["total_observations"])
```

##### `force_reflection()`

Force reflection on a thread.

```python
force_reflection(thread_id: str) -> str
```

**Parameters:**
- `thread_id` (str): Thread identifier

**Returns:**
- `str`: Result message

**Example:**
```python
result = om.force_reflection("thread-123")
print(result)  # "✅ Reflection complete. 10 observations"
```

---

### `ObservationConfig`

Configuration for Observational Memory.

#### Fields

```python
@dataclass
class ObservationConfig:
    observation_threshold: int = 30000      # Observer trigger threshold
    reflection_threshold: int = 40000      # Reflector trigger threshold
    observer_temperature: float = 0.3        # Observer LLM temperature
    reflector_temperature: float = 0.0        # Reflector LLM temperature
    llm_provider: str = "anthropic"          # LLM provider
    use_tiktoken: bool = True                # Use Tiktoken for counting
    db_path: str = ".openclaw/observational_memory.db"
```

#### Example

```python
config = ObservationConfig(
    observation_threshold=30000,
    reflection_threshold=40000,
    observer_temperature=0.3,
    reflector_temperature=0.0,
    llm_provider="anthropic",
    use_tiktoken=True,
)
om = ObservationalMemory(config)
```

---

### `Observation`

A single observation with temporal context.

#### Fields

```python
@dataclass
class Observation:
    timestamp: datetime                      # When observation was made
    priority: str                             # Priority emoji (🔴🟡🟢)
    content: str                              # Observation content
    referenced_date: Optional[datetime] = None  # Referenced date (optional)
```

#### Example

```python
from datetime import datetime
from openclaw.observational_memory.types import Observation, PriorityLevel

obs = Observation(
    timestamp=datetime.now(),
    priority=PriorityLevel.RED,
    content="User stated they work at Google",
    referenced_date=None,
)
```

---

### `ObservationalMemoryRecord`

Complete observational memory for a thread.

#### Fields

```python
@dataclass
class ObservationalMemoryRecord:
    observations: list[Observation]    # List of observations
    current_task: str = ""             # Current task (optional)
    suggested_response: str = ""       # Suggested response (optional)
    last_observed_at: Optional[datetime] = None  # Last observation time
```

---

### `PriorityLevel`

Priority levels for observations.

#### Constants

```python
class PriorityLevel:
    RED = "🔴"      # High priority
    YELLOW = "🟡"    # Medium priority
    GREEN = "🟢"     # Low priority
```

---

## LLM Client

### `get_llm_client()`

Get LLM client by provider.

```python
get_llm_client(
    provider: str = "anthropic",
    api_key: Optional[str] = None
) -> LLMClient
```

**Parameters:**
- `provider` (str): "anthropic", "openai", or "google"
- `api_key` (Optional[str]): API key (defaults to env var)

**Returns:**
- `LLMClient`: LLM client instance

**Example:**
```python
from openclaw.observational_memory.llm_client import get_llm_client

client = get_llm_client("anthropic")
response = client.generate("Hello!")
```

---

## Token Counter

### `get_token_counter()`

Get token counter instance.

```python
get_token_counter(encoding: str = "cl100k_base") -> TokenCounter
```

**Parameters:**
- `encoding` (str): Tiktoken encoding name

**Returns:**
- `TokenCounter`: Token counter instance

**Example:**
```python
from openclaw.observational_memory.tiktoken_counter import get_token_counter

counter = get_token_counter()
count = counter.count_tokens("Hello, world!")
print(count)  # 4
```

---

## CLI Tool

### Commands

#### `observe`

Observe messages from file or stdin.

```bash
python scripts/observational-memory-cli.py observe <thread> [-f <file>]
```

**Example:**
```bash
# From file
python scripts/observational-memory-cli.py observe thread-123 -f messages.json

# From stdin
echo '[{"role":"user","content":"Hello"}]' | python scripts/observational-memory-cli.py observe thread-123
```

#### `context`

Get context for a thread.

```bash
python scripts/observational-memory-cli.py context <thread>
```

**Example:**
```bash
python scripts/observational-memory-cli.py context thread-123
```

#### `stats`

Get statistics for a thread.

```bash
python scripts/observational-memory-cli.py stats <thread>
```

**Example:**
```bash
python scripts/observational-memory-cli.py stats thread-123
```

#### `reflect`

Force reflection on a thread.

```bash
python scripts/observational-memory-cli.py reflect <thread>
```

**Example:**
```bash
python scripts/observational-memory-cli.py reflect thread-123
```

#### `list`

List all threads.

```bash
python scripts/observational-memory-cli.py list
```

---

## Environment Variables

| Variable | Description | Required |
|-----------|-------------|-----------|
| `ANTHROPIC_API_KEY` | Anthropic API key | Yes (if using Anthropic) |
| `OPENAI_API_KEY` | OpenAI API key | Yes (if using OpenAI) |
| `GOOGLE_API_KEY` | Google API key | Yes (if using Google) |

---

## Examples

### Basic Usage

```python
from openclaw.observational_memory import ObservationalMemory
from datetime import datetime

# Initialize
om = ObservationalMemory()

# Process messages
messages = [
    {"role": "user", "content": "I have 2 kids", "timestamp": datetime.now()},
    {"role": "user", "content": "I work at Google", "timestamp": datetime.now()},
]
record = om.process_messages("thread-123", messages)

# Get context
context = om.get_context("thread-123")
print(context)

# Get stats
stats = om.get_stats("thread-123")
print(f"Observations: {stats['total_observations']}")
```

### With Custom Configuration

```python
from openclaw.observational_memory import ObservationalMemory, ObservationConfig

# Custom config
config = ObservationConfig(
    observation_threshold=30000,
    reflection_threshold=40000,
    llm_provider="openai",
    use_tiktoken=True,
)

# Initialize with config
om = ObservationalMemory(config)
```

### Using Different LLM Providers

```python
# Anthropic (default)
config = ObservationConfig(llm_provider="anthropic")
om = ObservationalMemory(config)

# OpenAI
config = ObservationConfig(llm_provider="openai")
om = ObservationalMemory(config)

# Google
config = ObservationConfig(llm_provider="google")
om = ObservationalMemory(config)
```

---

🐺📿 **OpenClaw Observational Memory API Reference**
