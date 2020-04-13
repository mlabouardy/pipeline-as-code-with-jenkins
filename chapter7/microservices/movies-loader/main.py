import json
import boto3
import os

sqs = boto3.client('sqs', region_name=os.environ['AWS_REGION'])

queue_url = os.environ['SQS_URL']

def sendMovie(movie):
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=(json.dumps(movie)))
    return response['MessageId']

with open('movies.json') as json_file:
    data = json.load(json_file)
    for movie in data:
        print('Name: ' + movie['title'])
        message = sendMovie(movie)
        print('Message ID: ' + message)