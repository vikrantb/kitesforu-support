---
# ==================================================================
# YAML Frontmatter - Edit these fields for your implementation session
# ==================================================================
protocol: "2.5"                    # Don't change (protocol version)
session: "impl-YYYY-MM-DD-topic"   # Example: "impl-2025-11-05-auth-api"
type: "implementation"             # Keep as "implementation"
priority: "medium"                 # low | medium | high | critical
delegation_reason: "parallelization" # second_opinion | parallelization | token_management
complexity: "MEDIUM"               # LOW | MEDIUM | HIGH
started: "2025-11-05T09:00:00Z"   # ISO 8601 UTC timestamp
updated: "2025-11-05T09:00:00Z"   # ISO 8601 UTC timestamp
status: "INITIATED"                # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---

<!--
==================================================================
IMPLEMENTATION SCENARIO TEMPLATE
==================================================================

USE THIS WHEN:
- Building new features or functionality
- Implementing approved designs
- Code refactoring or improvements
- Want to parallelize development work
- Need code review before merging

QUICK START:
1. Reference the design or specification
2. Define implementation scope clearly
3. List dependencies and blockers
4. Tag @codex with specific coding task
5. Coordinate parallel work if applicable

DELETE THIS COMMENT BLOCK WHEN READY
==================================================================
-->

# Implementation: [FEATURE_OR_COMPONENT_NAME]

**Feature**: [One-line description of what's being built]
**Type**: [New Feature | Enhancement | Refactoring | Bug Fix]
**Status**: [Planning | In Progress | Code Review | Testing | Complete]
**Target Release**: [Version or sprint]

---

## Specification Reference

**Design Document**: [Link to design doc or brief description]

**Requirements Summary**:
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

**Acceptance Criteria**:
- [ ] [Criterion 1 - must be testable]
- [ ] [Criterion 2 - must be testable]
- [ ] [Criterion 3 - must be testable]
- [ ] [Criterion 4 - must be testable]

---

## Implementation Scope

### In Scope (This Session)
- [ ] [Component or module 1]
- [ ] [Component or module 2]
- [ ] [Component or module 3]
- [ ] Tests for implemented functionality
- [ ] Documentation updates

### Out of Scope (Future Work)
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]

### Dependencies
- **Required Before Start**: [Blocking dependencies]
- **Needed During Development**: [Libraries, services, data]
- **Integration Points**: [APIs, services to integrate with]

---

## Technical Approach

### Architecture

```
[High-level component diagram]

┌─────────────────┐
│   Frontend      │
│   Component     │
└────────┬────────┘
         │
    ┌────▼────────────┐
    │   API Layer     │
    └────┬────────────┘
         │
    ┌────▼────────────┐
    │  Business Logic │
    └────┬────────────┘
         │
    ┌────▼────────────┐
    │   Data Layer    │
    └─────────────────┘
```

### Key Components

**Component 1**: [Name]
- **Location**: `path/to/component.ext`
- **Responsibility**: [What it does]
- **Key Methods/Functions**: [List main interfaces]
- **Dependencies**: [What it depends on]

**Component 2**: [Name]
- **Location**: `path/to/component.ext`
- **Responsibility**: [What it does]
- **Key Methods/Functions**: [List main interfaces]
- **Dependencies**: [What it depends on]

### Data Flow

```
Input → Validation → Processing → Storage → Response

1. User submits data
2. API validates format and permissions
3. Business logic processes request
4. Data persisted to database
5. Response returned to user
```

### Technology Stack
- **Language**: [Python | JavaScript | etc.]
- **Framework**: [React | Express | FastAPI | etc.]
- **Database**: [PostgreSQL | MongoDB | etc.]
- **Libraries**: [List key dependencies]

---

## Implementation Plan

### Phase 1: Core Functionality (EST: X hours)

**Tasks**:
1. [ ] Set up base project structure
2. [ ] Implement core business logic
3. [ ] Add basic error handling
4. [ ] Write unit tests for core logic

**Success Criteria**:
- Core functionality works in isolation
- Unit tests pass
- Code follows project conventions

---

### Phase 2: Integration (EST: Y hours)

**Tasks**:
1. [ ] Integrate with API layer
2. [ ] Connect to database
3. [ ] Add authentication/authorization
4. [ ] Write integration tests

**Success Criteria**:
- Component integrates with existing system
- Integration tests pass
- No breaking changes to existing functionality

---

### Phase 3: Polish & Documentation (EST: Z hours)

**Tasks**:
1. [ ] Add comprehensive error handling
2. [ ] Optimize performance
3. [ ] Write API documentation
4. [ ] Update user documentation
5. [ ] Code review and refinement

**Success Criteria**:
- Code review approved
- Documentation complete
- Performance meets requirements
- Ready for deployment

