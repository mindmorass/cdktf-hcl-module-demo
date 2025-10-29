# Manual HCL equivalent of the CDKTF-generated JSON
# This shows what the JSON represents in traditional HCL syntax

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

resource "local_file" "test-html" {
  filename = "test-output.html"
  content  = <<-EOT
    <!DOCTYPE html>
    <html>
    <head><title>CDKTF Test</title></head>
    <body>
      <h1>Success!</h1>
      <p>This HTML file was created by CDKTF using the local provider.</p>
      <div style="background: #d4edda; padding: 1rem; border-radius: 5px; margin: 1rem 0;">
        <strong>CDKTF → Local File Creation Working!</strong>
      </div>
    </body>
    </html>
  EOT
}

output "file_path" {
  value = local_file.test-html.filename
}
