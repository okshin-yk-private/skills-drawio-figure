# Terraform Resource → Draw.io Shape Mapping

This file maps Terraform AWS resource types to their corresponding draw.io mxgraph shape identifiers.
The mapping follows the AWS Architecture Icons Release 22-2025.07.31.

## Shape Types in Draw.io

There are two icon types in the AWS4 shape library:

### Service Icons (large, with gradient background)
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.{name}
```
- Size: 48x48 or 64x64 (recommend 48x48 for diagrams)
- Have gradient fill and white stroke
- Use `fillColor` and `gradientColor` per category

### Resource Icons (small, flat)
```
shape=mxgraph.aws4.{name}
```
- Size: 40x40
- Flat colored icons without gradient background
- Represent sub-resources of a service

## Category Color Reference

Each AWS service category has assigned colors for fillColor/gradientColor:

| Category                         | fillColor | gradientColor |
|----------------------------------|-----------|---------------|
| Compute                          | #ED7100   | #F78E04       |
| Storage                          | #3F8624   | #60A337       |
| Database                         | #C925D1   | #F15AEF       |
| Networking & Content Delivery    | #8C4FFF   | #BF80FF       |
| Security, Identity & Compliance  | #DD344C   | #FF6680       |
| Management & Governance          | #E7157B   | #FF4F8B       |
| Application Integration          | #E7157B   | #FF4F8B       |
| Analytics                        | #8C4FFF   | #BF80FF       |
| Developer Tools                  | #C7131F   | #F34482       |
| Containers                       | #ED7100   | #F78E04       |
| Serverless                       | #ED7100   | #F78E04       |
| Front-End Web & Mobile           | #C7131F   | #F34482       |
| IoT                              | #3F8624   | #60A337       |
| General                          | #232F3E   | none          |

## Mapping Table

### Compute

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_instance                    | resIcon=mxgraph.aws4.ec2             | Amazon EC2                   |
| aws_launch_template             | resIcon=mxgraph.aws4.ec2             | Amazon EC2                   |
| aws_autoscaling_group           | (use Auto Scaling group GROUP)       | EC2 Auto Scaling             |
| aws_lambda_function             | resIcon=mxgraph.aws4.lambda          | AWS Lambda                   |
| aws_lightsail_instance          | resIcon=mxgraph.aws4.lightsail       | Amazon Lightsail             |
| aws_elastic_beanstalk_environment | resIcon=mxgraph.aws4.elastic_beanstalk | AWS Elastic Beanstalk     |
| aws_batch_job_definition        | resIcon=mxgraph.aws4.batch           | AWS Batch                    |
| aws_apprunner_service           | resIcon=mxgraph.aws4.app_runner      | AWS App Runner               |

### Containers

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_ecs_cluster                 | resIcon=mxgraph.aws4.ecs             | Amazon ECS                   |
| aws_ecs_service                 | shape=mxgraph.aws4.ecs_service       | ECS Service                  |
| aws_ecs_task_definition         | shape=mxgraph.aws4.ecs_task          | ECS Task                     |
| aws_eks_cluster                 | resIcon=mxgraph.aws4.eks             | Amazon EKS                   |
| aws_ecr_repository              | resIcon=mxgraph.aws4.ecr             | Amazon ECR                   |
| aws_ecs_cluster (Fargate)       | resIcon=mxgraph.aws4.fargate         | AWS Fargate                  |

### Networking & Content Delivery

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_vpc                         | (use VPC GROUP, not icon)            | VPC                          |
| aws_subnet                      | (use Subnet GROUP, not icon)         | Public/Private Subnet        |
| aws_internet_gateway            | resIcon=mxgraph.aws4.internet_gateway | Internet gateway            |
| aws_nat_gateway                 | resIcon=mxgraph.aws4.nat_gateway     | NAT gateway                  |
| aws_lb (ALB)                    | resIcon=mxgraph.aws4.application_load_balancer | Application Load Balancer |
| aws_lb (NLB)                    | resIcon=mxgraph.aws4.network_load_balancer | Network Load Balancer  |
| aws_lb (GLB)                    | resIcon=mxgraph.aws4.gateway_load_balancer | Gateway Load Balancer  |
| aws_cloudfront_distribution     | resIcon=mxgraph.aws4.cloudfront      | Amazon CloudFront            |
| aws_route53_zone                | resIcon=mxgraph.aws4.route_53        | Amazon Route 53              |
| aws_route53_record              | shape=mxgraph.aws4.route_table       | Route 53 Record              |
| aws_vpn_gateway                 | resIcon=mxgraph.aws4.vpn_gateway     | VPN gateway                  |
| aws_customer_gateway            | resIcon=mxgraph.aws4.customer_gateway | Customer gateway            |
| aws_vpn_connection              | (arrow with label)                   | Site-to-Site VPN             |
| aws_ec2_transit_gateway         | resIcon=mxgraph.aws4.transit_gateway | AWS Transit Gateway          |
| aws_vpc_endpoint                | resIcon=mxgraph.aws4.vpc_endpoints   | VPC endpoint                 |
| aws_api_gateway_rest_api        | resIcon=mxgraph.aws4.api_gateway     | Amazon API Gateway           |
| aws_apigatewayv2_api            | resIcon=mxgraph.aws4.api_gateway     | Amazon API Gateway           |
| aws_globalaccelerator_accelerator | resIcon=mxgraph.aws4.global_accelerator | AWS Global Accelerator  |
| aws_dx_connection               | resIcon=mxgraph.aws4.direct_connect  | AWS Direct Connect           |
| aws_eip                         | shape=mxgraph.aws4.elastic_ip_address | Elastic IP                  |
| aws_vpc_peering_connection      | (arrow with label)                   | VPC Peering                  |

### Database

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_db_instance                 | resIcon=mxgraph.aws4.rds             | Amazon RDS                   |
| aws_rds_cluster                 | resIcon=mxgraph.aws4.aurora          | Amazon Aurora                |
| aws_dynamodb_table              | resIcon=mxgraph.aws4.dynamodb        | Amazon DynamoDB              |
| aws_elasticache_cluster         | resIcon=mxgraph.aws4.elasticache     | Amazon ElastiCache           |
| aws_elasticache_replication_group | resIcon=mxgraph.aws4.elasticache   | Amazon ElastiCache           |
| aws_redshift_cluster            | resIcon=mxgraph.aws4.redshift        | Amazon Redshift              |
| aws_neptune_cluster             | resIcon=mxgraph.aws4.neptune         | Amazon Neptune               |
| aws_docdb_cluster               | resIcon=mxgraph.aws4.documentdb_with_mongodb_compatibility | Amazon DocumentDB |
| aws_memorydb_cluster            | resIcon=mxgraph.aws4.memorydb_for_redis | Amazon MemoryDB          |
| aws_timestream_database         | resIcon=mxgraph.aws4.timestream      | Amazon Timestream            |

### Storage

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_s3_bucket                   | resIcon=mxgraph.aws4.s3              | Amazon S3                    |
| aws_efs_file_system             | resIcon=mxgraph.aws4.elastic_file_system | Amazon EFS              |
| aws_fsx_lustre_file_system      | resIcon=mxgraph.aws4.fsx             | Amazon FSx                   |
| aws_fsx_windows_file_system     | resIcon=mxgraph.aws4.fsx_for_windows_file_server | Amazon FSx     |
| aws_ebs_volume                  | shape=mxgraph.aws4.volume            | Amazon EBS                   |
| aws_s3_bucket_object            | shape=mxgraph.aws4.bucket            | S3 Bucket                    |
| aws_backup_vault                | resIcon=mxgraph.aws4.backup          | AWS Backup                   |

### Application Integration

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_sqs_queue                   | resIcon=mxgraph.aws4.sqs             | Amazon SQS                   |
| aws_sns_topic                   | resIcon=mxgraph.aws4.sns             | Amazon SNS                   |
| aws_sfn_state_machine           | resIcon=mxgraph.aws4.step_functions  | AWS Step Functions           |
| aws_cloudwatch_event_rule       | resIcon=mxgraph.aws4.eventbridge     | Amazon EventBridge           |
| aws_scheduler_schedule          | resIcon=mxgraph.aws4.eventbridge     | Amazon EventBridge Scheduler |
| aws_mq_broker                   | resIcon=mxgraph.aws4.mq              | Amazon MQ                    |
| aws_appsync_graphql_api         | resIcon=mxgraph.aws4.appsync         | AWS AppSync                  |

### Security, Identity & Compliance

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_security_group              | (use Security Group GROUP)           | Security group               |
| aws_wafv2_web_acl               | resIcon=mxgraph.aws4.waf             | AWS WAF                      |
| aws_shield_protection           | resIcon=mxgraph.aws4.shield          | AWS Shield                   |
| aws_kms_key                     | resIcon=mxgraph.aws4.kms             | AWS KMS                      |
| aws_secretsmanager_secret       | resIcon=mxgraph.aws4.secrets_manager | AWS Secrets Manager          |
| aws_acm_certificate             | resIcon=mxgraph.aws4.certificate_manager | AWS Certificate Manager  |
| aws_cognito_user_pool           | resIcon=mxgraph.aws4.cognito         | Amazon Cognito               |
| aws_guardduty_detector          | resIcon=mxgraph.aws4.guardduty       | Amazon GuardDuty             |
| aws_inspector2_enabler          | resIcon=mxgraph.aws4.inspector       | Amazon Inspector             |

### Management & Governance

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_cloudwatch_log_group        | resIcon=mxgraph.aws4.cloudwatch      | Amazon CloudWatch            |
| aws_cloudwatch_metric_alarm     | shape=mxgraph.aws4.alarm             | CloudWatch Alarm             |
| aws_cloudtrail                  | resIcon=mxgraph.aws4.cloudtrail      | AWS CloudTrail               |
| aws_config_configuration_recorder | resIcon=mxgraph.aws4.config        | AWS Config                   |
| aws_ssm_parameter               | resIcon=mxgraph.aws4.systems_manager | AWS Systems Manager          |
| aws_organizations_account       | (use AWS Account GROUP)              | AWS Account                  |

### Analytics

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_kinesis_stream              | resIcon=mxgraph.aws4.kinesis         | Amazon Kinesis               |
| aws_kinesis_firehose_delivery_stream | resIcon=mxgraph.aws4.kinesis_data_firehose | Amazon Data Firehose |
| aws_glue_catalog_database       | resIcon=mxgraph.aws4.glue            | AWS Glue                     |
| aws_athena_workgroup            | resIcon=mxgraph.aws4.athena          | Amazon Athena                |
| aws_opensearch_domain           | resIcon=mxgraph.aws4.opensearch_service | Amazon OpenSearch Service |
| aws_quicksight_data_source      | resIcon=mxgraph.aws4.quicksight      | Amazon QuickSight            |
| aws_msk_cluster                 | resIcon=mxgraph.aws4.managed_streaming_for_kafka | Amazon MSK     |

### AI/ML

| Terraform Resource              | draw.io resIcon / shape              | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| aws_sagemaker_endpoint          | resIcon=mxgraph.aws4.sagemaker       | Amazon SageMaker AI          |
| aws_bedrock_model_invocation    | resIcon=mxgraph.aws4.bedrock         | Amazon Bedrock               |

### General / External

| Element                         | draw.io shape                        | Label                        |
|---------------------------------|--------------------------------------|------------------------------|
| Internet / Users                | shape=mxgraph.aws4.users             | Users                        |
| On-premises server              | shape=mxgraph.aws4.traditional_server | On-premises                 |
| Corporate data center           | (use Corporate data center GROUP)    | Corporate data center        |
| Generic external                | shape=mxgraph.aws4.internet_alt2     | Internet                     |
| Client                          | shape=mxgraph.aws4.client            | Client                       |
| Mobile client                   | shape=mxgraph.aws4.mobile_client     | Mobile client                |

## Notes

- If a Terraform resource type is not in this table, search for the closest AWS service match
  in the draw.io AWS4 library. The naming convention is generally:
  `mxgraph.aws4.{service_name_in_snake_case}`
- When in doubt, use `shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.generic_application`
  as a fallback and annotate with the correct service name
- draw.io shape names may not perfectly match AWS service names — always test the shape renders correctly
- For the latest draw.io AWS shape names, refer to the built-in AWS19 library in draw.io