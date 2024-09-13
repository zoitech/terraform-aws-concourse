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
  instance_sg_id = aws_security_group.group_concourse.id
  alb_sg_id = aws_security_group.allow_all.id
  concourse_username = "concourse"
  concourse_password = "Sup3rS3cur3"
  instance_key_name = "my_key"
  public_sn_a = "subnet-ab123456"
  public_sn_b = "subnet-ab654321"
  private_sn_a = "subnet-bc123456"
  vpc_id = "vpc-98ad1234"
  instance_volume_size = "200" #default 60
  instance_ami = "ami-fo33w5t"
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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_event_subscription.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_instance_profile.ec2_role_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_role_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ec2_docker_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lb.concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.concource_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.concource_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_object.concourse_alb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.GroupLB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.GroupWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.RuleGroupLBHttpIn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.RuleGroupWsIn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_string.concourse_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_alb_loggin_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_sg_id"></a> [alb\_sg\_id](#input\_alb\_sg\_id) | The Security Group ID/s which should be attached to the Loadbalancer. | `list(string)` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the certificate. | `string` | `""` | no |
| <a name="input_concourse_db_size"></a> [concourse\_db\_size](#input\_concourse\_db\_size) | Size of the DB Instance. | `string` | `"db.t2.micro"` | no |
| <a name="input_concourse_db_storage"></a> [concourse\_db\_storage](#input\_concourse\_db\_storage) | Size of the DB Disk. | `string` | `"100"` | no |
| <a name="input_concourse_external_url"></a> [concourse\_external\_url](#input\_concourse\_external\_url) | The external URL (including http://) of the Concourse server. | `string` | `""` | no |
| <a name="input_concourse_password"></a> [concourse\_password](#input\_concourse\_password) | The Password for the default user on the Concourse Server. | `string` | `""` | no |
| <a name="input_concourse_username"></a> [concourse\_username](#input\_concourse\_username) | The Username for the default user on the Concourse Server. | `string` | `"concourse"` | no |
| <a name="input_concourse_version"></a> [concourse\_version](#input\_concourse\_version) | The Concourse version to launch. | `string` | `"3.4.1"` | no |
| <a name="input_enable_alb_access_logs"></a> [enable\_alb\_access\_logs](#input\_enable\_alb\_access\_logs) | Turn alb access logs on or off. | `bool` | `false` | no |
| <a name="input_enable_special_char_in_random_password"></a> [enable\_special\_char\_in\_random\_password](#input\_enable\_special\_char\_in\_random\_password) | Enable special characters in random password. | `bool` | `false` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | ami | `any` | n/a | yes |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | The SSH key to use for connecting to the instance. | `any` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the Instance. | `string` | `"concourse"` | no |
| <a name="input_instance_sg_id"></a> [instance\_sg\_id](#input\_instance\_sg\_id) | The Security Group ID/s which should be attached to the Instance. | `list(string)` | n/a | yes |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | The size of the Instance's disk. | `string` | `"t2.medium"` | no |
| <a name="input_instance_volume_size"></a> [instance\_volume\_size](#input\_instance\_volume\_size) | Custom volume size for concourse | `string` | `"60"` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | To enable the lifecycle rule | `bool` | `false` | no |
| <a name="input_lifecycle_rule_expiration"></a> [lifecycle\_rule\_expiration](#input\_lifecycle\_rule\_expiration) | Delete log files X days after creation | `number` | `90` | no |
| <a name="input_lifecycle_rule_id"></a> [lifecycle\_rule\_id](#input\_lifecycle\_rule\_id) | Name of the lifecyle rule id. | `string` | `"rule1"` | no |
| <a name="input_lifecycle_rule_prefix"></a> [lifecycle\_rule\_prefix](#input\_lifecycle\_rule\_prefix) | Lifecycle rule prefix. | `string` | `""` | no |
| <a name="input_postgres_family"></a> [postgres\_family](#input\_postgres\_family) | The Postgres Family to use. | `string` | `"postgres9.5"` | no |
| <a name="input_postgres_multiaz"></a> [postgres\_multiaz](#input\_postgres\_multiaz) | n/a | `string` | `"0"` | no |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | The Password for the Postgres database. | `string` | `""` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | The Username for the Postgres database. | `string` | `"dbadmin"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | The Postgres Version to use. | `string` | `"9.5.10"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix which is added to each ressource. | `string` | `"prod"` | no |
| <a name="input_principle_account_id"></a> [principle\_account\_id](#input\_principle\_account\_id) | Set principle account ID for the region | `string` | `"156460612806"` | no |
| <a name="input_private_sn"></a> [private\_sn](#input\_private\_sn) | The Public Subnets in which the EC2 Instance should be created. | `list(string)` | n/a | yes |
| <a name="input_public_sn"></a> [public\_sn](#input\_public\_sn) | The Public Subnets in which the LB should be created. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to run in. | `string` | `"eu-west-1"` | no |
| <a name="input_role_policies"></a> [role\_policies](#input\_role\_policies) | The policies which would be attached to the EC2 Role. | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AdministratorAccess"<br>]</pre> | no |
| <a name="input_s3_log_bucket_Key_name"></a> [s3\_log\_bucket\_Key\_name](#input\_s3\_log\_bucket\_Key\_name) | Name of the folder to store logs in the bucket. | `string` | `""` | no |
| <a name="input_s3_log_bucket_name"></a> [s3\_log\_bucket\_name](#input\_s3\_log\_bucket\_name) | Name of the logs bucket. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC Id in which the EC2 Instance should be created. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_alb_name"></a> [alb\_name](#output\_alb\_name) | n/a |
| <a name="output_concourse_password"></a> [concourse\_password](#output\_concourse\_password) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_postgres_password"></a> [postgres\_password](#output\_postgres\_password) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->