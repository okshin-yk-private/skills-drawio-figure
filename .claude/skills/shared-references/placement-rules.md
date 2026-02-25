# AWS Resource Placement Rules

This document defines which AWS resources belong inside which group boundaries in an architecture
diagram. Correct placement is critical for producing accurate, non-misleading diagrams.

## Placement Decision Flowchart

```
1. Does the Terraform resource have `subnet_id` / `subnet_ids`?
   YES → Place inside the corresponding Subnet group
   NO  → Go to 2

2. Does the resource have `vpc_id`?
   YES → Place inside the VPC group (but outside any Subnet)
   NO  → Go to 3

3. Is the resource type a "conditionally VPC" service?
   (See "Conditionally VPC-Based" table below)
   YES → Check for the vpc_config/network_configuration block
         Present → Place inside VPC (in subnet if subnet specified)
         Absent  → Place outside VPC at Region level
   NO  → Go to 4

4. Is the resource type a "VPC-internal" service?
   (See "Always VPC-Internal" table below)
   YES → Place inside VPC (resolve placement from related resources)
   NO  → Go to 5

5. Is the resource type a "Regional" service?
   YES → Place inside Region but outside VPC
   NO  → Go to 6

6. Is the resource type a "Global" service?
   YES → Place outside Region (at AWS Cloud level or outside AWS Cloud)
   NO  → Place at Region level by default
```

## Always VPC-Internal Resources

These resources always exist inside a VPC. Even if `vpc_id` is not directly on the resource,
trace the dependency chain to find the VPC.

| Terraform Resource                | How to find VPC                              |
|-----------------------------------|----------------------------------------------|
| aws_subnet                        | Direct `vpc_id` attribute                    |
| aws_security_group                | Direct `vpc_id` attribute                    |
| aws_network_interface             | `subnet_id` → subnet → VPC                  |
| aws_instance                      | `subnet_id` → subnet → VPC                  |
| aws_db_instance                   | `db_subnet_group_name` → subnet group → VPC |
| aws_db_subnet_group               | `subnet_ids` → subnets → VPC                |
| aws_elasticache_cluster           | `subnet_group_name` → subnet group → VPC    |
| aws_elasticache_subnet_group      | `subnet_ids` → subnets → VPC                |
| aws_lb                            | `subnets` or `subnet_mapping` → subnets → VPC |
| aws_lb_target_group               | Direct `vpc_id` attribute                    |
| aws_nat_gateway                   | `subnet_id` → subnet → VPC                  |
| aws_internet_gateway              | `vpc_id` (via aws_internet_gateway_attachment) |
| aws_vpn_gateway                   | `vpc_id` (via aws_vpn_gateway_attachment)    |
| aws_route_table                   | Direct `vpc_id` attribute                    |
| aws_network_acl                   | Direct `vpc_id` attribute                    |
| aws_vpc_endpoint                  | Direct `vpc_id` attribute                    |
| aws_redshift_cluster              | `cluster_subnet_group_name` → subnets → VPC |
| aws_neptune_cluster               | `neptune_subnet_group_name` → subnets → VPC |
| aws_docdb_cluster                 | `db_subnet_group_name` → subnets → VPC      |
| aws_mq_broker                     | `subnet_ids` → subnets → VPC                |
| aws_opensearch_domain             | `vpc_options.subnet_ids` → subnets → VPC (if vpc_options present) |
| aws_msk_cluster                   | `broker_node_group_info.client_subnets` → VPC |
| aws_directory_service_directory   | `vpc_settings.vpc_id`                        |
| aws_fsx_lustre_file_system        | `subnet_ids` → subnets → VPC                |
| aws_efs_mount_target              | `subnet_id` → subnet → VPC                  |

## Conditionally VPC-Based Resources

These resources CAN be placed inside a VPC but are not always. Check for the VPC configuration block.

