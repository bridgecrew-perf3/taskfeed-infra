resource "aws_api_gateway_rest_api" "this" {
  name           = var.name
  description    = var.description
  api_key_source = var.api_key_source

  body = var.openapi_spec
  endpoint_configuration {
    types = [var.api_endpoint_config_type]
  }

  tags = var.tags
}

## API DEPLOYMENT
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    # Should redeploy everytime something changes(?)
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage
}
