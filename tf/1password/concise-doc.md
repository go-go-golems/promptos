# 1. Getting Started with the 1Password Terraform Provider

## Installation
Add the provider to your Terraform configuration.

```hcl
terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 1.0.0"
    }
  }
}
```

# 2. Authenticating the 1Password Provider: CLI vs Connect Server

## CLI Authentication
Use environment variables for CLI authentication.

```bash
export OP_SERVICE_ACCOUNT_TOKEN="your-token-here"
```

## Connect Server Authentication
Configure provider block for Connect Server.

```hcl
provider "onepassword" {
  url   = "http://connect-server:8080"
  token = "your-connect-token"
}
```

# 3. Managing Vaults with Terraform

## Retrieving Vault Information
Use the `onepassword_vault` data source to get vault details.

```hcl
data "onepassword_vault" "example" {
  name = "My Vault"
}
```

# 4. Creating and Updating Login Items

## Creating a Login Item
Use the `onepassword_item` resource to create a login item.

```hcl
resource "onepassword_item" "example_login" {
  vault    = data.onepassword_vault.example.uuid
  title    = "Example Login"
  category = "login"
  username = "user@example.com"
  password = "generated-password"
}
```

# 5. Working with Password Items and Password Recipes

## Creating a Password Item with Recipe
Use `password_recipe` to generate passwords.

```hcl
resource "onepassword_item" "example_password" {
  vault    = data.onepassword_vault.example.uuid
  title    = "Generated Password"
  category = "password"
  password_recipe {
    length  = 20
    symbols = true
  }
}
```

# 6. Managing Database Credentials in 1Password

## Creating Database Credentials
Use the `database` category for database items.

```hcl
resource "onepassword_item" "example_db" {
  vault     = data.onepassword_vault.example.uuid
  title     = "Production Database"
  category  = "database"
  username  = "admin"
  password  = "secure-password"
  database  = "myapp_production"
  hostname  = "db.example.com"
  port      = 5432
}
```

# 8. Using Custom Sections and Fields in 1Password Items

## Adding Custom Sections and Fields
Use `section` and `field` blocks to add custom data.

```hcl
resource "onepassword_item" "example_custom" {
  vault    = data.onepassword_vault.example.uuid
  title    = "Custom Item"
  category = "login"
  section {
    label = "API Details"
    field {
      label = "API Key"
      type  = "concealed"
      value = "api-key-value"
    }
  }
}
```

# 11. Best Practices for Secret Management with 1Password and Terraform

## Use Data Sources for Sensitive Information
Avoid hardcoding secrets in your Terraform code.

```hcl
data "onepassword_item" "db_credentials" {
  vault = data.onepassword_vault.example.uuid
  title = "Production Database Credentials"
}

resource "aws_db_instance" "example" {
  username = data.onepassword_item.db_credentials.username
  password = data.onepassword_item.db_credentials.password
}
```

# 13. Using 1Password Data Sources in Terraform Configurations

## Retrieving Item Details
Use `onepassword_item` data source to fetch existing items.

```hcl
data "onepassword_item" "example" {
  vault = data.onepassword_vault.example.uuid
  title = "Existing Login"
}

output "username" {
  value = data.onepassword_item.example.username
}
```

# 14. Securely Storing 1Password Credentials for CI/CD Pipelines

## Using Environment Variables
Set sensitive values as environment variables in your CI/CD system.

```yaml
# Example GitHub Actions workflow
jobs:
  deploy:
    steps:
      - uses: actions/checkout@v2
      - name: Configure 1Password CLI
        env:
          OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
        run: |
          echo $OP_SERVICE_ACCOUNT_TOKEN | op signin
```

# 15. Version Control Strategies for 1Password Terraform Configurations

## Using Terraform Workspaces
Manage different environments using Terraform workspaces.

```hcl
resource "onepassword_item" "example" {
  vault    = data.onepassword_vault.example.uuid
  title    = "API Key - ${terraform.workspace}"
  category = "password"
}
```

