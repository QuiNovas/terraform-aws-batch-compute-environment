variable "availability_zones" {
  description = "The avaiability zones to use for the Cluster subnets, needed if subnets are not passed. So that necessary networking resources are created"
  type        = list(string)
  default     = []
}

variable "availability_zones_count" {
  description = "The number of availability zones, needed if subnets are not passed.  So that necessary networking resources are created"
  type        = number
  default     = 0
}

variable "bid_percentage" {
  type        = number
  description = "Integer of minimum percentage that a Spot Instance price must be when compared with the On-Demand price for that Instance type before instances are launched. For example, if you bid percentage is 20% (20), then the Spot price must be bellow 20% of the current On-Demand price for that EC2 Instance. This parameter is required for SPOT compute environments"
  default     = 100
}

variable "compute_environment_name" {
  type        = string
  description = "The name for your compute environment. Up to 128 letters (uppercase and lowercase), numbers, and underscores are allowed"
}

variable "compute_resources_type" {
  type        = string
  description = "The type of compute environment. Valid items are EC2 or SPOT"
}

variable "cidr_block" {
  description = "The CIDR block for the Compute environment VPC."
  type        = "string"
  default     = "172.16.0.0/16"
}

variable "desired_vcpus" {
  type        = number
  description = "The desired number of EC2 vCPUS in the compute environment, this number must be between min and max vcpus"
  default     = 0
}

variable "ec2_key_pair" {
  type        = string
  description = "The EC2 key pair is used for instances launched in the compute environment"
  default     = ""
}

variable "image_id" {
  type        = string
  description = "The Amazon Machine Image (AMI) ID used for instances launched in the compute environment"
  default     = ""
}

variable "instance_role" {
  type        = string
  description = "The Amazon ECS instance role applied to Amazon EC2 instance in a computed environment, Module will create the role if not provided"
  default     = ""
}

variable "instance_type" {
  type        = list(string)
  description = "A list of instance types that may be launched"
}

variable "launch_template" {
  type = list(object({
    launch_template_id = string #ID of the lauch template
    version            = string #The version number of the template. Default: The default version of the launch template
  }))
  description = "The launch template to use for your compute resource"
  default     = []
}

variable "max_vcpus" {
  type        = string
  description = "The maximum number of EC2 vCPUs that an environment can reach"
}

variable "min_vcpus" {
  type        = string
  description = "The minimum number of EC2 vCPUs that environment should maintain"
}

variable "prefix" {
  type        = string
  description = "Prefix which will be added to names of all the resources"
  default     = ""
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of EC2 security group that are associated with instances launched in the compuite environments"
  default     = []
}

variable "service_role" {
  type        = string
  description = "The full Amazon Resource Name(ARN) of the IAM role that allows AES Batch to make calls to other AWS services on you behalf, If not provided module will create the role"
  default     = ""
}

variable "spot_iam_fleet_role" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the Amazon EC2 Spot Fleet IAM role applied to a SPOT compute environment. This parameter is required for SPOT compute environment. When compute_resources_type is SPOT and if this role arn is not provided then module will create one"
  default     = ""
}

variable "state" {
  type        = string
  description = "The state of the compute environment. If the state id ENABLED, then the compute environment accepts jobs from a queue and can scale out automatically based on queues. Valid items are ENABLED or DISABLED. Default to ENABLED"
  default     = "ENABLED"
}

variable "subnets" {
  type        = list(string)
  description = "A list of VPC subnets into which the compute resources are launched. Module will the necessary networking resources if this variable is not passed"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Key-value pair tags to be applied to resource that are launched in the compute environment"
  default     = {}
}

variable "type" {
  type        = string
  description = "The type of the compute environment. Valid items are MANAGED or UNMANAGED"
}