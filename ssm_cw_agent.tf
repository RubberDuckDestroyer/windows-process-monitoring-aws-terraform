resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to get notifications for Process monitoring"
  name        = "/example/db/cloudwatch-agent/config"
  type        = "String"
  value       = file("cw_agent.json")
  overwrite = true
}
