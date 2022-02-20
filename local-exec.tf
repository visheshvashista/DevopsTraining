resource "null_resource" "testEcho" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "get_bucket_names" {
  provisioner "local-exec" {
    command = "aws s3 ls --region=${var.aws_region} >  s3_list.txt"
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "local_file" "s3-list" {
  filename = "s3_list.txt"
  depends_on = [null_resource.get_bucket_names]
}

resource "null_resource" "set-variable" {
  provisioner "local-exec" {
    command = "echo 'test'"
  set {
    name = "s3list"
    value = "http://${data.local_file.s3-list.content}"
   }
    
  }
}

