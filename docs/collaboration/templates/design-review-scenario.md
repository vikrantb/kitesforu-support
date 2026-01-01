---
# ==================================================================
# YAML Frontmatter - Edit these fields for your design session
# ==================================================================
protocol: "2.5"                    # Don't change (protocol version)
session: "design-YYYY-MM-DD-topic" # Example: "design-2025-11-05-auth-arch"
type: "design"                     # Keep as "design"
priority: "medium"                 # low | medium | high | critical
delegation_reason: "second_opinion" # second_opinion | parallelization | token_management
complexity: "HIGH"                 # LOW | MEDIUM | HIGH
started: "2025-11-05T14:00:00Z"   # ISO 8601 UTC timestamp
updated: "2025-11-05T14:00:00Z"   # ISO 8601 UTC timestamp
status: "INITIATED"                # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---

<!--
==================================================================
DESIGN REVIEW SCENARIO TEMPLATE
==================================================================

USE THIS WHEN:
- Making architectural decisions with long-term impact
- Designing new systems or major features
- Evaluating multiple technical approaches
- Need second opinion on design trade-offs
- Complex integration or interface design

QUICK START:
1. Describe the problem or requirement clearly
2. Document proposed approach or competing alternatives
3. List constraints and requirements
4. Tag @codex for independent design analysis
5. Review findings and make informed decision

DELETE THIS COMMENT BLOCK WHEN READY
==================================================================
-->

# Design Review: [SYSTEM_OR_FEATURE_NAME]

**Design Goal**: [One-line description of what needs to be designed]
**Decision Type**: [Architecture | API | Data Model | Integration | Interface]
**Timeline**: [Immediate | This sprint | Next quarter]
**Reversibility**: [Easily reversible | Costly to reverse | Irreversible]

---

## Problem Statement

### Business Context
- **User Need**: [What problem does this solve for users]
- **Business Value**: [Why this matters to the organization]
- **Success Metrics**: [How we'll measure success]
- **Priority Rationale**: [Why now, why this approach]

### Technical Context
- **Current State**: [Existing system or gap being addressed]
- **Scale Requirements**: [Users, requests/sec, data volume, growth projections]
- **Integration Points**: [Systems this will interact with]
- **Technology Constraints**: [Must use X, cannot use Y, prefer Z]

### Scope
**In Scope**:
- [Component or feature 1]
- [Component or feature 2]
- [Component or feature 3]

**Out of Scope** (explicitly):
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]

---

## Requirements

### Functional Requirements
1. **[Requirement 1]**: [Description]
   - Priority: [Must have | Should have | Nice to have]
   - Rationale: [Why this matters]

2. **[Requirement 2]**: [Description]
   - Priority: [Must have | Should have | Nice to have]
   - Rationale: [Why this matters]

3. **[Requirement 3]**: [Description]
   - Priority: [Must have | Should have | Nice to have]
   - Rationale: [Why this matters]

### Non-Functional Requirements
- **Performance**: [Latency, throughput, response time targets]
- **Scalability**: [Growth expectations, load patterns]
- **Reliability**: [Uptime requirements, error rates]
- **Security**: [Authentication, authorization, data protection]
- **Maintainability**: [Code clarity, testability, documentation]
- **Operability**: [Monitoring, debugging, deployment]

### Constraints
- **Technical**: [Language, framework, infrastructure limitations]
- **Business**: [Budget, timeline, resource constraints]
- **Compliance**: [Regulatory, security, privacy requirements]
- **Legacy**: [Existing systems must be supported]

---

## Proposed Design

### High-Level Architecture

```
[ASCII diagram or description of system architecture]

┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  Component  │─────▶│  Component  │─────▶│  Component  │
│      A      │      │      B      │      │      C      │
└─────────────┘      └─────────────┘      └─────────────┘
       │                    │                     │
       └────────────────────┴─────────────────────┘
                            │
                     ┌──────▼──────┐
                     │  Data Store │
                     └─────────────┘
```

**Component Responsibilities**:
- **Component A**: [What it does, why it exists]
- **Component B**: [What it does, why it exists]
- **Component C**: [What it does, why it exists]

### Key Design Decisions

#### Decision 1: [Choice Made]

**Options Considered**:
1. **Option A**: [Description]
   - Pros: [Advantage 1, Advantage 2]
   - Cons: [Disadvantage 1, Disadvantage 2]

2. **Option B**: [Description]
   - Pros: [Advantage 1, Advantage 2]
   - Cons: [Disadvantage 1, Disadvantage 2]

3. **Option C**: [Description]
   - Pros: [Advantage 1, Advantage 2]
   - Cons: [Disadvantage 1, Disadvantage 2]

**Chosen**: [Selected option]

**Rationale**: [Why this choice over alternatives]

---

#### Decision 2: [Choice Made]

