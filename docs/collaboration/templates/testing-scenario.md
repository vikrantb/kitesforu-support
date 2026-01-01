---
# ==================================================================
# YAML Frontmatter - Edit these fields for your testing session
# ==================================================================
protocol: "2.5"                    # Don't change (protocol version)
session: "test-YYYY-MM-DD-topic"   # Example: "test-2025-11-05-api-coverage"
type: "testing"                    # Keep as "testing"
priority: "medium"                 # low | medium | high | critical
delegation_reason: "parallelization" # second_opinion | parallelization | token_management
complexity: "MEDIUM"               # LOW | MEDIUM | HIGH
started: "2025-11-05T11:00:00Z"   # ISO 8601 UTC timestamp
updated: "2025-11-05T11:00:00Z"   # ISO 8601 UTC timestamp
status: "INITIATED"                # INITIATED | IN_PROGRESS | COMPLETED | BLOCKED | CLOSED
---

<!--
==================================================================
TESTING SCENARIO TEMPLATE
==================================================================

USE THIS WHEN:
- Planning test strategy for new features
- Improving test coverage
- Creating comprehensive test suites
- Validating quality before release
- Need test automation or E2E testing

QUICK START:
1. Define testing scope and goals
2. List existing coverage and gaps
3. Specify test types needed
4. Tag @codex with test creation task
5. Execute and validate tests

DELETE THIS COMMENT BLOCK WHEN READY
==================================================================
-->

# Testing: [FEATURE_OR_COMPONENT_NAME]

**Test Focus**: [One-line description of testing goal]
**Coverage Goal**: [Target percentage or comprehensive scope]
**Test Types**: [Unit | Integration | E2E | Performance | Security]
**Timeline**: [Immediate | Before release | Continuous]

---

## Testing Objectives

### Quality Goals
- **Primary Goal**: [Main testing objective]
- **Success Metrics**: [How success is measured]
- **Risk Mitigation**: [What risks these tests address]

### Coverage Targets
- **Current Coverage**: [X]% overall ([Y]% unit, [Z]% integration)
- **Target Coverage**: [X]% overall ([Y]% unit, [Z]% integration)
- **Critical Paths**: [Must be 100% covered]

---

## System Under Test

### Components in Scope
1. **[Component 1]**: `path/to/component1.ext`
   - **Functionality**: [What it does]
   - **Complexity**: [Low | Medium | High]
   - **Priority**: [Critical | High | Medium | Low]

2. **[Component 2]**: `path/to/component2.ext`
   - **Functionality**: [What it does]
   - **Complexity**: [Low | Medium | High]
   - **Priority**: [Critical | High | Medium | Low]

### Dependencies
- **External Services**: [APIs, databases, third-party services]
- **Internal Services**: [Other components or microservices]
- **Test Data**: [Required test data or fixtures]

### Known Issues
- [Known bug or limitation 1]
- [Known bug or limitation 2]

---

## Current Test Status

### Existing Coverage

**Unit Tests**:
- Location: `tests/unit/`
- Coverage: [X]%
- Tests: [Y] total
- Status: [Passing | Some failing | Not run]

**Integration Tests**:
- Location: `tests/integration/`
- Coverage: [X]%
- Tests: [Y] total
- Status: [Passing | Some failing | Not run]

**E2E Tests**:
- Location: `tests/e2e/`
- Coverage: [X scenarios covered]
- Tests: [Y] total
- Status: [Passing | Some failing | Not run]

### Coverage Gaps

**Uncovered Functionality**:
1. [Function or feature with no tests]
2. [Function or feature with insufficient tests]
3. [Edge cases not tested]

**Untested Edge Cases**:
1. [Edge case 1]
2. [Edge case 2]
3. [Edge case 3]

**Untested Error Scenarios**:
1. [Error condition 1]
2. [Error condition 2]

---

## Test Strategy

### Unit Testing Strategy

**Framework**: [Jest | Pytest | etc.]

**Focus Areas**:
- [ ] Core business logic functions
- [ ] Data validation and transformation
- [ ] Error handling and edge cases
- [ ] Helper and utility functions

**Mocking Strategy**:
- External APIs: [How to mock]
- Database calls: [How to mock]
- Time-dependent code: [How to mock]

**Test Data**:
```[language]
// Example test data structure
const testData = {
    valid: {...},
    invalid: {...},
    edge: {...}
};
```

---

### Integration Testing Strategy

**Framework**: [Jest | Pytest | etc.]

**Focus Areas**:
- [ ] API endpoint functionality
- [ ] Database interactions
- [ ] Service-to-service communication
- [ ] Authentication/authorization flows

**Test Environment**:
- Database: [Test database setup]
- External services: [Mocked | Test endpoints]
- Configuration: [Test-specific config]

