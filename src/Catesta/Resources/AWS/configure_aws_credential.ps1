<#
.SYNOPSIS
    This script is used in AWS CodeBuild to configure the default AWS Credentials for use by the AWS CLI and the AWS Powershell module.
.DESCRIPTION
    By default, the AWS PowerShell Module does not know about looking up an AWS Container's credentials path, so this works around that issue.
.NOTES
    This script enables AWSPowerShell cmdlets in your CodeBuild to interact with and access other AWS resources in your account.
#>
'Configurating AWS credentials'

'  - Retrieving temporary credentials from metadata'
$uri = 'http://169.254.170.2{0}' -f $env:AWS_CONTAINER_CREDENTIALS_RELATIVE_URI
$sts = Invoke-RestMethod -UseBasicParsing -Uri $uri

'  - Setting default AWS Credential'
$credentialsFile = "$env:HOME\.aws\credentials"
$null = New-Item -Path $credentialsFile -Force

'[default]' | Out-File -FilePath $credentialsFile -Append
'aws_access_key_id={0}' -f $sts.AccessKeyId | Out-File -FilePath $credentialsFile -Append
'aws_secret_access_key={0}' -f $sts.SecretAccessKey | Out-File -FilePath $credentialsFile -Append
'aws_session_token={0}' -f $sts.Token | Out-File -FilePath $credentialsFile -Append

'  - Setting default AWS Region'
'region={0}' -f $env:AWS_DEFAULT_REGION | Out-File -FilePath $credentialsFile -Append

'  - AWS credentials configured'