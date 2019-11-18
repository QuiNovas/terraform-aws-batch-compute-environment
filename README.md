
# AWS Batch Compute Environment Terraform Module

Creates a AWS Batch compute environment. Compute environments contain the Amazon ECS container instances that are used to run containerized batch jobs.

* [Terraform documentation](https://www.terraform.io/docs/providers/aws/r/batch_compute_environment.html)

## Terraform versions

Terraform 0.12

## Usage

### with out passing any subnets
```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

module "batch_compute_environment" {
  source = "QuiNovas/batch-compute-environment/aws"

  availability_zones       = data.aws_availability_zones.available.names
  cidr_block               = "172.16.0.0/16"
  compute_resources_type   = "SPOT"
  desired_vcpus            = 1
  instance_type            = ["optimal"]
  max_vcpus                = 16
  min_vcpus                = 1
  desired_vcpus            = 1
  spot_iam_fleet_role      = "arn:aws:iam:1234567890:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2SpotFleet"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
### with passing subnets
```hcl
module "batch_compute_environment" {
  source = "QuiNovas/batch-compute-environment/aws"
  
  compute_resources_type   = "SPOT"
  desired_vcpus            = 1  
  instance_type            = ["optimal"]
  max_vcpus                = 16
  min_vcpus                = 1
  name                     = "test-terraform"
  security_group_ids       = ["sg-1fd1106f"]
  subnets                  = ["subnet-a59faaed", "subnet-60eef25c"]
  spot_iam_fleet_role      = "arn:aws:iam:1234567890:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2SpotFleet"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

## Service Roles

By default this module will provision new service roles for batch, ec2 and spot fleet if they are not passed through variables.

## Network Resources

This module will create a VPC, a Internet Gateway, 2 or 3 Private subnets (one per az), 2 or 3 Public subnets (one per az), with 2 or 3 NATs in there respective az's/public subnets (along with necessary routing) If subnets are not passed in.

The subnets are created by using 4 bits for masking on the given CIDR.
A list of `availability_zones` is necessary if you want the vpc and other network resources are created by module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones | The avaiability zones for the subnets of compute environment, Required if subnets created outside the module are not passed in. So that necessary networking resources are created | list(string) | `[]` | no |
| bid\_percentage | Integer of minimum percentage that a Spot Instance price must be when compared with the On-Demand price for that Instance type before instances are launched. For example, if you bid percentage is 20% (20), then the Spot price must be bellow 20% of the current On-Demand price for that EC2 Instance. This parameter is required for SPOT compute environments | number | `100` | no |
| cidr\_block | The CIDR block for the Compute environment VPC | string | `"192.168.0.0/16"` | no |
| compute\_resources\_type | The type of compute environment. Valid items are EC2 or SPOT | string | | yes |
| desired\_vcpus | The desired number of EC2 vCPUS in the compute environment | number | `0` | no |
| ec2\_key\_pair | The EC2 key pair is used for instances launched in the compute environment | string | `""` | no |
| image\_id | The Amazon Machine Image (AMI) ID used for instances launched in the compute environment | string | `""` | no |
| instance\_role | The Amazon ECS instance role applied to Amazon EC2 instance in a computed environment, Module will create the role if not provided | string | `""` | no |
| instance\_type | A list of instance types that may be launched | list(string) | | yes |
| launch\_template | The launch template to use for your compute resource | list(object({launch\_template\_id, version })) | `[]` | no |
| launch\_template\_id| Child variable of launch template Object | string | `""` | no |
| version | Child variable of launch template Object | string | `""` | no |
| max\_vcpus | The maximum number of EC2 vCPUs that an environment can reach | string |  | yes |
| min\_vcpus | The minimum number of EC2 vCPUs that environment should maintain | string | | yes |
| name | The name of resources created, used either directly or as a prefix | string | | yes |
| security\_group\_ids | A list of EC2 security group that are associated with instances launched in the compuite environments | list(string) | | yes |
| service\_role | The full Amazon Resource Name(ARN) of the IAM role that allows AES Batch to make calls to other AWS services on you behalf, If not provided module will create the role | string | `""` | no |
| spot\_iam\_fleet\_role | The Amazon Resource Name (ARN) of the Amazon EC2 Spot Fleet IAM role applied to a SPOT compute environment. This parameter is required for SPOT compute environment. When compute\_resources\_type is SPOT and if this role arn is not provided then module will create one | string | `""` | no |
| state | The state of the compute environment. If the state id ENABLED, then the compute environment accepts jobs from a queue and can scale out automatically based on queues. Valid items are ENABLED or DISABLED. Default to ENABLED | string | `"ENABLED"` | no |
| subnets | A list of VPC subnets into which the compute resources are launched. | list(string) | `[]` | no |
| tags | Key-value pair tags to be applied to resource that are launched in the compute environment | map(string) | `{}` | no |
| type | The type of the compute environment. Valid items are MANAGED or UNMANAGED | string | | yes |


## Outputs

| Name | Description |
|------|-------------|
| arn | The arn of the created batch compute environment |


## Authors

Module is maintained by [QuiNovas](https://github.com/QuiNovas)