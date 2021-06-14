resource "azuredevops_branch_policy_merge_types" "merge_policy" {
  project_id = data.azuredevops_project.project.id
  enabled    = var.merge_policy.enabled
  blocking   = var.merge_policy.blocking
  settings {
    allow_squash                  = var.merge_policy.allow_squash
    allow_rebase_and_fast_forward = var.merge_policy.allow_rebase_and_fast_forward
    allow_basic_no_fast_forward   = var.merge_policy.allow_basic_no_fast_forward
    allow_rebase_with_merge       = var.merge_policy.allow_rebase_with_merge
    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}

resource "azuredevops_branch_policy_comment_resolution" "comment_policy" {
  project_id = data.azuredevops_project.project.id
  enabled    = var.comment_resolution_policy.enabled
  blocking   = var.comment_resolution_policy.blocking
  settings {
    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}

resource "azuredevops_branch_policy_work_item_linking" "linking_item" {
  project_id = data.azuredevops_project.project.id
  enabled    = var.work_item_policy.enabled
  blocking   = var.work_item_policy.blocking
  settings {
    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}

resource "azuredevops_branch_policy_build_validation" "validations" {
  for_each   = toset(local.pipeline_build_validations)
  project_id = data.azuredevops_project.project.id
  enabled    = var.build_validation_policy.enabled
  blocking   = var.build_validation_policy.blocking

  settings {
    display_name        = each.key
    build_definition_id = azuredevops_build_definition.pipelines[each.key].id
    valid_duration      = 720

    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}

resource "azuredevops_branch_policy_min_reviewers" "minimum_reviews" {
  project_id = data.azuredevops_project.project.id
  enabled    = var.minimum_reviewers_policy.enabled
  blocking   = var.minimum_reviewers_policy.blocking
  settings {
    reviewer_count                         = var.minimum_reviewers_policy.minimum_number_of_reviewer
    submitter_can_vote                     = var.minimum_reviewers_policy.author_can_vote
    last_pusher_cannot_approve             = false
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true
    on_last_iteration_require_vote         = false
    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}

resource "azuredevops_branch_policy_auto_reviewers" "required_reviewers" {
  for_each   = local.project_reviewers
  project_id = data.azuredevops_project.project.id
  enabled    = length(each.value.reviewers) > 0
  blocking   = length(each.value.reviewers) > 0
  settings {
    auto_reviewer_ids  = [azuredevops_group.reviewers[each.key].origin_id]
    submitter_can_vote = false
    message            = each.key
    path_filters       = each.value.path
    dynamic "scope" {
      for_each = var.project_scope
      content {
        repository_id  = azuredevops_git_repository.repository.id
        repository_ref = scope.value.repository_ref
        match_type     = scope.value.match_type
      }
    }
  }
}
