ready:
	gcloud config set project "xyz-dev-freelance"

install:
	./venv/bin/pip install -r requirements.txt

install-dev:
	./venv/bin/pip install black
	./venv/bin/pip install flake8

lint:
	./venv/bin/black *.py
	./venv/bin/flake8 *.py

run-local:
	python main.py

deploy-stage:
	pipenv run pip freeze > requirements.txt
	gcloud functions deploy stage_process_job \
    --entry-point process_job \
    --runtime python38 \
    --trigger-event "providers/cloud.firestore/eventTypes/document.write" \
  	--trigger-resource "projects/xyz-dev-freelance/databases/(default)/documents/jobs/{jobId}/tasks/{taskId}" \
    --set-env-vars GCP_PROJECT_ID=xyz-dev-freelance \
    --set-env-vars LOCATION_ID=us-east1 \
    --set-env-vars QUEUE_ID=dev-kubestan-taskqueue \
    --set-env-vars URL="https://dev-kubestan-modelfitting-ce3gacxtjq-ue.a.run.app" \
    --set-env-vars SA_EMAIL="xyz-dev-freelance-kubestan@xyz-dev-freelance.iam.gserviceaccount.com"

deploy-prod:
	gcloud functions deploy prod_process_job \
	--entry-point process_job \
	--runtime python38 \
	--trigger-event "providers/cloud.firestore/eventTypes/document.write" \
  	--trigger-resource "projects/YOUR_PROJECT_ID/databases/(default)/documents/messages/{pushId}" \
    --set-env-vars GCP_PROJECT_ID=xyz-dev-freelance \
    --set-env-vars GCP_PROJECT_NUMBER=719237765594