| Terraform Resource          | VPC Config Block                  | If absent, place at  |
|-----------------------------|-----------------------------------|----------------------|
| aws_lambda_function         | `vpc_config { subnet_ids, ... }`  | Region (outside VPC) |
| aws_ecs_service (Fargate)   | `network_configuration { subnets }` | Region             |
| aws_opensearch_domain       | `vpc_options { subnet_ids }`      | Region (outside VPC) |
| aws_sagemaker_notebook_instance | `subnet_id`                   | Region (outside VPC) |
| aws_apprunner_service       | `network_configuration`           | Region (outside VPC) |
| aws_codebuild_project       | `vpc_config`                      | Region (outside VPC) |
| aws_cloud9_environment_ec2  | `subnet_id`                       | Region (outside VPC) |
| aws_glue_connection         | `physical_connection_requirements.subnet_id` | Region      |

## Always Regional (Outside VPC) Resources

These resources are regional services and should be placed inside the Region group but outside
any VPC, even if they interact with VPC resources.

| Terraform Resource                    | Notes                                    |
|---------------------------------------|------------------------------------------|
| aws_s3_bucket                         | Global namespace, regional storage       |
| aws_dynamodb_table                    | Regional, VPC endpoints possible but service is external |
| aws_sqs_queue                         | Regional service                         |
| aws_sns_topic                         | Regional service                         |
| aws_sfn_state_machine                 | Regional service                         |
| aws_cloudwatch_event_rule             | Regional service                         |
| aws_cloudwatch_log_group              | Regional service                         |
| aws_cloudwatch_metric_alarm           | Regional service                         |
| aws_kms_key                           | Regional service                         |
| aws_secretsmanager_secret             | Regional service                         |
| aws_ssm_parameter                     | Regional service                         |
| aws_ecr_repository                    | Regional service                         |
| aws_kinesis_stream                    | Regional service                         |
| aws_kinesis_firehose_delivery_stream  | Regional service                         |
| aws_glue_catalog_database             | Regional service                         |
| aws_athena_workgroup                  | Regional service                         |
| aws_backup_vault                      | Regional service                         |
| aws_acm_certificate                   | Regional (or global for CloudFront)      |
| aws_cognito_user_pool                 | Regional service                         |
| aws_api_gateway_rest_api              | Regional service (edge, regional, private modes) |
| aws_apigatewayv2_api                  | Regional service                         |
| aws_batch_job_definition              | Regional service                         |
| aws_ses_domain_identity               | Regional service                         |
| aws_guardduty_detector                | Regional service                         |
| aws_inspector2_enabler               | Regional service                         |
| aws_config_configuration_recorder     | Regional service                         |
| aws_cloudtrail                        | Regional (or multi-region)               |
| aws_wafv2_web_acl                     | Regional (or global for CloudFront)      |
| aws_elastic_beanstalk_environment     | Regional; instances go in VPC            |
| aws_eks_cluster (control plane)       | Regional; nodes go in VPC subnets        |

## Global Resources (Outside Region)

These are global AWS services that span all regions.

| Terraform Resource                | Diagram Placement                       |
|-----------------------------------|-----------------------------------------|
| aws_cloudfront_distribution       | Outside Region, inside AWS Cloud        |
| aws_route53_zone                  | Outside Region, inside AWS Cloud        |
| aws_route53_record                | Outside Region, inside AWS Cloud        |
| aws_iam_role / aws_iam_policy     | Usually omitted from diagrams           |
| aws_wafv2_web_acl (CLOUDFRONT scope) | Outside Region, inside AWS Cloud     |
| aws_acm_certificate (us-east-1 for CF) | Outside Region or at us-east-1    |
| aws_globalaccelerator_accelerator | Outside Region, inside AWS Cloud        |
| aws_organizations_account         | Account-level grouping                  |

## External (Outside AWS Cloud) Elements

| Element                       | Notes                                        |
|-------------------------------|----------------------------------------------|
| Users / Internet              | Place **above** the AWS Cloud group, x-aligned with the primary ingress target (see SKILL.md Step 3, Rule A+). Fall back to left placement only for horizontal-flow diagrams. |
| Corporate data center         | Use Corporate Data Center group, outside AWS  |
| Third-party services          | Use generic icons outside AWS Cloud           |
| On-premises servers           | Use server icons outside AWS Cloud            |
| DNS queries from users        | Arrow from Users → Route 53. Place Route 53 to the **side** of the primary flow chain, not between Users and the primary ingress target. |

## Special Placement Notes

### Internet Gateway (IGW)
Place on the VPC border (edge of VPC box), as it sits at the VPC boundary. Visually, position it
at the top edge or left edge of the VPC group where external traffic enters.

