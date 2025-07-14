variable "my_instance_type" {
  type        = string
  default     = "t2.micro"
  
}
variable "client_name" {
  type        = string
  default     = "default"
}
variable "environment" {
  type        = string
  default     = "development"
}

variable "managed_by" {
    type        = string
  default     = "devops"
}