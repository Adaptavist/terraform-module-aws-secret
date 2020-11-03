# Secrets module

This module needs to be used in conjunction with [pipe-secret-generator](https://bitbucket.org/adaptavistlabs/pipe-secret-generator/src/master/).
This module wraps a CloudFomation stack which calls a common secret generation Lambda (created by pipe-secret-generator). Because SSM parameters and secrets within the Secrets manager do not allow you to create secrets with initial values we must populate them using a Lambda. Because the secret has been populated using a Lambda there is minimal chance of leakage.

## Variables

| Name                        | Description                                                                                     |
| --------------------------- | ----------------------------------------------------------------------------------------------- |
| secret_name                 | The name of the secret which will get populated                                                 |
| secret_lambda_function_name | The name of the function to call which will populate the secret with a value. This is optional. |
| secret_length | The length of the secret that should be generated. |
| respect_initial_value | If 'true', the secret will be added to the stack but its value will not be replaced with a generated value. This is useful for existing secrets that require importing ito IaC whose value needs to remain. Once imported, if the value needs to be changed to generated value at a later date the resource should have a terraform taint applied then a terraform apply. The secret will get replaced with a generated value. |
