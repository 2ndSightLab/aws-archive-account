#!/bin/bash -e

cat <<'END_TEXT'

***************************
SSM Secrets
***************************

Below is a list of Secrets Manager secrets. You can copy all the secrets or individual
secrets based on the secret name. If encrypted, the KMS key ID is listed as well
and access to the KMS key is required to decrypted and transfer the secret to the
new account.

END_TEXT


aws secretsmanager list-secrets --query "SecretList[*].[Name, KmsKeyId]" --output text \
 --profile $archive_from --region $region

echo ""

p_name="all"

while [[ -n $p_name ]]; do
   read -p "Enter the secret name you want to archive or all. Enter to continue." p_name
   if [[ -n $p_name ]]; then
     echo "TODO: Archive secrets"
   fi
done
