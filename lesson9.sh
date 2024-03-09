#!/bin/bash

# Step 1: Create DynamoDB Table
echo "Creating DynamoDB table..."
aws dynamodb create-table \
    --table-name MyTable \
    --attribute-definitions \
        AttributeName=ID,AttributeType=N \
    --key-schema \
        AttributeName=ID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-1

# Step 2: Create Simple Lambda Function
echo "Creating Lambda function..."
echo '
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }
' > lambda_function.py

lambda_arn=$(aws lambda create-function \
    --function-name HelloWorldFunction \
    --runtime python3.8 \
    --role arn:aws:iam::730335231758:policy/service-role/AWSLambdaBasicExecutionRole-8fc4972d-5958-4c7a-8fdf-53d7c64d662d \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda_function.py \
    --query 'FunctionArn' \
    --output text \
    --region us-east-1)

# Step 3: Create API Gateway (REST API)
echo "Creating API Gateway..."
rest_api_id=$(aws apigateway create-rest-api \
    --name MyTESTAPI \
    --query 'id' \
    --output text \
    --region us-east-1)

# Step 4: Integrate API Gateway with Lambda
echo "Integrating API Gateway with Lambda..."
resource_id=$(aws apigateway create-resource \
    --rest-api-id $rest_api_id \
    --parent-id "PARTENT_RESOURCE_ID" \
    --path-part "hello" \
    --query 'id' \
    --output text \
    --region us-east-1)

aws apigateway put-method \
    --rest-api-id $rest_api_id \
    --resource-id $resource_id \
    --http-method GET \
    --authorization-type "NONE" \
    --region us-east-1

aws apigateway put-integration \
    --rest-api-id $rest_api_id \
    --resource-id $resource_id \
    --http-method GET \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/$lambda_arn/invocations" \
    --region us-east-1

echo "Deploying API Gateway..."
aws apigateway create-deployment \
    --rest-api-id $rest_api_id \
    --stage-name dev \
    --region us-east-1

echo "Done."