variable "prefix" {
  type        = string
  description = "The prefix that should be in the tag name"
}

variable "infra_env" {
  type        = string
  description = "Infrastructure environment"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "contact" {
  type        = string
  default     = "test@test.com"
  description = "Contact address"
}

variable "default_region" {
  type        = string
  description = "Default region where your infrastructure is in"
}

variable "default_profile" {
  type        = string
  description = "Default profile to use for credentials"
}

variable "sagemaker_endpoint_conf_name" {
  type        = string
  description = "Sagemaker endpoint configuration name"
}

variable "sagemaker_endpoint_conf_variant_name" {
  type        = string
  description = "Sagemaker endpoint configuration variant name"
}

variable "sagemaker_endpoint_name" {
  type        = string
  description = "Sagemaker endpoint name"
}

variable "sagemaker_model_name" {
  type        = string
  description = "Name of the sagemaker model"
}

variable "sagemaker_model_data_s3_url" {
  type        = string
  description = "Model artifacts s3 url"
}

variable "sagemaker_container_repo_url" {
  type        = string
  description = "Url of the sagemaker app container"
}

variable "sagemaker_model_mode" {
  type        = string
  description = "Sagemaker model deployment mode"
  default = "SingleModel"
}

variable "sagemaker_model_instance_count" {
  type = number
  description = "The sagemaker model initial instance count"
  default = 1
}

variable "sagemaker_model_instance_type" {
  type = string
  description = "The sagemaker model instance type"
  default = "ml.t2.medium"
}

variable "cognito_user_pool_name" {
  type = string
  description = "Name of the cognito user pool"
}

variable "cognito_user_pool_client_name" {
  type = string
  description = "The user pool client name"
}

variable "cognito_user_pool_domain" {
  type = string
  description = "The user pool domain name for hosted UI"
}

variable "apigateway_authorizer_name" {
  type = string
  description = "The api gateway authorizer name"
}

variable "rest_api_name" {
  type        = string
  description = "Name of the REST API"
}

variable "rest_api_description" {
  type        = string
  description = "Description of the REST API"
}