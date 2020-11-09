
variable "environment" {
  description = "name of the environment"
}

variable "private_subnet1" {
  description = "aint no description"
}

variable "private_subnet2" {
  description = "aint no description"
}

variable "public_subnet1" {
  description = "aint no description"
}

variable "public_subnet2" {
  description = "aint no description"
}

variable "desired_size"{
  description = "Desired number of nodes for node group"
  default = 2
}

variable "max_size"{
  description = "Max number of nodes for node group"
  default = 3
}

variable "min_size"{
  description = "Min number of nodes for node group"
  default = 1
}