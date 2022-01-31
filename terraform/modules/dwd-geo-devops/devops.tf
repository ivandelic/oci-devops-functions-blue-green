resource "oci_devops_project" "devops_project" {
  compartment_id = var.compartment_ocid
  name           = var.devops_project_name
  notification_config {
    topic_id = oci_ons_notification_topic.devops_notification_topic.id
  }
}

resource "oci_devops_repository" "devops_repository" {
  name            = var.devops_repository_name
  project_id      = oci_devops_project.devops_project.id
  repository_type = "HOSTED"
}

resource "oci_devops_build_pipeline" "devops_build_pipeline" {
  project_id   = oci_devops_project.devops_project.id
  display_name = var.devops_build_pipeline_name
  description  = var.devops_build_pipeline_name
  build_pipeline_parameters {
    items {
      name          = "buildId"
      description   = "Build ID for Docker tag"
      default_value = "id"
    }
    items {
      name          = "commitId"
      description   = "Commit ID"
      default_value = "id"
    }
    items {
      name          = "timestamp"
      description   = "Timestamp"
      default_value = "id"
    }
  }
}

resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_build" {
  display_name              = "build-from-code-repo"
  description               = "Build artifacts and image fromthe integrated code repository"
  build_pipeline_id         = oci_devops_build_pipeline.devops_build_pipeline.id
  build_pipeline_stage_type = "BUILD"
  build_spec_file           = ""
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline.devops_build_pipeline.id
    }
  }
  build_source_collection {
    items {
      name            = "build-source"
      connection_type = "DEVOPS_CODE_REPOSITORY"
      repository_id   = oci_devops_repository.devops_repository.id
      repository_url  = oci_devops_repository.devops_repository.http_url
      branch          = "main"
    }
  }
  image = "OL7_X86_64_STANDARD_10"
}

resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_deliver" {
  display_name              = "deliver-artifacts"
  description               = "Deliver artifacts"
  build_pipeline_id         = oci_devops_build_pipeline.devops_build_pipeline.id
  build_pipeline_stage_type = "DELIVER_ARTIFACT"
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.devops_build_pipeline_stage_build.id
    }
  }
  deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.devops_deploy_artifact_fn_image.id
      artifact_name = var.arifact_build_spec_fn_image_specific
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.devops_deploy_artifact_fn_image_latest.id
      artifact_name = var.arifact_build_spec_fn_image_latest
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.devops_deploy_artifact_fn_payload.id
      artifact_name = var.arifact_build_spec_fn_payload
    }
  }
}

resource "oci_devops_deploy_artifact" "devops_deploy_artifact_fn_image" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_source {
    deploy_artifact_source_type = "OCIR"
    image_uri                   = format("%s%s:$%s", var.container_image_path, var.arifact_true_fn_image_name, "{buildId}")
  }
  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.devops_project.id
  display_name         = "fn-image"
}

resource "oci_devops_deploy_artifact" "devops_deploy_artifact_fn_image_latest" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_source {
    deploy_artifact_source_type = "OCIR"
    image_uri                   = format("%s%s:%s", var.container_image_path, var.arifact_true_fn_image_name, "latest")
  }
  deploy_artifact_type = "DOCKER_IMAGE"
  project_id           = oci_devops_project.devops_project.id
  display_name         = "fn-image"
}

resource "oci_devops_deploy_artifact" "devops_deploy_artifact_fn_payload" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_source {
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_path        = var.arifact_build_spec_fn_payload
    deploy_artifact_version     = "1.0"
    repository_id               = oci_artifacts_repository.artifacts_repository.id
  }
  deploy_artifact_type = "GENERIC_FILE"
  project_id           = oci_devops_project.devops_project.id
  display_name         = "fn-payload"
}

resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_trigger" {
  display_name                   = "trigger-deployment-pipeline"
  description                    = "Trigger deployment pipeline"
  build_pipeline_id              = oci_devops_build_pipeline.devops_build_pipeline.id
  build_pipeline_stage_type      = "TRIGGER_DEPLOYMENT_PIPELINE"
  is_pass_all_parameters_enabled = true
  deploy_pipeline_id             = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.devops_build_pipeline_stage_deliver.id
    }
  }
}

