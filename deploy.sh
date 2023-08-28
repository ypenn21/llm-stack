#!/bin/bash

#1. Build llama 2 model container image:

cd llama2-7b/llama2-7b
gcloud builds submit --region us-central1 --config cloudbuild.yaml

cd ../../web-app
gcloud builds submit --region us-central1 --config cloudbuild.yaml

# Set the Terraform variables

cd ..

export TF_VAR_project_id=rick-devops-01
export TF_VAR_key_file=rick-devops-01-keys.json
export TF_VAR_region=us-central1
export TF_VAR_model=llama2-7b
export TF_VAR_hf_api_token=$HF_API_TOKEN


# Initialize Terraform
terraform init

# Validate the Terraform configuration
terraform validate

# Apply the deployment
terraform apply --auto-approve
