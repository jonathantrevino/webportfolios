terraform {
	required_providers  {
		aws = { 
      source = "hashicorp/aws"
      version = ">= 6.50.0"
    }
	}
	required_version = ">= 1.14"
}

provider "aws" {
	region = var.region
	profile = "dev"
} 
