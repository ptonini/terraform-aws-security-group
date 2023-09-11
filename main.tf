locals {
  builtin_rules = {
    all           = { from_port = 0, protocol = -1 }
    http          = { from_port = 80 }
    https         = { from_port = 443 }
    ping          = { from_port = 8, to_port = 0, protocol = "icmp" }
    ssh           = { from_port = 22 }
    nodeports_tcp = { protocol = "tcp", from_port = 30000, to_port = 32767 }
    nodeports_udp = { protocol = "udp", from_port = 30000, to_port = 32767 }
    mongodb       = { from_port = 27017 }
    postgres      = { from_port = 5432 }
    mysql         = { from_port = 3306 }
  }
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc.id
  description = null
  dynamic "ingress" {
    for_each = merge(var.ingress_rules, { for r in var.builtin_ingress_rules : r => local.builtin_rules[r] })
    content {
      from_port        = ingress.value["from_port"]
      to_port          = try(ingress.value["to_port"], ingress.value["from_port"])
      protocol         = try(ingress.value["protocol"], "tcp")
      cidr_blocks      = try(ingress.value["cidr_blocks"], ["0.0.0.0/0"])
      ipv6_cidr_blocks = try(ingress.value["ipv6_cidr_blocks"], ["::/0"])
      prefix_list_ids  = try(ingress.value["prefix_list_ids"], [])
      security_groups  = try(ingress.value["security_groups"], [])
    }
  }
  dynamic "egress" {
    for_each = merge(var.egress_rules, { for r in var.builtin_egress_rules : r => local.builtin_rules[r] })
    content {
      from_port        = egress.value["from_port"]
      to_port          = try(egress.value["to_port"], egress.value["from_port"])
      protocol         = egress.value["protocol"]
      cidr_blocks      = try(egress.value["cidr_blocks"], ["0.0.0.0/0"])
      ipv6_cidr_blocks = try(egress.value["ipv6_cidr_blocks"], ["::/0"])
      prefix_list_ids  = try(egress.value["prefix_list_ids"], [])
      security_groups  = try(egress.value["security_groups"], [])
    }
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      description,
      tags,
      tags_all
    ]
  }
}