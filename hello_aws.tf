# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-west-2"
}


resource "aws_key_pair" "example_key" {
  key_name = "example_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdTbPtVW+RoHP4QZIfS41sl9SML9dHdMjWG/6wePYKDlC+8619nbuHxXbWpZ//1gR5L1vFYkCDSk4Nn0y46pBN+nslsKs/gusKRGwRdyEYvDGsosEzDXA4ZymlAGC0vX5Wbe4YBETqnsb1DV5XZ1il/YSLvSfOgoWN75jWOPSXlJNSoWPYszuDND9dzSNQaImxoLXonVeM38HuG+9fEz6xHhzUt+I1VCaXq+xTLcp3yJ5w8zBLYzqX+p9B2OlKwEWdg11chvFH+O+ImRYGRspJR5akXqv43bK+otUZ0zZqzEjzGsgyVDSYKGjtDdkxTNOxGv1Vrizwu2L/gPeIEcxN"
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
      "echo \"deb https://apt.dockerproject.org/repo ubuntu-xenial main\" | sudo tee /etc/apt/sources.list.d/docker.list",
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

