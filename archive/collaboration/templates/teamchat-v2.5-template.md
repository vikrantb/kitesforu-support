---
# ==================================================================
# YAML Frontmatter - Edit these fields for your session
# ==================================================================
protocol: "2.5"                    # Don't change (protocol version)
session: "SESSION_ID_HERE"         # Example: "debug-2025-11-05-api"
type: "TYPE_HERE"                  # debugging | design | implementation | testing
priority: "PRIORITY_HERE"          # low | medium | high | critical
delegation_reason: "REASON_HERE"   # second_opinion | parallelization | token_management
complexity: "COMPLEXITY_HERE"      # LOW | MEDIUM | HIGH
started: "TIMESTAMP_HERE"          # ISO 8601 UTC: 2025-11-05T10:30:00Z
updated: "TIMESTAMP_HERE"          # ISO 8601 UTC: 2025-11-05T12:45:00Z
status: "STATUS_HERE"              # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---

<!--
==================================================================
TEAMCHAT TEMPLATE v2.5
==================================================================

QUICK START:
1. Fill in YAML frontmatter above
2. Replace placeholders in sections below
3. Tag @codex with your task
4. Save and let Codex see it!

SECTIONS:
- Header: Problem statement
- Evidence: Logs, metrics, code references
- Attempts: What you've tried (if debugging)
- @codex Task: Delegation to Codex
- Codex Findings: Where Codex writes response
- Updates: Progress tracking

DELETE THIS COMMENT BLOCK WHEN READY
==================================================================
-->

# Team Chat: [YOUR_TOPIC_HERE]

**Issue**: [One-line problem statement or goal]
**Status**: [Current progress summary]

---

## Evidence

### Logs

- **Path**: `path/to/log/file.log:line-numbers`
- **Key Finding**: [What the logs show]
- **Query**: `command to reproduce log search`

### Metrics

- **Metric Name**: [Value] (threshold: [Expected value])
- **Time Range**: [When this occurred]
- **Trend**: [Increasing/Decreasing/Stable]

### Code

- **File**: `path/to/file.ext:line-range`
- **Issue**: [What's wrong or what needs attention]
- **Context**: [Surrounding code/system information]

### Additional Context

[Any other relevant information: architecture diagrams, related tickets, user reports, etc.]

---

## Attempts So Far

<!--
DELETE THIS SECTION if not debugging
Keep this section for debugging scenarios
-->

1. **Hypothesis**: [First approach you tried]
   **Result**: [What happened]
   **Confidence**: [0-100]%

2. **Hypothesis**: [Second approach]
   **Result**: [What happened]
   **Confidence**: [0-100]%

3. **Hypothesis**: [Third approach]
   **Result**: [What happened]
   **Confidence**: [0-100]%

---

## @codex Task

**Scenario**: [debugging | design | implementation | testing]
**System**: [Component or service name]
**Focus**: [Specific area of investigation]

**Context**:
- Current state: [Where we are now]
- Background: [Relevant history or decisions]
- Constraints: [Limitations or requirements]

**Your Task**:
[Clear description of what Codex should investigate or implement]

**Questions** (if applicable):
- [Specific question 1]
- [Specific question 2]
- [Specific question 3]

**Success Criteria**:
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Minimum confidence level: XX%]

**Guidance**:
- Focus areas: [Where to look first]
- Approach: [Any specific methodology or constraints]
- Use your judgment on: [Areas where Codex decides]

---

<!--
==================================================================
CODEX SECTION - Codex writes below this line
==================================================================
-->

## Codex Findings

**Status**: [✅ Completed | 🔄 In Progress | 🚨 Blocked | ⏳ Pending]
**Confidence**: [0-100]%
**Time Spent**: [X minutes/hours]

### Root Cause

[Clear, concise explanation of the problem or analysis]

**Location**: `file/path.ext:line_number`

**Problem**: [Why this causes the issue or what needs to change]

### Evidence

```
[Log snippets, error messages, test results, or analysis]
```

### Solution

**Approach**: [High-level strategy]

```[language]
// Proposed code changes with inline comments

// Before:
[Current code]

// After:
[Fixed/improved code]
```

### Test/Validation

**Commands to verify**:
```bash
# Exact commands to run
# Include expected output
```

**Test Results** (if tested):
- [Test 1]: [✅ Passed | ❌ Failed | ⏳ Not tested]
- [Test 2]: [Result]

### Next Steps

1. [Action item 1]
2. [Action item 2]
3. [Action item 3]

### Risks & Considerations

- **Risk**: [Potential issue]
  **Mitigation**: [How to address]
  **Priority**: [low | medium | high]

### Open Questions

- [Question requiring further investigation]
- [Question requiring user/Claude input]

---

## Progress Updates

<!--
Use this section for periodic status updates from either agent
-->

### [Agent Name] Update - [HH:MM]

**Status**: [Current activity]

**Progress**:
- ✅ Completed: [Task]
- 🔄 In Progress: [Task]
- ⏳ Pending: [Task]

**Blockers**: [None | Description]

**Next Checkpoint**: [Timestamp]

---

## 🚨 Blockers (if any)

<!--
DELETE THIS SECTION if no blockers
Use this section to escalate blockers immediately
-->

**Blocked By**: [What's preventing progress]

**Impact**:
- Cannot proceed with: [Task]
- Blocking: [Critical path? Y/N]

**Need**:
- [ ] From Claude: [Specific clarification]
- [ ] From User: [Specific input/access]
- [ ] External: [Resource/credential]

**Workaround**: [Alternative path if available, or "None"]

**Urgency**: [Immediate | Can wait | Non-blocking]

---

## Session Summary

<!--
Fill this out when session is complete
-->

**Outcome**: [Resolution achieved]
**Confidence**: [Final confidence level]

**Key Learnings**:
- [Insight 1]
- [Insight 2]
- [Insight 3]

**What Worked**:
- [Success factor 1]
- [Success factor 2]

**What to Improve**:
- [Area for enhancement]

**Next Session**:
- Topic: [Follow-up work if any]
- Priority: [Level]
- Estimated start: [Date/time]

**Archive To**: `docs/learnings/incidents/YYYY-MM-DD-topic.md`

---

<!--
==================================================================
TEMPLATE METADATA
==================================================================
Template Version: 2.5.0
Last Updated: 2025-11-05
Documentation: https://github.com/[your-org]/kiteagentcollab
==================================================================
-->
