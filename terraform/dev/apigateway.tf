resource "aws_api_gateway_rest_api" "taskfeed-rest-api" {
  name = "taskfeed-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
