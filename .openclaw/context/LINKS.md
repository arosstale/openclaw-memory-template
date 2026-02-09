# OpenClaw Context Registry (LINKS.md)
# Add new research links and resources here immediately after discovery

## Recent Research (Add to Section Below)

### 2026-02-03: OpenClaw V2 Self-Evolution
- **Purpose**: Migration from static memory to automated Git-backed system
- **Template Used**: https://github.com/arosstale/openclaw-memory-template
- **Outcome**: Full directory structure created, 4 automation scripts, templates
- **Files Created**: 
  - `.openclaw/core/` - Identity files
  - `memory/` - Git-backed knowledge base
  - `.openclaw/scripts/` - init.sh, sync.sh, log.sh, status.sh, fix-thermal-monitor.sh
  - `templates/` - daily-log.md, project.md
  - `HEARTBEAT.md` - Daily health and security checks (in .openclaw/core/)
- **Documentation**: IMPLEMENTATION_SUMMARY.md, QUICK_START.md, ACTIVATION_CHECKLIST.md

### Thermal Monitoring (Add to System Health Section)
- **Issue Found**: Daemon script `cpu_thermal_monitor.py` had outdated Discord token
- **Diagnosis Script**: `.openclaw/scripts/fix-thermal-monitor.sh`
- **Status**: Daemon running, logging to `/tmp/pi_thermal_monitor.log`
- **Fix Required**: Update Discord bot token, verify channel ID
- **Related**: Thermal monitoring integrated into memory heartbeat (add to HEARTBEAT.md)

---

## Usage Instructions

### When You Discover New Resources
1. **Categorize** the resource (CLI tool, API, documentation, skill, library)
2. **Add to this file** under the appropriate section
3. **Include**:
   - Name/Title
   - Description (what it is)
   - Link/URL
   - Use case (when to use it)
   - Discovery date

### Example Entry

```markdown
### OpenClaw V2 (2026-02-03)
**Purpose**: Upgrade to Git-backed memory with OpenClaw V2 template
**Link**: https://github.com/arosstale/openclaw-memory-template
**Use**: Reference for understanding directory structure and automation
**Discovery**: Self-implementation during Pi-Agent evolution
```

### Keep It Organized

- **Order**: Discovery (newest first)
- **Sections**:
  - OpenClaw System Components (templates, scripts, docs)
  - External Tools & APIs
  - Research & Documentation
  - Project-Specific Resources
  - Configuration & Setup Guides

### Don't Remove Old Entries

Keep historical resources for reference unless they're completely irrelevant. Mark deprecated items clearly.

---

**Last Updated**: 2026-02-03
