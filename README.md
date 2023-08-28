# llm-stack

## 1. Build the Llama 2 model serving containter image,

```
cd llama2-7b/llama2-7b
gcloud builds submit --region=us-west2 --config cloudbuild.yaml

```

## 2. Provision the GKE-GPU cluster, and llama 2 deployment/services
Update deploy.sh file

```
./deploy.sh

```

## 3. Test with web-app