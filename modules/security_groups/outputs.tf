output "security_groups" {
  description = "Map of AWS security group resources indexed by their Terraform identifier"
  value = tomap({
    for name, description in var.security_groups: name => aws_security_group.security_groups[name]
    if contains(keys(aws_security_group.security_groups), name)
  })
}

output "security_group_ids" {
  value = tomap({
    for name, description in var.security_groups: name => aws_security_group.security_groups[name].id
    if contains(keys(aws_security_group.security_groups), name)
  })
}

output "security_group_arns" {
  value = tomap({
    for name, description in var.security_groups: name => aws_security_group.security_groups[name].arn
    if contains(keys(aws_security_group.security_groups), name)
  })
}
