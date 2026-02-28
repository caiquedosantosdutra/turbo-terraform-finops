provider "aws" { 
  region = "us-east-1" // Specifies the AWS region where resources will be provisioned 
}

data "turbonomic_cloud_entity_recommendation" "example" { 
  entity_name  = "exampleVirtualMachine" // Name of the cloud entity (e.g., a virtual machine) to get recommendations for 
  entity_type  = "VirtualMachine" // Type of the cloud entity (e.g., VirtualMachine, Database, etc.) 
  default_size = "t3.nano" // Default instance size used if no recommendation is available. 
}

resource "aws_instance" "terraform-demo-ec2" { 
  ami           = "ami-079db87dc4c10ac91" // AMI ID used to launch the instance. 
  instance_type = data.turbonomic_cloud_entity_recommendation.example.new_instance_type // Uses the recommended instance type from the Turbonomic data source. 

  tags = merge( 
    { 
      Name = "exampleVirtualMachine" // Sets the Name tag for easy identification 
    }, 
    provider::turbonomic::get_tag() //tag the resource as optimized by Turbonomic Provider for Terraform 
  ) 
}