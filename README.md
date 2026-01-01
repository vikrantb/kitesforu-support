# KitesForU Support

Operational support scripts and documentation for the KitesForU podcast platform.

## Contents

### System Documentation

- **SYSTEM_STATE.md** - Comprehensive system state documentation verified from actual GCP deployments

### Scripts

#### Monitoring (`scripts/monitoring/`)

| Script | Purpose |
|--------|---------|
| `diagnose-job.sh` | Comprehensive job diagnostic tool - analyzes Firestore, Pub/Sub, workers, and logs |
| `check-logs.sh` | Quick log viewer for API and worker services |

**Usage:**
```bash
# Diagnose a specific job
./scripts/monitoring/diagnose-job.sh <job_id> [project_id]

# Check recent logs
./scripts/monitoring/check-logs.sh --service api --severity ERROR
./scripts/monitoring/check-logs.sh --service worker --follow
```

#### Maintenance (`scripts/maintenance/`)

| Script | Purpose |
|--------|---------|
| `clean_invalid_jobs.py` | Delete jobs with invalid schema data |
| `nuke_all_jobs.py` | Delete ALL jobs (use with extreme caution) |

**Usage:**
```bash
# Dry run (default) - see what would be deleted
python3 scripts/maintenance/clean_invalid_jobs.py

# Execute deletion
python3 scripts/maintenance/clean_invalid_jobs.py --execute

# Nuke all jobs (DANGEROUS)
python3 scripts/maintenance/nuke_all_jobs.py --confirm
```

### Documentation Archive

#### Collaboration Framework (`docs/collaboration/`)

Archived Claude+Codex collaboration framework (Protocol v2.5) for potential future multi-agent workflows.

## Requirements

```bash
pip install google-cloud-firestore kitesforu-schemas
```

## GCP Authentication

Scripts require appropriate GCP service account credentials:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

## Related Repositories

| Repository | Purpose |
|------------|---------|
| kitesforu-frontend | Next.js frontend |
| kitesforu-api | FastAPI backend |
| kitesforu-workers | Python workers |
| kitesforu-schemas | Shared Pydantic models |
| kitetest | E2E testing framework |
