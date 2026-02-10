# Contributing to OpenClaw Memory Template

Thank you for your interest in contributing to the OpenClaw Memory Template!

---

## How to Contribute

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/openclaw-memory-template.git
cd openclaw-memory-template
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 3. Make Your Changes

- Follow the existing code style
- Add tests for new features
- Update documentation

### 4. Run Tests

```bash
# Run Observational Memory tests
python3 test_observational_memory.py

# Run GEPA validation
bash scripts/gepa-test.sh
```

### 5. Commit and Push

```bash
git add .
git commit -m "feat: add your feature"
git push origin feature/your-feature-name
```

### 6. Create a Pull Request

- Go to https://github.com/arosstale/openclaw-memory-template
- Click "New Pull Request"
- Describe your changes clearly

---

## Code Style

### Python

- Follow PEP 8
- Use type hints
- Add docstrings to all public methods
- Maximum line length: 100 characters

### Example

```python
from typing import Dict, List, Optional
from datetime import datetime


class MyClass:
    """A brief description of the class."""

    def __init__(self, config: Optional[Config] = None):
        """Initialize MyClass.

        Args:
            config: Optional configuration object
        """
        self.config = config or default_config()

    def process_data(
        self,
        data: List[Dict],
        thread_id: str
    ) -> str:
        """Process data and return result.

        Args:
            data: List of data dictionaries
            thread_id: Thread identifier

        Returns:
            Processed result as string
        """
        # Implementation
        return result
```

---

## Adding New Features

### 1. Create Feature Branch

```bash
git checkout -b feature/new-memory-component
```

### 2. Implement Component

```python
# .openclaw/new_component/__init__.py
"""New memory component for OpenClaw."""

from typing import Dict, List


class NewComponent:
    """Brief description."""

    def __init__(self, config: Dict = None):
        self.config = config or {}

    def process(self, data: List) -> Dict:
        """Process data."""
        return {"result": "processed"}
```

### 3. Add Tests

```python
# test_new_component.py
"""Tests for new component."""

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent / ".openclaw"))

from new_component import NewComponent


def test_new_component():
    """Test new component."""
    comp = NewComponent()
    result = comp.process([1, 2, 3])
    assert "result" in result


if __name__ == "__main__":
    test_new_component()
    print("✅ All tests passed")
```

### 4. Add Documentation

```markdown
# New Component

Description of the new component.

## Usage

```python
from openclaw.new_component import NewComponent

comp = NewComponent()
result = comp.process(data)
```
```

### 5. Update CHANGELOG.md

```markdown
## [Unreleased]

### Added
- New memory component for XYZ
```

---

## Bug Fixes

### 1. Create Fix Branch

```bash
git checkout -b fix/bug-description
```

### 2. Fix the Bug

- Add a test that fails before the fix
- Implement the fix
- Ensure the test passes

### 3. Update Documentation

- Update relevant docs if behavior changes
- Add note to CHANGELOG.md

---

## Documentation

### Adding Documentation

- Use clear, concise language
- Include code examples
- Follow existing formatting

### Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Main documentation |
| `Vx.y_RELEASE_NOTES.md` | Version changelog |
| `MIGRATION_Vxy.md` | Migration guides |
| `.openclaw/docs/` | Component documentation |

---

## Testing

### Running Tests

```bash
# Observational Memory tests
python3 test_observational_memory.py

# All tests (if pytest is used)
pytest
```

### Writing Tests

- Test both success and failure cases
- Use descriptive test names
- Keep tests independent
- Mock external dependencies

### Example Test

```python
def test_process_messages_with_valid_input():
    """Test that valid messages are processed correctly."""
    om = ObservationalMemory()
    messages = [
        {"role": "user", "content": "Test", "timestamp": datetime.now()}
    ]
    record = om.process_messages("test-thread", messages)

    assert record is not None
    assert len(record.observations) > 0
```

---

## Release Process

### 1. Update Version

```bash
# Update version in documentation
# Update CHANGELOG.md
```

### 2. Tag Release

```bash
git tag v2.5.0
git push origin v2.5.0
```

### 3. Create Release

- Go to GitHub Releases
- Click "Draft a new release"
- Fill in details
- Publish release

---

## Code Review Guidelines

### For Reviewers

- Check code style consistency
- Verify tests pass
- Ensure documentation is updated
- Consider edge cases

### For Authors

- Address reviewer feedback
- Keep discussions constructive
- Be open to suggestions

---

## Community Guidelines

- Be respectful and inclusive
- Focus on constructive feedback
- Welcome new contributors
- Ask questions when unsure

---

## Questions?

- **Discord**: https://discord.com/invite/clawd
- **Issues**: https://github.com/arosstale/openclaw-memory-template/issues
- **Discussions**: https://github.com/arosstale/openclaw-memory-template/discussions

---

Thank you for contributing! 🐺📿
