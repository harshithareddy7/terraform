provider "aws" {
  region = "us-east-2"
}

data "aws_iam_policy_document" "assume_role"{
    statement{
        effect="Allow"

        principals{
            type="Service"
            identifiers=["lambda.amazonaws.com"]
        }
        actions=["sts:AssumeRole"]

    }
}

resource "aws_iam_role" "lambda_execution_role"{
    name="lambda_exec_role"
    assume_role_policy=data.aws_iam_policy_document.assume_role.json

}

#Package the Lambda function code

data "archive_file" "lambda_zip"{

    type="zip"
    source_file="${path.module}/lambda/index.py"
    output_path="${path.module}/lambda/index.zip"
}

#Lambda function

resource "aws_lambda_function" "first_lambda"{
    filename= data.archive_file.lambda_zip.output_path
    function_name="example_first_lambda"
    role=aws_iam_role.lambda_execution_role.arn
    handler="index.lambda_handler"
    source_code_hash=data.archive_file.lambda_zip.output_base64sha256

    runtime="python3.13"

    environment{
        variables={
            ENVIRONMENT="production"
        }
    }

}

#Creating REST API 
resource "aws_api_gateway_rest_api" "lambda_api"{
    name="LambdaAPIGateway"
    description="API Gateway to trigger Lambda"
}

# Define resource (e.g., /trigger)
resource "aws_api_gateway_resource" "trigger_resource"{
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id
    parent_id = aws_api_gateway_rest_api.lambda_api.root_resource_id
    path_part = "trigger"
}

# Define method (e.g., GET)
resource "aws_api_gateway_method" "trigger_method"{
    rest_api_id=aws_api_gateway_rest_api.lambda_api.id
    resource_id=aws_api_gateway_resource.trigger_resource.id
    http_method="GET"
    authorization="NONE"
}

# Integration with Lambda
resource "aws_api_gateway_integration" "lambda_integration"{
    rest_api_id=aws_api_gateway_rest_api.lambda_api.id
    resource_id=aws_api_gateway_resource.trigger_resource.id
    http_method=aws_api_gateway_method.trigger_method.http_method

    integration_http_method="POST"
    type="AWS_PROXY"
    uri=aws_lambda_function.first_lambda.invoke_arn
}

# Lambda permission to allow API Gateway
resource "aws_lambda_permission" "allow_apigw"{
    statement_id="AllowExecutionFromAPIGateway"
    action="lambda:InvokeFunction"
    function_name=aws_lambda_function.first_lambda.function_name
    principal="apigateway.amazonaws.com"

    source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.lambda_api.id}/*/${aws_api_gateway_method.trigger_method.http_method}${aws_api_gateway_resource.trigger_resource.path}"
}

#Deploying API Gateway
resource "aws_api_gateway_deployment" "api_deployment"{

    depends_on=[aws_api_gateway_integration.lambda_integration]
    rest_api_id=aws_api_gateway_rest_api.lambda_api.id
}

#Stage
resource "aws_api_gateway_stage" "api_stage"{
    deployment_id=aws_api_gateway_deployment.api_deployment.id
    rest_api_id=aws_api_gateway_rest_api.lambda_api.id
    stage_name="lambda_test"
}
