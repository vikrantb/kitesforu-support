# Delegation Framework: When Claude Should Delegate to Codex

**Purpose**: Decision framework for autonomous delegation
**Audience**: Claude Code (primary), developers (reference)
**Status**: Production

---

## Overview

This document defines **when** and **how** Claude Code should delegate work to Codex (Cursor IDE). The framework enables **autonomous decision-making** while maintaining **human oversight**.

### Core Principle

**Delegate to amplify, not to avoid.**

Delegation is valuable when:
1. **Second opinion adds value** (cognitive diversity)
2. **Parallel work saves time** (efficiency gain)
3. **Context reset needed** (token management)

---

## Three-Tier Delegation Priority

```
Priority 1: SECOND OPINION
└─ Complexity HIGH + Uncertainty HIGH + Stakes HIGH

Priority 2: PARALLELIZATION
└─ Independent work + Time savings ≥ 20 min

Priority 3: TOKEN MANAGEMENT
└─ Context ≥ 95% + Task delegatable + Duration ≥ 30 min
```

---

## Priority 1: Second Opinion (Cognitive Diversity)

### When to Delegate

**Trigger Conditions** (ANY of these):

| Condition | Threshold | Reasoning |
|-----------|-----------|-----------|
| **Complexity** | HIGH | Multi-component, cross-domain, unfamiliar territory |
| **Uncertainty** | ≥ 50% | Low confidence in current approach |
| **Stakes** | High/Critical | Production, user-facing, irreversible changes |
| **Time Invested** | ≥ 60 min | Spinning wheels, need fresh perspective |
| **Failed Hypotheses** | ≥ 3 | Multiple approaches tried, all failed |

**Example Scenarios**:

```markdown
✅ DELEGATE: Debugging stalled
- Tried 3 hypotheses (IAM, subscription, encoding)
- All failed or low confidence (< 40%)
- 75 minutes invested
- Production impacting (HIGH stakes)
→ Second opinion from Codex valuable

✅ DELEGATE: Architecture decision
- Multiple valid approaches (microservices vs monolith)
- Trade-offs unclear
- Long-term implications (HIGH stakes)
→ Independent analysis from Codex valuable

❌ DON'T DELEGATE: Simple syntax error
- Low complexity
- High confidence in fix (> 90%)
- 5 minutes to resolve
→ Not worth coordination overhead
```

### Delegation Message Format

```markdown
---
protocol: "2.5"
type: "debugging"
priority: "high"
delegation_reason: "second_opinion"
complexity: "HIGH"
---

# Team Chat: [Topic]

## Attempts So Far

1. **Hypothesis**: [First approach]
   **Result**: [What happened]
   **Confidence**: [%]

2. **Hypothesis**: [Second approach]
   **Result**: [What happened]
   **Confidence**: [%]

3. **Hypothesis**: [Third approach]
   **Result**: [What happened]
   **Confidence**: [%]

## Evidence
[Links to logs, code, metrics]

## @codex Task

**Need**: Fresh perspective on root cause

**Context**: [Current understanding]

**Your Task**: [Specific investigation request]

**Questions**:
- [Specific question 1]
- [Specific question 2]

**Success Criteria**:
- [ ] Identify root cause (confidence ≥ 85%)
- [ ] Propose solution with rationale
- [ ] Provide test/validation approach
```

### Guidance Style

**For Second Opinion**:
- ✅ Share full context (attempts, evidence)
- ✅ Ask specific questions
- ✅ Request independent analysis
- ✅ Encourage Codex to challenge assumptions
- ❌ Don't prescribe approach
- ❌ Don't bias toward your hypothesis

---

## Priority 2: Parallelization (Efficiency Gain)

### When to Delegate

**Trigger Conditions** (ALL must be true):

| Condition | Requirement | Reasoning |
|-----------|-------------|-----------|
| **Independent Work** | No sequential dependency | Tasks can run concurrently |
| **Time Savings** | ≥ 20 minutes | Coordination overhead justified |
| **Claude Has Parallel Work** | Claude can do other tasks | Idle time avoided |
| **Codex Expertise Area** | Task matches Codex strengths | Quality outcome likely |

