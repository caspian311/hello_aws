variable "access_key" {}
variable "secret_key" {}
variable "public_key" {}

# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-west-2"
}

# create key pair
resource "aws_key_pair" "example_key" {
  key_name = "example_key"
  public_key = "${var.public_key}"
}

# create server
resource "aws_instance" "example" {
  ami           = "ami-b7a114d7"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.example_key.key_name}"
  security_groups = [ "web_and_ssh" ]


  # install docker
  provisioner "remote-exec" "docker_install" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' | sudo tee /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install -y linux-image-extra-$(uname -r)",
      "sudo apt-get install -y linux-image-extra-virtual",
      "sudo apt-get install -y docker-engine"
    ]
  }

  # start docker
  provisioner "remote-exec" "start_docker" {
    inline = [
      "sudo service docker start",
      "sudo docker pull caspian311/hello_aws",
      "sudo docker run -d --name hello_aws -p 80:4444 caspian311/hello_aws",
    ]
  }
}