**Options Considered**:
[Same structure as Decision 1]

**Chosen**: [Selected option]

**Rationale**: [Why this choice over alternatives]

---

### Data Model

**Entities and Relationships**:

```
[Entity relationship diagram or description]

User {
  id: UUID
  email: string
  created_at: timestamp
}

Resource {
  id: UUID
  user_id: UUID -> User.id
  data: jsonb
  updated_at: timestamp
}
```

**Storage Strategy**:
- **Database**: [PostgreSQL | MongoDB | DynamoDB | etc.]
- **Rationale**: [Why this database choice]
- **Capacity Planning**: [Expected data volume, growth rate]

### API Design

**Endpoints**:

```
POST /api/v1/resources
GET /api/v1/resources/:id
PUT /api/v1/resources/:id
DELETE /api/v1/resources/:id
```

**Request/Response Formats**:

```json
// POST /api/v1/resources
{
  "name": "string",
  "config": {
    "key": "value"
  }
}

// Response 201 Created
{
  "id": "uuid",
  "name": "string",
  "config": {...},
  "created_at": "2025-11-05T10:30:00Z"
}
```

**Error Handling**:
- 400 Bad Request: [When and format]
- 401 Unauthorized: [When and format]
- 404 Not Found: [When and format]
- 500 Internal Error: [When and format]

### Integration Points

**External Systems**:
1. **[System A]**: [How we integrate, data flow, failure handling]
2. **[System B]**: [How we integrate, data flow, failure handling]

**Internal Services**:
1. **[Service A]**: [Interface, dependencies, communication pattern]
2. **[Service B]**: [Interface, dependencies, communication pattern]

---

## Trade-offs Analysis

### Performance vs Maintainability
- **Choice**: [What we chose to optimize]
- **Trade-off**: [What we sacrificed]
- **Rationale**: [Why this balance is right]

### Scalability vs Simplicity
- **Choice**: [What we chose to optimize]
- **Trade-off**: [What we sacrificed]
- **Rationale**: [Why this balance is right]

### Flexibility vs Constraints
- **Choice**: [What we chose to optimize]
- **Trade-off**: [What we sacrificed]
- **Rationale**: [Why this balance is right]

---

## Alternative Approaches Considered

### Alternative 1: [Approach Name]

**Description**: [How this approach would work]

**Advantages**:
- [Advantage 1]
- [Advantage 2]

**Disadvantages**:
- [Disadvantage 1]
- [Disadvantage 2]

**Why Not Chosen**: [Decision rationale]

---

### Alternative 2: [Approach Name]

**Description**: [How this approach would work]

**Advantages**:
- [Advantage 1]
- [Advantage 2]

**Disadvantages**:
- [Disadvantage 1]
- [Disadvantage 2]

**Why Not Chosen**: [Decision rationale]

---

## @codex Task

**System**: [System or feature being designed]
**Design Type**: [Architecture | API | Data Model | Integration]
**Decision Stage**: [Proposal | Review | Validation]

**Context**:
- **Problem**: [Technical problem to solve]
- **Proposed Solution**: [High-level approach above]
- **Constraints**: [Key limitations or requirements]
- **Uncertainty**: [Areas where confidence is low]

**Your Task**:
Review the proposed design for [specific aspect]. Provide independent analysis of:
- Architectural soundness and scalability
- Potential issues or blind spots
- Alternative approaches worth considering
- Risk assessment and mitigation strategies

**Specific Questions**:
1. [Question about design decision 1]
2. [Question about scalability or performance]
3. [Question about trade-offs or alternatives]
4. [Question about risks or edge cases]

**Success Criteria**:
- [ ] Identify potential design issues (confidence ≥ 80%)
- [ ] Validate or challenge key design decisions
- [ ] Propose improvements or alternatives if applicable
- [ ] Assess scalability and maintainability
- [ ] Highlight risks and mitigation strategies

**Guidance**:
- **Focus Areas**: [Specific aspects to emphasize - scalability, maintainability, etc.]
- **Approach**: [Any specific analysis methodology]
- **Constraints**: [Factors that limit options]
- **Use Your Judgment**: [Areas where Codex decides analysis depth]

---

<!--
==================================================================
CODEX SECTION - Codex writes below this line
==================================================================
-->

## Codex Analysis

**Status**: [✅ Completed | 🔄 In Progress | 🚨 Blocked | ⏳ Pending]
**Confidence**: [0-100]%
**Time Spent**: [X minutes/hours]

### Overall Assessment

**Design Quality**: [Excellent | Good | Acceptable | Needs Revision]

**Strengths**:
- [Strength 1]
- [Strength 2]
- [Strength 3]

**Concerns**:
- [Concern 1]
- [Concern 2]
- [Concern 3]

### Detailed Analysis

#### Architecture Review

