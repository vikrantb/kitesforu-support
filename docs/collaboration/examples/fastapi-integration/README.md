# FastAPI Integration Example

This example demonstrates integrating kiteagentcollab into a FastAPI project for AI-powered collaborative development.

---

## Overview

**Project**: Simple FastAPI application with user authentication
**Framework**: kiteagentcollab v2.5
**Goal**: Show practical Claude-Codex collaboration workflow

---

## Project Structure

```
fastapi-project/
├── .collab/                    # Git submodule (kiteagentcollab)
│   ├── docs/
│   ├── templates/
│   └── scripts/
├── teamchat/                   # Your collaboration sessions
│   └── 2025-11-05.md          # Today's collaboration
├── app/
│   ├── main.py
│   ├── models.py
│   ├── routes/
│   │   ├── auth.py
│   │   └── users.py
│   └── services/
│       ├── auth_service.py
│       └── user_service.py
├── tests/
│   ├── test_auth.py
│   └── test_users.py
├── requirements.txt
└── README.md
```

---

## Setup Instructions

### Step 1: Add kiteagentcollab as Submodule

```bash
cd fastapi-project
git submodule add https://github.com/[your-org]/kiteagentcollab .collab
git submodule update --init --recursive
```

### Step 2: Create Teamchat Directory

```bash
mkdir -p teamchat
```

### Step 3: Create First Teamchat File

```bash
cp .collab/templates/teamchat-v2.5-template.md teamchat/$(date +%Y-%m-%d).md
```

---

## Example Collaboration Scenarios

### Scenario 1: Debugging Authentication Issue

**File**: `teamchat/2025-11-05-auth-debug.md`

```markdown
---
protocol: "2.5"
session: "debug-2025-11-05-auth"
type: "debugging"
priority: "high"
delegation_reason: "second_opinion"
complexity: "HIGH"
started: "2025-11-05T10:00:00Z"
updated: "2025-11-05T10:00:00Z"
status: "INITIATED"
---

# Debugging: JWT Token Validation Failing

**Issue**: POST /api/login returns 401 even with correct credentials
**Environment**: Development
**Impact**: User-facing
**Severity**: High

---

## Evidence

### Error Message

**Location**: `app/logs/api.log:1234-1256`

```
2025-11-05 10:15:23 ERROR: JWT validation failed
Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Error: Signature verification failed
File: app/services/auth_service.py:45
```

### Metrics

| Metric | Value | Normal | Status |
|--------|-------|--------|--------|
| Login success rate | 0% | 95% | 🚨 |
| Token generation | Working | Working | ✅ |
| Token validation | Failing | Working | ❌ |

### Code Context

**Suspected Location**: `app/services/auth_service.py:45-60`

```python
def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=["HS256"]
        )
        return payload
    except jwt.InvalidSignatureError:
        raise HTTPException(401, "Invalid token")
```

---

## Attempts So Far

### Hypothesis 1: Wrong Secret Key

**Reasoning**: Secret key might differ between token creation and validation

**Investigation**:
- Verified SECRET_KEY in .env matches
- Checked settings loading in both modules
- Both modules use same `settings.SECRET_KEY`

**Result**: Secret keys match in both places

**Outcome**: ❌ Disproven

**Confidence**: 90%

---

### Hypothesis 2: Algorithm Mismatch

**Reasoning**: Token created with RS256 but validated with HS256

**Investigation**:
- Checked token creation in `create_access_token()`
- Algorithm specified as HS256 in both places

**Result**: Algorithms match

**Outcome**: ❌ Disproven

**Confidence**: 95%

---

### Hypothesis 3: Token Encoding Issue

**Reasoning**: Token might have encoding/decoding problems

**Investigation**:
- Printed token string
- Checked for extra spaces or encoding issues
- Token appears clean

**Result**: Inconclusive, still investigating

**Outcome**: ⚠️ Inconclusive

**Confidence**: 40%

---

## @codex Task

**System**: FastAPI Authentication API
**Symptom**: JWT token validation failing with signature error
**Focus**: Token creation and validation flow

**Context**:
- **Current Understanding**: Token creation works, validation fails
- **Hypotheses Tested**: Secret key match, algorithm match, token encoding
- **Environmental Constraints**: Development environment, full access
- **Time Pressure**: Urgent (blocking user login)

**Your Task**:
Investigate why JWT signature validation fails when the same secret key and algorithm are used for creation and validation.

**Specific Questions**:
1. Is there a subtle difference in how SECRET_KEY is loaded or used?
2. Could there be token manipulation between creation and validation?
3. Are we missing something in the JWT library configuration?

**Success Criteria**:
- [ ] Identify root cause with confidence ≥ 85%
- [ ] Explain why our three hypotheses failed
- [ ] Provide fix with validation steps
- [ ] No breaking changes to existing functionality

**Guidance**:
- **Focus Areas**: Token creation flow, settings loading, JWT library usage
- **Approach**: Systematic comparison of creation vs validation paths
- **Files to Check**:
  - `app/services/auth_service.py` (main logic)
  - `app/routes/auth.py` (endpoint)
  - `app/config.py` (settings)
- **Use Your Judgment**: Investigation strategy and debugging approach

---

## Codex Findings

**Status**: ✅ Completed
**Confidence**: 92%
**Time Spent**: 35 minutes

### Root Cause

Settings module uses Pydantic BaseSettings which **strips whitespace** from environment variables.

**Location**: `app/config.py:8-12`

**Problem**: `.env` file has `SECRET_KEY` with trailing newline:
```
SECRET_KEY="mysecretkey123"↵
```

Pydantic strips this to `"mysecretkey123"`, but token creation happens **before** settings initialization and reads raw env var with newline.

**Mechanism**:
1. Token created using `os.environ.get("SECRET_KEY")` → includes newline
2. Token validated using `settings.SECRET_KEY` → newline stripped by Pydantic
3. Different keys → signature mismatch

### Evidence

```python
# Token creation (app/routes/auth.py:23)
access_token = create_access_token(
    data={"sub": user.email},
    key=os.environ.get("SECRET_KEY")  # ❌ Raw env var with newline
)

