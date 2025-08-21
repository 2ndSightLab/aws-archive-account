#!/bin/bash -e

cat <<'END_TEXT'

***************************
S3 Buckets 
***************************

Below is a list of S3 Buckets. You can copy all the buckets or individual
buckets based on the bucket name. You will need permission to use the KMS key 
if one exists to decrypt the contents of the bucket.

END_TEXT

read -p "Would you like to see the required policies to apply to IAM roles and bucket? (y)" read v
if [ "$v" == "y" ]; then

cat <<'END_TEXT' 
Add IAM policy for archive admin role in the from_account (limit further if needed):
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::*",
                "arn:aws:s3:::*/*"
            ]
        }
    ]
}

Add bucket policy for each bucket in the from account:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<AccountA-IAM-ROLE-ARN>" 
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::YOUR_BUCKET_NAME",
                "arn:aws:s3:::YOUR_BUCKET_NAME/*"
            ]
        }
    ]
}

If the bucket is encrypted make sure the key policy grants access to the archive admin role:

{
    "Version": "2012-10-17",
    "Id": "key-policy-for-s3-role-access",
    "Statement": [
        {
            "Sid": "Allow role to encrypt and decrypt data in S3",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<AWS-ACCOUNT-ID>:role/<ROLE-NAME>"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*" 
        }
    ]
}


END_TEXT
fi

for bucket_name in $(aws s3api list-buckets --query "Buckets[].Name" --output text --profile $archive_from --region $region); do 
  echo "Bucket: ${bucket_name}" 
  encryption_info=$(aws s3api get-bucket-encryption --bucket "${bucket_name}" --profile $archive_from --region $region)
  if [[ $? -eq 0 ]]; then 
     kms_key_id=$(echo "${encryption_info}" | \
     jq -r '.ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.KMSMasterKeyID')
  if [ "${kms_key_id}" == "null" ]; then kms_key_id=""; fi
  echo "  KMS Key ID: ${kms_key_id}" 
 fi
done
echo ""

p_name="all"

while [[ -n $p_name ]]; do
   read -p "Enter the bucket name you want to archive or all. Enter to continue: " p_name
   if [[ -n $p_name ]]; then
     echo "TODO: Archive S3 buckets"
   fi
done
