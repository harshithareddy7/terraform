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