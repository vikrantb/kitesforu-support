#!/bin/bash

# ================================================================================================
# JOB DIAGNOSTIC TOOL FOR KITESFORU PODCAST STUDIO
# ================================================================================================
#
# Purpose: Comprehensive diagnostic tool for troubleshooting stuck, failed, or delayed jobs
#
# This tool analyzes the complete job processing pipeline:
#   1. Job status in Firestore
#   2. Pub/Sub message delivery status
#   3. Worker logs and processing
#   4. API logs for job creation
#   5. Provider failover execution
#
# Usage:
#   ./scripts/diagnose-job.sh <job_id> [project_id]
#
# Examples:
#   ./scripts/diagnose-job.sh 37ee4775-9628-45d8-b396-c070fd3db05c
#   ./scripts/diagnose-job.sh 37ee4775-9628-45d8-b396-c070fd3db05c kitesforu-dev
#
# Output:
#   Detailed diagnostic report showing:
#   - Job current status and stage
#   - Pub/Sub message delivery attempts
#   - Worker processing logs
#   - API logs for job creation
#   - Error patterns and root cause analysis
#
# ================================================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get arguments
JOB_ID="$1"
PROJECT_ID="${2:-kitesforu-dev}"
REGION="us-central1"

if [ -z "$JOB_ID" ]; then
    echo -e "${RED}ERROR: Job ID is required${NC}"
    echo "Usage: $0 <job_id> [project_id]"
    echo "Example: $0 37ee4775-9628-45d8-b396-c070fd3db05c"
    exit 1
fi

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}JOB DIAGNOSTIC REPORT${NC}"
echo -e "${BLUE}================================================${NC}"
echo "Job ID: $JOB_ID"
echo "Project: $PROJECT_ID"
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# ================================================================================================
# SECTION 1: JOB STATUS IN FIRESTORE
# ================================================================================================
echo -e "${BLUE}[1] CHECKING JOB STATUS IN FIRESTORE${NC}"
echo "Getting job document from Firestore..."

JOB_DATA=$(gcloud firestore documents get \
    --project="$PROJECT_ID" \
    --database="(default)" \
    --format=json \
    "projects/$PROJECT_ID/databases/(default)/documents/podcast_jobs/$JOB_ID" 2>&1 || echo "NOT_FOUND")

if echo "$JOB_DATA" | grep -q "NOT_FOUND\|does not exist"; then
    echo -e "${RED}❌ Job not found in Firestore${NC}"
    echo "This job does not exist or was deleted"
    exit 1
else
    # Extract key fields
    STATUS=$(echo "$JOB_DATA" | jq -r '.fields.status.stringValue // "unknown"')
    STAGE=$(echo "$JOB_DATA" | jq -r '.fields.progress.mapValue.fields.stage.stringValue // "unknown"')
    PCT=$(echo "$JOB_DATA" | jq -r '.fields.progress.mapValue.fields.pct.integerValue // "0"')
    CREATED=$(echo "$JOB_DATA" | jq -r '.fields.created_at.timestampValue // "unknown"')
    UPDATED=$(echo "$JOB_DATA" | jq -r '.fields.updated_at.timestampValue // "unknown"')

    echo -e "${GREEN}✅ Job found in Firestore${NC}"
    echo "  Status: $STATUS"
    echo "  Stage: $STAGE (${PCT}%)"
    echo "  Created: $CREATED"
    echo "  Updated: $UPDATED"

    # Calculate time since creation
    if [ "$CREATED" != "unknown" ]; then
        CREATED_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${CREATED:0:19}" "+%s" 2>/dev/null || echo "0")
        NOW_EPOCH=$(date "+%s")
        AGE_SECONDS=$((NOW_EPOCH - CREATED_EPOCH))
        AGE_MINUTES=$((AGE_SECONDS / 60))
        echo "  Age: ${AGE_MINUTES} minutes (${AGE_SECONDS} seconds)"

        if [ $AGE_SECONDS -gt 300 ] && [ "$STATUS" = "queued" ]; then
            echo -e "${RED}  ⚠️  WARNING: Job stuck in queued state for >5 minutes${NC}"
        fi
    fi
fi

echo ""

# ================================================================================================
# SECTION 2: PUB/SUB MESSAGE DELIVERY
# ================================================================================================
echo -e "${BLUE}[2] CHECKING PUB/SUB MESSAGE DELIVERY${NC}"
echo "Analyzing Pub/Sub topic and subscription..."

