#!/usr/bin/env python3
"""
Clean Invalid Jobs from Firestore

Deletes all jobs with invalid schema data. Since there are no production users,
we can safely delete all bad development data.

Invalid jobs include:
- Jobs with invalid status values (not in JobStatus enum)
- Jobs missing required fields
- Jobs that fail Pydantic validation

Usage:
    # Dry run (default):
    python3 scripts/maintenance/clean_invalid_jobs.py

    # Execute deletion:
    python3 scripts/maintenance/clean_invalid_jobs.py --execute

Safety:
- Dry run by default (no deletions)
- Batch operations for efficiency
- Detailed logging of what will be deleted
- Validation against current Pydantic models

Requirements:
    pip install kitesforu-schemas google-cloud-firestore
"""

import sys
import os
import argparse
import logging
from datetime import datetime
from typing import List, Dict, Any

from google.cloud import firestore
from pydantic import ValidationError

# Import from kitesforu-schemas package
from kitesforu_schemas.models import JobStatus, PodcastJob

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class JobCleaner:
    """Clean invalid jobs from Firestore"""

    def __init__(self, db: firestore.Client, dry_run: bool = True):
        self.db = db
        self.dry_run = dry_run
        self.stats = {
            'total_jobs': 0,
            'invalid_status': 0,
            'validation_failed': 0,
            'deleted': 0,
            'kept': 0
        }

    def validate_job(self, job_id: str, data: dict) -> tuple[bool, str]:
        """
        Validate a job against current Pydantic schema.

        Args:
            job_id: Job document ID
            data: Job data from Firestore

        Returns:
            (is_valid, reason) tuple
        """
        # Check 1: Valid status
        status = data.get('status')
        valid_statuses = [s.value for s in JobStatus]

        if status not in valid_statuses:
            return False, f"Invalid status '{status}' (not in {valid_statuses})"

        # Check 2: Pydantic validation
        try:
            PodcastJob(**data)
            return True, "Valid"
        except ValidationError as e:
            # Extract first error for concise reporting
            first_error = e.errors()[0]
            field = '.'.join(str(x) for x in first_error['loc'])
            msg = first_error['msg']
            return False, f"Pydantic validation failed: {field} - {msg}"
        except Exception as e:
            return False, f"Unexpected error: {str(e)}"

    def analyze_jobs(self) -> List[Dict[str, Any]]:
        """
        Analyze all jobs and identify invalid ones.

        Returns:
            List of invalid jobs with metadata
        """
        logger.info("Analyzing all jobs in Firestore...")

        collection_ref = self.db.collection('podcast_jobs')
        jobs = collection_ref.stream()

        invalid_jobs = []

        for job_doc in jobs:
            self.stats['total_jobs'] += 1
            job_id = job_doc.id
            data = job_doc.to_dict()

            is_valid, reason = self.validate_job(job_id, data)

            if not is_valid:
                invalid_jobs.append({
                    'job_id': job_id,
                    'reason': reason,
                    'status': data.get('status'),
                    'created_at': data.get('created_at'),
                    'user_id': data.get('user_id')
                })

                # Track specific failure types
                if 'Invalid status' in reason:
                    self.stats['invalid_status'] += 1
                elif 'Pydantic validation failed' in reason:
                    self.stats['validation_failed'] += 1

                logger.warning(f"Invalid job: {job_id} - {reason}")
            else:
                self.stats['kept'] += 1
                logger.debug(f"Valid job: {job_id}")

        logger.info(f"\nAnalysis complete:")
        logger.info(f"  Total jobs: {self.stats['total_jobs']}")
        logger.info(f"  Valid jobs: {self.stats['kept']}")
        logger.info(f"  Invalid jobs: {len(invalid_jobs)}")
        logger.info(f"    - Invalid status: {self.stats['invalid_status']}")
        logger.info(f"    - Validation failed: {self.stats['validation_failed']}")

        return invalid_jobs

    def delete_jobs(self, invalid_jobs: List[Dict[str, Any]]) -> None:
        """
        Delete invalid jobs from Firestore.

        Args:
            invalid_jobs: List of invalid job metadata
        """
        if not invalid_jobs:
            logger.info("No invalid jobs to delete.")
            return

        if self.dry_run:
            logger.info(f"\n{'='*60}")
            logger.info("DRY RUN MODE - No deletions will be performed")
            logger.info(f"{'='*60}\n")
            logger.info(f"Would delete {len(invalid_jobs)} invalid jobs:")
            for job in invalid_jobs:
                logger.info(f"  - {job['job_id']}: {job['reason']}")
            return

        logger.info(f"\n{'='*60}")
        logger.info(f"EXECUTING DELETION OF {len(invalid_jobs)} JOBS")
        logger.info(f"{'='*60}\n")

        collection_ref = self.db.collection('podcast_jobs')
        batch = self.db.batch()
        batch_count = 0

        for job in invalid_jobs:
            job_id = job['job_id']
            logger.info(f"Deleting {job_id}: {job['reason']}")

            job_ref = collection_ref.document(job_id)
            batch.delete(job_ref)
            batch_count += 1
            self.stats['deleted'] += 1

            # Commit batch every 500 operations
            if batch_count >= 500:
                logger.info(f"Committing batch of {batch_count} deletions...")
                batch.commit()
                batch = self.db.batch()
                batch_count = 0

        # Commit remaining operations
        if batch_count > 0:
            logger.info(f"Committing final batch of {batch_count} deletions...")
            batch.commit()

        logger.info(f"\nDeleted {self.stats['deleted']} invalid jobs")

    def print_summary(self) -> None:
        """Print final summary"""
        print(f"\n{'='*60}")
        print("CLEANUP SUMMARY")
        print(f"{'='*60}")
        print(f"Total jobs analyzed: {self.stats['total_jobs']}")
        print(f"Valid jobs kept: {self.stats['kept']}")
        print(f"Invalid jobs found: {self.stats['invalid_status'] + self.stats['validation_failed']}")
        print(f"  - Invalid status: {self.stats['invalid_status']}")
        print(f"  - Validation failed: {self.stats['validation_failed']}")

        if self.dry_run:
            print(f"\nDRY RUN - No deletions performed")
            print(f"Run with --execute to delete invalid jobs")
        else:
            print(f"\nDeleted: {self.stats['deleted']}")

        print(f"{'='*60}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Clean invalid jobs from Firestore",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Dry run (analyze only, no deletions):
  python3 scripts/maintenance/clean_invalid_jobs.py

  # Execute deletion:
  python3 scripts/maintenance/clean_invalid_jobs.py --execute

  # With verbose logging:
  python3 scripts/maintenance/clean_invalid_jobs.py --execute --verbose
        """
    )

    parser.add_argument(
        '--execute',
        action='store_true',
        help='Execute deletion (default is dry run)'
    )

    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Enable verbose logging'
    )

    parser.add_argument(
        '--project',
        default='kitesforu-dev',
        help='GCP project ID (default: kitesforu-dev)'
    )

    args = parser.parse_args()

    # Set logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    # Initialize Firestore with service account
    logger.info(f"Connecting to Firestore (project: {args.project})")

    # Use service account if GOOGLE_APPLICATION_CREDENTIALS is set
    if 'GOOGLE_APPLICATION_CREDENTIALS' in os.environ:
        logger.info(f"Using service account: {os.environ['GOOGLE_APPLICATION_CREDENTIALS']}")

    db = firestore.Client(project=args.project)

    # Create cleaner
    cleaner = JobCleaner(db, dry_run=not args.execute)

    try:
        # Analyze jobs
        invalid_jobs = cleaner.analyze_jobs()

        # Delete invalid jobs (or show what would be deleted in dry run)
        cleaner.delete_jobs(invalid_jobs)

        # Print summary
        cleaner.print_summary()

        sys.exit(0)

    except KeyboardInterrupt:
        logger.warning("\n\nOperation cancelled by user")
        sys.exit(1)

    except Exception as e:
        logger.error(f"\nError: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
