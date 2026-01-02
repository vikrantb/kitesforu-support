# Best Practices for Claude-Codex Collaboration

**Audience**: Both Claude Code and Codex (Cursor IDE), developers using the framework
**Purpose**: Proven patterns and anti-patterns from real-world collaboration
**Status**: Production

---

## Overview

This document captures best practices learned from Claude-Codex collaboration, organized by collaboration type and common scenarios. These patterns optimize for **efficiency**, **quality**, and **autonomy** while maintaining **human oversight**.

---

## General Collaboration Principles

### DO ✅

**1. Be Explicit and Specific**
```markdown
❌ Bad: "Fix the API"
✅ Good: "Debug why POST /api/users returns 404. Focus on routes/users.js:15-30"
```

**2. Provide Evidence, Not Opinions**
```markdown
❌ Bad: "The system seems slow"
✅ Good: "API response time: 2.3s (target: <500ms). See logs at backend/logs/api.log:1234-1267"
```

**3. Use Checklists for Success Criteria**
```markdown
✅ Success Criteria:
- [ ] Root cause identified (confidence ≥ 85%)
- [ ] Fix tested locally
- [ ] No breaking changes
```

**4. Update Status Regularly**
- Every 20-30 minutes during active work
- Immediately when blocked
- Upon completing major milestones

**5. State Confidence Explicitly**
```markdown
**Confidence**: 85%

**Why this score**:
- ✅ Tested locally with 5 scenarios
- ✅ Matches error pattern
- ⚠️ Not tested in production
```

### DON'T ❌

**1. Don't Be Vague or Generic**
```markdown
❌ "Something's broken"
❌ "The app doesn't work"
❌ "Investigate the issue"
```

**2. Don't Skip Evidence**
```markdown
❌ "I think it's a database problem"
✅ "Database query timeout at 30s (logs: db.log:342). Connection pool at 100/100"
```

**3. Don't Micromanage**
```markdown
❌ "First check routes.js line 15, then check controllers.js line 42..."
✅ "Investigate 404 errors. Focus on routing layer. Use your judgment on approach"
```

**4. Don't Forget to Close Sessions**
- Archive completed sessions
- Update YAML status to CLOSED
- Document learnings and outcomes

**5. Don't Duplicate Work**
- Always check existing teamchat before starting
- Read previous attempts and findings
- Build on existing work, don't restart

---

## Debugging Collaboration

### When to Delegate

**Delegate for Second Opinion When**:
- ✅ 3+ hypotheses failed (each <50% confidence)
- ✅ 60+ minutes invested without resolution
- ✅ Problem spans multiple components
- ✅ High stakes (production, user-facing)

**Don't Delegate When**:
- ❌ Problem is simple syntax or typo
- ❌ Less than 10 minutes investigation
- ❌ Clear solution already known
- ❌ Requires real-time user interaction

### Effective Debugging Delegation

**Pattern: Evidence-First**
```markdown
## Evidence
**Error**: `JSONDecodeError: line 1 column 2`
**Location**: `worker.py:156`
**Frequency**: 45% of messages (last hour)
**Logs**:
```
[Paste exact error with context]
```

## Attempts So Far
1. **Hypothesis**: Encoding issue
   **Tested**: Changed encoding to utf-8
   **Result**: Still failing
   **Confidence**: 30%

## @codex Task
Find root cause of JSON parsing failure.
**Focus**: Message encoding between API and worker
**Success**: Root cause (≥85% confidence) + fix
```

### Anti-Patterns

**❌ Vague Symptom Description**
```markdown
"The API isn't working"
```

**✅ Specific Symptom Description**
```markdown
"POST /api/users returns 404. Started after deployment API-00168.
Affects 100% of requests. GET /api/users works normally."
```

**❌ No Attempts Documented**
```markdown
"I tried some things but nothing worked"
```