# Token validation (app/services/auth_service.py:45)
payload = jwt.decode(
    token,
    settings.SECRET_KEY,  # ✅ Pydantic stripped newline
    algorithms=["HS256"]
)
```

**Why Previous Hypotheses Failed**:
- Hypothesis 1: Both used "SECRET_KEY" but different sources (raw env vs Pydantic)
- Hypothesis 2: Algorithms matched, but keys didn't
- Hypothesis 3: Token encoding was fine, key was the issue

### Solution

**Approach**: Use Pydantic settings consistently

```python
# File: app/routes/auth.py

# BEFORE (line 23):
access_token = create_access_token(
    data={"sub": user.email},
    key=os.environ.get("SECRET_KEY")
)

# AFTER (fixed):
from app.config import settings

access_token = create_access_token(
    data={"sub": user.email},
    key=settings.SECRET_KEY  # Use Pydantic settings
)
```

**Why This Works**: Both creation and validation now use Pydantic settings, ensuring consistent key handling.

### Test/Validation

**Local Testing**:
```bash
# 1. Apply the fix
# Edit app/routes/auth.py line 23

# 2. Restart server
uvicorn app.main:app --reload

# 3. Test login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'

# Expected: 200 OK with valid token
# Verify token validates correctly in subsequent requests
```

**Validation Steps**:
1. ✅ Login successful with correct credentials
2. ✅ Token validates on protected endpoints
3. ✅ Existing tests pass
4. ✅ No breaking changes

### Risks & Considerations

**Risk**: Other places might use `os.environ.get()` instead of settings
- **Mitigation**: Search codebase: `grep -r "os.environ.get" app/`
- **Priority**: medium

**Risk**: .env file format might have other whitespace issues
- **Mitigation**: Add .env validation in settings class
- **Priority**: low

### Next Steps

1. Apply fix to `app/routes/auth.py:23`
2. Run full test suite
3. Search for other `os.environ.get("SECRET_KEY")` usage
4. Consider adding .env validation
5. Deploy to staging for validation

---

## Claude Update

✅ Applied fix - changed to use settings.SECRET_KEY consistently
✅ All tests passing
✅ Verified in development environment
✅ Ready for staging deployment

**Session**: CLOSED
```

---

### Scenario 2: Parallel Implementation

**File**: `teamchat/2025-11-05-user-endpoint.md`

