# Working Deployment Notes

Steps for deploying a basic Rails project using AWS Fargate

<ul>
  <li><a href='#dockerize-the-project'>Dockerize the project</a></li>
  <li><a href='#create-an-ecr-repo'>Create an Amazon ECR Repository</a></li>
  <li><a href='#push-the-image'>Push the Docker image to Amazon ECR</a></li>
  <li><a href='#create-task-definition'>Create a Task Definition</a></li>
  <li><a href='#create-a-cluster'>Create a Cluster</a></li>
  <li><a href='#create-a-service'>Create a Service</a></li>
  <li><a href='#create-a-task'>Create a Task</a></li>
<ul>

<a id='dockerize-the-project'></a>
## Dockerize the project

Update the [Dockerfile](https://github.com/unboxed/retrofit/blob/main/Dockerfile).

Run
```
docker build . -t retrofit
docker run -p 3000:3000 retrofit
```

Check it's up and running at `http://localhost:3000`.

<a id='create-an-ecr-repo'></a>
## Create an Amazon ECR Repository

In the AWS console go to [ECR Private Repositories](https://console.aws.amazon.com/ecr/private-registry/repositories), click 'Create Repository' to create a new private repository.

(See [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html))

<a id='push-the-image'></a>
## Push the Docker image to Amazon ECR

### Authenticate your Docker client to the ECR registry

`aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com`

### Tag the Docker image with the ECR repository URI

Run `docker images` to get the image id.

Get the ECR repository URI from [the AWC ECR console](https://console.aws.amazon.com/ecr/private-registry/repositories).

Tag the docker image: 

`docker tag <image_id> <repository_uri>:<optional_tag>`

### Push the Docker image

`docker push <repository_uri>:<optional_tag>`

(See [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html))

<a id='create-task-definition'></a>
## Create a Task Definition

- In the AWS Console go to [ECS Task Definitions](https://console.aws.amazon.com/ecs/v2/task-definitions) and click 'Create a new task definition'.
- Under 'Launch Type' check 'AWS Fargate'.
- Set desired CPU and Memory.
- Under 'Container', enter a container name and your ECR repository URI.
- Click 'Create'

<a id='create-a-cluster'></a>
## Create a Cluster

- In the AWS Console go to [ECS Clusters](https://console.aws.amazon.com/ecs/v2/clusters) and click 'Create cluster'.
- Under 'Infrastructure' check 'AWS Fargate (serverless)'
- Click 'Create'

<a id='create-a-service'></a>
## Create a Service

In [ECS Clusters](https://console.aws.amazon.com/ecs/v2/clusters) click on your cluster name.

- In the 'Services' tab click 'Create'.
- Under 'Networking' select default VPC.
- Under 'Subnets' select one of the default subnets.
- Click 'Create'. 

<a id='create-a-task'></a>
## Create a Task

- Go back to your cluster ([ECS Clusters](https://console.aws.amazon.com/ecs/v2/clusters) and click on your cluster name.)
- In the 'Tasks' tab click 'Run new task'.

TBC!


## Glossary

- <strong>Cluster</strong> is a logical way to group services and task definition.

- <strong>Services</strong> are used to run load balancers in front of group of tasks. This is also where you specify how many instances of task should be running.

- <strong>Tasks</strong> are the running instances of a task definition.


## Resources

[Useful blog post on deploying with Fargate](https://allenchun.medium.com/deploy-rails-app-image-in-serverless-way-using-aws-fargate-aa79369e9196)