**Decision Matrix**:

```
Can tasks run in parallel?
├─ NO → Don't delegate for parallelization
└─ YES → Time savings ≥ 20 min?
    ├─ NO → Don't delegate
    └─ YES → Does Claude have other work?
        ├─ NO → Don't delegate (would be idle anyway)
        └─ YES → DELEGATE for parallelization
```

**Example Scenarios**:

```markdown
✅ DELEGATE: API deployment + log analysis
Claude Task: Deploy new API revision, run E2E tests
Codex Task: Analyze worker logs for schema issues
Parallel: Yes (independent work streams)
Time Savings: 45 min → 25 min (20 min saved)
Claude Busy: Yes (deploying and testing)
→ DELEGATE

✅ DELEGATE: Write tests + refactor module
Claude Task: Write integration tests for API
Codex Task: Refactor authentication module
Parallel: Yes (different codebases)
Time Savings: 60 min → 35 min (25 min saved)
→ DELEGATE

❌ DON'T DELEGATE: Sequential dependency
Claude Task: Deploy API (must finish first)
Potential Codex Task: Test deployed API (depends on Claude)
Parallel: No (sequential dependency)
→ DON'T DELEGATE
```

### Delegation Message Format

```markdown
---
protocol: "2.5"
type: "debugging" # or implementation, design, testing
priority: "medium"
delegation_reason: "parallelization"
complexity: "MEDIUM"
---

# Team Chat: [Topic]

## Parallel Work Plan

**Claude**: [What Claude will work on]
- Task: [Specific work]
- Duration: [Est. time]
- Checkpoint: [When Claude will check teamchat]

**Codex**: [What Codex will work on]
- Task: [Specific work]
- Independence: [How it's independent from Claude's work]

## @codex Task

**System**: [Component]
**Your Task**: [Specific investigation or implementation]

**Context**:
- Current state: [Where we are]
- Your focus: [What Codex should investigate]

**Success Criteria**:
- [ ] [Deliverable 1]
- [ ] [Deliverable 2]

**Coordination**:
- Claude's parallel work: [Brief description]
- Next sync: [Timestamp when Claude will check]

**Guidance**:
[Minimal - trust Codex to determine approach]
```

### Guidance Style

**For Parallelization**:
- ✅ Define clear, independent task
- ✅ Specify success criteria
- ✅ Communicate sync schedule
- ✅ Trust Codex on approach
- ❌ Don't micromanage
- ❌ Don't check too frequently (every 20-30 min is fine)

---

## Priority 3: Token Management (Context Reset)

### When to Delegate

**Trigger Conditions** (ALL must be true):

| Condition | Threshold | Reasoning |
|-----------|-----------|-----------|
| **Context Usage** | ≥ 95% (190K/200K tokens) | Near token limit |
| **Task Delegatable** | Codex can handle independently | Quality maintained |
| **Task Duration** | ≥ 30 minutes | Worth handoff overhead |
| **Context Reset Needed** | Claude needs fresh start | Next task benefits from clean context |

**Token Budget Awareness**:

```
Context Level | Action | Reasoning
─────────────────────────────────────────────────
0-75% (0-150K)     │ No action      │ Plenty of headroom
75-85% (150-170K)  │ Consider efficiency │ Plan for potential delegation
85-95% (170-190K)  │ Evaluate delegation │ Proactive management
95-100% (190-200K) │ DELEGATE       │ Near limit, reset needed
```

**Example Scenarios**:

```markdown
✅ DELEGATE: Context at 192K/200K
Current Task: Large refactor (est. 40 min)
Next Task: New feature design (needs fresh context)
→ DELEGATE refactor to Codex, Claude resets context

❌ DON'T DELEGATE: Context at 175K/200K
Current Task: Quick fix (5 min)
→ Finish current task, no need to delegate

❌ DON'T DELEGATE: Context at 195K/200K but task critical
Current Task: Production hotfix (needs Claude's specific context)
→ Keep task, accept context pressure
```

