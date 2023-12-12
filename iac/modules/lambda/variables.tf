variable "runtime" {
  description = "The runtime for the Lambda function [nodejs20.x, go1.x]"
  type        = string
  default     = "node20.x"
}

variable "name" {
  description = "The name of the Lambda function"
  type        = string
  nullable    = false
}

variable "handler" {
  description = "The handler function in your code for he Lambda function"
  type        = string
  default     = "index.handler"
}

variable "environment_variables" {
  description = "The environment variables for this lambda"
  type        = map(string)
  default     = {}
}
