# Create Concourse Server with Application Load Balancer
Terraform module which sets up a very generic concourse CI server.
CoreOS and docker are used in behind.
* Create instance
* Create EC2 role
* Create ALB (with optional SSL binding)


## Usage Example
```hcl
module "concourse" {
  source  = "git::https://github.com/zoitech/terraform-aws-concourse.git?ref=v0.0.5"
  instance_name = "concourse"
  instance_sg_id = "${aws_security_group.group_concourse.id}"
  alb_sg_id = "${aws_security_group.allow_all.id}"
  concourse_username = "concourse"
  concourse_password = "Sup3rS3cur3"
  instance_key_name = "my_key"
  public_sn_a = "subnet-ab123456"
  public_sn_b = "subnet-ab654321"
  private_sn_a = "subnet-bc123456"
  vpc_id = "vpc-98ad1234"
```
To enable access logs for the load balancer, set the parameter "enable_alb_access_logs = true". When set to true, the following parameters should also be configured as shown below:
```hcl
  enable_alb_access_logs = true
  s3_log_bucket_name = "log-log-log-for-logging-test"
  s3_log_bucket_Key_name = "concourse-alb-logs"
  principle_account_id = "054676820928" # See below for more information
  lifecycle_rule_id = "concourse_alb_log_expiration"
  lifecycle_rule_enabled = true
}
```
The account ID for the principle within the bucket policy needs to match the region to allow the load balancer to write the logs to the bucket.

| Region          | Region Name               | Elastic Load Balancing Account ID  |
| --------------- |:-------------------------:| ----------------------------------:|
| us-east-1       | US East (N. Virginia)     | 127311923021                       |
| us-east-2       | US East (Ohio)            | 033677994240                       |
| us-west-1       | US West (N. California)   | 027434742980                       |
| us-west-2       | US West (Oregon)          | 797873946194                       |
| ca-central-1    | Canada (Central)          | 985666609251                       |
| eu-central-1    | EU (Frankfurt)            | 054676820928                       |
| eu-west-1       | EU (Ireland)              | 156460612806                       |
| eu-west-2       | EU (London)               | 652711504416                       |
| eu-west-3       | EU (Paris)                | 009996457667                       |
| ap-northeast-1  | Asia Pacific (Tokyo)      | 582318560864                       |
| ap-northeast-2  | Asia Pacific (Seoul))     | 600734575887                       |
| ap-northeast-3  | Asia Pacific (Osaka-Local)| 383597477331                       |
| ap-southeast-1  |	Asia Pacific (Singapore)  |	114774131450                       |
| ap-southeast-2  |	Asia Pacific (Sydney)	    | 783225319266                       |
| ap-south-1      |	Asia Pacific (Mumbai)	    | 718504428378                       |
| sa-east-1	      | South America (São Paulo) | 507241528517                       |
| us-gov-west-1\* |	AWS GovCloud (US)         |	048591011584                       |
| cn-north-1 \*\* |	China (Beijing)           |	638102146993                       |
| cn-northwest-1 \*\*|	China (Ningxia)       |	037604701340                       |

\* This region requires a separate account. For more information, see AWS GovCloud (US).

\*\* This region requires a separate account. For more information, see China (Beijing).

For updated account IDs with corresponding regions, please refer to: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy

## Authors
Module managed by [Zoi](https://github.com/zoitech).

## License
MIT License. See LICENSE for full details.
