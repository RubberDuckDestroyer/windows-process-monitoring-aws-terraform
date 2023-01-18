#--------------------------------------------------------------------------
# IAM assumable role
#--------------------------------------------------------------------------
module "app_iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.17.1"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "ec2-role-process-monitoring"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

resource "aws_iam_role_policy" "ec2-porcess-monitoring-policy" {
  name = "ec2-process-monitoring-policy"
  role = module.app_iam_assumable_role.iam_role_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2:CreateTags",
        "Resource" : [
          "arn:aws:ec2:*::snapshot/*",
          "arn:aws:ec2:*::image/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:CreateSnapshot",
          "ec2:CreateImage",
          "ec2:DescribeImages"
        ],
        "Resource" : "*"
      }
    ]
  })
}
