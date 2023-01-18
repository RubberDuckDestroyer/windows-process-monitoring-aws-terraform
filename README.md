# Windows process monitoring example

## Description

* **NOTE: THIS REPO CREATES A t3.XLARGE INSTANCE FOR WHICH YOU MAY INCUR COSTS ON AWS**
* This repo creates an ec2 instance which acts as a windows sql server (AMI: WindowsSQL 2019 Basic); a custom cloudwatch agent congifured to send process ID and memory (vss, rss) info to cloudwatch ; cloudwatch alarms; SNS Topic that will email you if the process starts/stops

## How to deploy

* Clone this project
* Create a `terraform.tfvars` file locally and add the following values:

```{}
subnet_id = "your-public-subnet-id"
vpc_id = "your-vpc-id"
whitelist_cidr_ip = "your-ip-to-whitelists"
email_endpoint = "alerts-go-here@email.com"
```

* The email endpoint will send a SNS topic confirmation to your desired email before sending you alerts about the process.

* In the cw_agent.json, update line #16 to include the exe name of the process you want to monitor. By default this is set up for the MSSQL process

```{json}
{
    "exe": "my-custom-exe",
    "measurement": [
        "pid",
        "memory_vms",
        "memory_rss"
    ]
}
```

* Make sure you have the right aws creds loaded on your aws profile/cli.
* Deploy the code using terrform.

## Test using SSM Agent

1. Once deployed, connect to the EC2 Instance with SSM. Run the following command(s)

    * Powershell:

    ```{ps}
    $DfltInstance = $Wmi.Services['MSSQLSERVER']
    # Display the state of the service.
    $DfltInstance
    # Stop the service.
    $DfltInstance.Stop();
    # Display the state of the service.
    $DfltInstance
    # Start the service.
    $DfltInstance.Start();
    # Display the state of the service.
    $DfltInstance
    ```

    OR

    * Command Prompt

    ```{}
    net stop "SQL Server (MSSQLSERVER)"
    net start "SQL Server (MSSQLSERVER)"
    ```

## Cleanup

* Run `terraform destroy` in your cli.

## Additional Reading

* [AWS: Using the procstat plugin with the cloudwatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-procstat-process-metrics.html), https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-procstat-process-metrics.html
