# Getting Started with kiteagentcollab

**Time to First Collaboration**: 5 minutes
**Difficulty**: Easy

---

## Quick Start

### 1. Add to Your Project (30 seconds)

```bash
cd your-project
git submodule add https://github.com/[your-org]/kiteagentcollab .collab
git submodule update --init --recursive
```

### 2. Create Teamchat Directory (10 seconds)

```bash
mkdir -p teamchat
```

### 3. Start Your First Session (2 minutes)

```bash
# Copy template
cp .collab/templates/teamchat-v2.5-template.md teamchat/$(date +%Y-%m-%d).md

# Edit the file
# - Update YAML frontmatter (session ID, type, priority)
# - Describe your problem in the body
# - Tag @codex with your task

# Save and let Codex see it!
```

### 4. Codex Responds (varies)

Codex reads the teamchat file, investigates, and writes findings back to the same file.

You now have a persistent record of the entire collaboration!

---

## Your First Collaboration

Let's debug a simple API 404 error together.

### Step 1: Create Teamchat File

```bash
cd your-project
vi teamchat/2025-11-05.md
```

### Step 2: Write Your Task

```markdown
---
protocol: "2.5"
session: "debug-api-404"
type: "debugging"
priority: "high"
---

# Team Chat: API 404 Debug

**Issue**: `/api/users` endpoint returns 404
**Status**: Investigating

## Evidence

- Route defined in `backend/routes/users.js:15`
- Controller exists at `backend/controllers/users.js`
- Logs show: "Route matched but handler not found"

## Attempts So Far

1. **Hypothesis**: Route path mismatch
   **Result**: Path is correct (`/api/users`)
   **Confidence**: 90%

## @codex Task

**System**: Express API
**Your Task**: Find why handler isn't connecting to route

**Success Criteria**:
- [ ] Root cause identified
- [ ] Fix provided
- [ ] Confidence ≥ 85%
```

### Step 3: Save and Share with Codex

In Cursor IDE:
1. Codex automatically detects the `@codex` mention
2. Or manually trigger: Open Command Palette → "Codex: Read Teamchat"

### Step 4: Codex Investigates

Codex reads your file, investigates the code, and adds findings:

```markdown
## Codex Findings

**Status**: ✅ Completed
**Confidence**: 95%

### Root Cause

Controller method name doesn't match route configuration.

**Location**: `backend/routes/users.js:15`

Route expects: `getUsers`
Controller has: `fetchUsers`

### Solution

```js
// backend/routes/users.js line 15
// Before:
router.get('/users', controller.getUsers);

// After:
router.get('/users', controller.fetchUsers);
```

### Test

```bash
curl http://localhost:3000/api/users
# Should return 200 OK with user list
```
```

### Step 5: Apply the Fix

```bash
# Make the change
vi backend/routes/users.js

# Test
curl http://localhost:3000/api/users

# Update teamchat
```

Add to teamchat:
```markdown
## Claude Update

✅ Applied fix - method name corrected
✅ Tests passing
✅ Deployed to staging

**Session**: CLOSED
```

**Done!** You just completed your first Claude-Codex collaboration!

---

## Understanding the Workflow

```
┌─────────────┐
│   CLAUDE    │  1. Creates teamchat file
│    CODE     │  2. Describes problem + tags @codex
└──────┬──────┘  3. Continues other work in parallel
       │
       ↓
   teamchat/
   2025-11-05.md  ← Persistent collaboration log
       ↑
       │
┌──────┴──────┐
│   CODEX     │  4. Reads teamchat
│  (Cursor)   │  5. Investigates independently
└──────┬──────┘  6. Writes findings back
       │
       ↓
┌─────────────┐
│   CLAUDE    │  7. Reads Codex findings
│    CODE     │  8. Applies solution
└─────────────┘  9. Closes session
```

**Key Insight**: Everything happens through the teamchat file. No complex APIs, no real-time coordination needed. Just clear communication in Markdown.

---

## File Organization

### Recommended Structure

```
your-project/
├── .collab/                    # Git submodule (this framework)
│   ├── docs/
│   ├── templates/
│   └── scripts/
│
├── teamchat/                   # Your collaboration sessions
│   ├── 2025-11-05.md          # Daily file (recommended)
│   └── archive/
│       └── 2025-10/           # Archived sessions
│
├── docs/
├── src/
└── tests/
```

### Naming Conventions

**Option A: Daily Files** (Recommended for most projects)
```
teamchat/2025-11-05.md         # All today's collaboration
teamchat/2025-11-06.md         # All tomorrow's collaboration
```

**Option B: Topic Files** (For complex projects)
```
teamchat/2025-11-05-api-debug.md
teamchat/2025-11-05-auth-refactor.md
teamchat/2025-11-05-performance.md
```

**Choose** based on your workflow:
- Lots of small tasks → Daily files
- Few big tasks → Topic files

---

## Configuration

### Minimal Setup (Works immediately)

No configuration needed! Just:
1. Add submodule
2. Create `teamchat/` directory
3. Start collaborating

### Optional: Automation

