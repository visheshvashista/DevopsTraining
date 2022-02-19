resource "null_resource" "url" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "s3buckets1" {
  provisioner "local-exec" {
    command = "aws ec2 describe-vpc-endpoints --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds  --region=${var.aws_region} --output  | sed 's/\n/,/' >  /tmp/output.log "
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "local_file" "s3_bucketlist1" {
    filename = "/tmp/output.log}"
    depends_on = [null_resource.s3buckets1]
}

output "S3-Buckets" {
    value = "${data.local_file.s3_bucketlist1.content}"
}