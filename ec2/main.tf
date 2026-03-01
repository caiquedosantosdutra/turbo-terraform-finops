terraform {
  required_providers {
    turbonomic = {
      source  = "IBM/turbonomic"
      version = "1.7.0"  # versão disponível no registry
    }
  }
}

provider "turbonomic" {
  hostname   = var.hostname
  client_id     = var.client_id
  client_secret = var.client_secret
  role          = var.role

}

variable "hostname" {}
variable "client_id" {}
variable "client_secret" {
  sensitive = true
}
variable "role" {}


data "turbonomic_cloud_entity_recommendation" "example" { 
  entity_name  = "exampleVirtualMachine" // Name of the cloud entity (e.g., a virtual machine) to get recommendations for 
  entity_type  = "VirtualMachine" // Type of the cloud entity (e.g., VirtualMachine, Database, etc.) 
  default_size = "t3.nano" // Default instance size used if no recommendation is available. 
}

resource "aws_instance" "terraform-demo-ec2" { 
  ami           = "ami-079db87dc4c10ac91" // AMI ID used to launch the instance. 
  instance_type = data.turbonomic_cloud_entity_recommendation.example.new_instance_type // Uses the recommended instance type from the Turbonomic data source. 
  subnet_id = "subnet-005ad2b23ed39a428"
  tags = merge( 
    { 
      Name = "exampleVirtualMachine" // Sets the Name tag for easy identification 
    }, 
    provider::turbonomic::get_tag() //tag the resource as optimized by Turbonomic Provider for Terraform 
  ) 
}
# check "turbonomic_consistent_with_recommendation_check"{
#   assert {
#     condition =  aws_instance.terraform-instance-1.instance_type == coalesce(data.turbonomic_cloud_entity_recommendation.example.new_instance_type,aws_instance.terraform-instance-1.instance_type)
#     error_message = "Must use the latest recommended instance type,${coalesce(data.turbonomic_cloud_entity_recommendation.example.new_instance_type,aws_instance.terraform-instance-1.instance_type)}"
#   }
# }