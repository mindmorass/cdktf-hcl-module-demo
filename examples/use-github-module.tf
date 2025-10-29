# Example: Using the CDKTF-generated HCL module from GitHub
#
# Option 1: Use the module directly from the git repository (when the module
#           is committed to a subdirectory in the repo)
#
# Option 2: Use the module from a GitHub release zip file (see commented example below)

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

module "html_files" {
  # This requires the module to be in the repo at the specified subdirectory
  source = "github.com/mindmorass/cdktf-hcl-module-demo//terraform-html-module?ref=v0.0.1"

  # Alternative: Download from GitHub release zip
  # source = "https://github.com/mindmorass/cdktf-hcl-module-demo/releases/download/v0.0.1/terraform-html-module-v0.0.1.zip"

  html_files = {
    welcome = {
      filename = "./output/welcome.html"
      title    = "Welcome Page"
      message  = "Welcome to our website!"
    }
    about = {
      filename = "./output/about.html"
      title    = "About Us"
      message  = "Learn more about our company and mission."
    }
    contact = {
      filename = "./output/contact.html"
      title    = "Contact Us"
      message  = "Get in touch with our team."
    }
  }
}

output "created_files" {
  description = "Files created by the module"
  value       = module.html_files.created_files
}

