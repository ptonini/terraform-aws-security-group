variable "vpc" {
  type = object({
    id = string
  })
}

variable "ingress_rules" {
  type = map(object({
    from_port        = number
    to_port          = optional(number)
    protocol         = optional(string, "tcp")
    cidr_blocks      = optional(set(string))
    ipv6_cidr_blocks = optional(set(string))
    prefix_list_ids  = optional(set(string))
    security_groups  = optional(set(string))
    self             = optional(bool)
  }))
  default = {}
}

variable "egress_rules" {
  type = map(object({
    from_port        = number
    to_port          = optional(number)
    protocol         = optional(string, "tcp")
    cidr_blocks      = optional(set(string))
    ipv6_cidr_blocks = optional(set(string))
    prefix_list_ids  = optional(set(string))
    security_groups  = optional(set(string))
    self             = optional(bool)
  }))
  default = {}
}