#!/bin/bash

# test-pipeline.sh
# Local test of the GitHub Actions pipeline workflow

echo "Testing GitHub Actions Pipeline Locally"
echo "======================================="
echo ""

# Step 1: Install dependencies
echo "1. Installing dependencies..."
npm ci

# Step 2: Generate CDKTF providers
echo "2. Generating CDKTF providers..."
npx cdktf get

# Step 3: Synth HCL module
echo "3. Synthesizing HCL module..."
npx cdktf synth --hcl

# Step 4: Validate generated HCL
echo "4. Validating generated HCL..."
cd cdktf.out/stacks/SimpleTestStack
terraform init
terraform validate
terraform fmt -check
cd ../../..

# Step 5: Create module package (simulate the pipeline)
echo "5. Creating module package..."
VERSION="v1.0.0-test"

# Create package directory
mkdir -p terraform-module-package

# Copy the native HCL output
cp cdktf.out/stacks/SimpleTestStack/cdk.tf terraform-module-package/main.tf

# Create proper module structure
cat > terraform-module-package/variables.tf << 'EOF'
variable "html_files" {
  description = "Map of HTML files to create"
  type = map(object({
    filename = string
    title    = string
    message  = string
  }))
  default = {}
}
EOF

cat > terraform-module-package/outputs.tf << 'EOF'
output "created_files" {
  description = "Map of created files"
  value = {
    for k, v in local_file.html_files : k => {
      filename = v.filename
      size     = length(v.content)
    }
  }
}
EOF

# Add module documentation
cat > terraform-module-package/README.md << EOF
# HTML File Terraform Module ${VERSION}

Generated from CDKTF TypeScript code.

## Usage

\`\`\`hcl
module "html_files" {
  source = "./terraform-html-module"
  
  html_files = {
    welcome = {
      filename = "./output/welcome.html"
      title    = "Welcome Page"
      message  = "Welcome to our website!"
    }
  }
}
\`\`\`

## Generated from

- Repository: local-test
- Tag: ${VERSION}
- Generated: $(date -u)
EOF

# Create package metadata
cat > terraform-module-package/module.json << EOF
{
  "name": "terraform-html-module",
  "version": "${VERSION}",
  "description": "Terraform module for creating HTML files",
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "cdktf_version": "0.20.0"
}
EOF

# Create version file
echo "${VERSION}" > terraform-module-package/VERSION

# Step 6: Create module zip
echo "6. Creating module zip..."
cd terraform-module-package
zip -r ../terraform-html-module-${VERSION}.zip .
cd ..
sha256sum terraform-html-module-${VERSION}.zip > terraform-html-module-${VERSION}.zip.sha256

# Step 7: Show results
echo ""
echo "Pipeline Test Complete!"
echo "======================"
echo ""
echo "Generated Files:"
ls -la terraform-module-package/
echo ""
echo "Package Files:"
ls -la terraform-html-module-*
echo ""
echo "Package Contents:"
unzip -l terraform-html-module-${VERSION}.zip
echo ""
echo "Test the module:"
echo "  1. Extract: unzip terraform-html-module-${VERSION}.zip -d test-module"
echo "  2. Use in Terraform:"
echo '     module "html_files" {'
echo '       source = "./test-module"'
echo '       html_files = { ... }'
echo '     }'
echo ""
echo "Cleanup test files:"
echo "  rm -rf terraform-module-package terraform-html-module-*"