---
# ==================================================================
# YAML Frontmatter - Edit these fields for your debugging session
# ==================================================================
protocol: "2.5"                    # Don't change (protocol version)
session: "debug-YYYY-MM-DD-topic"  # Example: "debug-2025-11-05-pubsub"
type: "debugging"                  # Keep as "debugging"
priority: "high"                   # low | medium | high | critical
delegation_reason: "second_opinion" # second_opinion | parallelization | token_management
complexity: "HIGH"                 # LOW | MEDIUM | HIGH
started: "2025-11-05T10:30:00Z"   # ISO 8601 UTC timestamp
updated: "2025-11-05T10:30:00Z"   # ISO 8601 UTC timestamp
status: "INITIATED"                # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---

<!--
==================================================================
DEBUGGING SCENARIO TEMPLATE
==================================================================

USE THIS WHEN:
- Something's broken in production or development
- Error messages appear but root cause unclear
- System behavior doesn't match expectations
- Performance degradation or failures occur
- Multiple hypotheses tested without resolution

QUICK START:
1. Fill in symptom and environment details below
2. Gather all available evidence (logs, errors, metrics)
3. Document what you've already tried
4. Tag @codex with specific investigation request
5. Let Codex independently analyze the problem

DELETE THIS COMMENT BLOCK WHEN READY
==================================================================
-->

# Debugging: [SYMPTOM_DESCRIPTION]

**Issue**: [One-line description of the problem]
**Environment**: [Production | Staging | Development | Local]
**Impact**: [User-facing | Internal | Critical path | Non-blocking]
**Severity**: [Critical | High | Medium | Low]

---

## Symptom Details

### User-Visible Behavior
- **Expected**: [What should happen]
- **Actual**: [What actually happens]
- **Frequency**: [Always | Intermittent | Rare | Percentage]
- **First Observed**: [Timestamp or date when first noticed]

### Environmental Context
- **Affected Components**: [List services, modules, or systems]
- **Recent Changes**: [Deployments, config changes, or updates within 24-48 hours]
- **Affected Users**: [All | Specific subset | Random]
- **Reproducibility**: [100% | ~50% | Cannot reproduce]

---

## Evidence

### Error Messages

**Location**: `path/to/log/file.log:line-numbers`

```
[Paste exact error message with stack trace]
```

**Occurrence Pattern**: [How often, when, under what conditions]

### Logs

**Source**: `service-name` or `log-query-command`
**Time Range**: [Start timestamp] to [End timestamp]

```
[Relevant log entries showing the problem]
```

**Key Observations**:
- [Pattern or anomaly 1]
- [Pattern or anomaly 2]

### Metrics

| Metric Name | Current Value | Normal Range | Threshold |
|-------------|---------------|--------------|-----------|
| [metric_1] | [value] | [range] | [threshold] |
| [metric_2] | [value] | [range] | [threshold] |

**Metric Trends**: [Increasing | Decreasing | Stable | Spiking]

### Code Context

**Suspected Location**: `file/path.ext:line-range`

```[language]
// Relevant code section
// Include surrounding context
```

**Why Suspected**: [Reasoning for focusing on this code]

### System State

- **Resource Usage**: CPU [%] | Memory [%] | Disk [%] | Network [Mbps]
- **Database State**: [Connection pool, query times, locks]
- **External Dependencies**: [API status, third-party service health]
- **Configuration**: [Relevant config values or environment variables]

---

## Investigation Timeline

### Recent Changes
1. **[Timestamp]**: [Change description - deployment, config, etc.]
2. **[Timestamp]**: [Change description]
3. **[Timestamp]**: [Change description]

### Problem Evolution
1. **[Timestamp]**: [First occurrence or symptoms began]
2. **[Timestamp]**: [Problem escalated or changed]
3. **[Timestamp]**: [Current state]

---

## Attempts So Far

### Hypothesis 1: [Description]

**Reasoning**: [Why this seemed likely]

**Investigation Steps**:
- [Step 1 taken]
- [Step 2 taken]
- [Step 3 taken]

**Results**: [What was discovered]

**Outcome**: ❌ Disproven | ⚠️ Inconclusive | ✅ Partial confirmation

**Confidence**: [0-100]%

---

### Hypothesis 2: [Description]

**Reasoning**: [Why this seemed likely]

**Investigation Steps**:
- [Step 1 taken]
- [Step 2 taken]

**Results**: [What was discovered]

**Outcome**: ❌ Disproven | ⚠️ Inconclusive | ✅ Partial confirmation

**Confidence**: [0-100]%

---

### Hypothesis 3: [Description]

**Reasoning**: [Why this seemed likely]

**Investigation Steps**:
- [Step 1 taken]

**Results**: [What was discovered]

**Outcome**: ❌ Disproven | ⚠️ Inconclusive | ✅ Partial confirmation

**Confidence**: [0-100]%

---

## @codex Task

**System**: [Component or service name]
**Symptom**: [Brief problem description]
**Focus**: [Specific area to investigate]

**Context**:
- **Current Understanding**: [What we know so far]
- **Hypotheses Tested**: [Quick summary of attempts above]
- **Environmental Constraints**: [Production limitations, access restrictions]
- **Time Pressure**: [Urgent | Important | Can wait]

