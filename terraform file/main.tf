
resource "aws_instance" "test-server" {
  ami                 = "ami-0e86e20dae9224db8"
  instance_type       = "t2.micro"
  key_name            = "k8S"
  vpc_security_group_ids = ["sg-0b2f60d0cb7032a9a"]

  tags = {
    Name = "test-server"
  }

  # Use the connection block only if you need to use remote-exec provisioner
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./k8S.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start instance'"]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/pipeline project/terraform file/ansible-playbook.yml"
  }
}
