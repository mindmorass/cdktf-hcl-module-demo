#!/bin/bash

# package-module.sh
# Creates a distributable package of the generated Terraform module

echo "Packaging Terraform Module"
echo "=========================="
echo ""

# Step 1: Generate the module
echo "1. Generating HCL module from CDKTF..."
if [ ! -d "generated-hcl-module" ]; then
    echo "   Running demo to generate module..."
    ./demo-workflow.sh > /dev/null 2>&1
fi

if [ ! -d "generated-hcl-module" ]; then
    echo "   Failed to generate module. Run ./demo-workflow.sh first."
    exit 1
fi

echo "   Module generated"

# Step 2: Create package directory
echo "2. Creating package structure..."
rm -rf module-package
mkdir -p module-package

# Copy generated module files
cp generated-hcl-module/*.tf module-package/

# Step 3: Add documentation
echo "3. Adding documentation..."

cat > module-package/README.md << 'EOF'
# HTML File Terraform Module

This Terraform module creates HTML files with professional styling. Generated from CDKTF TypeScript code.

## Features

- Creates multiple HTML files with custom content
- Professional styling and responsive design  
- Configurable titles and messages
- Returns file metadata as outputs

## Usage

```hcl
module "html_files" {
  source = "./html-file-module"
  
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
  }
}

output "created_files" {
  value = module.html_files.created_files
}
```

## Variables

- `html_files` (map) - Map of HTML files to create with filename, title, and message

## Outputs

- `created_files` - Map containing metadata about created files

## Requirements

- Terraform >= 0.13
- Local provider ~> 2.0

## Generated From

This module was generated from CDKTF TypeScript code, demonstrating how to create reusable Terraform modules using modern infrastructure-as-code practices.
EOF

# Step 4: Add metadata
echo "4. Adding metadata..."

# Get version from git if available, otherwise use timestamp
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev-$(date +%Y%m%d-%H%M%S)")
    COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
else
    VERSION="dev-$(date +%Y%m%d-%H%M%S)"
    COMMIT="unknown"
    BRANCH="unknown"
fi

cat > module-package/module-info.json << EOF
{
  "name": "html-file-module",
  "description": "Terraform module for creating HTML files",
  "version": "$VERSION",
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": "$COMMIT",
  "branch": "$BRANCH",
  "source": "cdktf-typescript",
  "terraform_version": ">= 0.13",
  "providers": {
    "local": "~> 2.0"
  }
}
EOF

cat > module-package/VERSION << EOF
$VERSION
EOF

# Step 5: Validate the module
echo "5. Validating module..."
cd module-package
if command -v terraform &> /dev/null; then
    terraform init > /dev/null 2>&1
    if terraform validate > /dev/null 2>&1; then
        echo "   Module validation passed"
    else
        echo "   Module validation failed (but package created)"
    fi
else
    echo "   Terraform not found - skipping validation"
fi
cd ..

# Step 6: Create zip package
echo "6. Creating zip package..."
cd module-package
zip -r ../terraform-html-module-${VERSION}.zip . > /dev/null 2>&1
cd ..

# Step 7: Create checksums
echo "7. Creating checksums..."
sha256sum terraform-html-module-${VERSION}.zip > terraform-html-module-${VERSION}.zip.sha256

# Step 8: Show results
echo ""
echo "Package Created Successfully!"
echo "============================="
echo ""
echo "Package files:"
ls -la terraform-html-module-${VERSION}.zip*
echo ""
echo "Package contents:"
echo "   main.tf - Module resources"
echo "   outputs.tf - Module outputs"  
echo "   README.md - Usage documentation"
echo "   module-info.json - Metadata"
echo "   VERSION - Version identifier"
echo ""
echo "To inspect package:"
echo "   unzip -l terraform-html-module-${VERSION}.zip"
echo ""
echo "To verify integrity:"
echo "   sha256sum -c terraform-html-module-${VERSION}.zip.sha256"
echo ""
echo "Ready for distribution!"
echo ""
echo "Usage in other projects:"
echo "   1. Download terraform-html-module-${VERSION}.zip"
echo "   2. Extract to your project: unzip terraform-html-module-${VERSION}.zip -d html-file-module"
echo "   3. Reference in your Terraform:"
echo '      module "html_files" {'
echo '        source = "./html-file-module"'
echo '        html_files = { ... }'
echo '      }'