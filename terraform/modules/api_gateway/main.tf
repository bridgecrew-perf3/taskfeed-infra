resource "aws_api_gateway_rest_api" "this" {
  name           = var.api_name
  description    = var.api_description
  api_key_source = var.api_key_source

  body = file(var.api_openapi_spec)
  endpoint_configuration {
    types = [var.api_endpoint_config_type]
  }

  tags = var.api_tags
}

## API DEPLOYMENT
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.id))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_stage
}
