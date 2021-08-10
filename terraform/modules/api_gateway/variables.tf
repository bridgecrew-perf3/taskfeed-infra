variable "api_name" {
  type        = string
  description = "Name of the API."
}

variable "api_description" {
  type        = string
  description = "Description of the API."
}

variable "api_key_source" {
  default     = "HEADER"
  type        = string
  description = "Source of the API key for requests."
}

variable "api_openapi_spec" {
  type        = string
  description = "Path to the OpenAPI specification file."
}

variable "api_endpoint_config_type" {
  default     = "REGIONAL"
  type        = string
  description = "API Gateway endpoint."
}

variable "api_tags" {
  default     = {}
  type        = map(string)
  description = "Tags for the API."
}

variable "api_stage" {
  type        = string
  description = "Stage to deploy API in."
}
