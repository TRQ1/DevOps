# How to configure multicontainer Docker deployment by using AWS.

# Requirement
- GitHub: use it as the repository for my source code.
- AWS CodeBuild:   use it for creating the Docker image, pushing it to AWS ECR and other build steps.
- AWS ECR: use it as the repository for my docker images. Remember that, for configuring AWS Elastic Beanstalk, we need to define our images in our Dockerrun.aws.json file.
- AWS CodeDeploy: Codepipeline uses it to deploy to AWS ElasticBeanstalk.
- Amazon ECS: AWS Elastic Beanstalk uses Amazon ECS to run the docker service for multicontainer deployments.
- AWS CodePipeline: use it to automate the deployment steps.
- AWS Lambda:

# Will add
- Cloudformation

# Do now
- Build a Docker container with jenkins by using Packer
- Provision the images to Google Compute Engine by using Terraform

