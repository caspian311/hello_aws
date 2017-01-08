# Hello AWS

This is meant as a sample start-up for AWS cloud hosted web stuffs. This will run a simple Sinatra application run inside a Docker container and be deployed to an EC2 instance with a Security Group blocking all ports except 22 and 80 using Terraform.



### How to run things

To run the app locally...

    ./run.sh

To build the Docker image...

    docker build .

To create the EC2 instance...

    terraform apply

