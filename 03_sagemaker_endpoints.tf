resource "aws_sagemaker_model" "model" {
  name               = var.sagemaker_model_name
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn
  container {
    image          = var.sagemaker_container_repo_url
    model_data_url = var.sagemaker_model_data_s3_url
    mode           = var.sagemaker_model_mode
    environment = {
      "SAGEMAKER_CONTAINER_LOG_LEVEL" = "20"
      "SAGEMAKER_PROGRAM"             = "inference.py"
      "SAGEMAKER_REGION"              = "${var.default_region}"
      "SAGEMAKER_SUBMIT_DIRECTORY"    = "/opt/ml/model/code"
      "MMS_DEFAULT_WORKERS_PER_MODEL" = "1"
    }
  }
}

resource "aws_sagemaker_endpoint_configuration" "serverless_ec" {
  name = var.sagemaker_endpoint_conf_name

  production_variants {
    variant_name           = var.sagemaker_endpoint_conf_variant_name
    model_name             = aws_sagemaker_model.model.name
    # volume_size_in_gb      = 10
    serverless_config {
      max_concurrency         = 1
      memory_size_in_mb       = 3072
      provisioned_concurrency = 1
    }
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-${var.sagemaker_endpoint_conf_name}" }
  )
}

resource "aws_sagemaker_endpoint" "e" {
  name                 = var.sagemaker_endpoint_name
  endpoint_config_name = aws_sagemaker_endpoint_configuration.serverless_ec.name

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-${var.sagemaker_endpoint_name}" }
  )
}