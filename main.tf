#----
# EC2 Instance
#----
module "aws_ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "3.5.0"
    
    name = "windows-process-monitoring-sql-example"
    depends_on = [aws_ssm_parameter.cw_agent]

    ami = var.ami_id
    instance_type = "t3.xlarge"
    subnet_id = var.subnet_id
    availability_zone = "ap-southeast-2a"
    associate_public_ip_address = true
    vpc_security_group_ids = [module.db_server_sg.security_group_id]
    disable_api_termination = true
    iam_instance_profile = module.app_iam_assumable_role.iam_instance_profile_id
    user_data_base64 = base64encode(local.user_data)

    key_name = "windows-proc-monitor-kp" # AWS Key Pair Key name

    enable_volume_tags = false
    root_block_device = [
      {
        volume_type = "gp2"
        volume_size = 65
        encrypted = false
      }
    ]
}

# Security group
module "db_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "windows-procstat-example-db-sg"
  description = "Security group for Windows Process Monitoring example"
  vpc_id      = var.vpc_id


  ingress_with_cidr_blocks = [
    {
      rule        = "rdp-tcp"
      cidr_blocks = var.whitelist_cidr_ip
      description = "remote administration"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
      description = "Testing only"

    }
  ]

}

# SNS Topic for monitoring
module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "5.0.0"

  name = "process-monitoring-alerts"

  subscriptions = {
    email = {
      protocol = "email"
      endpoint = var.email_endpoint
    }
  }
}
