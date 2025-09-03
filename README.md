Work in progress. 

Archiving resources from one account to another.

8/21/25 - initial commit is to list the resources I want to archive. Automation is balanced with time it will take vs. manual effort. \
8/23/25 - S3 bucket archive to different account with different KMS key; ami copy working \
8/24/25 - Test ami after creation to make sure it actually works. The problem is the length of time it takes to create an AMI is quite long. Still testing. \
9/1/25 - Added profile for KMS in case KMS keys are in a separate account. Basically archiving all AMIs, S3 buckets and secrets in an account is working. \
9/2/25 - Added ability to apply lifecycle policy to S3 bucket. 
