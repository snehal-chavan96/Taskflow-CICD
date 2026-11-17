
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "allowed_cidr" {
  description = "Your public IP address in CIDR notation"
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_cidr, 0))
    error_message = "Enter a valid CIDR block, such as 223.233.82.27/32."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the new TaskFlow public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for TaskFlow public subnet"
  type        = string
}
