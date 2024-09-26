provider "aws" {
  region = "us-west-2"  # Specify the AWS region
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI ID for Amazon Linux 2
  instance_type = "t2.micro"               # Instance type

  key_name = aws_key_pair.my_key.key_name  # Reference the key pair

  tags = {
    Name = "MyTerraformInstance"            # Tag the instance
  }

  # Security group to allow SSH access
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_security_group" "my_security_group" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22            # Allow SSH on port 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs (for demo purposes; use caution)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}