**Scalability Assessment**:
- [Analysis of how design scales]
- [Potential bottlenecks identified]
- [Recommendations for scale]

**Maintainability Assessment**:
- [Analysis of code complexity]
- [Testing and debugging considerations]
- [Long-term maintenance implications]

**Security Assessment**:
- [Security considerations]
- [Potential vulnerabilities]
- [Recommended security measures]

#### Design Decision Validation

**Decision 1 Analysis**: [Chosen approach]
- ✅ **Agree** | ⚠️ **Concerns** | ❌ **Recommend Reconsider**
- **Reasoning**: [Why this assessment]
- **Alternative Consideration**: [If applicable]

**Decision 2 Analysis**: [Chosen approach]
- ✅ **Agree** | ⚠️ **Concerns** | ❌ **Recommend Reconsider**
- **Reasoning**: [Why this assessment]
- **Alternative Consideration**: [If applicable]

#### Identified Issues

**Issue 1**: [Description]
- **Severity**: [Critical | High | Medium | Low]
- **Impact**: [What could go wrong]
- **Recommendation**: [How to address]

**Issue 2**: [Description]
- **Severity**: [Critical | High | Medium | Low]
- **Impact**: [What could go wrong]
- **Recommendation**: [How to address]

### Alternative Approach Suggestion

[If Codex identifies a significantly better approach]

**Proposed Alternative**: [Description]

**Advantages Over Current Design**:
- [Advantage 1]
- [Advantage 2]

**Trade-offs**:
- [What this approach sacrifices]

**Implementation Complexity**: [Higher | Similar | Lower]

### Risk Assessment

**High-Risk Areas**:
1. **[Risk 1]**: [Description]
   - **Probability**: [High | Medium | Low]
   - **Impact**: [Critical | Moderate | Minor]
   - **Mitigation**: [Recommended mitigation strategy]

2. **[Risk 2]**: [Description]
   - **Probability**: [High | Medium | Low]
   - **Impact**: [Critical | Moderate | Minor]
   - **Mitigation**: [Recommended mitigation strategy]

**Edge Cases to Consider**:
- [Edge case 1 and handling strategy]
- [Edge case 2 and handling strategy]

### Recommendations

**Must Address Before Implementation**:
1. [Critical recommendation 1]
2. [Critical recommendation 2]

**Should Consider**:
1. [Important recommendation 1]
2. [Important recommendation 2]

**Nice to Have**:
1. [Optional improvement 1]
2. [Optional improvement 2]

### Implementation Roadmap Suggestion

**Phase 1 (MVP)**:
- [Core functionality to implement first]
- [Rationale for MVP scope]

**Phase 2 (Enhancement)**:
- [Features to add in second phase]
- [Why deferred from MVP]

**Phase 3 (Optimization)**:
- [Performance and scaling improvements]
- [When these become necessary]

### Open Questions

- [Question requiring further discussion or research]
- [Question about unclear requirements]
- [Question about edge cases or scenarios]

---

## Decision Record

<!--
Fill this out after review and discussion
-->

**Final Decision**: [Proceed as proposed | Proceed with modifications | Redesign]

**Key Changes from Original**:
- [Change 1 based on review]
- [Change 2 based on review]

**Rationale for Changes**:
[Why the modifications were made]

**Remaining Risks Accepted**:
- [Risk 1]: [Why accepted]
- [Risk 2]: [Why accepted]

**Success Criteria Validation**:
- [ ] Design meets all functional requirements
- [ ] Non-functional requirements addressed
- [ ] Scalability validated for expected growth
- [ ] Security considerations incorporated
- [ ] Maintainability acceptable for team
- [ ] Integration points clearly defined

**Approval**:
- **Reviewed By**: [Names or roles]
- **Approved By**: [Names or roles]
- **Date**: [YYYY-MM-DD]

**Next Steps**:
1. [Create implementation tickets]
2. [Write technical specification]
3. [Begin implementation in phase 1]

**Documentation**:
- **Design Doc**: [Link to detailed design document]
- **ADR**: [Link to Architecture Decision Record if applicable]
- **Diagrams**: [Link to detailed architecture diagrams]

---

## Session Summary

**Outcome**: [Design validated | Design improved | Alternative identified]

**Key Learnings**:
- [Design insight 1]
- [Design insight 2]
- [Design insight 3]

**What Worked**:
- [Success factor 1]
- [Success factor 2]

**What to Improve**:
- [Area for enhancement in next design session]

**Archive To**: `docs/architecture/designs/YYYY-MM-DD-[topic].md`

---

<!--
==================================================================
TEMPLATE METADATA
==================================================================
Template: Design Review Scenario
Version: 2.5.0
Last Updated: 2025-11-05
Documentation: https://github.com/[your-org]/kiteagentcollab
==================================================================
-->
