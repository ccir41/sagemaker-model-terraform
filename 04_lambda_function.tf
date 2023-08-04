resource "aws_iam_role" "lambda_role" {
  name = "FinbertModelLambdaRoleTF"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  name = "FinbertModelLambdaRoleTFLogsPolicy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogGroup"
        Resource = "arn:aws:logs:${var.default_region}:${local.aws_account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.default_region}:${local.aws_account_id}:log-group:/aws/lambda/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_sagemaker_policy" {
  name = "FinbertModelLambdaRoleTFSageMakerPolicy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sagemaker:InvokeEndpoint"
        Resource = "arn:aws:sagemaker:${var.default_region}:${local.aws_account_id}:endpoint/*"
      }
    ]
  })
}

resource "aws_lambda_function" "my_lambda_function" {
  filename         = "./lambda.zip"
  function_name    = "finbert-tone-tf"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda.zip")

  layers = [
    "arn:aws:lambda:ap-south-1:017000801446:layer:AWSLambdaPowertoolsPythonV2:38"
  ]
  timeout = 300
  environment {
    variables = {
      ENDPOINT_NAME = "${var.sagemaker_endpoint_name}"
    }
  }
}
