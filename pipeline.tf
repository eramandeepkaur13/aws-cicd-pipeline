/*resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan"
  description   = "plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role1.arn

  artifacts {
    type = "CODEPIPELINE"
  }



  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.2.1"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SCRETS_MANAGER"

    }
  }

 source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
}    
resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role1.arn

  artifacts {
    type = "CODEPIPELINE"
  }



  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.2.1"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SCRETS_MANAGER"

    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

resource "aws_codepipeline" "cicd_pipeline"{
    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role1.arn

  artifact_store {
    location = aws_s3_bucket.my-demo.id
    type     = "S3"

    
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStartSourceConnection"
      version          = "1"
      output_artifacts = ["tf-code"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "eramandeepkaur13/aws-cicd-pipeline"
        BranchName       = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
    stage {
        name = "Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "AWS"
            owner= "AWS"
            version = "1"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }


        }
    }
    stage {
        name = "Deploy"
        action{
            name = "Deploy"
            category = "CodeBuild"
            owner = "AWS"
            version = "1"
            provider = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }


        }
    }


}*/
