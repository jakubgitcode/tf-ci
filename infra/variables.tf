variable "environment" {
  description = "Nazwa środowiska (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Środowisko musi być: dev, test lub prod."
  }
}

variable "location" {
  description = "Region Azure"
  type        = string
  default     = "Poland Central"
}

variable "project_name" {
  description = "Nazwa projektu"
  type        = string
  default     = "cross-repo"
}

variable "vnet_address_space" {
  description = "Przestrzeń adresowa VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Mapa podsieci"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tagi wspólne"
  type        = map(string)
  default     = {}
}