```markdown
---
protocol: "2.5"
session: "impl-2025-11-05-user-endpoint"
type: "implementation"
priority: "medium"
delegation_reason: "parallelization"
complexity: "MEDIUM"
started: "2025-11-05T14:00:00Z"
status: "IN_PROGRESS"
---

# Implementation: User Profile Endpoint

**Feature**: GET /api/users/{user_id} endpoint
**Type**: New Feature
**Target**: Sprint 12

---

## Specification

**Endpoint**: `GET /api/users/{user_id}`

**Requirements**:
- Return user profile data
- Require authentication
- Handle user not found
- Include profile completeness score

**Acceptance Criteria**:
- [ ] Endpoint returns 200 with valid user data
- [ ] Returns 404 for non-existent user
- [ ] Returns 401 for unauthenticated request
- [ ] Includes profile_completeness field (0-100%)
- [ ] All tests pass

---

## Parallel Work Plan

**Claude Will Work On**:
- Write integration tests for the endpoint
- Test authentication requirements
- Test error scenarios
- Est: 25 minutes

**Codex Will Work On**:
- Implement GET /api/users/{user_id} endpoint
- Implement profile completeness calculation
- Write unit tests for completeness logic
- Est: 25 minutes

**Independence**: Codex implements, Claude tests interface
**Integration Point**: Codex's endpoint implementation + Claude's integration tests
**Time Savings**: Sequential (50 min) → Parallel (25 min) = 50% saved

**Sync Points**:
- **14:25**: First checkpoint - share progress
- **14:50**: Final integration - combine and validate

---

## @codex Task

**Feature**: User profile endpoint implementation
**Your Part**: Backend logic and unit tests
**Target Files**: `app/routes/users.py`, `app/services/user_service.py`, `tests/unit/test_user_service.py`

**Context**:
- User model exists in `app/models.py`
- Authentication middleware in `app/middleware/auth.py`
- Follow pattern from `app/routes/auth.py`

**Your Task**:
Implement GET /api/users/{user_id} endpoint with profile completeness calculation.

**Specific Requirements**:
1. **Endpoint** (`app/routes/users.py`):
   - GET /api/users/{user_id}
   - Requires authentication (use `Depends(get_current_user)`)
   - Returns UserProfile schema
   - Handles 404 for missing user

2. **Profile Completeness** (`app/services/user_service.py`):
   - Calculate completeness based on filled fields
   - Fields: email (required), name, bio, avatar_url, phone
   - Formula: (filled_optional_fields / total_optional_fields) * 100

3. **Unit Tests** (`tests/unit/test_user_service.py`):
   - Test completeness calculation for various scenarios
   - Test all fields filled = 100%
   - Test no optional fields = 0%
   - Test partial fill

**Success Criteria**:
- [ ] Endpoint implementation complete
- [ ] Completeness calculation working
- [ ] Unit tests passing
- [ ] Follows project patterns

**Code Style**:
```python
# Follow this pattern from app/routes/auth.py
@router.get("/endpoint")
async def endpoint_name(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Implementation
    pass
```

**Coordination**:
- Claude's parallel work: Writing integration tests
- Next sync: 14:25 (25 minutes)

---

## Codex Implementation

**Status**: ✅ Completed
**Time**: 23 minutes

### Files Modified

- `app/routes/users.py` - Added GET endpoint
- `app/services/user_service.py` - Added completeness calculation
- `tests/unit/test_user_service.py` - Added unit tests

### Implementation

#### app/routes/users.py

```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import User
from app.schemas import UserProfile
from app.services.user_service import calculate_profile_completeness
from app.middleware.auth import get_current_user

router = APIRouter()

@router.get("/users/{user_id}", response_model=UserProfile)
async def get_user_profile(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get user profile by user ID.
    Requires authentication.
    Returns profile with completeness score.
    """
    # Fetch user from database
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Calculate profile completeness
    completeness = calculate_profile_completeness(user)

    # Return profile with completeness
    return UserProfile(
        id=user.id,
        email=user.email,
        name=user.name,
        bio=user.bio,
        avatar_url=user.avatar_url,
        phone=user.phone,
        profile_completeness=completeness,
        created_at=user.created_at
    )
```

#### app/services/user_service.py

```python
from app.models import User

def calculate_profile_completeness(user: User) -> int:
    """
    Calculate user profile completeness as percentage.

    Required field: email (always present)
    Optional fields: name, bio, avatar_url, phone

    Returns: 0-100 representing percentage of optional fields filled
    """
    optional_fields = ['name', 'bio', 'avatar_url', 'phone']
    filled_fields = 0

    for field in optional_fields:
        value = getattr(user, field, None)
        if value is not None and value != "":
            filled_fields += 1

    # Calculate percentage
    total_optional = len(optional_fields)
    completeness = int((filled_fields / total_optional) * 100)

    return completeness
```

#### tests/unit/test_user_service.py

```python
import pytest
from app.models import User
from app.services.user_service import calculate_profile_completeness

def test_completeness_all_fields_filled():
    """Test completeness when all optional fields are filled"""
    user = User(
        email="test@example.com",
        name="John Doe",
        bio="Software engineer",
        avatar_url="https://example.com/avatar.jpg",
        phone="+1234567890"
    )

    completeness = calculate_profile_completeness(user)
    assert completeness == 100

def test_completeness_no_optional_fields():
    """Test completeness when no optional fields are filled"""
    user = User(
        email="test@example.com",
        name=None,
        bio=None,
        avatar_url=None,
        phone=None
    )

    completeness = calculate_profile_completeness(user)
    assert completeness == 0

def test_completeness_partial_fields():
    """Test completeness when some optional fields are filled"""
    user = User(
        email="test@example.com",
        name="John Doe",
        bio="Software engineer",
        avatar_url=None,
        phone=None
    )

    completeness = calculate_profile_completeness(user)
    assert completeness == 50  # 2 out of 4 optional fields

def test_completeness_empty_strings_treated_as_unfilled():
    """Test that empty strings are treated as unfilled"""
    user = User(
        email="test@example.com",
        name="",
        bio="",
        avatar_url="",
        phone=""
    )

    completeness = calculate_profile_completeness(user)
    assert completeness == 0
```

### Test Results

```bash
pytest tests/unit/test_user_service.py -v

tests/unit/test_user_service.py::test_completeness_all_fields_filled PASSED
tests/unit/test_user_service.py::test_completeness_no_optional_fields PASSED
tests/unit/test_user_service.py::test_completeness_partial_fields PASSED
tests/unit/test_user_service.py::test_completeness_empty_strings_treated_as_unfilled PASSED

======================== 4 passed in 0.12s ========================
```

### Integration Ready

**For Claude**:
- Endpoint available at GET /api/users/{user_id}
- Requires Bearer token in Authorization header
- Returns UserProfile schema with profile_completeness field
- Ready for integration testing

---

## Claude Update - 14:30

✅ Codex's implementation integrated
✅ Integration tests written and passing
✅ All scenarios covered (200, 401, 404)
✅ E2E workflow validated

**Test Results**:
```bash
pytest tests/integration/test_user_endpoint.py -v

tests/integration/test_user_endpoint.py::test_get_user_authenticated PASSED
tests/integration/test_user_endpoint.py::test_get_user_unauthenticated PASSED
tests/integration/test_user_endpoint.py::test_get_user_not_found PASSED
tests/integration/test_user_endpoint.py::test_profile_completeness_calculation PASSED

======================== 4 passed in 0.34s ========================
```

**Time Comparison**:
- Sequential estimate: 50 minutes
- Parallel actual: 30 minutes (including integration)
- Time saved: 20 minutes (40%)

**Session**: CLOSED
```

---

## Best Practices for This Integration

### 1. Daily Teamchat Files

```bash
# Create single file per day
teamchat/2025-11-05.md
```

### 2. Update YAML Status

```yaml
# Start of session
status: "INITIATED"

# During work
status: "IN_PROGRESS"
updated: "2025-11-05T10:30:00Z"

# After completion
status: "COMPLETED"

# When closed
status: "CLOSED"
```

### 3. Clear Evidence

Always link to:
- Log files with line numbers
- Code files with line ranges
- Error messages with context
- Metrics with thresholds

### 4. Confidence Scores

```markdown
**Confidence**: 85%

**Why This Score**:
- ✅ Factor increasing confidence
- ⚠️ Factor decreasing confidence
```

### 5. Regular Updates

- Every 20-30 minutes during active work
- Immediately when blocked
- Upon completion

---

## Automation (Optional)

### Watch for @codex Mentions

```bash
# Install dependencies
pip install watchdog pyyaml

# Run watcher
python .collab/scripts/python/teamchat_watcher.py \
  --file teamchat/2025-11-05.md \
  --watch --log
```

### Generate Metrics

```bash
python .collab/scripts/python/teamchat_metrics.py \
  --dir teamchat/ \
  --report
```

---

## Common Workflows

### Workflow 1: Debug Production Issue

1. Copy debugging template
2. Fill in evidence (logs, metrics, errors)
3. Document attempts so far
4. Tag @codex with specific investigation request
5. Let Codex analyze independently
6. Review findings and apply fix
7. Validate and close session

### Workflow 2: Parallel Feature Development

1. Copy implementation template
2. Define clear boundaries for parallel work
3. Specify integration points
4. Claude and Codex work simultaneously
5. Sync at checkpoints
6. Integrate and validate together
7. Close session with time savings noted

### Workflow 3: Design Review

1. Copy design review template
2. Document proposed design with alternatives
3. Tag @codex for independent review
4. Review findings and concerns
5. Adjust design based on feedback
6. Document final decision
7. Close session

---

## Integration Checklist

- [ ] Add kiteagentcollab as git submodule
- [ ] Create teamchat/ directory
- [ ] Copy template for first session
- [ ] Update .gitignore to track teamchat/ files
- [ ] Educate team on @codex pattern
- [ ] Set up automation (optional)
- [ ] Start collaborating!

---

## Resources

- **Framework Docs**: [.collab/docs/](../../docs/)
- **Templates**: [.collab/templates/](../../templates/)
- **Best Practices**: [.collab/docs/05-best-practices.md](../../docs/05-best-practices.md)

---

## Questions or Issues?

- Check [Getting Started Guide](../../docs/00-getting-started.md)
- See [Best Practices](../../docs/05-best-practices.md)
- Review [Protocol v2.5](../../docs/01-protocol-v2.5.md)
- Open issue in kiteagentcollab repository
