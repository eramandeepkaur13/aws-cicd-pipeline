resource "aws_iam_role" "tf-codepipeline-role1" {
  name = "tf-codepipeline-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  
}
data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:Useconnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }

}
resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
    name = "tf-cicd-pipeline-policy"
    path = "/"
    description = "Pipeline Policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}
resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
    role = aws_iam_role.tf-codepipeline-role1.id
}

resource "aws_iam_role" "tf-codebuild-role1" {
  name = "tf-codebuild-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*","secretmanger:*", "iam:*" ]
        resources = ["*"]
        effect = "Allow"
    }
    
}
resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "codebuild Policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}
resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    policy_arn = aws_iam_policy.tf-cicd-build-policy.arn
    role = aws_iam_role.tf-codebuild-role1.id
}

/*resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
    policy_arn = "arn:aws:iam:aws:policy/PowerUserAccess"
    role = aws_iam_role.tf-codebuild-role1.id
}*/