**✅ Attempts Documented**
```markdown
## Attempts So Far
1. **Hypothesis**: Route path mismatch
   **Investigation**: Verified routes.js:15 has '/api/users'
   **Result**: Path is correct
   **Confidence**: 90%
```

---

## Design Review Collaboration

### When to Delegate

**Delegate for Second Opinion When**:
- ✅ Multiple valid architectural approaches
- ✅ Long-term consequences unclear
- ✅ High reversibility cost
- ✅ Cross-domain complexity

**Don't Delegate When**:
- ❌ Trivial implementation details
- ❌ Arbitrary style preferences
- ❌ Decisions already made and approved
- ❌ Emergency hotfixes (no time for review)

### Effective Design Delegation

**Pattern: Trade-offs Analysis**
```markdown
## Design Decision: Database Choice

**Options**:
1. **PostgreSQL**: Relational, strong consistency
   - ✅ ACID guarantees, complex queries
   - ❌ Harder horizontal scaling

2. **MongoDB**: Document store, flexible schema
   - ✅ Easy horizontal scaling, flexible
   - ❌ Weaker consistency guarantees

**Proposed**: PostgreSQL

**Rationale**: Financial data requires ACID. Scale needs moderate (<10K ops/sec)

## @codex Task
**Question**: Are we underestimating future scale?
Would starting with PostgreSQL create migration problems if we hit 100K ops/sec in 2 years?
```

### Anti-Patterns

**❌ Asking for Preferences**
```markdown
"Which database do you think is better?"
```

**✅ Asking for Analysis**
```markdown
"Given 10K ops/sec now, 100K ops/sec in 2 years, financial data requiring ACID,
is PostgreSQL the right choice or would future migration costs outweigh benefits?"
```

---

## Implementation Collaboration

### Parallelization Opportunities

**Parallel When**:
- ✅ Independent components (API + Worker)
- ✅ Time savings ≥20 minutes
- ✅ Clear integration points defined
- ✅ Claude has other work to do

**Sequential When**:
- ❌ Dependencies between tasks
- ❌ Integration complexity high
- ❌ Time savings <20 minutes
- ❌ Claude would be idle anyway

### Effective Parallel Delegation

**Pattern: Clear Boundaries**
```markdown
## Parallel Work Plan

**Claude**: Deploy API-00169, run E2E tests (25 min)
**Codex**: Analyze worker logs for schema errors (25 min)

**Integration**: Codex findings inform API-00170 deployment decisions

**Sync**: Every 30 minutes

## @codex Task
Analyze `worker-*` logs (last 24 hours) for schema validation errors.
**Focus**: Pattern analysis and recommendations
**Deliverable**: Error breakdown + fix recommendations
**Timeline**: Claude will check back at [HH:MM + 30]
```

### Anti-Patterns

**❌ Unclear Boundaries**
```markdown
"Work on the authentication system while I do other stuff"
```

**✅ Clear Boundaries**
```markdown
**Codex**: Implement JWT token validation in auth.js
**Claude**: Implement refresh token logic in users.js
**Integration Point**: auth.verifyToken() interface
**Sync**: 15:30 (30 minutes)
```

---

## Testing Collaboration

### When to Delegate

**Delegate When**:
- ✅ Large test surface area
- ✅ Clear specifications provided
- ✅ Existing test patterns to follow
- ✅ Independent of other work

**Don't Delegate When**:
- ❌ Tests require deep domain knowledge
- ❌ Testing strategy unclear
- ❌ Rapid iteration needed
- ❌ Test data complex to set up

### Effective Testing Delegation

