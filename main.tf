data "aws_lambda_function" "secret_generator" {
  function_name = var.secret_lambda_function_name
}

data "aws_region" "current" {}

locals {
  lambda_inputs = {
    path                = var.secret_ssm_path
    respectInitialValue = var.respect_initial_value
    secretLength        = var.secret_length
  }

  lambda_outputs = []

  stageTag = {
    "Avst:Stage:Name" = var.stage
  }

  finalTags = merge(var.tags, local.stageTag)
}

# this is generated at initial resource creation and then not modified afterwards
resource "random_string" "cf_stack" {
  length  = 8
  special = false
}

resource "aws_cloudformation_stack" "execute_lambda" {
  name = "create-secret-${random_string.cf_stack.result}-execution-stack${var.name_suffix}"

  timeout_in_minutes = "3"
  template_body = <<EOF
{
  "AWSTemplateFormatVersion" : "2010-09-09",
  "Description" : "Execute a Lambda which may populate a SSM parameter with a generated secret",
  "Resources" : {
    "GeneratePassword" : {
      "Type": "AWS::CloudFormation::CustomResource",
      "Version" : "1.0",
      "Properties" :
        ${jsonencode(merge(tomap(
  {
    ServiceToken = data.aws_lambda_function.secret_generator.arn
  }
), local.lambda_inputs))}
    }
  },
  "Outputs": {
    ${join(",", formatlist("\"%s\":{\"Value\": {\"Fn::GetAtt\":[\"ExecuteLambda\", \"%s\"]}}", local.lambda_outputs, local.lambda_outputs))}
  }
}
EOF
tags = local.finalTags
}
