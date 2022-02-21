resource "null_resource" "get-eni-list" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
    environment = {
      AWS_ACCESS_KEY_ID = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
    command = <<-EOT
      aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text | sed -e :a -e '$!N;s/\\n/,/;ta' >  eni_list1.txt
      sed '$d' eni_list1.txt
      cp eni_list1.txt eni_list.txt
      cat eni_list.txt
    EOT    
  }
}

data "local_file" "eni-list" {
  filename = "eni_list.txt"
  depends_on = [null_resource.get-eni-list]
}

/*
data "aws_network_interface" "network-interface" {
       set{
	       var.s3list = ${data.local_file.eni-list.content}
       }
       count = 2
       id = element(
}
*/

resource "null_resource" "test-dig-command" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
	  
    command = <<-EOT
      dig CNAME +short google.com > test.txt
      echo "vishesh" >> test.txt
      cat test.txt
    EOT
}
}


resource "null_resource" "test-dig-command1" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
    command = "tesu =`cat test.txt` | echo $tesu"
}
  depends_on = [null_resource.test-dig-command]
}

data "local_file" "dig-list" {
  filename = "test.txt"
  depends_on = [null_resource.test-dig-command]
  
}
