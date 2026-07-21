import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor-counter')
def lambda_handler(event, context):
    response = table.get_item(Key={'id': 'visitors'})
    current_count = response.get('Item',{}).get('count',0)
    new_count = int(current_count + 1)

    table.put_item(Item={'id': 'visitors', 'count': new_count})
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type':'application/json'
        },
        'body': json.dumps({'count':new_count})
    }