environment = "prod"
location    = "Poland Central"

vnet_address_space = ["10.30.0.0/16"]

subnets = {
  app  = { address_prefixes = ["10.30.1.0/24"] }
  db   = { address_prefixes = ["10.30.2.0/24"] }
  mgmt = { address_prefixes = ["10.30.3.0/24"] }
  test = { address_prefixes = ["10.30.4.0/24"] }
}

tags = {
  Owner      = "team-platform"
  CostCenter = "CC-PROD"
  Compliance = "required"
}
