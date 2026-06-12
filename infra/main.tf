terraform {
	required_providers  {
		aws = "hashicorp/aws"
		version = ">= 6.50.0"
	}
	required_version = ">= 1.15.0"
}

provider "aws" {
	region = var.region
	profile = "dev"
} 