# Get topic name
TOPIC="projects/$PROJECT_ID/topics/podcast-jobs"
SUBSCRIPTION="projects/$PROJECT_ID/subscriptions/podcast-jobs-sub"

# Check if message was published
echo "Searching for job message in Pub/Sub..."
PUB_SUB_LOGS=$(gcloud logging read \
    --project="$PROJECT_ID" \
    --format=json \
    --limit=50 \
    "resource.type=\"pubsub_topic\"
     resource.labels.topic_id=\"podcast-jobs\"
     jsonPayload.message.attributes.job_id=\"$JOB_ID\"" 2>&1)

if echo "$PUB_SUB_LOGS" | grep -q "$JOB_ID"; then
    echo -e "${GREEN}✅ Message published to Pub/Sub topic${NC}"
    PUBLISH_TIME=$(echo "$PUB_SUB_LOGS" | jq -r '.[0].timestamp // "unknown"')
    echo "  Published at: $PUBLISH_TIME"
else
    echo -e "${RED}❌ No message found in Pub/Sub topic${NC}"
    echo "  This indicates job was not published to the queue"
    echo "  Check API logs for job creation errors"
fi

# Check delivery attempts
echo ""
echo "Checking message delivery attempts..."
DELIVERY_LOGS=$(gcloud logging read \
    --project="$PROJECT_ID" \
    --format=json \
    --limit=100 \
    "resource.type=\"cloud_run_revision\"
     resource.labels.service_name=\"kitesforu-worker\"
     httpRequest.requestUrl=~\"/worker/pubsub\"
     timestamp>=\"${CREATED}\"" 2>&1)

DELIVERY_COUNT=$(echo "$DELIVERY_LOGS" | jq '. | length')
echo "  Delivery attempts: $DELIVERY_COUNT"

if [ "$DELIVERY_COUNT" -gt 0 ]; then
    # Check for 404 errors
    ERROR_404_COUNT=$(echo "$DELIVERY_LOGS" | jq '[.[] | select(.httpRequest.status == 404)] | length')
    ERROR_500_COUNT=$(echo "$DELIVERY_LOGS" | jq '[.[] | select(.httpRequest.status >= 500)] | length')
    SUCCESS_COUNT=$(echo "$DELIVERY_LOGS" | jq '[.[] | select(.httpRequest.status == 200)] | length')

    echo "    ✅ Successful (200): $SUCCESS_COUNT"
    echo "    ❌ Not Found (404): $ERROR_404_COUNT"
    echo "    ⚠️  Server Error (5xx): $ERROR_500_COUNT"

    if [ "$ERROR_404_COUNT" -gt 0 ]; then
        echo -e "${RED}  ⚠️  CRITICAL: Worker endpoint returning 404${NC}"
        echo "  This means worker is running wrong app (API instead of worker)"
        echo "  Fix: Ensure worker deployment specifies correct entry point"
    fi

    if [ "$SUCCESS_COUNT" -gt 0 ]; then
        echo -e "${GREEN}  ✅ Worker successfully received message${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠️  No delivery attempts found${NC}"
    echo "  Message may still be in queue or delivery is delayed"
fi

echo ""

# ================================================================================================
# SECTION 3: WORKER PROCESSING LOGS
# ================================================================================================
echo -e "${BLUE}[3] CHECKING WORKER PROCESSING LOGS${NC}"
echo "Searching for job processing logs..."

