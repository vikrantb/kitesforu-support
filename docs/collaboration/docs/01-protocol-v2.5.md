# Protocol v2.5: Enhanced Markdown Collaboration Format

**Status**: Production
**Version**: 2.5.0
**Last Updated**: 2025-11-05

---

## Overview

Protocol v2.5 defines the communication format for structured collaboration between Claude Code and Codex (Cursor IDE). It combines **YAML frontmatter** for machine-parseable metadata with **Markdown body** for human-readable content.

### Design Philosophy

1. **Human-First**: Markdown primary format ensures readability for debugging
2. **LLM-Optimized**: YAML frontmatter enables reliable parsing and automation
3. **Async Native**: File-based communication supports parallel, non-blocking work
4. **Persistent**: All collaboration history preserved across sessions
5. **Framework-Agnostic**: Works with any tech stack or project structure

---

## File Structure

### Location Convention

```
project-root/
└── teamchat/
    ├── 2025-11-05-pubsub-debug.md
    ├── 2025-11-06-auth-refactor.md
    └── 2025-11-07-api-performance.md
```

**Naming**: `YYYY-MM-DD-topic-slug.md` or `YYYY-MM-DD.md` for single daily file

### File Format

```markdown
---
# YAML Frontmatter (Machine-Parseable Metadata)
protocol: "2.5"
session: "debug-2025-11-05-pubsub"
type: "debugging"
priority: "high"
# ... more metadata
---

# Markdown Body (Human-Readable Content)

## Section 1
Content in flexible Markdown format...

## @codex Task
Delegation request in natural language...
```

---

## YAML Frontmatter Specification

### Required Fields

```yaml
---
protocol: "2.5"                    # Protocol version (REQUIRED)
session: "string"                   # Unique session identifier (REQUIRED)
type: "string"                      # Session type (REQUIRED)
---
```

### Standard Fields

```yaml
---
protocol: "2.5"
session: "debug-2025-11-05-pubsub"          # Format: type-YYYY-MM-DD-topic
type: "debugging"                            # debugging | design | implementation | testing
priority: "high"                             # low | medium | high | critical
delegation_reason: "second_opinion"          # second_opinion | parallelization | token_management
complexity: "HIGH"                           # LOW | MEDIUM | HIGH
started: "2025-11-05T10:30:00Z"             # ISO 8601 UTC timestamp
updated: "2025-11-05T12:45:00Z"             # ISO 8601 UTC timestamp
status: "IN_PROGRESS"                        # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---
```

### Optional Fields

```yaml
---
# Additional context
tags: ["api", "pubsub", "production"]        # Searchable tags
participants: ["claude_code", "codex_cursor"] # Agent identifiers
estimated_duration: 60                        # Minutes
confidence_target: 0.85                       # 0.0-1.0 scale
---
```

### Field Descriptions

| Field | Type | Values | Description |
|-------|------|--------|-------------|
| `protocol` | string | "2.5" | Protocol version (always "2.5") |
| `session` | string | any | Unique identifier for session |
| `type` | string | debugging/design/implementation/testing | Primary session category |
| `priority` | string | low/medium/high/critical | Urgency level |
| `delegation_reason` | string | second_opinion/parallelization/token_management | Why delegating to Codex |
| `complexity` | string | LOW/MEDIUM/HIGH | Task complexity assessment |
| `started` | string | ISO 8601 | Session start timestamp |
| `updated` | string | ISO 8601 | Last update timestamp |
| `status` | string | INITIATED/IN_PROGRESS/COMPLETED/BLOCKED/CLOSED | Current state |

---

## Markdown Body Structure

### Standard Sections

```markdown
# Team Chat: [Topic]

**Issue**: One-line problem statement
**Status**: Current progress summary

## Evidence

### Logs
- Path: `backend/logs/api.log:123-456`
- Key finding: "JSONDecodeError on line 342"

### Metrics
- Pub/Sub delivery attempts: 15 (threshold: 3)
- Error rate: 45% (last 1 hour)

### Code
- File: `backend/app/services.py:330-350`
- Issue: Message encoding format mismatch

## Attempts So Far

1. **Hypothesis**: IAM permission issue
   **Result**: Permission granted, still failing
   **Confidence**: 30%

2. **Hypothesis**: Subscription misconfigured
   **Result**: Subscription verified correct
   **Confidence**: 40%

## @codex Task

**System**: Pub/Sub worker pipeline
**Focus**: Message encoding between API and Worker

**Questions**:
- Why would `json.loads()` fail with single-quote dict format?
- Should we use `json.dumps()` or `str()` for encoding?

**Success Criteria**:
- [ ] Identify exact line causing error
- [ ] Confirm fix resolves issue (confidence ≥ 85%)
- [ ] Provide code change with test command

---

## Codex Findings

**Status**: ✅ Completed
**Confidence**: 92%
**Time**: 45 minutes

### Root Cause
[Detailed explanation...]

### Solution
```python
# Code changes
```

### Test Command
```bash
# Verification steps
```

### Risks
- Risk 1: Description
- Mitigation: How to address

---

## Claude Update

✅ Applied fix
✅ Tests passing
✅ Deployed to staging

**Session**: CLOSED
```

