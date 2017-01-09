# Hello AWS

This is meant as a sample start-up for AWS cloud hosted web stuffs. This will run a simple Sinatra application run inside a Docker container and be deployed to an EC2 instance with a Security Group blocking all ports except 22 and 80 using Terraform.


## How to run things

### Sinatra application

This is just a simple Sinatra app running on Puma. To run the app locally...

    ./run.sh

### Docker

To build and publish the Docker image...

    docker build -t caspian311/hello_aws .
    docker login
    docker push caspian311/hello_aws
    
To run the Docker image...

    docker run -d --name hello_aws -p 80:4444 caspian311/hello_aws

###Terraform

You will need to create a secrets.tfvars file to all the things you don't want checked into your SCM. This file will be added to the .gitignore file and should contain the following keys: `access_key`, `secret_key` and `public_key`

To create the public_key, use the private given for the IAM account...

    ssh-keygen -y -f mykey.pem

Then take the output of that command and put it as the value for the `public_key` in the `secrets.tfvars` file.

To see if terraform is setup correctly...

    terraform plan -var-file=secrets.tfvars

To create the EC2 instances...

    terraform apply -var-file=secrets.tfvars

To remove all EC2 instances...

    terraform destroy


