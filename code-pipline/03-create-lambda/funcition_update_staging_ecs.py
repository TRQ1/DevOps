import boto3

client = boto3.client('ecs')
cluster_value = 'base-meteor-cluster'
service_name = 'base-meteor'
task_definition = 'demoproject-01'

def get_list_tasks():
    list_response = client.list_tasks(
        cluster=cluster_value
    )
    return print(list_response['taskDefinitionArn'])

def get_list_services():
    list_service_response = client.list_services(
        cluster=cluster_value
    )
    return list_service_response

def stop_tasks():
    if get_list_tasks().lenght == 0:
        stop_response = client.stop_task(
            cluster=cluster_value,
            task=get_list_tasks()
        )
    return stop_response

def reginster_task_definition():
    get_task_definition_response = client.describe_task_definition(
        taskDefinition=task_definition
    )
    regiseter_task_definition_response = client.register_task_definition(
        family=get_task_definition_response['taskDefinition']['family'],
        containerDefinitions=[
        {
            "name": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['name'],
            "image": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['image'],
            "cpu": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['cpu'],
            "memoryReservation": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['memoryReservation'],
            "essential": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['essential'],
            "portMappings": [
                {
                    "hostPort": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['portMappings'][0]['hostPort'],
                    "containerPort": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['portMappings'][0]['containerPort'],
                    "protocol": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['portMappings'][0]['hostPort']['protocol']
                }
            ],
            "environment": [
                {
                    "name": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['environment'][1]['name'],
                    "value": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['environment'][1]['value']
                },
                {
                    "name": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['environment'][0]['name'],
                    "value": get_task_definition_response['taskDefinition']['containerDefinitions'][0]['environment'][0]['value']
                }
            ],
            "links": [
                get_task_definition_response['taskDefinition']['containerDefinitions'][0]['links']
            ]
        },
        {
            "name": get_task_definition_response['taskDefinition']['containerDefinitions'][1]['name'],
            "image": get_task_definition_response['taskDefinition']['containerDefinitions'][1]['image'],
            "cpu": get_task_definition_response['taskDefinition']['containerDefinitions'][1]['cpu'],
            "memoryReservation": get_task_definition_response['taskDefinition']['containerDefinitions'][1]['memoryReservation'],
            "essential": get_task_definition_response['taskDefinition']['containerDefinitions'][1]['essential']
        }
    ]
    )
    return regiseter_task_definition_response

def update_service():
    update_service_response = client.update_service(
        cluster=cluster_value,
        service=service_name,
        desiredCount=1,
        taskDefinition=task_definition
    )
    return update_service_response


if __name__ == '__main__':
    stop_tasks()
    reginster_task_definition()
    update_service()
