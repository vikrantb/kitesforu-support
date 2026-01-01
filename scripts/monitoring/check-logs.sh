#!/bin/bash
set -e

# Quick Log Viewer for Kitesforu Services
# Shows recent logs from API and worker services

PROJECT_ID="${PROJECT_ID:-kitesforu-dev}"
REGION="${REGION:-us-central1}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --service <api|worker>    Show logs for specific service (default: both)"
    echo "  --severity <level>        Filter by severity (ERROR, WARNING, INFO, DEBUG)"
    echo "  --limit <n>               Number of log entries (default: 20)"
    echo "  --follow                  Follow logs in real-time"
    echo "  --since <time>            Show logs since time (e.g., '5 minutes ago', '1 hour ago')"
    echo ""
    echo "Examples:"
    echo "  $0 --service api --severity ERROR"
    echo "  $0 --limit 50 --since '10 minutes ago'"
    echo "  $0 --service worker --follow"
}

# Parse arguments
SERVICE=""
SEVERITY=""
LIMIT=20
FOLLOW=false
SINCE="10 minutes ago"

while [[ $# -gt 0 ]]; do
    case $1 in
        --service)
            SERVICE="$2"
            shift 2
            ;;
        --severity)
            SEVERITY="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --follow)
            FOLLOW=true
            shift
            ;;
        --since)
            SINCE="$2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Build log filter
build_filter() {
    local service_name=$1
    local filter="resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"$service_name\""

    if [ -n "$SEVERITY" ]; then
        filter="$filter AND severity>=$SEVERITY"
    fi

    echo "$filter"
}

# Show logs for a service
show_logs() {
    local service_name=$1
    local service_label=$2

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$service_label Logs${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    local filter=$(build_filter "$service_name")
    local since_timestamp=$(date -u -d "$SINCE" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-10M +%Y-%m-%dT%H:%M:%SZ)

    if [ "$FOLLOW" = true ]; then
        echo -e "${YELLOW}Following logs (Ctrl+C to stop)...${NC}"
        echo ""
        gcloud logging tail "$filter AND timestamp>=\"$since_timestamp\"" \
            --project=$PROJECT_ID \
            --format="table(timestamp,severity,textPayload,jsonPayload.message)" \
            2>&1
    else
        gcloud logging read "$filter AND timestamp>=\"$since_timestamp\"" \
            --limit=$LIMIT \
            --project=$PROJECT_ID \
            --format="table(timestamp,severity,textPayload,jsonPayload.message)" \
            2>&1
    fi

    echo ""
}

# Check authentication
echo -e "${YELLOW}Checking gcloud authentication...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo -e "${RED}Not authenticated to gcloud. Run: gcloud auth login${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Authenticated${NC}"
echo ""

# Show logs based on service selection
if [ -z "$SERVICE" ] || [ "$SERVICE" = "api" ]; then
    show_logs "kitesforu-api" "API Service"
fi

if [ -z "$SERVICE" ] || [ "$SERVICE" = "worker" ]; then
    show_logs "kitesforu-worker" "Worker Service"
fi

# Show quick stats
if [ "$FOLLOW" = false ]; then
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Quick Stats (Last Hour)${NC}"
    echo -e "${BLUE}========================================${NC}"

    one_hour_ago=$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-1H +%Y-%m-%dT%H:%M:%SZ)

    if [ -z "$SERVICE" ] || [ "$SERVICE" = "api" ]; then
        echo ""
        echo -e "${YELLOW}API Errors:${NC}"
        gcloud logging read "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"kitesforu-api\" AND severity>=ERROR AND timestamp>=\"$one_hour_ago\"" \
            --limit=1 \
            --project=$PROJECT_ID \
            --format="value(severity)" 2>&1 | wc -l | xargs echo
    fi

    if [ -z "$SERVICE" ] || [ "$SERVICE" = "worker" ]; then
        echo ""
        echo -e "${YELLOW}Worker Errors:${NC}"
        gcloud logging read "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"kitesforu-worker\" AND severity>=ERROR AND timestamp>=\"$one_hour_ago\"" \
            --limit=1 \
            --project=$PROJECT_ID \
            --format="value(severity)" 2>&1 | wc -l | xargs echo
    fi
fi

echo ""
echo -e "${GREEN}Log check complete!${NC}"
