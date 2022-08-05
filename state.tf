terraform{
    backend "s3" {
        bucket = "aws-pipline"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }

}