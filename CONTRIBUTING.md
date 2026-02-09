# Contributing to OpenClaw V2.1 Elite

Thank you for your interest in contributing to Pi's memory architecture!

## 🐺 About Pi

Pi is a self-evolving, hardware-aware, swarm-ready OpenClaw Elite agent. This repository provides a production-ready template for building autonomous agent systems with:

- **GEPA**: Self-correcting mutation engine
- **Dual-Core Memory**: PostgreSQL (structured) + QMD (semantic search)
- **Swarm Protocol**: Multi-agent coordination
- **Hardware-Aware**: Thermal monitoring and adaptive compute

## 🤝 How to Contribute

### Reporting Issues

- **Bugs**: Open an issue with steps to reproduce
- **Features**: Open an issue with "feature:" prefix
- **Questions**: Use GitHub Discussions

### Submitting Pull Requests

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit (`git commit -m 'feat: Add amazing feature'`)
5. Push to your fork (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

## 🏗️ Development Setup

```bash
# Clone the repository
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# Run the welcome script
bash scripts/welcome.sh

# Start the development environment
docker-compose -f docker-compose.postgres.yml up -d
docker-compose -f docker-compose.qmd.yml up -d
```

## 📋 Areas of Contribution

### Priority Areas
1. **Memory Architecture**: New search backends, caching strategies
2. **GEPA**: New mutation patterns, fitness functions
3. **Swarm Protocol**: New agent types, handoff strategies
4. **Hardware Support**: New sensors, thermal profiles
5. **Documentation**: Examples, tutorials, API docs

### Community Contributions
- **Success Stories**: Share how you're using Pi
- **Agent Templates**: Custom AGENTS.md configurations
- **Scripts**: Maintenance and utility scripts
- **Translations**: Internationalization support

## 🧪 Testing

Before submitting a PR:

1. Test on your local environment
2. Verify Docker Compose services start correctly
3. Check thermal monitoring scripts
4. Validate PostgreSQL schema changes
5. Test QMD integration (if applicable)

## 📜 Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Assume good intentions

## 📄 License

This project is released under the MIT License.

## 💬 Community

- **Discord**: https://discord.com/invite/clawd
- **GitHub Discussions**: Use for questions and ideas
- **Issues**: For bugs and feature requests

---

Thank you for contributing to Pi's evolution! 🐺📿
