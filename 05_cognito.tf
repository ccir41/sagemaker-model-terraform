resource "aws_cognito_user_pool" "cognito_user_pool" {
  name                     = var.cognito_user_pool_name
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  verification_message_template {
    email_message        = "Your verification code is {####}"
    email_subject        = "Verify your email for our app"
    default_email_option = "CONFIRM_WITH_CODE"
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-${var.cognito_user_pool_name}" }
  )
}


resource "aws_cognito_user_pool_domain" "cognito_user_pool_domain" {
  domain       = var.cognito_user_pool_domain
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}

# resource "aws_cognito_identity_provider" "google_idp" {
#   user_pool_id         = aws_cognito_user_pool.cognito_user_pool.id
#   provider_name        = "Google"
#   provider_type        = "Google"
#   provider_details     = {
#     "client_id" = var.google_client_id
#   }
# }

resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name                                 = var.cognito_user_pool_client_name
  user_pool_id                         = aws_cognito_user_pool.cognito_user_pool.id
  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["http://localhost:3000"]
  logout_urls                          = ["http://localhost:3000/signout"]
  supported_identity_providers         = ["COGNITO"]
}
