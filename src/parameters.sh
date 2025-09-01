#!/bin/sh

copy_ssm_parameter(){
  p_from="$1"
  p_to="$2"
  archive_from="$3"
  archive_to="$4"
  region="5"

  echo "todo"
}

cat <<'END_TEXT'

***************************
SSM Parameters 
***************************

END_TEXT

read -p "Do you want to copy any SSM Parameters? (y) :" copy
if [ "$copy" == "y" ]; then 

cat <<'END_TEXT'
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

fi #end copy
copy=""

