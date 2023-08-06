prefix = "poc"
infra_env = "dev"
project = "demo"
contact = "test@test.com"
default_region = "ap-south-1"
default_profile = "sagemaker"
sagemaker_endpoint_conf_name = "finbert-tone-model-conf-tf"
sagemaker_endpoint_conf_variant_name = "finbert-tone-model-conf-variant-t2-medium"
sagemaker_endpoint_name = "finbert-tone-model-endpoint-t2-medium-tf"
sagemaker_model_name = "finbert-tone-model-tf-2023-08-03"
sagemaker_model_instance_count = 1
sagemaker_model_instance_type = "ml.t2.medium"
sagemaker_model_mode = "SingleModel"
sagemaker_container_repo_url = "763104351884.dkr.ecr.ap-south-1.amazonaws.com/pytorch-inference:1.7.1-cpu-py3"
sagemaker_model_data_s3_url = "s3://finbert-tone-poc-model/finbert-tone-model-2023-08-03/model.tar.gz"
cognito_user_pool_name = "SagemakerUserPool"
cognito_user_pool_client_name = "SagemakerUserPoolClient"
cognito_user_pool_domain = "sagemaker-up-2023-0-06"
apigateway_authorizer_name = "SagemakerCognitoAuthorizer"
rest_api_name = "finbert-tone-model-api"
rest_api_description = "API for Finbert tone model"