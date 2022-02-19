resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "s3buckets" {
  provisioner "local-exec" {
    command = "aws s3 ls --region=${var.aws_region} >  ${data.template_file.s3buckets.rendered} "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "template_file" "s3buckets" {
    template = "/output.log"
}

data "local_file" "s3_bucketlist" {
    filename = "${data.template_file.s3buckets.rendered}"
    depends_on = ["null_resource.s3buckets"]
}

output "S3-Buckets" {
    value = "${data.local_file.s3_bucketlist.content}"
}