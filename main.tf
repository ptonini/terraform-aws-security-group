resource "aws_security_group" "this" {
  name        = var.name
  vpc_id      = var.vpc.id
  description = null
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      description,
      tags,
      tags_all
    ]
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each                     = var.ingress_rules
  security_group_id            = aws_security_group.this.id
  from_port                    = each.value.from_port
  to_port                      = coalesce(each.value.to_port, each.value.from_port)
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each                     = var.egress_rules
  security_group_id            = aws_security_group.this.id
  from_port                    = each.value.from_port
  to_port                      = coalesce(each.value.to_port, each.value.from_port)
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}