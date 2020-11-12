# Launching Kubernetes Cluster using EKS and Helm, orchestrated by Terraform

Terraform template to create a VPC and EKS Cluster. Terraform launches the infrastructure. Helm automates deployment of Kubernetes

## Installation and Setup

[Download and Install Terraform](https://www.terraform.io/downloads.html)

[Download and Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
After you have installed AWS CLI, use your terminal to configure your AWS credentials: 
```bash
aws configure
```

[Download and Install Helm](https://helm.sh/docs/intro/install/)
I'm using macOS and I used:
```bash
brew install helm
```

## Managing Terraform Backend

If you are using this project independently, please either **comment out the terraform block** that begins on line 5 of serverless.tf, or **change the bucket parameter** to reference an S3 bucket that you have access to with your AWS credentials. 

## Usage

```bash
terraform init
terraform apply
```

Follow the prompts from these commands and as long as you have the correct permissions on your AWS credentials, the environment should launch successfully. Then run the following command to configure and deploy Kubernetes:

```bash
terraform init
aws eks --region us-west-1  update-kubeconfig --name mainCluster
helm install artgenerator helmchart
```

After running these commands you can view the deployment and grab the url to access your app by running:

```bash
kubectl get all
```

![wireframe](/wireframe.png)
