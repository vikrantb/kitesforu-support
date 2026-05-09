#!/usr/bin/env bash
set -euo pipefail

# Collects GitHub PR metadata and Cloud Run logs for a course ID.
# Usage:
#   GH_CONFIG_DIR=/tmp/gh CLOUDSDK_CONFIG=/tmp/gcloud \
#   ./collect_course_debug.sh <course_id> [hours_back]

COURSE_ID="${1:-}"
HOURS_BACK="${2:-6}"

if [[ -z "${COURSE_ID}" ]]; then
  echo "Usage: $0 <course_id> [hours_back]" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Missing 'gh' CLI. Install GitHub CLI first." >&2
  exit 1
fi

if ! command -v gcloud >/dev/null 2>&1; then
  echo "Missing 'gcloud' CLI. Install Google Cloud SDK first." >&2
  exit 1
fi

LOG_DIR="${LOG_DIR:-/tmp/kitesforu-debug}"
mkdir -p "${LOG_DIR}"

timestamp="$(date -u +"%Y%m%dT%H%M%SZ")"
out_dir="${LOG_DIR}/course_${COURSE_ID}_${timestamp}"
mkdir -p "${out_dir}"

echo "Writing outputs to: ${out_dir}"

echo "== Network sanity checks ==" | tee "${out_dir}/network_checks.txt"
nslookup api.github.com 2>&1 | tee -a "${out_dir}/network_checks.txt" || true
nslookup logging.googleapis.com 2>&1 | tee -a "${out_dir}/network_checks.txt" || true
curl -I https://api.github.com 2>&1 | tee -a "${out_dir}/network_checks.txt" || true
curl -I https://logging.googleapis.com 2>&1 | tee -a "${out_dir}/network_checks.txt" || true

python - <<'PY' > "${out_dir}/since_iso.txt"
from datetime import datetime, timedelta, timezone
import os
hours = int(os.environ.get("HOURS_BACK", "6"))
since = datetime.now(timezone.utc) - timedelta(hours=hours)
print(since.strftime("%Y-%m-%dT%H:%M:%SZ"))
PY

SINCE_ISO="$(cat "${out_dir}/since_iso.txt")"
echo "Using since timestamp: ${SINCE_ISO}"

echo "== GitHub PRs (updated since ${SINCE_ISO}) ==" | tee "${out_dir}/github_prs.txt"
for repo in vikrantb/kitesforu-api vikrantb/kitesforu-course-workers vikrantb/kitesforu-frontend; do
  echo "--- ${repo} ---" | tee -a "${out_dir}/github_prs.txt"
  GH_CONFIG_DIR="${GH_CONFIG_DIR:-/tmp/gh}" \
  gh pr list -R "${repo}" -L 20 --state all \
    --search "updated:>=${SINCE_ISO}" 2>&1 | tee -a "${out_dir}/github_prs.txt" || true
done

echo "== Cloud Run logs ==" | tee "${out_dir}/cloudrun_logs.txt"
SERVICES=(
  "course-initiate-worker"
  "course-syllabus-worker"
  "course-orchestrate-worker"
  "kitesforu-api"
)

for svc in "${SERVICES[@]}"; do
  echo "--- ${svc} ---" | tee -a "${out_dir}/cloudrun_logs.txt"
  CLOUDSDK_CONFIG="${CLOUDSDK_CONFIG:-/tmp/gcloud}" \
  gcloud run services logs read "${svc}" \
    --region=us-central1 \
    --freshness="${HOURS_BACK}h" \
    --limit=200 \
    --log-filter="textPayload:\"${COURSE_ID}\" OR jsonPayload.course_id=\"${COURSE_ID}\" OR textPayload:\"/v1/podcasts\"" \
    2>&1 | tee -a "${out_dir}/cloudrun_logs.txt" || true
done

echo "== Done =="
echo "Share these files:"
echo "  ${out_dir}/github_prs.txt"
echo "  ${out_dir}/cloudrun_logs.txt"
