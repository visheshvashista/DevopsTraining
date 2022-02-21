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
      aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text | sed -e :a -e '$!N;s/\\n/,/;ta' >  eni_list.txt
      EOT    
  }
}

resource "null_resource" "hostinfo" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
    command = <<-EOT
      hostname
      uname -a
      which dig
      echo `dig hostinger.com +short`
      EOT    
  }
}

data "local_file" "eni-list" {
  filename = "eni_list.txt"
  depends_on = [null_resource.get-eni-list]
}

data "aws_network_interface" "network-interface" {
       for_each = toset(["eni-0a607e806a7139954","eni-05a6bf74e8dcba4ce"])
       id = each.key
}

resource "null_resource" "test-dig-command" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
	  
    command = <<-EOT
      echo `dig hostinger.com +short` > test.txt
      cat test.txt
    EOT
}
}

data "local_file" "dig-list" {
  filename = "test.txt"
  depends_on = [null_resource.test-dig-command]  
}
