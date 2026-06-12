# ses was configured through web console previously
# data blocks are only used to reference it

# configuration set
data "aws_sesv2_configuration_set" "existing_rules" {
  configuration_set_name = "my-first-configuration-set"
}

# domain
data "aws_sesv2_email_identity" "root_domain" {
  email_identity = "webportfolios.dev"
}

# support email
data "aws_sesv2_email_identity" "support_email" {
  email_identity = "support@webportfolios.dev"
}

# newsletter email
data "aws_sesv2_email_identity" "newsletter_email" {
  email_identity = "newsletter@webportfolios.dev"
}
