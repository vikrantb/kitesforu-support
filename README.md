# KitesForU Support

Operational support scripts and documentation for the KitesForU podcast platform.

## Overview

This repository contains:
- **Monitoring scripts**: Log analysis and job diagnostics
- **Maintenance scripts**: Job cleanup and database maintenance
- **Documentation**: System state, collaboration frameworks, and operational guides

## Directory Structure

```
kitesforu-support/
├── scripts/
│   ├── maintenance/      # Cleanup and maintenance utilities
│   │   ├── clean_invalid_jobs.py
│   │   └── nuke_all_jobs.py
│   └── monitoring/       # Log analysis and diagnostics
│       ├── check-logs.sh
│       └── diagnose-job.sh
├── docs/
│   └── collaboration/    # Claude-Codex collaboration framework
│       ├── docs/         # Protocol documentation
│       ├── templates/    # Teamchat templates
│       └── examples/     # Integration examples
├── SYSTEM_STATE.md       # Current system architecture and state
└── README.md
```

## Quick Start

### Monitoring

```bash
# Check recent logs
./scripts/monitoring/check-logs.sh

# Diagnose a specific job
./scripts/monitoring/diagnose-job.sh <job_id>
```

### Maintenance

```bash
# Clean invalid jobs (dry-run by default)
python scripts/maintenance/clean_invalid_jobs.py

# DANGEROUS: Remove all jobs (requires confirmation)
python scripts/maintenance/nuke_all_jobs.py
```

## System Documentation

See `SYSTEM_STATE.md` for:
- Production architecture diagram
- Currently deployed services
- GCP resource inventory
- Data flow documentation
- Known gotchas and verification commands

## Collaboration Framework

The `docs/collaboration/` directory contains the kiteagentcollab framework for structured Claude-Codex collaboration. See the [Getting Started Guide](docs/collaboration/docs/00-getting-started.md).

## License

MIT License - See LICENSE file in docs/collaboration/