**Setup/Teardown**:
```bash
# Before tests
docker-compose up test-db
npm run db:seed:test

# After tests
npm run db:clean
docker-compose down
```

---

### E2E Testing Strategy

**Framework**: [Playwright | Cypress | Selenium]

**User Flows to Test**:
1. **[Flow 1]**: [Description]
   - Steps: [List user actions]
   - Expected: [Expected outcome]
   - Priority: [Critical | High | Medium]

2. **[Flow 2]**: [Description]
   - Steps: [List user actions]
   - Expected: [Expected outcome]
   - Priority: [Critical | High | Medium]

**Browser Coverage**:
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Mobile browsers

**Test Data Management**:
- Test user accounts: [How created/managed]
- Test data: [How seeded/cleaned]

---

### Performance Testing Strategy

**Tools**: [Artillery | JMeter | k6]

**Scenarios**:
1. **Load Test**: [X concurrent users, Y duration]
2. **Stress Test**: [Ramp up to failure point]
3. **Spike Test**: [Sudden traffic surge]

**Performance Targets**:
- Response time: [X ms at 95th percentile]
- Throughput: [Y requests/second]
- Error rate: [< Z%]

---

### Security Testing Strategy

**Focus Areas**:
- [ ] Authentication bypass attempts
- [ ] Authorization boundary testing
- [ ] Input validation (SQL injection, XSS)
- [ ] CSRF protection
- [ ] Rate limiting

**Tools**:
- Static analysis: [SAST tool]
- Dynamic analysis: [DAST tool]
- Dependency scanning: [npm audit | snyk]

---

## Test Plan

### Phase 1: Unit Tests (EST: X hours)

**Tasks**:
- [ ] Write tests for `component1.ext` - [Y tests]
- [ ] Write tests for `component2.ext` - [Z tests]
- [ ] Cover edge cases identified above
- [ ] Achieve [X]% unit test coverage

**Success Criteria**:
- All unit tests pass
- Coverage target met
- No flaky tests

---

### Phase 2: Integration Tests (EST: Y hours)

**Tasks**:
- [ ] Write API endpoint tests
- [ ] Write database interaction tests
- [ ] Write service integration tests
- [ ] Test authentication/authorization

**Success Criteria**:
- All integration tests pass
- All API contracts validated
- Error handling verified

---

### Phase 3: E2E Tests (EST: Z hours)

**Tasks**:
- [ ] Implement user flow 1
- [ ] Implement user flow 2
- [ ] Implement user flow 3
- [ ] Cross-browser validation

**Success Criteria**:
- Critical user flows validated
- Tests pass in all target browsers
- Tests are deterministic (not flaky)

---

## @codex Task

**Testing Scope**: [What needs testing]
**Your Part**: [Specific test creation task for Codex]
**Test Types**: [Unit | Integration | E2E]

