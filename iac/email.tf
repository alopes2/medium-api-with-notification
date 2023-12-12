# The email here will receive a verification email
# To set it as verified in SES
resource "aws_ses_email_identity" "email_identity" {
  email = var.email_identity
}

# Rules to monitor your SES email sending activity, you can create configuration sets and output them in Terraform.
# Event destinations
# IP pool managemen
resource "aws_ses_configuration_set" "configuration_set" {
  name = "movies-configuration-set"
}
