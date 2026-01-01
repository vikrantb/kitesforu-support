#!/usr/bin/env python3
"""
Nuke All Jobs

DESTRUCTIVE: Deletes ALL jobs from Firestore.
This is for development/testing cleanup only.

NEVER run this in production without explicit authorization.
"""

import os
import sys

try:
    from google.cloud import firestore
except ImportError:
    print("Error: google-cloud-firestore not installed")
    print("Run: pip install google-cloud-firestore")
    sys.exit(1)


def get_firestore_client():
    """Initialize Firestore client."""
    return firestore.Client(project="kitesforu-dev")


def count_jobs(db):
    """Count total jobs in the collection."""
    jobs_ref = db.collection("podcast_jobs")
    return len(list(jobs_ref.stream()))


def delete_all_jobs(db, dry_run=True):
    """
    Delete ALL jobs from Firestore.
    
    Args:
        db: Firestore client
        dry_run: If True, only count without deleting
    
    Returns:
        Number of jobs deleted
    """
    jobs_ref = db.collection("podcast_jobs")
    
    if dry_run:
        count = count_jobs(db)
        print(f"\n[DRY RUN] Would delete {count} jobs")
        return count
    
    # Batch delete for efficiency
    batch_size = 100
    deleted = 0
    
    while True:
        # Get a batch of documents
        docs = list(jobs_ref.limit(batch_size).stream())
        
        if not docs:
            break
        
        # Create a batch
        batch = db.batch()
        
        for doc in docs:
            batch.delete(doc.reference)
            deleted += 1
        
        # Commit the batch
        batch.commit()
        print(f"Deleted batch of {len(docs)} jobs (total: {deleted})")
    
    return deleted


def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="DESTRUCTIVE: Delete ALL jobs from Firestore",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
WARNING: This script will DELETE ALL jobs from the podcast_jobs collection.
This action is IRREVERSIBLE.

Use --confirm-delete and type the confirmation phrase to execute.
        """
    )
    parser.add_argument("--confirm-delete", action="store_true",
                        help="Enable deletion (still requires confirmation)")
    
    args = parser.parse_args()
    
    db = get_firestore_client()
    
    # Always show count first
    count = count_jobs(db)
    print(f"\n=== Job Count ===")
    print(f"Total jobs in podcast_jobs: {count}")
    
    if not args.confirm_delete:
        print("\n[DRY RUN] Use --confirm-delete to enable deletion")
        return
    
    # Require typed confirmation
    print("\n" + "="*60)
    print("DANGER: This will DELETE ALL {} JOBS.".format(count))
    print("="*60)
    print("\nType 'DELETE ALL JOBS' to confirm:")
    
    confirmation = input("> ")
    
    if confirmation != "DELETE ALL JOBS":
        print("\nConfirmation failed. Aborted.")
        return
    
    print("\nDeleting all jobs...")
    deleted = delete_all_jobs(db, dry_run=False)
    print(f"\n=== Complete ===")
    print(f"Deleted {deleted} jobs")


if __name__ == "__main__":
    main()
