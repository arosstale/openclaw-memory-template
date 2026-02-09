# 🌅 Morning Coffee Routine - HEARTBEAT Tasks

**Trigger**: Every morning before starting work
**Command**: Read HEARTBEAT.md and complete security + system health checks

## 🔒 Security Checklist

- [ ] Review recent system changes or updates
- [ ] Check for any new files or directories in workspace
- [ ] Verify no unexpected processes or connections
- [ ] Review git logs for suspicious activity
- [ ] Check environment variables for sensitive data exposure

## 💻 System Health Checklist

- [ ] Disk usage < 90% (`df -h | grep -E '^/dev/' | awk '{print $5}'`)
- [ ] CPU temperature monitoring active (`/home/majinbu/pi-mono-workspace/.openclaw/scripts/fix-thermal-monitor.sh`)
- [ ] All expected daemons running (Prometheus, Grafana, etc.)
- [ ] Memory usage acceptable (< 12GB of 124GB used)
- [ ] No zombie processes consuming resources (`htop` or `ps aux | grep -E 'defunct|Z'`)

## 🧠 Memory System Status

- [ ] Git remote sync active (run `.openclaw/scripts/sync.sh` if behind)
- [ ] Daily log created for today (`ls -la memory/daily/$(date +%Y-%m-%d).md`)
- [ ] No merge conflicts in memory/ (`cd memory && git status`)

## 📋 Priority Setting

- [ ] Identify 1-2 most important tasks for today
- [ ] Add to daily log: "## Active Projects\n- [Task] [Task]\n\n## Next Steps\n- [Top Priority Task]"
- [ ] Ensure thermal monitoring doesn't block execution

## ✅ Complete When

- All security and system health checks pass
- Priority tasks identified and logged
- HEARTBEAT.md marked as checked for today

---

**Last Updated**: 2026-02-03
**Next Review**: Tomorrow morning same time