---

## Parallel Work Plan

<!--
DELETE THIS SECTION if not doing parallel work
Use when Claude and Codex work simultaneously
-->

**Claude Will Work On**:
- [Task 1] - Est: [X minutes]
- [Task 2] - Est: [Y minutes]
- Total: [Z minutes]

**Codex Will Work On**:
- [Task A] - Est: [X minutes]
- [Task B] - Est: [Y minutes]
- Total: [Z minutes]

**Independence Verification**:
- [ ] Tasks can run simultaneously
- [ ] No sequential dependencies between agent tasks
- [ ] Clear integration points defined
- [ ] Time savings: [Original time] → [Parallel time] = [Savings]%

**Sync Points**:
- **[HH:MM]**: First checkpoint - share progress
- **[HH:MM]**: Second checkpoint - integrate work
- **[HH:MM]**: Final sync - validate integration

---

## @codex Task

**Feature**: [Feature or component being implemented]
**Your Part**: [Specific implementation scope for Codex]
**Target Files**: [List of files to create or modify]

**Context**:
- **Overall Goal**: [High-level feature description]
- **Your Scope**: [Specific subset Codex implements]
- **Integration**: [How this connects to other work]
- **Existing Code**: [Relevant existing patterns or code to follow]

**Your Task**:
Implement [specific component or functionality] according to the specification above.

**Specific Requirements**:
1. [Detailed requirement 1]
2. [Detailed requirement 2]
3. [Detailed requirement 3]
4. Follow existing code style in `path/to/similar/file.ext`
5. Include unit tests for all new functionality

**Success Criteria**:
- [ ] Implementation matches specification
- [ ] All tests pass (both new and existing)
- [ ] Code follows project conventions
- [ ] No breaking changes introduced
- [ ] Documentation updated

**Code Style Guidelines**:
```[language]
// Example of project's preferred patterns
// Show specific coding conventions to follow
```

**Guidance**:
- **Patterns to Follow**: [Existing patterns or examples]
- **Libraries to Use**: [Preferred libraries or approaches]
- **Testing Approach**: [Testing framework and style]
- **Edge Cases**: [Known edge cases to handle]
- **Performance Considerations**: [Any performance requirements]

**Coordination** (if parallel work):
- **Claude's Parallel Work**: [What Claude works on simultaneously]
- **Integration Point**: [How work comes together]
- **Next Sync**: [When to check teamchat for coordination]

---

<!--
==================================================================
CODEX SECTION - Codex writes below this line
==================================================================
-->

## Codex Implementation

**Status**: [✅ Completed | 🔄 In Progress | 🚨 Blocked | ⏳ Pending]
**Confidence**: [0-100]%
**Time Spent**: [X minutes/hours]

### Implementation Summary

**Files Created/Modified**:
- `path/to/file1.ext` - [What was done]
- `path/to/file2.ext` - [What was done]
- `path/to/test.ext` - [Tests added]

**Key Decisions Made**:
1. [Decision 1]: [Rationale]
2. [Decision 2]: [Rationale]

### Code Implementation

#### File: `path/to/component.ext`

**Purpose**: [What this file does]

**Key Functions/Classes**:

```[language]
// Main implementation
// Include comprehensive inline comments

/**
 * [Function description]
 * @param {type} param1 - Description
 * @param {type} param2 - Description
 * @returns {type} Description
 */
function mainFunction(param1, param2) {
    // Implementation with explanatory comments
    // Explain WHY, not just WHAT

    // Handle edge case: [description]
    if (edgeCase) {
        // ...
    }

    return result;
}
```

**Error Handling**:
```[language]
// How errors are handled
try {
    // Operation
} catch (error) {
    // Specific error handling
    // Log appropriately
    // Return/throw appropriate error
}
```

#### File: `path/to/test.ext`

**Test Coverage**:

```[language]
describe('ComponentName', () => {
    describe('mainFunction', () => {
        it('should handle normal case', () => {
            // Test implementation
        });

        it('should handle edge case 1', () => {
            // Test implementation
        });

        it('should throw error for invalid input', () => {
            // Test implementation
        });
    });
});
```

**Test Results**:
```
✅ All tests passing (X/X)
Coverage: [X]%
```

### Integration Instructions

