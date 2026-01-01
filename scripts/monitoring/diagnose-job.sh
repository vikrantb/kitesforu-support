#!/bin/bash
#
# Diagnose Job - Deep dive into a specific job's logs and state
#
# Usage:
#   ./diagnose-job.sh <job_id>
#

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <job_id>"
    echo ""
    echo "Example: $0 abc123-def456-ghi789"
    exit 1
fi

JOB_ID="$1"
PROJECT="kitesforu-dev"

echo "=== Diagnosing Job: $JOB_ID ==="
echo ""

# 1. Check Firestore state
echo "--- Firestore State ---"
echo "(Note: Requires Firestore access via gcloud)"
echo "Collection: podcast_jobs"
echo "Document: $JOB_ID"
echo ""

# 2. API logs for this job
echo "--- API Logs ---"
gcloud logging read \
    'resource.type="cloud_run_revision" AND resource.labels.service_name="kitesforu-api" AND jsonPayload.job_id="'"$JOB_ID"'"' \
    --project="$PROJECT" \
    --limit=20 \
    --format='table(timestamp,severity,jsonPayload.message)' \
    2>/dev/null || echo "No API logs found for this job"

echo ""

# 3. Worker logs for this job
echo "--- Worker Logs ---"
gcloud logging read \
    'resource.type="cloud_run_revision" AND resource.labels.service_name=~"kitesforu-worker" AND jsonPayload.job_id="'"$JOB_ID"'"' \
    --project="$PROJECT" \
    --limit=50 \
    --format='table(timestamp,resource.labels.service_name,severity,jsonPayload.message)' \
    2>/dev/null || echo "No worker logs found for this job"

echo ""

# 4. Check for errors
echo "--- Errors Related to Job ---"
gcloud logging read \
    'resource.type="cloud_run_revision" AND severity>=ERROR AND jsonPayload.job_id="'"$JOB_ID"'"' \
    --project="$PROJECT" \
    --limit=10 \
    --format='table(timestamp,resource.labels.service_name,textPayload)' \
    2>/dev/null || echo "No errors found for this job"

echo ""

# 5. Pub/Sub activity (if accessible)
echo "--- Pub/Sub Activity ---"
echo "Check Pub/Sub console for message delivery status:"
echo "https://console.cloud.google.com/cloudpubsub/topic/list?project=$PROJECT"
echo ""

# 6. Summary
echo "=== Diagnosis Complete ==="
echo ""
echo "Next steps:"
echo "1. Check Firestore console for job state:"
echo "   https://console.firebase.google.com/project/$PROJECT/firestore/data/podcast_jobs/$JOB_ID"
echo ""
echo "2. If job is stuck, check worker logs for the specific stage"
echo ""
echo "3. Common issues:"
echo "   - Status mismatch: Check status field is valid enum"
echo "   - Pub/Sub failure: Check dead-letter topic"
echo "   - Worker crash: Check worker logs for errors"
