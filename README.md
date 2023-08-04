# Sagemaker model endpoint deployment through terraform

## Step 0 : AWS profile setup
Configure aws profile to be used by terraform

```bash
aws configure --profile sagemaker
```

and enter aws access key id and secret key id

## Step 1 : Create S3 bucket with version enabled

Create a s3 bucket to store the terraform state. The bucket should have version enabled. Enabling versioning for the S3 bucket storing Terraform state allows maintaining historical versions of the state file, aiding in disaster recovery, change tracking, and collaborative work.

**Create s3 bucket from CLI**

```bash
aws s3api create-bucket \ 
    --bucket sagemaker-endpoint-deploy-tf-state \
    --region ap-south-1 \
    --create-bucket-configuration LocationConstraint=ap-south-1 \
    --profile sagemaker
```

**Enable Version**

```bash
aws s3api put-bucket-versioning \
    --bucket sagemaker-endpoint-deploy-tf-state \
    --versioning-configuration Status=Enabled \ 
    --profile sagemaker
```

## Step 2 : Build artifacts

**First lets build model artifacts**

`model` folder consists of the `code` folder consisting `inference.py` which will be used by sagemaker model endpoint to generate model inference from API call and `requirements.txt` for python dependency. 

The model should also contain the model artifacts like model config and actual model. Here actual model named `pytorch_model.bin` is absent inside model folder. You can get it from the link here [Finbert Tone Model](https://huggingface.co/yiyanghkust/finbert-tone/tree/main)

Compress model artifacts into tar file.

```bash
tar -czvf model.tar.gz -C model .
```

- `tar` : The tar command.
- `-czvf` : Flags for creating a gzipped tar archive with verbose output.
- `model.tar.gz` : The name of the output archive.
- `-C model` : Change directory to the "model" directory.
- `.` : Include all files and subdirectories inside the "model" directory in the archive.


**Compress Lambda function for deployment**

```bash
zip -r lambda.zip ./lambda/* -j
```
- `zip -r lambda.zip` : It creates a zip file named `lambda.zip`
- `./lambda/*` : It specify the path of the files and folders inside the `lambda` directory. The `*` glob pattern is used to include all files and folders inside the `lambda` directory.
- `-j`: With this option, `zip` will store only the relative paths of the files, effectively flattening the folder structure inside the zip archive.

## Step 3 : Upload model artifacts to s3 bucket

```bash
aws s3 cp model.tar.gz s3://finbert-tone-poc-model/finbert-tone-model-2023-08-03/model.tar.gz --profile sagemaker
```

You will get output like

```bash
upload: ./model.tar.gz to s3://finbert-tone-poc-model/finbert-tone-model-2023-08-03/model.tar.gz
```

Copy the s3 model artifacts link and place it into `sagemaker_model_data_s3_url` in `terraform.tfvars` file

## Step 4 : Terraform deploy

**Don't forget to change variables name in `terraform.tfvars` file as your preferences**

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

```bash
terraform destroy
```

1. `terraform init`
    - It initializes a Terraform configuration in the current directory. 
    - It downloads and installs the required provider plugins and modules specified in our configuration. 
    - It sets up the working directory and prepares it for the other Terraform commands.

2. `terraform plan`
    - It creates an execution plan for our infrastructure. 
    - It compares the desired state (specified in our Terraform configuration files) with the current state (tracked in the Terraform state file). 
    - The plan shows what changes Terraform will make to achieve the desired state. 
    - It does not make any actual changes to our infrastructure; it only shows us what changes will occur when we apply.

3. `terraform apply`
    - It applies the changes to our infrastructure as described in the execution plan generated by `terraform plan`. 
    - It creates, updates, or deletes resources as needed to reach the desired state. 
    - It interacts with us to confirm whether we want to proceed with the changes or not, based on the plan.

4. `terraform destroy`
    - It is used to destroy the infrastructure created by Terraform. 
    - It will delete all the resources that were previously created using `terraform apply`. 
    - Terraform will ask for confirmation before actually destroying the resources to avoid accidental deletions.

After successful deployment you will see something like below

```bash
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

api_gateway_url = "https://k3565nbkl6.execute-api.ap-south-1.amazonaws.com/dev"
```

Append `/sentiment` to the api url for getting the sentiment for financial text. Request method will be `POST`

```bash

https://k3565nbkl6.execute-api.ap-south-1.amazonaws.com/dev/sentiment

{
    "text": "growth is strong and we have plenty of liquidity"
}

Response

{
    "data": [
        {
            "label": "POSITIVE",
            "score": 1
        }
    ]
}
```

## Caution!!!
**Remember that `terraform apply` and `terraform destroy` can make changes to our infrastructure, so use them with caution.** 

**Always review the execution plan carefully `terraform plan` before applying changes to ensure that us understand the impact on our infrastructure.**
