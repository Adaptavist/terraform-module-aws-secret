variable "secret_ssm_path" {
  type = string
}

variable "secret_length" {
  type    = number
  default = 60
}

variable "respect_initial_value" {
  type    = bool
  default = true
}

variable "secret_lambda_function_name" {
  type    = string
  default = "ssm-secret-generator"
}

variable "tags" {
  type = map(string)
}