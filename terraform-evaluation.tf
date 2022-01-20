variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "dynamo_table" {
  description = "Dynamo table fo the application."

  type    = string
  default = "terracontact"
}

variable "deployment_bucket" {
  description = "where to deploy the code."

  type    = string
  default = "terraform-evaluation-peterm"
}

provider "aws" {
   region = var.aws_region
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.deployment_bucket

  acl           = "private"
  force_destroy = true
}

data "archive_file" "terraform-evaluation" {
  type = "zip"

  source_dir  = "${path.module}/dist/serverless"
  output_path = "${path.module}/serverless.zip"
}

resource "aws_s3_bucket_object" "terraform-evaluation" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "serverless.zip"
  source = data.archive_file.terraform-evaluation.output_path

  etag = filemd5(data.archive_file.terraform-evaluation.output_path)
}


resource "aws_lambda_function" "myLambda" {
   function_name = "terraform-evaluation"

   s3_bucket = aws_s3_bucket.lambda_bucket.id
   s3_key    = "serverless.zip"
   
   handler = "serverless.handler"
   runtime = "nodejs14.x"

   role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      REGION =var.aws_region,
      DOCUMENTS_TABLE = var.dynamo_table
    }
  }
}

resource "aws_cloudwatch_log_group" "myLambda" {
  name = "/aws/lambda/${aws_lambda_function.myLambda.function_name}"

  retention_in_days = 30
}

 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "lambda_role" {
   name = "role_lambda"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = file("policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "terraAPI"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.proxyMethod.resource_id
   http_method = aws_api_gateway_method.proxyMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.myLambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.myLambda.invoke_arn
}


resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.myLambda.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}

resource "aws_dynamodb_table" "terradynamo" {
  name           = var.dynamo_table
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "contact_id"

  attribute {
    name = "contact_id"
    type = "S"
  }
  
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
    AutoDelete  = "no"
  }
}


output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}
