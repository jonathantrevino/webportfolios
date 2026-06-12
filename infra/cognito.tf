# triggers upon right before first sign up
# auto-verifies users email, allowing user to sign in via email code
data "aws_lambda_function" "preSignUpTrigger" {
  function_name = "preSignUpTrigger"
}

# triggers right when user signs up / in for the first time
# adds user to dynamodb
data "aws_lambda_function" "postCognitoTrigger" {
  function_name = "postCognitoTrigger"
}

# triggers after sign up / in loop right before user is sent their JWT
# modifies JWT to include custom roles: "role:..."
data "aws_lambda_function" "preTokenTrigger" {
  function_name = "preTokenTrigger"
}

# #1 requests custom challenge
# #2 checks whether code is wrong or right
data "aws_lambda_function" "defineAuthChallenge" {
  function_name = "defineAuthChallenge"
}

# called by defineAuthChallenge, issues custom challenge
data "aws_lambda_function" "createAuthChallenge" {
  function_name = "createAuthChallenge"
}

# verifies custom challenge
data "aws_lambda_function" "verifyAuthChallenge" {
  function_name = "verifyAuthChallenge"
}

resource "aws_cognito_user_pool" "pool" {
  name = "webportfolios"

  alias_attributes = ["email"]
  deletion_protection = "ACTIVE"

  email_configuration {
    email_sending_account = "DEVELOPER"

    # where to send verify code from
    source_arn = data.aws_sesv2_email_identity.root_domain.arn
    from_email_address = "webportfolios support <support@webportfolios.dev>"

    # tracking rules
    configuration_set = data.aws_sesv2_configuration_set.existing_rules.configuration_set_name
  }
}

resource "aws_cognito_user_pool_client" "pool_client" {
  name = "client"
  user_pool_id = aws_cognito_user_pool.pool.id
      
  supported_identity_providers = ["COGNITO"] # eventually can allow for google etc.

  # apps supported authentication flows
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  # used in every api request in authorization header
  access_token_validity = 1 # hours
  # duration for 6-digit code created for auth flow
  auth_session_validity = 5 # minutes
  # used to refresh access token
  refresh_token_validity = 5 # days
  # token used by frontend, contains basic user profile data
  id_token_validity = 1 # hours

  # prevents api responses that can aid in brute force attacks
  prevent_user_existence_errors = "ENABLED"

  # revoke refresh tokens for a user
  # all access tokens issued by that refresh token are invalidated
  enable_token_revocation = true 

  # not needed unless using cognito managed login pages
  # allowed_oauth_flows_user_pool_client = true
  # allowed_oauth_scopes = ["email", "openid", "profile"]

}