**Pattern: Comprehensive Specification**
```markdown
## @codex Task
Write unit tests for `auth.js` (lines 1-150)

**Framework**: Jest
**Coverage Target**: ≥90%
**Existing Pattern**: See `tests/auth.test.js` for style

**Test Cases Required**:
- ✅ Happy path: valid token → user object
- ⚠️ Edge: expired token → error
- ⚠️ Edge: malformed token → error
- ❌ Error: missing token → 401
- ❌ Error: invalid signature → 401

**Mocking**: Mock database calls using `jest.mock('./db')`
**Data**: Use fixtures from `tests/fixtures/users.js`

**Success**:
- [ ] All cases above covered
- [ ] Coverage ≥90%
- [ ] All tests pass
- [ ] No flaky tests (10 runs = 10 passes)
```

---

## Communication Best Practices

### Frequency Guidelines

| Situation | Update Frequency | Format |
|-----------|-----------------|--------|
| **Normal Progress** | Every 20-30 min | Brief status update |
| **Blocker Hit** | Immediately | Detailed blocker message |
| **Major Milestone** | Upon completion | Summary with evidence |
| **Task Complete** | Immediately | Full findings report |

### Message Quality

**❌ Low Quality**
```markdown
"Still working on it"
```

**✅ High Quality**
```markdown
## Codex Update - 14:30

**Status**: 🔄 Analyzing logs (Phase 2 of 3)

**Progress**:
- ✅ Downloaded 50K log entries
- 🔄 Pattern analysis in progress
- ⏳ Recommendations pending

**Preliminary Findings**:
- 342 schema errors found
- 3 distinct patterns identified

**Next Checkpoint**: 15:00
```

### Confidence Transparency

**Always State Uncertainty**:
```markdown
**Confidence**: 70%

**High Confidence**:
- ✅ Error pattern matches exactly
- ✅ Fix works locally

**Lower Confidence**:
- ⚠️ Not tested in production environment
- ⚠️ Edge case with null values unclear
```

---

## File Organization Best Practices

### Teamchat File Naming

**Option A: Daily Files (Recommended)**
```
teamchat/2025-11-05.md      # All today's collaboration
teamchat/2025-11-06.md      # All tomorrow's collaboration
```

**Benefits**:
- Simple to locate
- Natural chronological order
- Good for many small tasks

**Option B: Topic Files (For Complex Projects)**
```
teamchat/2025-11-05-api-debug.md
teamchat/2025-11-05-auth-refactor.md
teamchat/2025-11-05-performance.md
```

**Benefits**:
- Clear topic separation
- Better for long-running investigations
- Easier to reference specific topics

### Session Lifecycle

**1. Start Session**
```markdown
---
protocol: "2.5"
session: "debug-2025-11-05-api"
type: "debugging"
priority: "high"
started: "2025-11-05T10:00:00Z"
status: "INITIATED"
---
```

**2. Work Session**
```markdown
status: "IN_PROGRESS"
updated: "2025-11-05T10:30:00Z"
```

**3. Complete Session**
```markdown
status: "COMPLETED"
updated: "2025-11-05T11:15:00Z"

## Session Summary
**Outcome**: Root cause found and fixed
**Confidence**: 92%
[...]
```

**4. Close Session**
```markdown
status: "CLOSED"
**Archive To**: `docs/learnings/incidents/2025-11-05-api-404.md`
```

---

## Conflict Resolution

### When Findings Differ

**Pattern: Evidence-Based Discussion**
```markdown
## Codex Findings
**Root Cause**: Message encoding (str() instead of json.dumps())
**Confidence**: 92%
**Evidence**: [Logs showing single-quote dict format]

## Claude's Earlier Hypothesis
**Hypothesis**: IAM permissions issue
**Confidence**: 30% (disproven)

## Resolution
- **Evidence supports Codex analysis**: Logs clearly show format mismatch
- **Claude's hypothesis ruled out**: Permissions verified as correct
- **Action**: Implement Codex's recommended fix
```

### When Approaches Conflict

**Don't**:
- ❌ Argue about subjective preferences
- ❌ Dismiss alternative approaches without evidence
- ❌ Force consensus prematurely

**Do**:
- ✅ Test both approaches if feasible
- ✅ Evaluate trade-offs explicitly
- ✅ Let data decide when possible
- ✅ Escalate to human if truly unclear

