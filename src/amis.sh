#!/bin/bash -e

cat <<'END_TEXT'

***************************
EC2 AMIs (Amamazon Machine Images)
***************************

Below is a list of Amazon Machine Images in this account which can be used to 
start new EC2 instances. Note that if the AMI is encrypted, the user trying
to start a new image from the AMI will need permission to use the associated
KMS key.

END_TEXT

aws ec2 describe-images \
  --owners self \
  --profile $archive_from \
  --region $region \
  --query 'Images[*].{Name: Name, ImageId: ImageId, Snapshots: BlockDeviceMappings[?Ebs.Encrypted==`true`].Ebs.SnapshotId}' \
  --output json \
| jq -r '.[] | "\(.Name),\(.ImageId),\(.Snapshots[] // "N/A")" ' \
| while IFS=, read -r ami_name ami_id snapshot_id; do
    if [[ "${snapshot_id}" == "N/A" ]]; then
        echo "AMI Name: ${ami_name}, AMI ID: ${ami_id}, KMS Key ID: No encryption/KMS key used"
    else
        kms_key_id=$(aws ec2 describe-snapshots \
          --snapshot-ids "${snapshot_id}" \
          --profile $archive_from \
          --region $region \
          --query "Snapshots[*].KmsKeyId" \
          --output text 2>/dev/null)
        if [[ -z "${kms_key_id}" ]]; then
            kms_key_id="Default/AWS managed key"
        fi
        echo "AMI Name: ${ami_name}, AMI ID: ${ami_id}, KMS Key ID: ${kms_key_id}"
    fi
done

echo ""

p_name="all"

while [[ -n $p_name ]]; do
   read -p "Enter the AMI name you want to archive or all. Enter to continue." p_name
   if [[ -n $p_name ]]; then
     echo "TODO: Archive AMIs."
   fi
done
