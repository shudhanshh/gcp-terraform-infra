from os import environ, path
from dotenv import load_dotenv

import logging

from utils import tasks


logging.basicConfig(level=logging.INFO)

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, ".env"))

GCP_PROJECT_ID = environ["GCP_PROJECT_ID"]
LOCATION_ID = environ["LOCATION_ID"]
QUEUE_ID = environ["QUEUE_ID"]
URL = environ["URL"]
SA_EMAIL = environ["SA_EMAIL"]


def process_job(data, context):
    """Triggered by a change to a Firestore document.
    Args:
        data (dict): The event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    job_id = data["value"]["name"].split("/")[-3]
    task_id = data["value"]["name"].split("/")[-1]

    logging.info("Creating task for job_id: {} and task_id: {}".format(job_id, task_id))

    task_payload = {"job_id": job_id, "task_id": task_id}

    task_response = tasks.create_task(
        project_id=GCP_PROJECT_ID,
        location_id=LOCATION_ID,
        queue_id=QUEUE_ID,
        job_id=job_id,
        task_id=task_id,
        payload=task_payload,
        url=URL,
        sa_email=SA_EMAIL,
    )

    return {"Response Code": "200"}


if __name__ == "__main__":
    test_data = {
        "value": {
            "name": "projects/xyz-dev-freelance/databases/(default)/documents/jobs/UEPWuObn88VAPfG8umCN/tasks/HAQGzkh8c92IhhmtVZxZ"
        }
    }
    process_job(data=test_data, context=None)
