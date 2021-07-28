from google.cloud import tasks_v2
import json

from os import environ, path
from dotenv import load_dotenv
import logging


def create_task(
    project_id,
    location_id,
    queue_id,
    job_id,
    task_id,
    payload,
    url,
    sa_email,
    in_seconds=None,
):
    """
    Based on input parameters, will create a task on a given Google Cloud
    Task Queue.
    """
    client = tasks_v2.CloudTasksClient()
    parent_queue = client.queue_path(project_id, location_id, queue_id)

    task_name = f"projects/{project_id}/locations/{location_id}/queues/{queue_id}/tasks/{job_id}-{task_id}"

    payload = json.dumps(payload)
    converted_payload = payload.encode()  # API expects bytes payload

    task = {
        "name": task_name,
        "http_request": {
            "http_method": tasks_v2.HttpMethod.POST,
            "url": url,
            "oidc_token": {"service_account_email": sa_email},
            "headers": {"Content-type": "application/json"},
            "body": converted_payload,
        },
    }

    response = client.create_task(parent=parent_queue, task=task)

    logging.info("Successfully created {} task.".format(response.name))

    return response
