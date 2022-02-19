resource "null_resource" "testEcho" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "tilakbuckets" {
  provisioner "local-exec" {
    command = "aws s3 ls --region=${var.aws_region} >  output.log "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "external" "get_S3_list_using_shell" {
  program = ["bash","scripts/cats3output.sh"]
  depends_on= ["null_resource.tilakbuckets"]
}

output "S3-Buckets" {
  value = data.external.get_S3_list_using_shell.result.bucket_name
}
}
