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
     # aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text | sed -e :a -e '$!N;s/\n/,/;ta' >  eni_list_sourav.txt
      aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text >  eni_list_sourav.txt
      aws ec2 describe-vpc-endpoints --region=${var.aws_region} --filters Name=tag:Name,Values=test-ep --query VpcEndpoints[*].NetworkInterfaceIds --output text >  eni_list.txt
      k=0
      delimiter=","
      out1="["
      for i in  `cat eni_list.txt | sed '/^$/d'`
      do
	      if [ $k -eq 0 ]
	      then
		out1=$out1$i
	      else
		out1=$out1$delimiter$i
	      fi
	      k=`expr $k + 1`
      done
      out1=$out1"]"
      echo $out1 > eni_list_sourav.txt  
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

data "local_file" "eni-list" {
  filename = "eni_list_sourav.txt"
  depends_on = [null_resource.get-eni-list]
}

data "aws_network_interface" "network-interface" {
      count = 2
      id = element(${data.local_file.eni-list.content},0)
}


/*	
data "aws_network_interface" "network-interface" {
      for_each = toset(["${data.local_file.eni-list.content}"])
      id = each.key
}

data "aws_network_interface" "network-interface" {
  id = "${data.local_file.eni-list.content}"
}
*/
	
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
