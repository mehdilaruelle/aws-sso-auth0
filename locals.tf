locals {
  tags = merge(
    var.tags,
    {
      "Name" : local.name
      "Environment" : lower(var.env),
      "FQN" : local.fqn
    }
  )
}
