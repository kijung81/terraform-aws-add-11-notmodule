terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # cloud {
  #   organization = "Golfzon"
  #   workspaces {
  #     name = "add_scenario_11_notmodule"
  #   }
  # }
}

provider "aws" {
  region = "ap-northeast-2"
}