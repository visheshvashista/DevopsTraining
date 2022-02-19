resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "instances" {
  provisioner "local-exec" {
    command = "aws s3 ls --region=${var.aws_region} "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}