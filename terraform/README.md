## Prerequisites
To setup this terraform project we need to have some prerequisites.

1. GCP project.
2. Cloud Storage Bucket.
3. Cloud Resource Manager API activated.
4. Service account.
5. Github oatuh token.
6. Github Cloud Build app installed and installation id.

## Setup:

Get the file "terraform.tfvars.example" and create "terraform.tfvars" with your values.

Export serviceaccount json to variable:

    GOOGLE_APPLICATION_CREDENTIALS=auth/sa.json

Now run init terraform command (substitute the bucket name with yours bucket.):

    terraform init -backend-config="bucket=terraform-mms"

Now apply terraform and apply

    terraform apply