**Watch for @codex mentions** (Python):
```bash
python .collab/scripts/python/teamchat_watcher.py \
  --file teamchat/2025-11-05.md \
  --watch --log
```

**Metrics and analytics**:
```bash
python .collab/scripts/python/teamchat_metrics.py \
  --dir teamchat/ \
  --report
```

### Optional: Project-Specific Config

Create `.collab/config.local.yaml` (git-ignored):
```yaml
project_name: "your-project"
default_priority: "medium"
default_complexity: "MEDIUM"
teamchat_dir: "teamchat"  # Custom location if needed
```

---

## Templates

### Available Templates

| Template | Use Case | When to Use |
|----------|----------|-------------|
| **teamchat-v2.5-template.md** | Blank slate | Any scenario |
| **debugging-scenario.md** | Bug investigation | Something's broken |
| **design-review-scenario.md** | Architecture decisions | Need design input |
| **implementation-scenario.md** | Code tasks | Build new feature |
| **testing-scenario.md** | Test strategy | Need test plan |

### Using Templates

```bash
# List available templates
ls .collab/templates/

# Copy template for today
cp .collab/templates/debugging-scenario.md teamchat/$(date +%Y-%m-%d).md

# Edit and fill in your specific details
vi teamchat/2025-11-05.md
```

---

## Common Patterns

### Pattern 1: Quick Bug Fix

```markdown
---
protocol: "2.5"
session: "quick-fix"
type: "debugging"
priority: "low"
---

## @codex Task
[One paragraph describing the bug]
[Link to error message]

Success: Fix with confidence >= 80%
```

**Time**: 10-30 minutes

### Pattern 2: Parallel Work

```markdown
---
protocol: "2.5"
delegation_reason: "parallelization"
---

## Parallel Work Plan
**Claude**: Deploy API + run tests (25 min)
**Codex**: Analyze worker logs (25 min)

## @codex Task
[Your specific analysis task]
```

**Time Savings**: 30-50%

### Pattern 3: Second Opinion

```markdown
---
protocol: "2.5"
delegation_reason: "second_opinion"
complexity: "HIGH"
---

## Attempts So Far
1. Hypothesis A → Failed
2. Hypothesis B → Failed
3. Hypothesis C → Low confidence

## @codex Task
Need fresh perspective on root cause.
[Full context + evidence]
```

**Success Rate**: 85%+ find issue

---

## Tips for Success

### DO ✅

1. **Be Specific**: "Debug message encoding in Pub/Sub" not "Fix API"
2. **Provide Evidence**: Link to logs, errors, code locations
3. **Set Clear Criteria**: Use checklists for success criteria
4. **Update Regularly**: Note progress, findings, status changes
5. **Use Confidence Scores**: Helps assess reliability of findings

### DON'T ❌

1. **Don't Be Vague**: "Something's broken" isn't actionable
2. **Don't Skip Context**: Codex needs evidence to investigate
3. **Don't Micromanage**: Trust Codex's approach once task is clear
4. **Don't Forget to Close**: Archive completed sessions
5. **Don't Duplicate Work**: Read teamchat before starting new investigation

---

## Troubleshooting

### Issue: Codex doesn't respond

**Possible causes**:
1. Codex not running in Cursor IDE
2. @codex mention not detected
3. File not in expected location

**Solutions**:
```bash
# Check Codex is active in Cursor
# Manually trigger: Command Palette → "Codex: Read Teamchat"
# Verify file location: teamchat/*.md
```

### Issue: Findings don't match expectations

**This is GOOD!** Second opinions often reveal new insights.

**Next steps**:
1. Review Codex's evidence
2. Test both hypotheses if possible
3. Discuss discrepancy in teamchat
4. Let data decide

### Issue: Task unclear

Codex will ask for clarification:
```markdown
## Codex - Need Clarification

**Question**: [Specific question]
```

Respond in teamchat with details.

---

## Next Steps

### Learn More

- **[Protocol v2.5](01-protocol-v2.5.md)** - Full specification
- **[Delegation Framework](02-delegation-framework.md)** - When to delegate
- **[Best Practices](05-best-practices.md)** - Proven patterns
- **[Examples](../examples/)** - Integration examples

### Try Advanced Features

1. **Automation**: Set up watcher script for auto-detection
2. **Metrics**: Track collaboration effectiveness
3. **Parallelization**: Multiple Codex tasks simultaneously
4. **Complex Workflows**: Multi-day investigations

### Join Community

- **GitHub Discussions**: Share patterns and learnings
- **Issues**: Report bugs or request features
- **Contributing**: Submit templates and improvements

---

## Summary

**You've learned**:
- ✅ How to add kiteagentcollab to your project
- ✅ How to create your first teamchat session
- ✅ How Claude and Codex collaborate asynchronously
- ✅ Common patterns and best practices
- ✅ Where to find templates and documentation

**Ready to collaborate!**

Start with a simple debugging task, then gradually explore more complex patterns. The framework scales from quick fixes to multi-day architectural work.

---

**Questions?** See [docs/06-troubleshooting.md](06-troubleshooting.md) or open a GitHub issue.

**Happy collaborating!** 🚀
