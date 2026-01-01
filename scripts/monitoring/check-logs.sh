#!/bin/bash
#
# Check Logs - Quick log viewer for KitesForU services
#
# Usage:
#   ./check-logs.sh                  # Show recent logs from all services
#   ./check-logs.sh api              # Show API logs
#   ./check-logs.sh worker           # Show worker logs
#   ./check-logs.sh frontend         # Show frontend logs
#   ./check-logs.sh -n 100           # Show last 100 log entries
#

set -e

# Configuration
PROJECT="kitesforu-dev"
REGION="us-central1"
DEFAULT_LIMIT=50

# Parse arguments
SERVICE="all"
LIMIT=$DEFAULT_LIMIT

while [[ $# -gt 0 ]]; do
    case $1 in
        api)
            SERVICE="api"
            shift
            ;;
        worker|workers)
            SERVICE="worker"
            shift
            ;;
        frontend)
            SERVICE="frontend"
            shift
            ;;
        -n)
            LIMIT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [api|worker|frontend] [-n limit]"
            exit 1
            ;;
    esac
done

echo "=== KitesForU Logs ==="
echo "Project: $PROJECT"
echo "Service: $SERVICE"
echo "Limit: $LIMIT"
echo ""

# Build filter
case $SERVICE in
    api)
        FILTER='resource.type="cloud_run_revision" AND resource.labels.service_name="kitesforu-api"'
        ;;
    worker)
        FILTER='resource.type="cloud_run_revision" AND resource.labels.service_name=~"kitesforu-worker"'
        ;;
    frontend)
        FILTER='resource.type="cloud_run_revision" AND resource.labels.service_name="kitesforu-frontend"'
        ;;
    all)
        FILTER='resource.type="cloud_run_revision" AND resource.labels.service_name=~"kitesforu"'
        ;;
esac

# Show errors first
echo "--- Recent Errors ---"
gcloud logging read "$FILTER AND severity>=ERROR" \
    --project="$PROJECT" \
    --limit=10 \
    --format='table(timestamp,resource.labels.service_name,textPayload)' \
    2>/dev/null || echo "No recent errors"

echo ""
echo "--- Recent Logs ---"
gcloud logging read "$FILTER" \
    --project="$PROJECT" \
    --limit="$LIMIT" \
    --format='table(timestamp,resource.labels.service_name,severity,textPayload)' \
    2>/dev/null