**For Claude** (if parallel work):
1. [Step to integrate Codex's work]
2. [Files that need coordination]
3. [Testing after integration]

**Manual Testing Steps**:
```bash
# Commands to test the implementation
npm run dev
# or
python main.py

# Expected behavior:
# [Description of what should happen]
```

**Verification Checklist**:
- [ ] Code compiles/runs without errors
- [ ] All new tests pass
- [ ] All existing tests still pass
- [ ] Integration with other components works
- [ ] Error cases handled appropriately

### Design Patterns Used

**Pattern 1**: [Pattern name]
- **Where**: `file.ext:line-range`
- **Why**: [Rationale for this pattern]

**Pattern 2**: [Pattern name]
- **Where**: `file.ext:line-range`
- **Why**: [Rationale for this pattern]

### Performance Considerations

**Complexity Analysis**:
- Time complexity: [O notation]
- Space complexity: [O notation]

**Optimization Opportunities**:
- [Potential optimization 1]
- [Potential optimization 2]

**Benchmarks** (if applicable):
- [Operation]: [X ms/ops or Y ops/sec]

### Known Limitations

**Limitation 1**: [Description]
- **Impact**: [What this affects]
- **Workaround**: [If available]
- **Future Work**: [How to address]

**Limitation 2**: [Description]
- **Impact**: [What this affects]
- **Workaround**: [If available]
- **Future Work**: [How to address]

### Documentation

**API Documentation**:
```
Endpoint: POST /api/v1/resource
Description: [What it does]

Request:
{
  "field": "value"
}

Response 200:
{
  "id": "uuid",
  "created": "timestamp"
}

Errors:
- 400: Invalid input format
- 401: Unauthorized
- 500: Server error
```

**Code Comments**: [Inline documentation approach]
**Usage Examples**: [Link to examples or inline examples]

### Testing & Quality

**Unit Test Results**:
```
✅ All tests passing
Total: [X] tests
Coverage: [Y]%
```

**Lint/Type Check**:
```bash
# Commands run
npm run lint
npm run typecheck

# Results
✅ No issues found
```

**Integration Test Results**:
```
✅ Integration tests passing
[Test scenario 1]: Pass
[Test scenario 2]: Pass
```

### Next Steps

**For Deployment**:
1. [ ] Merge feature branch
2. [ ] Run full test suite
3. [ ] Deploy to staging
4. [ ] Validate in staging environment
5. [ ] Deploy to production

**For Further Development**:
1. [ ] [Future enhancement 1]
2. [ ] [Future enhancement 2]

### Open Questions

- [Question about edge case or unclear requirement]
- [Question about performance optimization]

---

## Integration & Validation

<!--
Fill out after combining parallel work or after Codex completion
-->

**Integration Status**: [✅ Successful | ⚠️ Issues | 🔄 In Progress]

**Combined Work Validation**:
- [ ] All components integrated successfully
- [ ] No conflicts or breaking changes
- [ ] Full test suite passes
- [ ] Performance meets requirements

**Issues Found** (if any):
- [Issue 1]: [Description and resolution]
- [Issue 2]: [Description and resolution]

**Final Verification**:
```bash
# Commands to verify complete implementation
npm run test:all
npm run build
npm run lint

# Results
✅ All checks passing
```

---

## Code Review Checklist

**Functionality**:
- [ ] Meets all acceptance criteria
- [ ] Edge cases handled
- [ ] Error handling comprehensive
- [ ] Performance acceptable

**Code Quality**:
- [ ] Follows project conventions
- [ ] Well-commented and clear
- [ ] No code duplication
- [ ] Appropriate abstractions

**Testing**:
- [ ] Unit tests comprehensive
- [ ] Integration tests pass
- [ ] Edge cases tested
- [ ] Test coverage ≥ [X]%

**Documentation**:
- [ ] API documented
- [ ] Usage examples provided
- [ ] README updated
- [ ] CHANGELOG updated

**Security**:
- [ ] Input validation present
- [ ] Authentication/authorization correct
- [ ] No sensitive data exposed
- [ ] SQL injection / XSS prevented

---

## Session Summary

**Outcome**: [Feature complete | Partial completion | Blocked]

**Completed**:
- ✅ [Completed item 1]
- ✅ [Completed item 2]

**Pending**:
- ⏳ [Pending item 1]
- ⏳ [Pending item 2]

**Key Learnings**:
- [Technical insight 1]
- [Technical insight 2]

**What Worked Well**:
- [Success factor 1]
- [Success factor 2]

**What to Improve**:
- [Area for enhancement]

**Time Comparison** (if parallel work):
- Sequential estimate: [X minutes]
- Parallel actual: [Y minutes]
- Time saved: [Z minutes] ([%]%)

**Next Session**:
- Topic: [Follow-up work if any]
- Focus: [Specific area]

**Archive To**: `docs/implementations/YYYY-MM-DD-[feature].md`

---

<!--
==================================================================
TEMPLATE METADATA
==================================================================
Template: Implementation Scenario
Version: 2.5.0
Last Updated: 2025-11-05
Documentation: https://github.com/[your-org]/kiteagentcollab
==================================================================
-->
