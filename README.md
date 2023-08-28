# Self-host Llama 2 model in GKE
## Prerequisites:
Meta access request: https://ai.meta.com/resources/models-and-libraries/llama-downloads/

Hugging face access: https://huggingface.co/meta-llama/Llama-2-7b

Get Hugging face access token from HF settings
Create a Artifact Registry repo: llm-repo in us-central1

## 1. Build the Llama 2 model serving containter image,

```
cd llama2-7b/llama2-7b
sed -i 's/API_TOKEN_HERE/XXXXXX/g' config.yaml
gcloud builds submit --region=us-west2 --config cloudbuild.yaml

```

## 2. Provision the GKE-GPU cluster, and llama 2 deployment/services
Update deploy.sh file
export TF_VAR_project_id=rick-devops-01
export TF_VAR_key_file=rick-devops-01-keys.json
export TF_VAR_region=us-central1
export TF_VAR_model=llama2-7b
export TF_VAR_hf_api_token=$HF_API_TOKEN

Then run the deploy.sh script to provision GKE clusters 

```
./deploy.sh

```

## 3. Test with web-app