**Your Task**:
Investigate the root cause of [specific problem]. Focus on [specific area or approach].

**Specific Questions**:
1. [Targeted question about the problem]
2. [Question about alternative explanations]
3. [Question about system behavior]

**Success Criteria**:
- [ ] Identify root cause with confidence ≥ 85%
- [ ] Explain why previous hypotheses failed
- [ ] Provide fix or workaround with test validation approach
- [ ] Identify any related issues or risks

**Guidance**:
- **Focus Areas**: [Where to look first - components, logs, code sections]
- **Approach**: [Any specific methodology or constraints]
- **Timeline**: [How urgent - affects depth of investigation]
- **Constraints**: [Production environment, no restart allowed, etc.]
- **Use Your Judgment**: [Areas where Codex decides investigation strategy]

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

[Clear, concise explanation of what's actually causing the problem]

**Location**: `file/path.ext:line_number`

**Mechanism**: [How this causes the observed symptoms]

**Why This Explains Symptoms**:
- Symptom 1: [Explanation]
- Symptom 2: [Explanation]

### Evidence Supporting Root Cause

```
[Log entries, error messages, or test results proving this is the cause]
```

**Why Previous Hypotheses Failed**:
- Hypothesis 1: [Explanation of why it was wrong]
- Hypothesis 2: [Explanation of why it was wrong]

### Solution

**Approach**: [High-level fix strategy]

**Priority**: [Immediate hotfix | Deploy with next release | Technical debt]

**Code Changes**:

```[language]
// File: path/to/file.ext

// BEFORE (lines X-Y):
[Current problematic code]

// AFTER (proposed fix):
[Fixed code with inline comments explaining WHY]
```

**Why This Fix Works**: [Explanation of the solution mechanism]

### Test/Validation Plan

**Pre-Deployment Validation**:
```bash
# Local testing commands
# Include expected output
```

**Deployment Steps**:
1. [Step-by-step deployment procedure]
2. [Include rollback plan]

**Post-Deployment Validation**:
```bash
# Verification commands
# Expected results
```

**Monitoring**:
- Metric to watch: [metric_name] should [expected behavior]
- Log to check: [log_location] should show [expected pattern]
- Time to validate: [duration after deployment]

### Risks & Considerations

**Risk 1**: [Potential issue with the fix]
- **Likelihood**: [High | Medium | Low]
- **Impact**: [Critical | Moderate | Minor]
- **Mitigation**: [How to address or monitor]

**Risk 2**: [Another potential issue]
- **Likelihood**: [High | Medium | Low]
- **Impact**: [Critical | Moderate | Minor]
- **Mitigation**: [How to address or monitor]

### Related Issues

**Similar Problems Identified**:
- `file/path.ext:line`: [Related issue 1]
- `file/path.ext:line`: [Related issue 2]

**Recommended Follow-ups**:
1. [Additional fix or improvement]
2. [Preventive measure]

### Open Questions

- [Question requiring further investigation or user input]
- [Question about edge cases]

---

## Progress Updates

<!--
Use this section for status updates during investigation
-->

### [Agent Name] Update - [HH:MM]

**Status**: [Current activity]

**Progress**:
- ✅ Completed: [Task]
- 🔄 In Progress: [Task]
- ⏳ Pending: [Task]

**Current Findings**: [Preliminary observations]

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
- Cannot proceed with: [Investigation step]
- Blocking: [Critical path? Y/N]
- Users affected: [Ongoing | Will be affected]

**Need**:
- [ ] From Claude: [Specific clarification or action]
- [ ] From User: [Specific access, permission, or decision]
- [ ] External: [Third-party, infrastructure, or resource]

**Workaround**: [Alternative path if available, or "None"]

**Urgency**: [Immediate | Can wait hours | Can wait days]

---

## Resolution Summary

<!--
Fill this out when debugging session is complete
-->

**Root Cause**: [Final confirmed cause]

**Fix Applied**: [What was done to resolve]

**Validation Results**:
- [ ] Fix deployed successfully
- [ ] Symptoms resolved
- [ ] Metrics returned to normal
- [ ] No new issues introduced
- [ ] Monitoring confirms stability

**Timeline**:
- Problem identified: [Timestamp]
- Root cause found: [Timestamp]
- Fix deployed: [Timestamp]
- Validated: [Timestamp]
- Total time: [Duration]

**Key Learnings**:
- [What we learned about the system]
- [What we learned about debugging approach]
- [What could prevent this in future]

**Preventive Measures**:
- [ ] [Action to prevent recurrence]
- [ ] [Monitoring improvement]
- [ ] [Code or architecture improvement]

**Follow-up Issues Created**:
- [Link to follow-up ticket 1]
- [Link to follow-up ticket 2]

**Archive To**: `docs/learnings/incidents/YYYY-MM-DD-[topic].md`

---

<!--
==================================================================
TEMPLATE METADATA
==================================================================
Template: Debugging Scenario
Version: 2.5.0
Last Updated: 2025-11-05
Documentation: https://github.com/[your-org]/kiteagentcollab
==================================================================
-->