### Section Guidelines

| Section | Purpose | Format |
|---------|---------|--------|
| **Header** | Problem statement | One line, clear |
| **Evidence** | Supporting data | Logs, metrics, code refs |
| **Attempts** | What's been tried | Hypothesis → Result → Confidence |
| **@codex Task** | Delegation request | Questions + Success criteria |
| **Codex Findings** | Response | Root cause + Solution + Tests |
| **Updates** | Progress tracking | Checkboxes, timestamps |

---

## Message Patterns

### Pattern 1: Task Delegation (Claude → Codex)

```markdown
## @codex Task

**Scenario**: [debugging | design | implementation | testing]
**System**: [Component or service name]
**Symptom**: [User-visible issue or requirement]

**Context**:
- Current state: [Where we are now]
- Attempts: [What's been tried]
- Evidence: [Links to logs, code, metrics]

**Your Task**:
[Specific investigation or implementation request]

**Success Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Minimum confidence level: XX%

**Guidance**:
- Focus areas: [Specific areas to investigate]
- Open questions: [Questions to answer]
- Use your judgment on: [Areas where Codex decides approach]
```

### Pattern 2: Findings Response (Codex → Claude)

```markdown
## Codex Findings

**Status**: [✅ Completed | 🔄 In Progress | 🚨 Blocked]
**Confidence**: [0-100]%
**Time Spent**: [X minutes/hours]

### Root Cause
[Clear explanation of the problem]

**Location**: `file/path.ext:line_number`
**Problem**: [Why this causes the issue]

### Evidence
[Log snippets, error messages, test results]

### Solution
```[language]
// Code changes with comments
```

**Test Command**:
```bash
# Exact commands to verify fix
```

### Next Steps
1. [Action item 1]
2. [Action item 2]

### Risks & Considerations
- **Risk**: [Potential problem]
  **Mitigation**: [How to address]
  **Priority**: [low | medium | high]

### Open Questions
- [Question requiring clarification]
```

### Pattern 3: Progress Update

```markdown
## [Agent] Update - [HH:MM]

**Status**: [Current activity]

**Progress**:
- ✅ Completed: [Task]
- 🔄 In Progress: [Task]
- ⏳ Pending: [Task]

**Blockers**: [None | Description]

**Next Checkpoint**: [Timestamp]
```

### Pattern 4: Blocker Escalation

```markdown
## 🚨 BLOCKER

**Blocked By**: [What's preventing progress]
**Impact**: [What can't proceed]

**Need From**:
- [ ] User: [Specific input needed]
- [ ] Claude: [Clarification needed]
- [ ] External: [Resource/access needed]

**Workaround**: [Alternative path if available]

**Urgency**: [Immediate | Can wait | Blocking critical path]
```

### Pattern 5: Session Synthesis

```markdown
## Session Summary

**Outcome**: [Resolution achieved]
**Confidence**: [Final confidence level]

**Key Learnings**:
- [Insight 1]
- [Insight 2]

**What Worked**:
- [Success factor 1]

**What to Improve**:
- [Area for enhancement]

**Next Session**:
- Topic: [Follow-up work]
- Priority: [Level]
- Estimated start: [Date]

**Archive To**: `docs/learnings/incidents/YYYY-MM-DD-topic.md`
```

---

## State Machine

### Session States

```
INITIATED
   ↓
IN_PROGRESS ←→ BLOCKED
   ↓
COMPLETED
   ↓
CLOSED
```

### State Descriptions

| State | Meaning | Transition Triggers |
|-------|---------|-------------------|
| **INITIATED** | Session created, work not started | First message posted |
| **IN_PROGRESS** | Active collaboration ongoing | Work begins |
| **BLOCKED** | Cannot proceed without intervention | Blocker encountered |
| **COMPLETED** | Work finished, awaiting validation | Final findings delivered |
| **CLOSED** | Session archived, no further work | Validated and documented |

### Checkpoint Cadence

- **Every 30 minutes**: Progress update
- **Every 2 hours**: Status checkpoint with both agents
- **End of session**: Synthesis and archival

---

## Confidence Scoring

### Scale

- **0-30%**: Low confidence, speculative
- **31-60%**: Moderate confidence, needs validation
- **61-80%**: High confidence, tested locally
- **81-95%**: Very high confidence, production-ready
- **96-100%**: Absolute certainty (rare, only for proven facts)

### Usage

