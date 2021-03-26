variable "service_name" {
    type = string
    description = "The service name related to our new task."
}

variable "environment" {
    type = string
    description = "An identifier for the target environment (i.e. prod, dev etc.)."
}

variable "container_definitions" {
    
    type = list(object{
        name = string
        image = string
        cpu = number
        memory = number
        portMappings = list(object{
            containerPort = number
            hostPort = number
        })
    })
    
    description = "A list of objects, each of which contain data that constructs the definition for our new task."
    
    default = [
        {
            name = "New ECS Service"
            image = "Our Docker Image"
            cpu = 2
            memory = 4
            portMappings = [
                {
                    containerPort = 80
                    hostPort = 80
                }
            ]
        }
    ]
}