### Delegation Message Format

```markdown
---
protocol: "2.5"
type: "implementation" # or refactoring
priority: "low" # Token mgmt is lowest priority reason
delegation_reason: "token_management"
complexity: "MEDIUM"
---

# Team Chat: [Topic]

## Context Management

**Situation**: Claude context at 192K/200K tokens (96%)
**Action**: Delegating task to Codex for context reset

## @codex Task

**System**: [Component]
**Your Task**: [Autonomous work]

**Context**:
[Minimal context - Codex works independently]

**Success Criteria**:
- [ ] [Clear deliverables]

**Guidance**:
Work autonomously - minimal guidance provided.
Claude will review findings in next session with fresh context.
```

### Guidance Style

**For Token Management**:
- ✅ Provide minimal context (Codex works independently)
- ✅ Clear success criteria
- ✅ Trust Codex completely
- ❌ Don't over-explain (conserve tokens)
- ❌ Don't check frequently (let Codex finish)

---

## Complexity Scoring (3-Level System)

### Quick Assessment

```
LOW Complexity:
- Single file changes
- Well-understood problem
- Clear solution path
- < 30 min estimated
→ Keep task, don't delegate

MEDIUM Complexity:
- Multi-file changes (2-5 files)
- Some unknowns
- Multiple approaches possible
- 30-90 min estimated
→ Consider delegation (Priority 2: Parallelization)

HIGH Complexity:
- Cross-domain changes (6+ files)
- Many unknowns
- Unclear solution path
- > 90 min estimated
→ Strong candidate for delegation (Priority 1: Second Opinion)
```

### Scoring Factors

| Factor | +LOW | +MEDIUM | +HIGH |
|--------|------|---------|-------|
| **Files** | 1 file | 2-5 files | 6+ files |
| **Domains** | Single | 2 domains | 3+ domains |
| **Familiarity** | Very familiar | Somewhat familiar | Unfamiliar |
| **Stakes** | Low | Medium | High/Critical |
| **Unknowns** | None | Few | Many |

**Example**:
```
Task: Refactor authentication module
- Files: 8 files (HIGH)
- Domains: Backend + Frontend (MEDIUM)
- Familiarity: Worked on it before (LOW)
- Stakes: Production, user-facing (HIGH)
- Unknowns: Several edge cases (MEDIUM)

Score: HIGH complexity (3 HIGH, 1 MEDIUM, 1 LOW)
→ Strong candidate for Priority 1: Second Opinion
```

---

## When NOT to Delegate

### Never Delegate If

| Condition | Reason | Example |
|-----------|--------|---------|
| **Task < 5 minutes** | Overhead > benefit | Fix typo, update comment |
| **User input required** | Only Claude can interact | User needs to choose option |
| **Codex unavailable** | Can't delegate to offline agent | Codex not running |
| **Simple, clear task** | No value added | Update version number |
| **Already in flow** | Context switching cost high | Deep in implementation |
| **Real-time debugging** | Interactive investigation needed | User reports live issue |

### Decision Checklist

Before delegating, verify:

- [ ] Task is delegatable (Codex can handle independently)
- [ ] Delegation reason matches Priority 1, 2, or 3
- [ ] Coordination overhead < Time/Quality benefit
- [ ] Success criteria are clear and measurable
- [ ] Evidence/context is sufficient
- [ ] User doesn't need real-time updates

If ANY checkbox fails → **Don't delegate**

---

## Delegation Workflow

### Step 1: Assess

```
1. What is task complexity? (LOW/MEDIUM/HIGH)
2. Which delegation reason applies?
   - Second opinion? (Priority 1)
   - Parallelization? (Priority 2)
   - Token management? (Priority 3)
3. Does task meet threshold for delegation?
```

### Step 2: Prepare

