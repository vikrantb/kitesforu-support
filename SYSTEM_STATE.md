# KitesForU System State

**Last Verified**: 2026-01-01 from actual GCP deployments

---

## Production Architecture

```
beta.kitesforu.com
        │
        ▼ (DNS: ghs.googlehosted.com)
┌─────────────────────────────────────────────────────────────────┐
│                    GCP Project: kitesforu-dev                   │
│                    Region: us-central1                          │
├─────────────────────────────────────────────────────────────────┤
│  FRONTEND          API              WORKERS (7 services)        │
│  Cloud Run ───────►Cloud Run ──────►Cloud Run                   │
│  Next.js           FastAPI          Python                      │
│      │                │                  │                      │
│      └────────────────┼──────────────────┘                      │
│                       ▼                                         │
│               ┌───────────────┐                                 │
│               │   Firestore   │◄───── Job State                 │
│               │   Pub/Sub     │◄───── Job Queue                 │
│               │   Storage     │◄───── Audio Files               │
│               └───────────────┘                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Currently Deployed

| Service | Image SHA | GitHub Commit | Date |
|---------|-----------|---------------|------|
| kitesforu-frontend | `7296cc3` | fix: use NEXT_PUBLIC_API_BASE | Dec 31 |
| kitesforu-api | `2183b7b` | fix: CLARIFYING status flow | Dec 31 |
| kitesforu-worker-* (×7) | `a5bc92e` | fix: remove unused TAVILY | Dec 31 |

---

## Components

### Frontend

| | |
|---|---|
| **GitHub** | github.com/vikrantb/kitesforu-frontend |
| **Local Path** | `/Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-frontend` |
| **Dockerfile** | `/Dockerfile` |
| **CI/CD** | `.github/workflows/ci.yml` |
| **Stack** | Next.js 14, React 18, Tailwind, Clerk Auth |
| **Port** | 3000 |
| **Cloud Run URL** | https://kitesforu-frontend-m6zqve5yda-uc.a.run.app |

### API

| | |
|---|---|
| **GitHub** | github.com/vikrantb/kitesforu-api |
| **Local Path** | `/Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-api` |
| **Dockerfile** | `/Dockerfile` |
| **CI/CD** | `.github/workflows/ci.yml` |
| **Tests** | `/tests/*.py` |
| **Stack** | FastAPI, Python 3.11, Firestore |
| **Port** | 8080 |
| **Cloud Run URL** | https://kitesforu-api-m6zqve5yda-uc.a.run.app |

### Workers

| | |
|---|---|
| **GitHub** | github.com/vikrantb/kitesforu-workers |
| **Local Path** | `/Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-workers` |
| **Dockerfile** | `/Dockerfile` (single image, 7 entry points) |
| **CI/CD** | `.github/workflows/ci.yml` |
| **Tests** | `/tests/*.py` |
| **Stack** | Python 3.11, Pub/Sub triggers |

**Worker Services** (all share same Docker image):
| Worker | Pub/Sub Topic | Purpose |
|--------|---------------|---------|
| initiator | job-initiate | Start job processing |
| research-planner | job-research-planner | Plan research tasks |
| planner | job-plan | Plan podcast script |
| script | job-script | Generate script |
| audio | job-audio | TTS + audio mixing |
| tools | job-execute-tools | Execute tool calls |
| execute-tools | job-execute-tools | Tool execution |

### Schemas

| | |
|---|---|
| **GitHub** | github.com/vikrantb/kitesforu-schemas |
| **Local Path** | `/Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-schemas` |
| **CI/CD** | `.github/workflows/ci.yml` |
| **Distribution** | Artifact Registry (Python package) |
| **Purpose** | Shared Pydantic models across all services |

### E2E Testing

| | |
|---|---|
| **Local Path** | `/Users/vikrantbhosale/gitprojects/kitesforu/kitetest` |
| **Stack** | Playwright, Python |
| **Target** | beta.kitesforu.com |
| **Test Credentials** | test@kitesforu.com / PatangUdav.15 |

---

## GCP Resources

### Cloud Run Services (9 total)

| Service | URL |
|---------|-|
| kitesforu-frontend | https://kitesforu-frontend-m6zqve5yda-uc.a.run.app |
| kitesforu-api | https://kitesforu-api-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-initiator | https://kitesforu-worker-initiator-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-research-planner | https://kitesforu-worker-research-planner-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-planner | https://kitesforu-worker-planner-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-script | https://kitesforu-worker-script-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-audio | https://kitesforu-worker-audio-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-tools | https://kitesforu-worker-tools-m6zqve5yda-uc.a.run.app |
| kitesforu-worker-execute-tools | https://kitesforu-worker-execute-tools-m6zqve5yda-uc.a.run.app |

### Pub/Sub Topics

| Topic | Purpose |
|-------|---------|
| job-initiate | Start new job |
| job-research-planner | Research planning stage |
| job-plan | Script planning stage |
| job-script | Script generation stage |
| job-audio | TTS + audio mixing stage |
| job-execute-tools | Tool execution stage |
| workers-dead-letter | Failed message handling |

### Storage Buckets

| Bucket | Purpose |
|--------|---------|
| kitesforu-dev-podcasts | Audio output files |
| kitesforu-podcasts | Production audio |
| kitesforu-dev-worker-logs | Worker debug logs |

### Firestore Collections

| Collection | Purpose |
|------------|---------|
| podcast_jobs | Job state and metadata |
| users | User data |
| model_provider_health | Model availability tracking |
| model_quotas | Usage limits |
| model_router_alerts | Routing alerts |

---

## Data Flow

```
User Request
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│  FRONTEND (beta.kitesforu.com)                              │
│  1. User enters topic                                       │
│  2. POST /v1/podcasts                                       │
└─────────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│  API                                                        │
│  1. Validate request                                        │
│  2. Check if clarification needed                           │
│     ├─► YES: Set status=CLARIFYING, return questions        │
│     └─► NO: Publish to job-initiate                         │
└─────────────────────────────────────────────────────────────┘
     │
     ├─► (If CLARIFYING) ──► User answers ──► PATCH /answers ──┐
     │                                                          │
     ▼                                                          │
┌─────────────────────────────────────────────────────────────┐│
│  WORKERS (Pub/Sub triggered)                                ││
│                                                             ││
│  job-initiate ──► research-planner ──► planner             ◄┘
│                          │                │
│                          ▼                ▼
│                       script ──────► audio
│                                        │
│                                        ▼
│                              Storage (audio file)
│                              Firestore (status=COMPLETED)
└─────────────────────────────────────────────────────────────┘
     │
     ▼
Frontend polls GET /v1/podcasts/{id}/status → Shows progress/audio
```

---

## Job Status Values

```python
class JobStatus(str, Enum):
    pending = "pending"
    clarifying = "clarifying"    # Waiting for user answers
    running = "running"          # NOT 'in_progress'!
    completed = "completed"
    failed = "failed"
    cancelled = "cancelled"
```

---

## Known Gotchas

| Issue | Fix | Commit |
|-------|-----|--------|
| CLARIFYING status must be set BEFORE Pub/Sub queue | Set status in Firestore first, then publish | 2183b7b |
| Frontend env var naming | Use `NEXT_PUBLIC_API_BASE`, not `API_URL` | 7296cc3 |
| Firestore transaction.get() | Returns generator in Python, must iterate | c2647d2 |
| Credits field | Must be integer, not float | 1a569f4 |
| Workers share image | Single Dockerfile, different `--worker-type` flag | - |

---

## Verification Commands

```bash
# Check deployed versions
gcloud run services list --project=kitesforu-dev --region=us-central1

# Check specific service image
gcloud run services describe kitesforu-api \
  --project=kitesforu-dev \
  --region=us-central1 \
  --format="value(spec.template.spec.containers[0].image)"

# View logs
gcloud logging read 'resource.type="cloud_run_revision"' \
  --project=kitesforu-dev --limit=50

# Run E2E test
cd /Users/vikrantbhosale/gitprojects/kitesforu/kitetest
python3 scripts/run_beta_e2e_test.py

# Check DNS
dig beta.kitesforu.com +short
```

---

## Environments

| Environment | Domain | GCP Project | API Base |
|-------------|--------|-------------|----------|
| Production/Beta | beta.kitesforu.com | kitesforu-dev | https://kitesforu-api-m6zqve5yda-uc.a.run.app |
| Local Dev | localhost:3000 | emulators | http://localhost:8501 |

---

## Directory Structure (Production Repos)

```
/Users/vikrantbhosale/gitprojects/kitesforu/
├── kitesforu-frontend/     # PRODUCTION - Next.js frontend
├── kitesforu-api/          # PRODUCTION - FastAPI backend
├── kitesforu-workers/      # PRODUCTION - Python workers
├── kitesforu-schemas/      # PRODUCTION - Shared Pydantic models
├── kitesforu-support/      # Support scripts and documentation
├── kitetest/               # E2E testing framework
└── kitesforu-infrastructure/  # Infrastructure configs
```

---

## Quick Start (Local Dev)

```bash
# 1. Start API
cd /Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-api
uvicorn main:app --reload --port 8501

# 2. Start Frontend
cd /Users/vikrantbhosale/gitprojects/kitesforu/kitesforu-frontend
npm run dev

# 3. Run E2E tests
cd /Users/vikrantbhosale/gitprojects/kitesforu/kitetest
python3 scripts/run_beta_e2e_test.py
```

---

## CI/CD Flow

```
Push to main
     │
     ▼
GitHub Actions (.github/workflows/ci.yml)
     │
     ├─► Build Docker image
     ├─► Push to Artifact Registry
     └─► Deploy to Cloud Run
```

Each repo has independent CI/CD. Push to `main` triggers automatic deployment.

---

*Generated from verified GCP deployments, not documentation.*
