# triggers upon right before first sign up
# auto-verifies users email, allowing user to sign in via email code
data "aws_lambda_function" "preSignUpTrigger" {
  function_name = "preSignUpTrigger"
  qualifier = "production"
}

# triggers right when user signs up / in for the first time
# adds user to dynamodb
data "aws_lambda_function" "postCognitoTrigger" {
  function_name = "postCognitoTrigger"
  qualifier = "production"
}

# triggers after sign up / in loop right before user is sent their JWT
# modifies JWT to include custom roles: "role:..."
data "aws_lambda_function" "preTokenTrigger" {
  function_name = "preTokenTrigger"
  qualifier = "production"
}

# #1 requests custom challenge
# #2 checks whether code is wrong or right
data "aws_lambda_function" "defineAuthChallenge" {
  function_name = "defineAuthChallenge"
  qualifier = "production"
}

# called by defineAuthChallenge, issues custom challenge
data "aws_lambda_function" "createAuthChallenge" {
  function_name = "createAuthChallenge"
  qualifier = "production"
}

# verifies custom challenge
data "aws_lambda_function" "verifyAuthChallenge" {
  function_name = "verifyAuthChallenge"
  qualifier = "production"
}

resource "aws_cognito_user_pool" "pool" {
  name = "webportfolios"

  alias_attributes = ["email"]
  deletion_protection = "ACTIVE"

  email_configuration {
    email_sending_account = "DEVELOPER"

    # where to send verify code from
    source_arn = aws_sesv2_email_identity.domain.arn
    from_email_address = "webportfolios support <support@webportfolios.dev>"

    # tracking rules
    configuration_set = aws_sesv2_configuration_set.existing_rules.configuration_set_name
  }
}
