provider "github" {
 token = var.github_prive_access_token
 owner = "Stintlab"
}

variable github_prive_access_token {
    type = string
    default = ""
    description = "Personal Access Token to authenticate against Github. Get from here: https://github.com/settings/personal-access-tokens"
}