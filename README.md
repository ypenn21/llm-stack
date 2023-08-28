# Self-host Llama 2 model in GKE
## Prerequisites:
Meta access request: https://ai.meta.com/resources/models-and-libraries/llama-downloads/

Hugging face access: https://huggingface.co/meta-llama/Llama-2-7b

Get Hugging face access token from HF settings

Create a Artifact Registry repo: llm-repo in us-central1

Main GCP Services:

GKE, Cloud Build, Cloud Run
## 1. Update Llama 2 model serving config file with your own HF token API,

```
cd llama2-7b
sed -i 's/API_TOKEN_HERE/XXXXXX/g' config.yaml
cd ..
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

Validation:
```

curl --location 'http://SERVICE_IP:8080/v1/models/model:predict' --header 'Content-Type: application/json' --data '{  "prompt": "Who was president of the united states of america in 1890??"}'
```
## 3. Test with web-app
Go to cloud run, and open the web-client run service URL, and test out prompts.

## 4. Clean-up 

To clean up resource, update the deploy.sh file:

. comment out the cloud build lines in step 1 and step 2

. Update the last line to destroy resources:  terraform destroy --auto-approve
