resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "s3buckets1" {
  provisioner "local-exec" {
    command = "aws ec2 describe-vpc-endpoints --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds  --region=${var.aws_region} --output text >  ${data.template_file.s3buckets.rendered} "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "template_file" "s3buckets1" {
    template = "/tmp/output.log"
}

data "local_file" "s3_bucketlist1" {
    filename = "${data.template_file.s3buckets1.rendered}"
    depends_on = [null_resource.s3buckets]
}

output "S3-Buckets" {
    value = "${data.local_file.s3_bucketlist1.content}"
}