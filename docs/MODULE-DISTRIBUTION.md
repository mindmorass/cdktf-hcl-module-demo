# Terraform Module Distribution

## Important: GitHub Packages vs Terraform Modules

**GitHub Packages (npm) cannot be used directly as a Terraform module source.**

Terraform has its own module source types and doesn't support pulling from package registries like npm.

## How Terraform Modules Can Be Distributed

Terraform supports these module source types:

### 1. Git Repository

```hcl
module "html_page" {
  source = "github.com/username/repo//terraform-html-module?ref=v1.0.0"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}
```

**Pros:**

- Simple to use
- Version control built-in (via git tags)
- No additional infrastructure
- Direct reference to versioned module

**Cons:**

- Requires module to be committed to the repo
- Everyone clones the entire repo (unless using shallow clone)
- Requires maintaining module in repository

### 2. GitHub Release Archives (Recommended for Version Management)

GitHub Releases provide an excellent way to manage Terraform module versions. When you create a release with a version tag (e.g., `v1.0.0`), GitHub Actions automatically packages the module and attaches it to the release.

**Using Release ZIPs:**

```bash
# Download from GitHub release
curl -L -o terraform-html-module.zip \
  https://github.com/username/repo/releases/download/v1.0.0/terraform-html-module-v1.0.0.zip

# Extract to a local directory
unzip terraform-html-module.zip -d terraform-html-module

# Use in Terraform
```

```hcl
module "html_page" {
  source = "./terraform-html-module/terraform-html-module"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}

output "created_file" {
  value = module.html_page.created_file
}
```

**Option 2: Reference ZIP Directly (Terraform 1.5+)**

You can reference the ZIP file directly as a module source without manually downloading:

```hcl
module "html_page" {
  source = "https://github.com/username/repo/releases/download/v1.0.0/terraform-html-module-v1.0.0.zip?archive=zip"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}

output "created_file" {
  value = module.html_page.created_file
}
```

Terraform will automatically download and extract the ZIP when you run `terraform init`. The `?archive=zip` parameter tells Terraform to treat this as a ZIP archive.

**Complete Example:**

```bash
# Initialize Terraform (downloads and extracts the ZIP automatically)
terraform init

# Apply the configuration
terraform apply
```

**Benefits:**

- No manual download/extraction needed
- Terraform handles caching
- Version is explicit in the URL
- Works with any GitHub release ZIP

**Pros:**

- Automated via GitHub Actions on version tags
- Semantic versioning with git tags (`v1.0.0`, `v1.1.0`, etc.)
- Lightweight downloads (only module files)
- Version management through releases
- Checksums included for verification
- Release notes document changes

**Cons:**

- Requires GitHub Actions setup (already done in this project!)
- ZIP files need proper extraction for local use

**Version Management Workflow:**

```bash
# Create a new version
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions automatically:
# 1. Detects the tag
# 2. Generates the module
# 3. Creates a release
# 4. Attaches ZIP file with checksum
```

### 3. Terraform Registry (Public or Private)

```hcl
module "example" {
  source = "app.terraform.io/company/module/aws"
  version = "1.0.0"
}
```

**Pros:**

- Official distribution method
- Versioning built-in
- Easy to discover

**Cons:**

- Requires publishing to registry
- Public registry is free, private costs money

### 4. Local Directories

```hcl
module "example" {
  source = "./local-module"
}
```

**Pros:**

- Fast for development
- No network dependency

**Cons:**

- Not shareable
- No versioning

## Recommended Approach for This Project

**Option A: GitHub Release ZIPs - Direct Reference (Recommended)**

Use the ZIP file directly as the module source. Terraform handles the download and extraction automatically.

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

module "html_page" {
  source = "https://github.com/username/repo/releases/download/v1.0.0/terraform-html-module-v1.0.0.zip?archive=zip"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}

output "created_file" {
  value = module.html_page.created_file
}
```

**Option B: GitHub Release ZIPs - Download and Extract**

Manually download and extract the ZIP, then reference the local directory.

```bash
# Download from GitHub release
curl -L -o terraform-html-module.zip \
  https://github.com/username/repo/releases/download/v1.0.0/terraform-html-module-v1.0.0.zip

# Extract to a local directory
unzip terraform-html-module.zip -d terraform-html-module
```

```hcl
module "html_page" {
  source = "./terraform-html-module/terraform-html-module"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}
```

**Option C: Git Repository Subdirectory**

1. Commit the generated module to a subdirectory in your repo (e.g., `terraform-html-module/`)
2. Tag the release
3. Users reference: `github.com/mindmorass/cdktf-hcl-module-demo//terraform-html-module?ref=v1.0.0`

```hcl
module "html_page" {
  source = "github.com/username/repo//terraform-html-module?ref=v1.0.0"

  filename = "./output/page.html"
  title    = "My Page"
  message  = "Content for the page"
}
```

The workflow currently uses **Option A** (Direct ZIP Reference) which provides better version management through GitHub Releases and requires no manual steps. **Option B** (Download and Extract) is useful when you want more control over the download or need to verify checksums before use.

## Removing the GitHub Packages Step

Since Terraform doesn't support npm packages, the "Publish to GitHub Packages" step in the workflow (lines 207-233) is not useful and can be removed if desired. However, it doesn't hurt to leave it there if you want to keep it for other purposes.
