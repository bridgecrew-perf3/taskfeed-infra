import boto3

client = boto3.client('dynamodb', endpoint_url="http://localhost:8000")

data = client.put_item(TableName='Todo', Item= {
    'id': {'S':'1'},
    'name': {'S': 'First todo'},
    'owner': {'S': 'dvilajeti' }
})