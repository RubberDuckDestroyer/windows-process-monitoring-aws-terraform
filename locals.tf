locals {
    region = "ap-southeast-2"

    user_data = <<EOT
    <powershell>
        ## CW Agent install
        c:
        mkdir c:\temp
        cd \temp

        Invoke-WebRequest -Uri https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi -OutFile c:\temp\amazon-cloudwatch-agent.msi
        & msiexec /i "c:\temp\amazon-cloudwatch-agent.msi" /l*v "cw_agent_install.log"
        Start-Sleep -Seconds 60
        & $env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:/example/db/cloudwatch-agent/config -s
        
    </powershell>
    EOT
}