### NAT Gateway
Place inside the **Public Subnet** where it is deployed (NAT gateways require a public subnet and EIP).
NAT Gateways handle **outbound** traffic only (private subnet → internet). They are NOT part of
the inbound communication path.

**Arrow exit/entry constraints (required):** draw.io's `orthogonalEdgeStyle` does NOT automatically
avoid obstacles. When an inbound arrow (e.g., ALB → ECS Task) would cross through a Public Subnet
at the same y-level as the NAT Gateway, add **exit/entry constraints** to the arrow style to force
the routing direction:

```
exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;
```

- `exitX=0.5;exitY=1` — arrow exits from the **bottom center** of the source (e.g., ALB)
- `entryX=0.5;entryY=0` — arrow enters from the **top center** of the target (e.g., ECS Task)

This forces the route: source bottom → straight down → horizontal turn → target top, which
bypasses the Public Subnet y-level entirely. With this constraint, NAT Gateway can be placed
at any x-position within the Public Subnet (center is preferred for visual balance).

See `drawio-xml-patterns.md` > "Arrow with Exit/Entry Constraints" for the XML template.

### Load Balancers (ALB/NLB)
ALB/NLB creates ENIs in each subnet listed in the `subnets` attribute.

- **Multiple AZs (typical):** Place a single ALB/NLB icon at the **VPC level** (`parent="vpc-main"`),
  positioned so that its **y-coordinate aligns with the Public Subnet icons** (e.g., NAT Gateway)
  it is deployed in. This means calculating the absolute y position of the subnet content within
  the VPC and placing ALB at the same y level. The ALB should visually sit between the two AZ
  groups, spanning across AZ boundaries. Do NOT place inside individual subnets when the LB
  spans multiple AZs.
- **Single AZ:** Place inside the specific subnet where the LB has its ENI.

### ECS/EKS with Fargate

When `aws_ecs_service` has `network_configuration { subnets }`, draw the following hierarchy:

1. **ECS Service group** — Place an ECS Service container group (`parent` = the Private Subnet)
   inside each specified Private Subnet (one per AZ). This is a draw.io container using
   a **solid orange border** (see `drawio-xml-patterns.md` > ECS Service Group).
2. **ECS Service icon marker** — Place a small (24x24) ECS Service icon
   (`shape=mxgraph.aws4.ecs_service`) as a child cell at the top-left corner (x=5, y=5)
   of the ECS Service group. This acts as a group icon marker. Set `value=""` (no label).
3. **ECS Task icons** — Place ECS Task icons (`shape=mxgraph.aws4.ecs_task`) inside the
   ECS Service group. **All communication arrows (incoming and outgoing) MUST connect to
   the ECS Task icon**, as the task is the actual communication endpoint.
4. **Fargate icon** — When using the Fargate launch type, place an AWS Fargate icon
   (`resIcon=mxgraph.aws4.fargate`) inside each ECS Service group. Position it away from
   the ECS Task icon (e.g., right side of the group) so it does not overlap with
   communication arrow paths. The Fargate icon is a launch-type indicator, NOT a
   communication target — never connect arrows to/from it.
5. **Auto Scaling** — If `aws_appautoscaling_target` / `aws_appautoscaling_policy` targets
   the ECS service, place an Application Auto Scaling icon near the ECS Service group.

**Note:** Do NOT place a separate ECS cluster icon at the Region level. The ECS Service
group within the subnet already represents the ECS deployment. The `aws_ecs_cluster`
resource is a management-plane construct and does not need a standalone icon in the diagram.

- EKS control plane is a regional managed service (place at Region level); worker nodes
  (including Fargate pods) go in the subnets specified by the node group or Fargate profile.

### RDS Multi-AZ
Place in the primary AZ's subnet, with an arrow/notation indicating Multi-AZ standby.
Or duplicate the icon in both AZs with a sync arrow.

### ElastiCache / MemoryDB
Place in the subnet(s) from the subnet group. If the cluster spans multiple AZs, show in each.

### API Gateway (Private)
If `aws_apigatewayv2_api` has `endpoint_configuration { types = ["PRIVATE"] }`, it uses a VPC
endpoint. Show the API Gateway at the Region level with an arrow to the VPC endpoint inside the VPC.