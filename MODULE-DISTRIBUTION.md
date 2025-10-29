# Terraform Module Distribution

## Important: GitHub Packages vs Terraform Modules

**GitHub Packages (npm) cannot be used directly as a Terraform module source.**

Terraform has its own module source types and doesn't support pulling from package registries like npm.

## How Terraform Modules Can Be Distributed

Terraform supports these module source types:

### 1. Git Repository (Best for this project)

```hcl
module "example" {
  source = "github.com/username/repo//subdirectory?ref=tag"
}
```

**Pros:**

- Simple to use
- Version control built-in
- No additional infrastructure

**Cons:**

- Requires module to be in the repo
- Everyone clones the entire repo

### 2. GitHub Release Archives (Currently in workflow)

```hcl
module "example" {
  source = "https://github.com/username/repo/releases/download/v1.0.0/module.zip"
}
```

**Pros:**

- Only downloads the module
- Lightweight downloads
- Versioned releases

**Cons:**

- Requires manual releases
- Need to maintain zip structure

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

**Option A: Git Repository Subdirectory (Recommended)**

1. Commit the generated module to a subdirectory in your repo (e.g., `terraform-html-module/`)
2. Tag the release
3. Users reference: `github.com/mindmorass/cdktf-hcl-module-demo//terraform-html-module?ref=v0.0.1`

**Option B: Release Archives**

1. Build zip files in GitHub Actions
2. Attach to GitHub releases
3. Users download and reference locally

The workflow currently creates zip files in GitHub releases, which users can download.

## Removing the GitHub Packages Step

Since Terraform doesn't support npm packages, the "Publish to GitHub Packages" step in the workflow (lines 207-233) is not useful and can be removed if desired. However, it doesn't hurt to leave it there if you want to keep it for other purposes.