---

## Performance Optimization

### Minimize Coordination Overhead

**Parallel Work**:
- Define clear boundaries upfront
- Minimize sync points (every 20-30 min sufficient)
- Document integration points clearly

**Async Communication**:
- Don't wait for acknowledgment to start
- Use teamchat status to coordinate
- Trust agents to work independently

### Maximize Efficiency

**Batch Evidence Gathering**:
```markdown
## Evidence
✅ Logs: backend/logs/api.log:1234-1267
✅ Metrics: api_latency=2.3s (target <500ms)
✅ Code: routes.js:15-30
✅ Recent changes: API-00168 deployed 2025-11-05 09:00
```

**Use Links, Not Duplication**:
```markdown
❌ [Paste 100 lines of logs here]
✅ Logs: `backend/logs/api.log:1234-1267`
    Key error: JSONDecodeError at line 342
    Query: `grep "JSONDecode" api.log | tail -20`
```

---

## Quality Gates

### Before Delegation

**Checklist**:
- [ ] Problem statement clear and specific
- [ ] Evidence gathered and linked
- [ ] Success criteria defined
- [ ] Complexity assessment done
- [ ] Delegation reason clear (second opinion | parallelization | token mgmt)

### Before Marking Complete

**Checklist**:
- [ ] All success criteria met
- [ ] Confidence level stated and justified
- [ ] Evidence provided for conclusions
- [ ] Risks and limitations documented
- [ ] Next steps or follow-up items identified

### Before Closing Session

**Checklist**:
- [ ] Work validated (tests pass, fix works, etc.)
- [ ] Status updated to COMPLETED then CLOSED
- [ ] Session summary written
- [ ] Key learnings documented
- [ ] Archived appropriately

---

## Anti-Patterns to Avoid

### Delegation Anti-Patterns

**❌ Premature Delegation**
```markdown
"I haven't looked at this yet, can you investigate?"
```
**Why Bad**: Inefficient use of collaboration. Investigate first, delegate when stuck.

**❌ Over-Delegation**
```markdown
"Fix typo in line 42" → @codex
```
**Why Bad**: Coordination overhead > task complexity.

**❌ Under-Specification**
```markdown
"Make the API faster"
```
**Why Bad**: No clear success criteria, constraints, or focus area.

### Communication Anti-Patterns

**❌ Radio Silence**
```markdown
[No updates for 60+ minutes on active task]
```
**Why Bad**: Other agent doesn't know status, can't plan effectively.

**❌ Over-Communication**
```markdown
[Update every 5 minutes with trivial progress]
```
**Why Bad**: Noise reduces signal, wastes time reviewing updates.

**❌ Claiming Certainty Without Evidence**
```markdown
"The database is definitely the problem" (Confidence: 100%)
```
**Why Bad**: Misleads investigation, wastes time on wrong approach.

### Quality Anti-Patterns

**❌ Skipping Tests**
```markdown
"Fixed it. Didn't test but should work."
```
**Why Bad**: High risk of breaking production or introducing new bugs.

**❌ No Root Cause Analysis**
```markdown
"I restarted the server and it works now. Closing."
```
**Why Bad**: Problem likely to recur, no learning captured.

**❌ Solution Without Understanding**
```markdown
"I found this on Stack Overflow. Try it."
```
**Why Bad**: Copy-paste solutions without understanding often fail or cause new problems.

---

## Success Patterns

### Pattern: Systematic Debugging

1. **Gather Evidence First**
   - Logs, errors, metrics, recent changes
   - Reproduce issue reliably if possible

2. **Form Hypotheses**
   - Based on evidence, not guesses
   - Testable and falsifiable

3. **Test Systematically**
   - One hypothesis at a time
   - Document results and confidence

4. **Delegate at Right Time**
   - After 3 failed hypotheses OR
   - After 60+ minutes without progress OR
   - When fresh perspective clearly valuable

