resource "github_repository" "StintLab" {
 name        = "StintLab"
 description = "StintLab Frontend Repository"
 visibility  = "public"
 auto_init   = false
 homepage_url = "stintlab.github.io/StintLab"
 has_issues = true
 has_discussions = false
 has_projects = false
 has_downloads = false
 has_wiki = false
 delete_branch_on_merge = true
 vulnerability_alerts = true
 topics = ["racing", "motorsports", "management"]

    pages {
        build_type = "legacy"
        source {
            branch = "gh-pages"
            path = "/"
        }
    }
}

##################################################################
##########################              ##########################
##########################     MAIN     ##########################
##########################              ##########################
##################################################################

resource "github_branch" "main" {
  repository = github_repository.StintLab.name
  branch     = "main"
}

resource "github_branch" "gh-pages" {
  repository = github_repository.StintLab.name
  branch     = "gh-pages"
}

resource "github_branch_default" "mainDefaultBranch"{
  repository = github_repository.StintLab.name
  branch     = github_branch.main.branch
}

resource "github_repository_ruleset" "mainProtection" {
  name = "mainProtection"
  repository = github_repository.StintLab.name
  target = "branch"
  enforcement = "active"

  conditions {
    ref_name {
        exclude = []
        include = [ "refs/heads/main" ]
      }
  }

  bypass_actors {
    actor_id = data.github_user.MathiasSonderfeld.id
    actor_type = "OrganizationAdmin"
    bypass_mode = "always"
  }

  rules {
    creation = true
    update   = true
    deletion = true
    required_signatures = true

    pull_request {
      dismiss_stale_reviews_on_push = true
      require_code_owner_review = false
      required_review_thread_resolution = true
      required_approving_review_count = 1
      
    }
    required_status_checks {
      strict_required_status_checks_policy = true
      required_check {
        context = "all-green"
      }
    }
  }
}