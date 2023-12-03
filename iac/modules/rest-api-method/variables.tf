variable "http_method" {
  description = "The HTTP method"
  type        = string
}

variable "resource_id" {
  description = "The ID of the resource this method is attached to"
  type        = string
}

variable "api_id" {
  description = "The ID of the API this method is attached to"
  type        = string
}

variable "integration_uri" {
  description = "The URI of the integration this method will call"
  type        = string
}

variable "resource_path" {
  description = "The path of the resource"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function that will be called"
  type        = string
}

variable "account_id" {
  description = "The AWS Account ID for the resource"
  type        = string
}
