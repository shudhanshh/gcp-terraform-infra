

### Development Notes
1. Cloud Function and Firestore instance have to be located in the same project
1. Cloud Function service account (service-XXXXX@gcf-admin-robot.iam.gserviceaccount.com) doesn't have the necessary permissions to be triggered by Firestore updates. I had to explicitly add Cloud Datastore Owner permissions to the service account in the IAM controls. This isn't really documented anywhere - I got an error when I tried to deploy initially and took a lucky guess as to what the resolution step was.
1. Cloud Function set to trigger when task is created