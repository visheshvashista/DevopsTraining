resource "null_resource" "testEcho" {

   provisioner "local-exec" {
          command = "echo  'vishesh'"
	}
}

resource "null_resource" "get-eni-list" {
  provisioner "local-exec" {
    command = "aws ec2 describe-vpc-endpoints --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --region=${var.aws_region} >  eni_list.txt"
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

data "local_file" "eni-list" {
  filename = "eni_list.txt"
  depends_on = [null_resource.get-eni-list]
}

data "aws_network_interface" "network-interface" {
  id = "${data.local_file.eni-list.content}"
}
