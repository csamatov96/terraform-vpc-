resource "aws_instance" "wordpress" { 
  ami             = var.ami #
  instance_type   = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = aws_key_pair.key_resource.key_name
  security_groups = ["sg"] #refer only by its name not resource name
  user_data = file("userdata_file.sh")

  #terraform side 
  provisioner "local-exec" { 
    command = "wget https://wordpress.org/latest.zip"
  }

  provisioner "file" {
    source      = "/root/terraform-hw/latest.zip"
    destination = "/tmp/latest.zip"

    connection  {
            host = "${self.public_ip}" 
            type = "ssh" 
            user = "${var.user}" 
            private_key = "${file(var.ssh_key_location)}" #use that key, whenever it creates an instance 
    }
  }


}
