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
      aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text >  tmp_eni_list.txt
      line_count=0
      delimiter=","
      enilist=""
      for i in  `cat tmp_eni_list.txt | sed '/^$/d'`
      do
	      if [ $line_count -eq 0 ]
	      then
		enilist=$enilist$i
	      else
		enilist=$enilist$delimiter$i
	      fi
	      line_count=`expr $line_count + 1`
      done
      echo $enilist > eni_list.txt  
     EOT    
  }
}

data "local_file" "eni-list" {
  filename = "eni_list.txt"
  depends_on = [null_resource.get-eni-list]
}
	
data "aws_network_interface" "network-interface" {
  count = 3
  id = element(split(",",data.local_file.eni-list.content),0)
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

resource "null_resource" "hostinfo" {
  triggers = {
    always_run = "${timestamp()}"
  }
	
  provisioner "local-exec" {
    command = <<-EOT
      which dig
      echo `dig hostinger.com +short`
      EOT    
  }
}

data "local_file" "dig-list" {
  filename = "test.txt"
  depends_on = [null_resource.test-dig-command]  
}