WORKER_LOGS=$(gcloud logging read \
    --project="$PROJECT_ID" \
    --format=json \
    --limit=200 \
    "resource.type=\"cloud_run_revision\"
     resource.labels.service_name=\"kitesforu-worker\"
     (jsonPayload.job_id=\"$JOB_ID\" OR textPayload=~\"$JOB_ID\")
     timestamp>=\"${CREATED}\"" 2>&1)

WORKER_LOG_COUNT=$(echo "$WORKER_LOGS" | jq '. | length')
echo "  Worker log entries: $WORKER_LOG_COUNT"

if [ "$WORKER_LOG_COUNT" -eq 0 ]; then
    echo -e "${RED}  ❌ No worker logs found for this job${NC}"
    echo "  This indicates worker never received or started processing the job"
    echo "  Likely causes:"
    echo "    1. Pub/Sub message not delivered (see section 2)"
    echo "    2. Worker crashed on startup"
    echo "    3. Worker filtering out the message"
else
    echo -e "${GREEN}  ✅ Worker processing logs found${NC}"

    # Analyze log patterns
    echo ""
    echo "  Log pattern analysis:"

    # Check for job start
    if echo "$WORKER_LOGS" | jq -e '[.[] | select(.jsonPayload.operation == "job_start")] | length > 0' >/dev/null 2>&1; then
        echo "    ✅ Job processing started"
        START_TIME=$(echo "$WORKER_LOGS" | jq -r '[.[] | select(.jsonPayload.operation == "job_start")] | .[0].timestamp')
        echo "       Started at: $START_TIME"
    else
        echo "    ❌ Job processing never started"
    fi

    # Check for errors
    ERROR_LOGS=$(echo "$WORKER_LOGS" | jq '[.[] | select(.severity == "ERROR")]')
    ERROR_COUNT=$(echo "$ERROR_LOGS" | jq '. | length')
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "    ❌ Errors found: $ERROR_COUNT"
        echo ""
        echo "  Recent errors:"
        echo "$ERROR_LOGS" | jq -r '.[] | "    [\(.timestamp)] \(.jsonPayload.message // .textPayload)"' | head -5
    else
        echo "    ✅ No errors in processing"
    fi

    # Check for stage progression
    echo ""
    echo "  Stage progression:"
    echo "$WORKER_LOGS" | jq -r '[.[] | select(.jsonPayload.operation != null)] | .[] | "    [\(.timestamp)] \(.jsonPayload.operation // "unknown") - \(.jsonPayload.message // "")"' | head -10
fi

echo ""

# ================================================================================================
# SECTION 4: API JOB CREATION LOGS
# ================================================================================================
echo -e "${BLUE}[4] CHECKING API JOB CREATION LOGS${NC}"
echo "Searching for job creation logs..."

API_LOGS=$(gcloud logging read \
    --project="$PROJECT_ID" \
    --format=json \
    --limit=50 \
    "resource.type=\"cloud_run_revision\"
     resource.labels.service_name=\"kitesforu-api\"
     (jsonPayload.job_id=\"$JOB_ID\" OR textPayload=~\"$JOB_ID\")
     timestamp>=\"${CREATED}\"" 2>&1)

API_LOG_COUNT=$(echo "$API_LOGS" | jq '. | length')
echo "  API log entries: $API_LOG_COUNT"

if [ "$API_LOG_COUNT" -gt 0 ]; then
    echo -e "${GREEN}  ✅ Job creation logs found${NC}"

    # Show creation flow
    echo ""
    echo "  Job creation flow:"
    echo "$API_LOGS" | jq -r '[.[] | select(.jsonPayload.operation != null)] | .[] | "    [\(.timestamp)] \(.jsonPayload.operation) - \(.jsonPayload.message // "")"' | head -10

    # Check for errors
    API_ERRORS=$(echo "$API_LOGS" | jq '[.[] | select(.severity == "ERROR")]')
    API_ERROR_COUNT=$(echo "$API_ERRORS" | jq '. | length')
    if [ "$API_ERROR_COUNT" -gt 0 ]; then
        echo ""
        echo "  ❌ Errors during job creation:"
        echo "$API_ERRORS" | jq -r '.[] | "    [\(.timestamp)] \(.jsonPayload.message // .textPayload)"'
    fi
else
    echo -e "${YELLOW}  ⚠️  No API logs found for this job${NC}"
fi

echo ""

# ================================================================================================
# SECTION 5: PROVIDER FAILOVER ANALYSIS
# ================================================================================================
echo -e "${BLUE}[5] CHECKING PROVIDER FAILOVER${NC}"
echo "Analyzing model provider usage and failover..."

# Search for model provider logs
PROVIDER_LOGS=$(gcloud logging read \
    --project="$PROJECT_ID" \
    --format=json \
    --limit=100 \
    "resource.type=\"cloud_run_revision\"
     resource.labels.service_name=\"kitesforu-worker\"
     jsonPayload.job_id=\"$JOB_ID\"
     (jsonPayload.message=~\"provider\" OR jsonPayload.message=~\"failover\" OR jsonPayload.message=~\"model\")
     timestamp>=\"${CREATED}\"" 2>&1)

PROVIDER_LOG_COUNT=$(echo "$PROVIDER_LOGS" | jq '. | length')

if [ "$PROVIDER_LOG_COUNT" -gt 0 ]; then
    echo -e "${GREEN}  ✅ Provider logs found${NC}"
    echo ""
    echo "  Provider execution timeline:"
    echo "$PROVIDER_LOGS" | jq -r '.[] | "    [\(.timestamp)] \(.jsonPayload.message // .textPayload)"'

    # Check for OpenAI attempts
    if echo "$PROVIDER_LOGS" | grep -qi "openai"; then
        echo ""
        echo "  OpenAI provider:"
        echo "$PROVIDER_LOGS" | jq -r '[.[] | select(.jsonPayload.message | test("openai"; "i"))] | .[] | "    [\(.timestamp)] \(.jsonPayload.message)"'
    fi

    # Check for Anthropic failover
    if echo "$PROVIDER_LOGS" | grep -qi "anthropic"; then
        echo ""
        echo -e "  ${GREEN}✅ Anthropic failover executed${NC}"
        echo "$PROVIDER_LOGS" | jq -r '[.[] | select(.jsonPayload.message | test("anthropic"; "i"))] | .[] | "    [\(.timestamp)] \(.jsonPayload.message)"'
    fi

    # Check for quota/rate limit errors
    if echo "$PROVIDER_LOGS" | grep -qi "quota\|rate.limit\|insufficient_quota"; then
        echo ""
        echo -e "  ${RED}❌ Quota/Rate limit errors detected${NC}"
        echo "$PROVIDER_LOGS" | jq -r '[.[] | select(.jsonPayload.message | test("quota|rate.limit|insufficient_quota"; "i"))] | .[] | "    [\(.timestamp)] \(.jsonPayload.message)"'
    fi
else
    echo -e "${YELLOW}  ⚠️  No provider-specific logs found${NC}"
    echo "  Job may not have reached script generation stage"
fi

echo ""

# ================================================================================================
# SECTION 6: ROOT CAUSE ANALYSIS & RECOMMENDATIONS
# ================================================================================================
echo -e "${BLUE}[6] ROOT CAUSE ANALYSIS & RECOMMENDATIONS${NC}"
echo ""

# Analyze patterns and provide recommendations
if [ "$STATUS" = "queued" ] && [ "$DELIVERY_COUNT" -eq 0 ]; then
    echo -e "${RED}ROOT CAUSE: Message not delivered to worker${NC}"
    echo "Recommendations:"
    echo "  1. Check Pub/Sub subscription configuration"
    echo "  2. Verify worker service is running and healthy"
    echo "  3. Check service account permissions"
elif [ "$STATUS" = "queued" ] && [ "$ERROR_404_COUNT" -gt 0 ]; then
    echo -e "${RED}ROOT CAUSE: Worker running wrong application (404 on /worker/pubsub)${NC}"
    echo "Recommendations:"
    echo "  1. Verify worker deployment uses correct entry point (app.workers.main:app)"
    echo "  2. Check gcloud run deploy --command and --args parameters"
    echo "  3. Redeploy worker with correct command override"
elif [ "$STATUS" = "failed" ]; then
    echo -e "${RED}ROOT CAUSE: Job failed during processing${NC}"
    echo "Recommendations:"
    echo "  1. Review worker error logs above"
    echo "  2. Check provider quota and API keys"
    echo "  3. Verify input validation and error handling"
elif [ "$STATUS" = "queued" ] && [ $AGE_MINUTES -gt 5 ]; then
    echo -e "${RED}ROOT CAUSE: Job stuck in queued state for >5 minutes${NC}"
    echo "Recommendations:"
    echo "  1. Check worker is processing messages (section 3)"
    echo "  2. Verify Pub/Sub delivery (section 2)"
    echo "  3. Check for worker crashes or restarts"
elif [ "$SUCCESS_COUNT" -gt 0 ] && [ "$WORKER_LOG_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}WARNING: Message delivered but no worker logs${NC}"
    echo "Recommendations:"
    echo "  1. Worker may have crashed immediately"
    echo "  2. Check for worker startup errors"
    echo "  3. Verify logging is configured correctly"
else
    echo -e "${GREEN}✅ No obvious issues detected${NC}"
    echo "Job appears to be processing normally"
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}END OF DIAGNOSTIC REPORT${NC}"
echo -e "${BLUE}================================================${NC}"