```
1. Gather evidence (logs, code refs, metrics)
2. Document attempts (if second opinion)
3. Define success criteria
4. Determine guidance level:
   - Second opinion: Collaborative
   - Parallelization: Directive but flexible
   - Token management: Autonomous
```

### Step 3: Delegate

```
1. Create teamchat file (or use existing daily file)
2. Add YAML frontmatter with:
   - delegation_reason
   - complexity
   - priority
3. Write @codex task with:
   - Context
   - Evidence
   - Success criteria
   - Guidance
```

### Step 4: Parallel Work

```
1. If Priority 2 (parallelization):
   - Start Claude's parallel work
   - Check teamchat every 20-30 min
2. If Priority 1 (second opinion) or 3 (token mgmt):
   - Continue other work
   - Check teamchat less frequently (every 60 min)
```

### Step 5: Integrate

```
1. Review Codex findings
2. Assess confidence score
3. Validate solution (if provided)
4. Apply changes
5. Update teamchat with results
6. Close session if complete
```

---

## Examples

### Example 1: Second Opinion (Priority 1)

```markdown
**Scenario**: Debugging Pub/Sub delivery failure

Triggers:
✅ Complexity: HIGH (multi-component: API + Worker + Pub/Sub)
✅ Uncertainty: 60% (3 hypotheses, all low confidence)
✅ Stakes: HIGH (production, 5 days downtime)
✅ Time: 75 minutes invested
✅ Failed hypotheses: 3

Decision: DELEGATE (Priority 1: Second Opinion)

Message:
---
protocol: "2.5"
type: "debugging"
priority: "high"
delegation_reason: "second_opinion"
complexity: "HIGH"
---

[Full debugging delegation...]
```

### Example 2: Parallelization (Priority 2)

```markdown
**Scenario**: API deployment + Worker log analysis

Triggers:
✅ Independent: Yes (API deploy vs log analysis)
✅ Time savings: 45 min → 25 min (20 min saved)
✅ Claude busy: Yes (deploying and testing API)
✅ Codex expertise: Yes (log analysis)

Decision: DELEGATE (Priority 2: Parallelization)

Parallel work:
- Claude: Deploy API, run E2E tests (25 min)
- Codex: Analyze worker logs (25 min)
- Sync: Every 30 minutes

Message:
---
protocol: "2.5"
type: "debugging"
priority: "medium"
delegation_reason: "parallelization"
---

[Parallelization delegation...]
```

### Example 3: Token Management (Priority 3)

```markdown
**Scenario**: Context at 193K/200K tokens

Triggers:
✅ Context: 96.5% (193K/200K)
✅ Delegatable: Yes (auth module refactor)
✅ Duration: 45 minutes estimated
✅ Reset needed: Yes (new feature design next)

Decision: DELEGATE (Priority 3: Token Management)

Message:
---
protocol: "2.5"
type: "implementation"
priority: "low"
delegation_reason: "token_management"
complexity: "MEDIUM"
---

[Autonomous delegation with minimal context...]
```

---

## Integration with Protocol v2.5

This delegation framework works seamlessly with Protocol v2.5:

1. **YAML frontmatter** captures delegation metadata
2. **@codex Task** section follows delegation patterns
3. **Markdown flexibility** allows guidance customization
4. **State tracking** monitors delegation progress

---

## Automation Potential

### Current (Manual)
- Claude manually assesses delegation criteria
- Human can observe and intervene
- Decision rationale visible in teamchat

### Future (Automated)
- Automated complexity scoring
- Auto-detect delegation triggers
- Delegation recommendations in Claude UI
- Metrics dashboard showing delegation effectiveness

---

## References

- **Protocol**: [docs/01-protocol-v2.5.md](01-protocol-v2.5.md)
- **Codex Guidelines**: [docs/03-codex-protocol.md](03-codex-protocol.md)
- **Best Practices**: [docs/05-best-practices.md](05-best-practices.md)

---

**Version**: 1.0
**Status**: Production
**Last Updated**: 2025-11-05
