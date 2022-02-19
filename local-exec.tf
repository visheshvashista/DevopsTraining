resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "create-endpoint" {
  provisioner "local-exec" {
    command = "aws ec2 describe-instances --region=${var.aws_region} "
     environment = {
	secret_key=${var.secret_key} 
	access_key=${var.access_key}
    }
  }
}