5. **Validate Solution**
   - Test fix locally
   - Verify in production
   - Monitor for recurrence

### Pattern: Effective Parallelization

1. **Plan Work Splits**
   - Identify independent components
   - Calculate time savings (≥20 min)
   - Define integration points

2. **Coordinate Upfront**
   - Clear task boundaries
   - Sync schedule (every 20-30 min)
   - Integration strategy

3. **Work Independently**
   - Trust agents to execute
   - Minimal coordination overhead
   - Focus on own deliverables

4. **Integrate Systematically**
   - Combine work at sync points
   - Test integration
   - Resolve conflicts collaboratively

5. **Validate Together**
   - End-to-end testing
   - Performance validation
   - Quality gates

### Pattern: High-Quality Design Review

1. **Present Complete Context**
   - Problem statement
   - Requirements and constraints
   - Proposed solution with rationale
   - Alternative approaches considered

2. **Request Specific Analysis**
   - Focus areas for review
   - Specific questions to answer
   - Trade-offs to evaluate

3. **Receive Independent Assessment**
   - Unbiased evaluation
   - Alternative perspectives
   - Risk identification

4. **Discuss Trade-offs**
   - Evidence-based discussion
   - Explicit trade-off analysis
   - Consensus or informed disagreement

5. **Document Decision**
   - Final approach with rationale
   - Risks accepted
   - Implementation roadmap

---

## Metrics and Improvement

### Collaboration Effectiveness Metrics

**Time Efficiency**:
- Time to resolution (vs. single-agent baseline)
- Coordination overhead as % of total time
- Parallelization time savings

**Quality Indicators**:
- Confidence scores (target ≥85%)
- Bug introduction rate
- Rework required

**Communication Quality**:
- Updates per session (target: every 20-30 min)
- Evidence provided (% of claims backed)
- Clarity score (subjective human assessment)

### Continuous Improvement

**After Each Session**:
```markdown
## Session Summary
**What Worked**:
- [Pattern that was effective]

**What to Improve**:
- [Pattern that was inefficient or unclear]

**Key Learning**:
- [Insight about problem domain or collaboration]
```

**Periodic Review**:
- Review archived sessions monthly
- Identify recurring patterns (good and bad)
- Update this best practices document
- Share learnings with team

---

## Quick Reference

### Delegation Decision Tree

```
Problem or task identified
├─ Complexity = LOW (< 30 min) → DON'T DELEGATE
├─ Complexity = MEDIUM (30-90 min)
│  ├─ Can work in parallel? → YES → DELEGATE (Parallelization)
│  └─ Cannot parallel? → NO → DON'T DELEGATE (do it yourself)
└─ Complexity = HIGH (> 90 min)
   ├─ Stuck (3 failures OR 60+ min)? → YES → DELEGATE (Second Opinion)
   ├─ Token usage > 95%? → YES → DELEGATE (Token Management)
   └─ Neither? → NO → Continue working
```

### Success Criteria Checklist

- [ ] Clear and specific
- [ ] Testable/measurable
- [ ] Achievable in reasonable time
- [ ] Relevant to actual problem
- [ ] Includes confidence target

### Communication Checklist

- [ ] Status clearly stated (✅/🔄/🚨/⏳)
- [ ] Progress against plan shown
- [ ] Confidence score with rationale
- [ ] Evidence for all claims
- [ ] Next steps or checkpoint clear

---

## References

- **Protocol Specification**: [docs/01-protocol-v2.5.md](01-protocol-v2.5.md)
- **Delegation Framework**: [docs/02-delegation-framework.md](02-delegation-framework.md)
- **Codex Protocol**: [docs/03-codex-protocol.md](03-codex-protocol.md)
- **Getting Started**: [docs/00-getting-started.md](00-getting-started.md)

---

**Version**: 1.0
**Status**: Production
**Last Updated**: 2025-11-05
