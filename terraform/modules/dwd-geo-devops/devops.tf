resource "oci_devops_project" "devops_project" {
    compartment_id = var.compartment_ocid
    name = var.devops_project_name
    notification_config {
        topic_id = oci_ons_notification_topic.devops_notification_topic.id
    }
}

resource "oci_devops_repository" "devops_repository" {
    name = var.devops_repository_name
    project_id = oci_devops_project.devops_project.id
    repository_type = "HOSTED"
}

resource "oci_devops_build_pipeline" "devops_build_pipeline" {
    project_id = oci_devops_project.devops_project.id
    display_name = var.devops_build_pipeline_name
    description = var.devops_build_pipeline_name
    build_pipeline_parameters {
        items {
            name = "buildId"
            default_value = "id"
            description = "Docker tag"
        }
    }
}

resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_build" {
    display_name = "build-from-code-repo"
    description = "Build artifacts and image fromthe integrated code repository"
    build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline.id
    build_pipeline_stage_type = "BUILD"
    build_spec_file = ""
    build_pipeline_stage_predecessor_collection {
        items {
            id = oci_devops_build_pipeline.devops_build_pipeline.id
        }
    }
    build_source_collection {
        items {
            name = "build-source"
            connection_type = "DEVOPS_CODE_REPOSITORY"
            repository_id = oci_devops_repository.devops_repository.id
            repository_url = oci_devops_repository.devops_repository.http_url
            branch = "main"
        }
    }

    image = "OL7_X86_64_STANDARD_10"
}

resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_deliver" {
    display_name = "deliver-artifacts"
    description = "Deliver artifacts"
    build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline.id
    build_pipeline_stage_type = "DELIVER_ARTIFACT"
    build_pipeline_stage_predecessor_collection {
        items {
            id = oci_devops_build_pipeline_stage.devops_build_pipeline_stage_build.id
        }
    }
    deliver_artifact_collection {
        items {
            artifact_id = oci_devops_deploy_artifact.devops_deploy_artifact_image_departments.id
            artifact_name = var.arifact_build_spec_fn_image
        }
    }
}

resource "oci_devops_deploy_artifact" "devops_deploy_artifact_image_departments" {
    argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
    deploy_artifact_source {
        deploy_artifact_source_type = "OCIR"
        image_uri = format("%s%s:$%s", var.container_image_path, var.arifact_build_spec_fn_image, "{buildId}")
    }
    deploy_artifact_type = "DOCKER_IMAGE"
    project_id = oci_devops_project.devops_project.id
    display_name = "image-departments"
}

/*resource "oci_devops_build_pipeline_stage" "devops_build_pipeline_stage_trigger" {
    display_name = "trigger-deployment-pipeline"
    description = "Trigger deployment pipeline"
    build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline.id
    build_pipeline_stage_type = "TRIGGER_DEPLOYMENT_PIPELINE"
    is_pass_all_parameters_enabled = true
    deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
    build_pipeline_stage_predecessor_collection {
        items {
            id = oci_devops_build_pipeline_stage.devops_build_pipeline_stage_deliver.id
        }
    }
}

resource "oci_devops_trigger" "devops_trigger" {
    actions {
        build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline.id
        type = "TRIGGER_BUILD_PIPELINE"
    }
    project_id = oci_devops_project.devops_project.id
    trigger_source = "DEVOPS_CODE_REPOSITORY"
    repository_id = oci_devops_repository.devops_repository.id
    display_name = "trigger-build-pipeline"
}

resource "oci_devops_deploy_environment" "deploy_environment" {
    deploy_environment_type = "OKE_CLUSTER"
    project_id = oci_devops_project.devops_project.id
    cluster_id = var.deployment_oke_cluster_ocid
    display_name = "oke-deploy-environment"
}

resource "oci_devops_deploy_pipeline" "devops_deploy_pipeline" {
    project_id = oci_devops_project.devops_project.id
    display_name = var.devops_deploy_pipeline_name
    description = "Deploy pipeline"
    deploy_pipeline_parameters {
      items {
            name = "buildId"
            default_value = "id"
            description = "Docker tag"
        }
    }
}

resource "oci_devops_deploy_stage" "devops_deploy_stage_departments" {
    display_name = "deploy-departments"
    deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
        }
    }
    deploy_stage_type = "OKE_DEPLOYMENT"
    kubernetes_manifest_deploy_artifact_ids = [oci_devops_deploy_artifact.devops_deploy_artifact_manifest_departments.id]
    namespace = var.deployment_oke_cluster_namespace
    oke_cluster_deploy_environment_id = oci_devops_deploy_environment.deploy_environment.id
    rollback_policy {
        policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
    }
}

resource "oci_devops_deploy_stage" "devops_deploy_stage_branches" {
    display_name = "deploy-branches"
    deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
        }
    }
    deploy_stage_type = "OKE_DEPLOYMENT"
    kubernetes_manifest_deploy_artifact_ids = [oci_devops_deploy_artifact.devops_deploy_artifact_manifest_branches.id]
    namespace = var.deployment_oke_cluster_namespace
    oke_cluster_deploy_environment_id = oci_devops_deploy_environment.deploy_environment.id
    rollback_policy {
        policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
    }
}

resource "oci_devops_deploy_stage" "devops_deploy_stage_frontend" {
    display_name = "deploy-frontend"
    deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.devops_deploy_pipeline.id
        }
    }
    deploy_stage_type = "OKE_DEPLOYMENT"
    kubernetes_manifest_deploy_artifact_ids = [oci_devops_deploy_artifact.devops_deploy_artifact_manifest_frontend.id]
    namespace = var.deployment_oke_cluster_namespace
    oke_cluster_deploy_environment_id = oci_devops_deploy_environment.deploy_environment.id
    rollback_policy {
        policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
    }
}*/