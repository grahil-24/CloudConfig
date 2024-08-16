provider "aws" {
	profile="default"
	region="ap-south-1"
		
}

#provisioning ec2 instance
resource "aws_instance" "webserver" {
	ami = "ami-0a4408457f9a03be3"
	instance_type = "t2.micro"


	tags = {
		name = "Web Server"
	}

	key_name = "ec2"
	vpc_security_group_ids = [aws_security_group.allow_http_https.id]
}

#provisioning security group for ec2 instance
resource "aws_security_group" "allow_http_https" {
	
	name = "allow_http_https"
	description = "allow ssh, http and https inbound traffic"

	#inbound rules
	#ssh access
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	#HTTP access
	ingress {
		from_port=80
		to_port=80
		protocol="tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	#HTTPS access
	ingress {
                from_port=443
                to_port=443
                protocol="tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

	#outbound rules
	#allow everything
	egress{
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#provision an elastic ip to the ec2 instance
resource "aws_eip_association" "webserver_eip" {
	instance_id = aws_instance.webserver.id
	allocation_id = "eipalloc-0472d6cc2118bac17"
}

output "instance_ip"{
	value=aws_instance.webserver.public_ip
}