```markdown
**Confidence**: 85%

**Rationale**:
- ✅ Tested locally with 10 sample cases
- ✅ Matches error pattern exactly
- ⚠️ Not tested in production environment
- ⚠️ Edge cases not fully explored
```

---

## File Naming Conventions

### Single Daily File
```
teamchat/2025-11-05.md
```
Use when: All day's collaboration fits in one file

### Topic-Specific Files
```
teamchat/2025-11-05-pubsub-debug.md
teamchat/2025-11-05-auth-refactor.md
```
Use when: Multiple parallel sessions or complex topics

### Archived Sessions
```
teamchat/archive/2025-10/pubsub-debug.md
```
After 30 days, move to archive by month

---

## Symbol System (Optional)

For high-frequency updates, use compressed symbols:

| Symbol | Meaning | Usage |
|--------|---------|-------|
| ✅ | Completed | Task finished successfully |
| 🔄 | In progress | Currently working |
| ⏳ | Pending | Scheduled, not started |
| 🚨 | Blocker/Urgent | Immediate attention needed |
| 🔍 | Investigating | Deep analysis mode |
| 💡 | Insight | Key discovery |
| ⚠️ | Warning | Needs review |
| ❌ | Failed | Something broke |

**Example**:
```markdown
⚡ 14:30 Claude: Deployed API-00168 → E2E running → ✅ next@15:00
```

---

## Best Practices

### DO ✅

1. **Always include YAML frontmatter** for automation compatibility
2. **Use ISO 8601 timestamps** (UTC) for temporal references
3. **Link to evidence** with file paths and line numbers
4. **Provide confidence scores** for all findings and recommendations
5. **Use checklists** for success criteria (trackable progress)
6. **Update session status** in frontmatter as work progresses
7. **Write for humans first** - Markdown readability > parsing efficiency

### DON'T ❌

1. **Don't use proprietary formats** - Keep Markdown compatible
2. **Don't skip evidence** - Always link to logs, code, tests
3. **Don't make unqualified claims** - State confidence and rationale
4. **Don't let sessions go stale** - Close or archive when done
5. **Don't duplicate work** - Check teamchat before starting new investigation
6. **Don't use relative timestamps** - Always absolute (ISO 8601)
7. **Don't over-structure** - Markdown flexibility is a feature

---

## Error Handling

### Malformed Frontmatter

If YAML parsing fails:
1. Log warning about malformed frontmatter
2. Parse as best-effort Markdown
3. Continue collaboration
4. Note issue for correction

### Missing Required Fields

If `protocol`, `session`, or `type` missing:
1. Infer from context if possible
2. Default to: `protocol: "2.5"`, generate UUID for session
3. Continue with warning

### Format Evolution

Protocol versions are backward-compatible:
- v2.5 parsers MUST handle v2.0 files (graceful degradation)
- v2.0 parsers MAY ignore v2.5-specific fields
- Always specify `protocol` field for version detection

---

## Migration from v1.0/v2.0

### From v1.0 (Unstructured Markdown)

**Before**:
```markdown
# Debugging Session

Claude: I'm investigating the API issue...
Codex: I found the problem...
```

**After (v2.5)**:
```markdown
---
protocol: "2.5"
session: "debug-2025-11-05"
type: "debugging"
---

# Team Chat: API Debug

## @codex Task
[Structured delegation]
```

### From v2.0 (Structured Markdown)

**Before**:
```markdown
# Team Chat: API Debug

**From Claude**: [timestamp]
**Task**: Investigate API 404
```

**After (v2.5)**:
```markdown
---
protocol: "2.5"
session: "debug-2025-11-05"
type: "debugging"
started: "2025-11-05T10:30:00Z"
---

# Team Chat: API Debug

## @codex Task
[Same content, now with metadata]
```

---

## Examples

See `templates/` directory for complete examples:
- `debugging-scenario.md` - Full debugging session
- `design-review-scenario.md` - Architecture decision
- `implementation-scenario.md` - Code implementation task
- `testing-scenario.md` - Test strategy development

---

## Protocol Evolution

### Version History

- **v1.0**: Unstructured Markdown with @codex trigger
- **v2.0**: Structured Markdown with sections
- **v2.5**: YAML frontmatter + Markdown body (current)
- **v3.0**: Planned - Typed messages with full automation

### Compatibility Promise

- Minor versions (2.x) maintain backward compatibility
- Major versions (3.0+) may break compatibility but provide migration tools
- All parsers MUST handle graceful degradation

---

## References

- **Research**: [docs/07-research-findings.md](07-research-findings.md)
- **Delegation**: [docs/02-delegation-framework.md](02-delegation-framework.md)
- **Best Practices**: [docs/05-best-practices.md](05-best-practices.md)

---

**Version**: 2.5.0
**Status**: Production
**Last Updated**: 2025-11-05
