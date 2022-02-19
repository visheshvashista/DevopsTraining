resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "create-endpoint" {
  provisioner "local-exec" {
    command = "aws --region=${var.aws_region} --secret_key=${secret_key} --access_key=${access_key} ec2 describe-instances"
  }
}