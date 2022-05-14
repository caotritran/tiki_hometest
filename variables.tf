variable "project" {
  type    = string
  default = "celtic-hour-349806"
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "user" {
  type    = string
  default = "centos"
}

variable "pubkey" {
  type    = string
  default = "./id_rsa.pub"
}

variable "private_key" {
  type = string
  default = "./id_rsa"
}