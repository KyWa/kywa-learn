terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Pull from ENV var
variable "github_token" {
  type = string
}

# Configure the GitHub Provider
provider "github" {
  token = var.github_token
}

# Branch Creation
resource "github_branch" "testing" {
  repository = "terraform-examples"
  branch = "dal-nonprod-ocp4"
  source_branch = "master"
}

# Branch Protections
resource "github_branch_protection" "nonprod" {
  repository_id = "terraform-examples"

  pattern = "*-nonprod-*"
  enforce_admins = true
  
  required_pull_request_reviews {
    dismiss_stale_reviews = true
    require_code_owner_reviews = true
  }
}
