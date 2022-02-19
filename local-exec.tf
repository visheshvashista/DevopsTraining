resource "null_resource" "testEcho" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "tilakbuckets" {
  provisioner "local-exec" {
    command = "aws s3 ls --region=${var.aws_region} >  ${data.template_file.tilakbuckets.rendered} "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "template_file" "tilakbuckets" {
    template = "/tmp/output.log"
}

data "local_file" "tilak_bucketlist" {
    filename = "${data.template_file.tilakbuckets.rendered}"
    depends_on = ["null_resource.tilakbuckets"]
}

output "S3-Buckets" {
    value = "${data.local_file.tilak_bucketlist.content}"
}
