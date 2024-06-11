# Server variables
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "ami_version" {
  description = "The AMI version to use"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "instance_tag" {
  description = "The tag for the instance"
  type        = map(string)
  default = {
    Name    = "App server"
    Owner   = "Maksims"
    Project = "Task assigment"
  }
}

variable "server_owner" {
  description = "The owner of the server"
  type        = string
  default     = "Maksims's"
}

# Bucket variables
variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
  default     = "ubuntu-server-bucket-321"

}
variable "bucket_tag" {
  description = "The tag for the bucket"
  type        = map(string)
  default = {
    Name        = "Bucket for ubuntu server"
    Environment = "Production"
  }
}

# Security group variables
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "allow"
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = "Allow connection"
}

variable "egress_port_list" {
  description = "The list of egress ports to allow"
  type        = list(string)
  default     = ["0"]
}

variable "ingress_port_list" {
  description = "The list of ingress ports to allow"
  type        = list(string)
  default     = ["22", "80", "443", "8080"]
}
