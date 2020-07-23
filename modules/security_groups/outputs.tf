output "security_groups" {
  description = "Map of AWS security group resources indexed by their Terraform identifier"
  value = tomap({
    for name, description in var.security_groups: name => aws_security_group.security_groups[name]
  })
}

output "security_group_ids" {
  value = tomap({
    for name, description in var.security_groups:
      name => aws_security_group.security_groups[name].id
  })
}

output "security_group_arns" {
  value = tomap({
    for name, description in var.security_groups:
      name => aws_security_group.security_groups[name].arn
  })
}
