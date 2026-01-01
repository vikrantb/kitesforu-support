#!/usr/bin/env python3
"""
Nuke all podcast jobs from Firestore.

USE WITH CAUTION - This deletes ALL jobs!

Usage:
    python scripts/maintenance/nuke_all_jobs.py              # Dry run (shows what would be deleted)
    python scripts/maintenance/nuke_all_jobs.py --confirm    # Actually delete

Requirements:
    pip install google-cloud-firestore

Environment:
    GOOGLE_APPLICATION_CREDENTIALS - Path to service account JSON
"""

import sys
from google.cloud import firestore


def nuke_all_jobs(dry_run: bool = True):
    """Delete all jobs from podcast_jobs collection."""

    db = firestore.Client()
    jobs_ref = db.collection("podcast_jobs")

    # Get all jobs
    jobs = list(jobs_ref.stream())

    print(f"\n{'='*60}")
    print(f"  FIRESTORE JOB CLEANUP")
    print(f"{'='*60}")
    print(f"\nFound {len(jobs)} jobs in podcast_jobs collection\n")

    if not jobs:
        print("No jobs to delete.")
        return

    # Show jobs
    for doc in jobs:
        data = doc.to_dict()
        status = data.get('status', 'unknown')
        topic = data.get('topic', data.get('inputs', {}).get('topic', 'N/A'))[:40]
        created = data.get('created_at', 'N/A')
        print(f"  [{status:12}] {doc.id[:20]}... | {topic}")

    print()

    if dry_run:
        print("DRY RUN - No changes made.")
        print("Run with --confirm to actually delete.")
        return

    # Actually delete
    print("Deleting all jobs...")
    deleted = 0
    for doc in jobs:
        doc.reference.delete()
        deleted += 1
        print(f"  Deleted: {doc.id}")

    print(f"\nDeleted {deleted} jobs.")


if __name__ == "__main__":
    confirm = "--confirm" in sys.argv
    nuke_all_jobs(dry_run=not confirm)