**Context**:
- **Feature**: [What's being tested]
- **Current Coverage**: [X]% → Target: [Y]%
- **Test Framework**: [Jest | Pytest | Playwright | etc.]
- **Existing Tests**: `path/to/existing/tests` (use as examples)

**Your Task**:
Create comprehensive test suite for [specific component or feature].

**Specific Requirements**:
1. **Unit Tests**:
   - Test all public functions/methods
   - Cover happy path, edge cases, and error scenarios
   - Mock external dependencies appropriately

2. **Integration Tests** (if applicable):
   - Test API endpoints end-to-end
   - Validate data persistence
   - Test error responses

3. **E2E Tests** (if applicable):
   - Implement [X] user flow(s)
   - Validate UI behavior
   - Test across required browsers

**Test Cases to Cover**:
- ✅ **Happy Path**: [Normal successful case]
- ⚠️ **Edge Cases**: [Boundary conditions, empty inputs, etc.]
- ❌ **Error Cases**: [Invalid inputs, failures, exceptions]
- 🔄 **State Changes**: [Data mutations, side effects]

**Success Criteria**:
- [ ] All specified test cases implemented
- [ ] All tests pass
- [ ] Coverage target met ([X]%)
- [ ] No flaky tests (run 10 times, all pass)
- [ ] Tests follow project conventions

**Test Style Example**:
```[language]
// Show preferred test structure and naming
describe('ComponentName', () => {
    beforeEach(() => {
        // Setup
    });

    describe('methodName', () => {
        it('should handle normal case', () => {
            // Arrange
            // Act
            // Assert
        });
    });
});
```

**Guidance**:
- **Patterns to Follow**: [Existing test patterns]
- **Mocking Strategy**: [How to mock dependencies]
- **Assertions Style**: [Preferred assertion library/style]
- **Test Data**: [Where to find or how to create test data]

**Coordination** (if parallel work):
- **Claude's Parallel Work**: [What Claude works on simultaneously]
- **Next Sync**: [When to check teamchat]

---

<!--
==================================================================
CODEX SECTION - Codex writes below this line
==================================================================
-->

## Codex Test Implementation

**Status**: [✅ Completed | 🔄 In Progress | 🚨 Blocked | ⏳ Pending]
**Confidence**: [0-100]%
**Time Spent**: [X minutes/hours]

### Test Suite Summary

**Files Created**:
- `tests/unit/component1.test.ext` - [X unit tests]
- `tests/integration/api.test.ext` - [Y integration tests]
- `tests/e2e/userflow.spec.ext` - [Z E2E tests]

**Total Tests Created**: [N] tests

**Coverage Achieved**:
- Unit: [X]%
- Integration: [Y]%
- Overall: [Z]%

### Unit Tests

#### File: `tests/unit/component.test.ext`

**Test Coverage**:

```[language]
describe('ComponentName', () => {
    describe('methodName', () => {
        // Happy path tests
        it('should process valid input correctly', () => {
            const input = {...};
            const result = component.methodName(input);
            expect(result).toEqual(expectedOutput);
        });

        // Edge case tests
        it('should handle empty input', () => {
            const result = component.methodName([]);
            expect(result).toEqual([]);
        });

        it('should handle null input', () => {
            const result = component.methodName(null);
            expect(result).toBeNull();
        });

        // Error case tests
        it('should throw error for invalid input', () => {
            expect(() => {
                component.methodName(invalidInput);
            }).toThrow('Invalid input');
        });
    });

    describe('anotherMethod', () => {
        // More test cases...
    });
});
```

**Test Results**:
```
✅ ComponentName
  ✅ methodName
    ✅ should process valid input correctly
    ✅ should handle empty input
    ✅ should handle null input
    ✅ should throw error for invalid input
  ✅ anotherMethod
    ✅ [test cases...]

Tests: [X] passed, [X] total
Time: [Y]s
Coverage: [Z]%
```

### Integration Tests

#### File: `tests/integration/api.test.ext`

**API Endpoint Tests**:

```[language]
describe('API Endpoints', () => {
    describe('POST /api/resource', () => {
        it('should create resource with valid data', async () => {
            const response = await request(app)
                .post('/api/resource')
                .send(validData);

            expect(response.status).toBe(201);
            expect(response.body).toHaveProperty('id');
        });

        it('should return 400 for invalid data', async () => {
            const response = await request(app)
                .post('/api/resource')
                .send(invalidData);

            expect(response.status).toBe(400);
            expect(response.body.error).toBeDefined();
        });

        it('should return 401 for unauthorized request', async () => {
            const response = await request(app)
                .post('/api/resource')
                .send(validData);
            // No auth header

            expect(response.status).toBe(401);
        });
    });
});
```

**Test Results**:
```
✅ API Endpoints
  ✅ POST /api/resource
    ✅ should create resource with valid data
    ✅ should return 400 for invalid data
    ✅ should return 401 for unauthorized request

Tests: [X] passed, [X] total
Time: [Y]s
```

### E2E Tests

#### File: `tests/e2e/userflow.spec.ext`

**User Flow Tests**:

```[language]
test('User can complete authentication flow', async ({ page }) => {
    // Navigate to login
    await page.goto('/login');

    // Fill credentials
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'password123');

    // Submit form
    await page.click('[data-testid="login-button"]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');

    // Verify user info displayed
    await expect(page.locator('[data-testid="user-name"]'))
        .toHaveText('Test User');
});

test('User cannot access protected route without auth', async ({ page }) => {
    await page.goto('/dashboard');

    // Should redirect to login
    await expect(page).toHaveURL('/login');
});
```

**Test Results**:
```
✅ User authentication flow
  ✅ User can complete authentication flow (2.3s)
  ✅ User cannot access protected route without auth (0.8s)

Tests: [X] passed, [X] total
Time: [Y]s
Browsers: chromium, firefox, webkit
```

### Test Data & Fixtures

**Test Data Location**: `tests/fixtures/`

```[language]
// tests/fixtures/testData.js
export const validUser = {
    email: 'test@example.com',
    password: 'SecurePass123!',
    name: 'Test User'
};

export const invalidUser = {
    email: 'invalid-email',
    password: '123', // Too short
};
```

**Database Seeding**:
```bash
# Seed test database
npm run db:seed:test

# Clean after tests
npm run db:clean:test
```

### Mocking Strategy

**External API Mocks**:
```[language]
jest.mock('../services/externalApi', () => ({
    fetchData: jest.fn(() => Promise.resolve(mockData)),
    postData: jest.fn(() => Promise.resolve({ id: 'mock-id' }))
}));
```

**Time Mocks**:
```[language]
jest.useFakeTimers();
jest.setSystemTime(new Date('2025-11-05T10:00:00Z'));
```

### Edge Cases Covered

**Edge Case 1**: [Empty or null inputs]
- Test: `tests/unit/component.test.ext:line`
- Result: ✅ Handled correctly

**Edge Case 2**: [Boundary values]
- Test: `tests/unit/component.test.ext:line`
- Result: ✅ Handled correctly

**Edge Case 3**: [Concurrent operations]
- Test: `tests/integration/api.test.ext:line`
- Result: ✅ Handled correctly

### Running the Tests

**All Tests**:
```bash
npm test

# Expected output:
# Tests: [X] passed, [Y] total
# Coverage: [Z]%
# Time: [N]s
```

**Specific Test Suites**:
```bash
# Unit tests only
npm run test:unit

# Integration tests only
npm run test:integration

# E2E tests only
npm run test:e2e
```

**Coverage Report**:
```bash
npm run test:coverage

# Generates HTML report at coverage/index.html
```

### Flakiness Analysis

**Test Stability**: [All tests run 10 times]
```
✅ All tests passed 10/10 runs
No flaky tests detected
```

**If flaky tests found**:
- [Test name]: Failed [X]/10 runs
- Cause: [Identified cause]
- Fix: [How it was stabilized]

### Performance

**Test Execution Time**:
- Unit tests: [X]s ([Y] tests)
- Integration tests: [Z]s ([W] tests)
- E2E tests: [N]s ([M] tests)
- Total: [Total]s

**Optimization Opportunities**:
- [Suggestion 1 if tests are slow]
- [Suggestion 2 if tests are slow]

### Coverage Report

**Overall Coverage**: [X]%

| Category | Coverage | Target | Status |
|----------|----------|--------|--------|
| Statements | [X]% | [Y]% | ✅/❌ |
| Branches | [X]% | [Y]% | ✅/❌ |
| Functions | [X]% | [Y]% | ✅/❌ |
| Lines | [X]% | [Y]% | ✅/❌ |

**Uncovered Code**:
- `file.ext:line-range` - [Reason not covered or recommendation]
- `file.ext:line-range` - [Reason not covered or recommendation]

### Known Limitations

**Limitation 1**: [Description]
- **Impact**: [What can't be tested]
- **Workaround**: [Alternative validation approach]
- **Future Work**: [How to address]

**Limitation 2**: [Description]
- **Impact**: [What can't be tested]
- **Workaround**: [Alternative validation approach]
- **Future Work**: [How to address]

### Next Steps

**For CI/CD**:
- [ ] Add tests to CI pipeline
- [ ] Configure coverage thresholds
- [ ] Set up test result reporting
- [ ] Enable pre-commit test hooks

**For Improvement**:
- [ ] Add performance benchmarks
- [ ] Increase coverage to [X]%
- [ ] Add mutation testing
- [ ] Improve test documentation

### Open Questions

- [Question about untestable scenario]
- [Question about test approach]

---

## Test Execution & Validation

**Execution Date**: [YYYY-MM-DD HH:MM]

**Environment**:
- OS: [Operating system]
- Node/Python version: [Version]
- Browser versions: [If E2E tests]

**All Tests Results**:
```
Test Suites: [X] passed, [Y] total
Tests: [N] passed, [M] total
Time: [Z]s
Coverage: [W]%
```

**CI/CD Integration**:
- [ ] Tests added to CI pipeline
- [ ] All CI tests passing
- [ ] Coverage uploaded to [service]
- [ ] Test results reported

**Quality Gates**:
- [ ] Coverage ≥ [X]% threshold
- [ ] All critical paths tested
- [ ] No flaky tests
- [ ] Test execution < [Y] minutes

---

## Session Summary

**Outcome**: [Coverage goals met | Partial completion | Blocked]

**Achievements**:
- ✅ Created [X] unit tests
- ✅ Created [Y] integration tests
- ✅ Created [Z] E2E tests
- ✅ Coverage increased from [A]% to [B]%

**Quality Improvements**:
- [Improvement 1]
- [Improvement 2]

**Key Learnings**:
- [Testing insight 1]
- [Testing insight 2]

**What Worked Well**:
- [Success factor 1]
- [Success factor 2]

**What to Improve**:
- [Area for enhancement]

**Next Session**:
- Topic: [Follow-up testing work if any]
- Focus: [Specific area]

**Archive To**: `docs/testing/YYYY-MM-DD-[feature]-tests.md`

---

<!--
==================================================================
TEMPLATE METADATA
==================================================================
Template: Testing Scenario
Version: 2.5.0
Last Updated: 2025-11-05
Documentation: https://github.com/[your-org]/kiteagentcollab
==================================================================
-->
