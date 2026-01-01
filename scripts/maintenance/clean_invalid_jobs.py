#!/usr/bin/env python3
"""
Clean Invalid Jobs

Removes jobs from Firestore that have invalid status or are stuck.
Use with caution in production.
"""

import os
import sys
from datetime import datetime, timedelta

try:
    from google.cloud import firestore
except ImportError:
    print("Error: google-cloud-firestore not installed")
    print("Run: pip install google-cloud-firestore")
    sys.exit(1)

# Valid job statuses
VALID_STATUSES = ["pending", "clarifying", "running", "completed", "failed", "cancelled"]


def get_firestore_client():
    """Initialize Firestore client."""
    return firestore.Client(project="kitesforu-dev")


def find_invalid_jobs(db, dry_run=True):
    """
    Find jobs with invalid status or stuck in running state.
    
    Args:
        db: Firestore client
        dry_run: If True, only report findings without making changes
    
    Returns:
        List of invalid job IDs
    """
    jobs_ref = db.collection("podcast_jobs")
    
    invalid_jobs = []
    stuck_jobs = []
    
    # Get all jobs
    print("Scanning jobs...")
    jobs = jobs_ref.stream()
    
    now = datetime.utcnow()
    stuck_threshold = now - timedelta(hours=2)  # Jobs running > 2 hours are stuck
    
    for job in jobs:
        data = job.to_dict()
        job_id = job.id
        status = data.get("status")
        
        # Check for invalid status
        if status not in VALID_STATUSES:
            invalid_jobs.append({
                "id": job_id,
                "status": status,
                "reason": f"Invalid status: {status}"
            })
            continue
        
        # Check for stuck jobs
        if status == "running":
            updated_at = data.get("updated_at")
            if updated_at:
                if hasattr(updated_at, 'timestamp'):
                    # Firestore timestamp
                    job_time = datetime.fromtimestamp(updated_at.timestamp())
                else:
                    job_time = updated_at
                
                if job_time < stuck_threshold:
                    stuck_jobs.append({
                        "id": job_id,
                        "status": status,
                        "updated_at": str(updated_at),
                        "reason": "Stuck in running state > 2 hours"
                    })
    
    # Report findings
    print(f"\n=== Scan Results ===")
    print(f"Invalid status: {len(invalid_jobs)}")
    print(f"Stuck jobs: {len(stuck_jobs)}")
    
    if invalid_jobs:
        print("\n--- Invalid Status Jobs ---")
        for job in invalid_jobs:
            print(f"  {job['id']}: {job['reason']}")
    
    if stuck_jobs:
        print("\n--- Stuck Jobs ---")
        for job in stuck_jobs:
            print(f"  {job['id']}: {job['reason']} (last update: {job['updated_at']})")
    
    return invalid_jobs + stuck_jobs


def clean_jobs(db, job_ids, dry_run=True):
    """
    Mark jobs as failed or delete them.
    
    Args:
        db: Firestore client
        job_ids: List of job IDs to clean
        dry_run: If True, only report what would be done
    """
    if dry_run:
        print(f"\n[DRY RUN] Would mark {len(job_ids)} jobs as failed")
        return
    
    jobs_ref = db.collection("podcast_jobs")
    
    for job in job_ids:
        job_id = job['id']
        print(f"Marking {job_id} as failed...")
        jobs_ref.document(job_id).update({
            "status": "failed",
            "error_message": f"Auto-cleanup: {job['reason']}",
            "updated_at": firestore.SERVER_TIMESTAMP
        })
    
    print(f"\nCleaned {len(job_ids)} jobs")


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Clean invalid Firestore jobs")
    parser.add_argument("--execute", action="store_true", 
                        help="Actually execute cleanup (default is dry-run)")
    parser.add_argument("--delete", action="store_true",
                        help="Delete jobs instead of marking as failed")
    
    args = parser.parse_args()
    dry_run = not args.execute
    
    if dry_run:
        print("=== DRY RUN MODE (use --execute to apply changes) ===")
    else:
        print("=== EXECUTE MODE - Changes will be applied ===")
        response = input("Are you sure? (yes/no): ")
        if response.lower() != "yes":
            print("Aborted.")
            return
    
    db = get_firestore_client()
    invalid_jobs = find_invalid_jobs(db, dry_run=dry_run)
    
    if invalid_jobs and not dry_run:
        clean_jobs(db, invalid_jobs, dry_run=dry_run)


if __name__ == "__main__":
    main()
