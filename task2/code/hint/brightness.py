import json
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


"""
    This serverless function returns the current brightness
"""
def brightness(event, context):
    body = {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "input": event
    }

    logger.info("Hello from somewhere in the cloud! This is the API /brightness")

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response

