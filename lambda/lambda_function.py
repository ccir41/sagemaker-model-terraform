import os
import json
import boto3
from http import HTTPStatus
from aws_lambda_powertools.event_handler import (
    APIGatewayRestResolver,
    CORSConfig,
    Response,
    content_types
)
from aws_lambda_powertools.utilities.typing import LambdaContext

cors_config = CORSConfig()
app = APIGatewayRestResolver(cors=cors_config)

ENDPOINT_NAME = os.environ.get('ENDPOINT_NAME')

runtime= boto3.client('runtime.sagemaker')

def process_record(record):
    max_sentiment = max(record, key=lambda x: x["score"])
    max_sentiment["label"] = max_sentiment["label"].upper()
    max_sentiment["score"] = round(max_sentiment["score"], 2)
    return max_sentiment


@app.post("/sentiment")
def get_sentiment():
    data = app.current_event.json_body
    text = data.get("text")

    if not data or not text:
        return Response(
            status_code=HTTPStatus.BAD_REQUEST.value,
            content_type=content_types.APPLICATION_JSON,
            body=json.dumps(
                {
                    "message": "Field text is required!"
                }
            )
        )
    try:
        response = runtime.invoke_endpoint(
            EndpointName=ENDPOINT_NAME,
            ContentType='application/json',
            Body=json.dumps(text)
        )

        result = json.loads(response['Body'].read().decode())
        new_response = list(map(process_record, result))
        
        return Response(
            status_code=HTTPStatus.OK.value,
            content_type=content_types.APPLICATION_JSON,
            body=json.dumps(
                {
                    "data": new_response
                }
            )
        )
    except:
        return Response(
            status_code=HTTPStatus.BAD_REQUEST.value,
            content_type=content_types.APPLICATION_JSON,
            body=json.dumps(
                {
                    "message": "Model error, may be context length for text exceeds 512 tokens!"
                }
            )
        )

def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)