resource "oci_devops_trigger" "devops_trigger" {
  actions {
    build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline.id
    type              = "TRIGGER_BUILD_PIPELINE"
  }
  project_id     = oci_devops_project.devops_project.id
  trigger_source = "DEVOPS_CODE_REPOSITORY"
  repository_id  = oci_devops_repository.devops_repository.id
  display_name   = "trigger-build-pipeline"
}

resource "oci_devops_deploy_environment" "fn_environment_rm_trigger" {
  deploy_environment_type = "FUNCTION"
  project_id              = oci_devops_project.devops_project.id
  function_id             = var.fn_resource_manager_trigger_id
  display_name            = "fn-environment-rm-trigger"
}

resource "oci_devops_deploy_environment" "fn_environment_dns_switch" {
  deploy_environment_type = "FUNCTION"
  project_id              = oci_devops_project.devops_project.id
  function_id             = var.fn_dns_switch_id
  display_name            = "fn-environment-dns-switch"
}

resource "oci_devops_deploy_pipeline" "devops_deploy_pipeline" {
  project_id   = oci_devops_project.devops_project.id
  display_name = var.devops_deploy_pipeline_name
  description  = "Deploy pipeline"
  deploy_pipeline_parameters {
    items {
      name          = "buildId"
      description   = "Build ID for Docker tag"
      default_value = "id"
    }
    items {
      name          = "commitId"
      description   = "Commit ID"
      default_value = "id"
    }
    items {
      name          = "timestamp"
      description   = "Commit ID"
      default_value = "id"
    }
    items {
      name          = "zoneId"
      default_value = "ocid1.dns-zone.oc1..aaaaaaaamwsmfzxa5iguu3u3gm4aqb24sl35poyzxwk3sobtqe6hjsbvbhla"
      description   = "DNS zone holding all domains for blue and green deployments"
    }
    items {
      name          = "domainId"
      default_value = "geo.dwd.ivandelic.com"
      description   = "Master domain for production in DNS zone"
    }
    items {
      name          = "blueFqdn"
      default_value = "dwd-blue.ivandelic.com."
      description   = "Blue domain in DNS zone"
    }
    items {
      name          = "greenFqdn"
      default_value = "dwd-green.ivandelic.com."
      description   = "Green domain in DNS zone"
    }
    items {
      name          = "blueStackId"
      default_value = "ocid1.ormstack.oc1.eu-frankfurt-1.aaaaaaaahrabmdueht2qvvan2ammc4cimk2k4piw4pp6wy7ipt3ajqagfk5a"
      description   = "Blue Resource Manager Stack ID"
    }
    items {
      name          = "greenStackId"
      default_value = "ocid1.ormstack.oc1.eu-frankfurt-1.aaaaaaaatoctnk2osftyrgiwnyeqm5sljjf3c6cpf2vzjmdjnc6auamo7uvq"
      description   = "Green Resource Manager Stack ID"
    }
  }
}

resource "oci_devops_deploy_stage" "deploy_stage_rm_trigger" {
  display_name       = "invoke-resource-manager"
  deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
    }
  }
  deploy_stage_type              = "INVOKE_FUNCTION"
  function_deploy_environment_id = oci_devops_deploy_environment.fn_environment_rm_trigger.id
  is_async                       = false
  is_validation_enabled          = true
  deploy_artifact_id             = oci_devops_deploy_artifact.devops_deploy_artifact_fn_payload.id
}

resource "oci_devops_deploy_stage" "deploy_stage_approval" {
  display_name       = "approve"
  deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_stage.deploy_stage_rm_trigger.id
    }
  }
  deploy_stage_type = "MANUAL_APPROVAL"
  approval_policy {
    approval_policy_type         = "COUNT_BASED_APPROVAL"
    number_of_approvals_required = 1
  }
}

resource "oci_devops_deploy_stage" "deploy_stage_dns_switch" {
  display_name       = "invoke-dns"
  deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_stage.deploy_stage_approval.id
    }
  }
  deploy_stage_type              = "INVOKE_FUNCTION"
  function_deploy_environment_id = oci_devops_deploy_environment.fn_environment_dns_switch.id
  is_async                       = false
  is_validation_enabled          = true
  deploy_artifact_id             = oci_devops_deploy_artifact.devops_deploy_artifact_fn_payload.id
}
