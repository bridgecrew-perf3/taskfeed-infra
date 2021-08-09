resource "aws_api_gateway_rest_api" "taskfeed_rest_api" {
  name           = "taskfeed-rest-api"
  description    = "REST API for TaskFeed app."
  api_key_source = "HEADER"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  # Need to implement tagging
  #tags = {}
}

## MODELS
resource "aws_api_gateway_model" "task" {
  rest_api_id  = aws_api_gateway_rest_api.taskfeed_rest_api.id
  name         = "Task"
  description  = "A JSON schema of a single task."
  content_type = "application/json"
  schema       = file("${path.module}/files/task_model.json")
}

resource "aws_api_gateway_model" "tasks" {
  rest_api_id  = aws_api_gateway_rest_api.taskfeed_rest_api.id
  name         = "Tasks"
  description  = "A JSON schema of an array of tasks."
  content_type = "application/json"
  schema       = templatefile("${path.module}/files/tasks_model.json.tmpl", { api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id })
}

resource "aws_api_gateway_model" "user" {
  rest_api_id  = aws_api_gateway_rest_api.taskfeed_rest_api.id
  name         = "User"
  description  = "A JSON schema of a single user."
  content_type = "application/json"
  schema       = file("${path.module}/files/user_model.json")

}

## RESOURCE /TASKS
resource "aws_api_gateway_resource" "tasks" {
  # https://{domain}/tasks
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  parent_id   = aws_api_gateway_rest_api.taskfeed_rest_api.root_resource_id
  path_part   = "tasks"
}

resource "aws_api_gateway_method" "get_tasks_all" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "GET"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "get_tasks_all" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks.id
  http_method = aws_api_gateway_method.get_tasks_all.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "add_task" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "POST"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "add_task" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks.id
  http_method = aws_api_gateway_method.add_task.http_method
  type        = "MOCK"
}

## RESOURCE /TASKS/{OWNER}
resource "aws_api_gateway_resource" "tasks_owner" {
  # https://{domain}/tasks/{owner}
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  parent_id   = aws_api_gateway_resource.tasks.id
  path_part   = "{owner}"
}

resource "aws_api_gateway_method" "get_tasks_owner" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks_owner.id
  http_method   = "GET"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "get_tasks_owner" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks_owner.id
  http_method = aws_api_gateway_method.get_tasks_owner.http_method
  type        = "MOCK"
}

## RESOURCE /TASKS/{OWNER}/{ID}
resource "aws_api_gateway_resource" "tasks_owner_id" {
  # https://{domain}/tasks/{owner}/{id}
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  parent_id   = aws_api_gateway_resource.tasks_owner.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_tasks_id" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks_owner_id.id
  http_method   = "GET"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "get_tasks_id" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks_owner_id.id
  http_method = aws_api_gateway_method.get_tasks_id.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "delete_tasks_id" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks_owner_id.id
  http_method   = "DELETE"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "delete_tasks_id" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks_owner_id.id
  http_method = aws_api_gateway_method.delete_tasks_id.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "update_tasks_id" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.tasks_owner_id.id
  http_method   = "PUT"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "update_tasks_id" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.tasks_owner_id.id
  http_method = aws_api_gateway_method.update_tasks_id.http_method
  type        = "MOCK"
}

## RESOURCE /{username}
resource "aws_api_gateway_resource" "users" {
  # https://{domain}/{username}
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  parent_id   = aws_api_gateway_rest_api.taskfeed_rest_api.root_resource_id
  path_part   = "{username}"
}

resource "aws_api_gateway_method" "get_user" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.get_user.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "delete_user" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "DELETE"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "delete_user" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.delete_user.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "add_user" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "add_user" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.add_user.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method" "update_user" {
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "PUT"
  authorization = "NONE" #temp measure
}

resource "aws_api_gateway_integration" "update_user" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.update_user.http_method
  type        = "MOCK"
}

## API DEPLOYMENT
resource "aws_api_gateway_deployment" "taskfeed_deployment_dev" {
  rest_api_id = aws_api_gateway_rest_api.taskfeed_rest_api.id
  description = "TaskFeed API Gateway deployment for DEV"
}

resource "aws_api_gateway_stage" "taskfeed_dev" {
  deployment_id = aws_api_gateway_deployment.taskfeed_deployment_dev.id
  rest_api_id   = aws_api_gateway_rest_api.taskfeed_rest_api.id
  stage_name    = "DEV"
}
