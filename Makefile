APP_NAME = galactus
GCP_PROJECT = test-eyal
GSA_EMAIL = $(APP_NAME)@$(GCP_PROJECT).iam.gserviceaccount.com
IMAGE_NAME = europe-west1-docker.pkg.dev/$(GCP_PROJECT)/$(APP_NAME)/$(APP_NAME)


setup-workload-identity:
	gcloud iam service-accounts create $(APP_NAME) --project=$(GCP_PROJECT) 2>/dev/null || true
	gcloud projects add-iam-policy-binding $(GCP_PROJECT) \
	    --member "serviceAccount:$(GSA_EMAIL)" \
	    --role "roles/policyanalyzer.activityAnalysisViewer"
	gcloud iam service-accounts add-iam-policy-binding $(GSA_EMAIL) \
	    --role roles/iam.workloadIdentityUser \
	    --member "serviceAccount:$(GCP_PROJECT).svc.id.goog[$(APP_NAME)/$(APP_NAME)]"

deploy:
	export GCP_PROJECT=$(GCP_PROJECT) GSA_EMAIL=$(GSA_EMAIL) IMAGE_NAME=$(IMAGE_NAME);\
	kubectl kustomize kustomize | envsubst | kubectl apply -f-
