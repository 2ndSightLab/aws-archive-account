#!/bin/sh
cat <<'END_TEXT'

***************************
SSM Parameters 
***************************

Below is a list of SSM Parameters. You can copy all the parameters or individual
parameters based on the parameter name.  If encrypted, the KMS key ID is listed as well
and access to the KMS key is required to decrypted and transfer the secret to the
new account.

END_TEXT

aws ssm get-parameters-by-path --path "/" --recursive --query "Parameters[*].[Name, KeyId]" \
  --output text --profile $archive_from --region $region

echo ""

p_name="all"

while [[ -n $p_name ]]; do
   read -p "Enter the parameter name you want to archive or all. Enter to continue" p_name
   if [[ -n $p_name ]]; then
     echo "TODO: Archive parameters"
   fi 
done


