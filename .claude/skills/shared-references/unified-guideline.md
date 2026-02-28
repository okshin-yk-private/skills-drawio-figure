# Unified Reference Guideline — Terraform-to-Drawio

This file consolidates all reference material needed to generate AWS architecture diagrams
from Terraform source code. It covers icon mapping, group hierarchy, placement rules, and
XML templates.

---

## 1. Icon Mapping (Terraform Resource → draw.io Shape)

### Shape Types

- **Service Icons** (48×48, gradient): `shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.{name}`
- **Resource Icons** (40×40, flat): `shape=mxgraph.aws4.{name}`

### Category Colors

| Category | fillColor | gradientColor |
|---|---|---|
| Compute / Containers / Serverless | #ED7100 | #F78E04 |
| Storage / IoT | #3F8624 | #60A337 |
| Database | #C925D1 | #F15AEF |
| Networking / Analytics | #8C4FFF | #BF80FF |
| Security, Identity & Compliance | #DD344C | #FF6680 |
| Management & Governance / App Integration | #E7157B | #FF4F8B |
| Developer Tools / Front-End Web & Mobile | #C7131F | #F34482 |
| General | #232F3E | none |

### Mapping Table

#### Compute

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_instance | resIcon=mxgraph.aws4.ec2 | Amazon EC2 |
| aws_launch_template | resIcon=mxgraph.aws4.ec2 | Amazon EC2 |
| aws_autoscaling_group | (use Auto Scaling group GROUP) | EC2 Auto Scaling |
| aws_lambda_function | resIcon=mxgraph.aws4.lambda | AWS Lambda |
| aws_lightsail_instance | resIcon=mxgraph.aws4.lightsail | Amazon Lightsail |
| aws_elastic_beanstalk_environment | resIcon=mxgraph.aws4.elastic_beanstalk | AWS Elastic Beanstalk |
| aws_batch_job_definition | resIcon=mxgraph.aws4.batch | AWS Batch |
| aws_apprunner_service | resIcon=mxgraph.aws4.app_runner | AWS App Runner |

#### Containers

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_ecs_cluster | resIcon=mxgraph.aws4.ecs | Amazon ECS |
| aws_ecs_service | shape=mxgraph.aws4.ecs_service | ECS Service |
| aws_ecs_task_definition | shape=mxgraph.aws4.ecs_task | ECS Task |
| aws_eks_cluster | resIcon=mxgraph.aws4.eks | Amazon EKS |
| aws_ecr_repository | resIcon=mxgraph.aws4.ecr | Amazon ECR |
| aws_ecs_cluster (Fargate) | resIcon=mxgraph.aws4.fargate | AWS Fargate |

#### Networking & Content Delivery

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_vpc | (use VPC GROUP) | VPC |
| aws_subnet | (use Subnet GROUP) | Public/Private Subnet |
| aws_internet_gateway | resIcon=mxgraph.aws4.internet_gateway | Internet gateway |
| aws_nat_gateway | resIcon=mxgraph.aws4.nat_gateway | NAT gateway |
| aws_lb (ALB) | resIcon=mxgraph.aws4.application_load_balancer | Application Load Balancer |
| aws_lb (NLB) | resIcon=mxgraph.aws4.network_load_balancer | Network Load Balancer |
| aws_lb (GLB) | resIcon=mxgraph.aws4.gateway_load_balancer | Gateway Load Balancer |
| aws_cloudfront_distribution | resIcon=mxgraph.aws4.cloudfront | Amazon CloudFront |
| aws_route53_zone | resIcon=mxgraph.aws4.route_53 | Amazon Route 53 |
| aws_route53_record | shape=mxgraph.aws4.route_table | Route 53 Record |
| aws_vpn_gateway | resIcon=mxgraph.aws4.vpn_gateway | VPN gateway |
| aws_customer_gateway | resIcon=mxgraph.aws4.customer_gateway | Customer gateway |
| aws_vpn_connection | (arrow with label) | Site-to-Site VPN |
| aws_ec2_transit_gateway | resIcon=mxgraph.aws4.transit_gateway | AWS Transit Gateway |
| aws_vpc_endpoint | resIcon=mxgraph.aws4.vpc_endpoints | VPC endpoint |
| aws_api_gateway_rest_api | resIcon=mxgraph.aws4.api_gateway | Amazon API Gateway |
| aws_apigatewayv2_api | resIcon=mxgraph.aws4.api_gateway | Amazon API Gateway |
| aws_globalaccelerator_accelerator | resIcon=mxgraph.aws4.global_accelerator | AWS Global Accelerator |
| aws_dx_connection | resIcon=mxgraph.aws4.direct_connect | AWS Direct Connect |
| aws_eip | shape=mxgraph.aws4.elastic_ip_address | Elastic IP |
| aws_vpc_peering_connection | (arrow with label) | VPC Peering |

#### Database

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_db_instance | resIcon=mxgraph.aws4.rds | Amazon RDS |
| aws_rds_cluster | resIcon=mxgraph.aws4.aurora | Amazon Aurora |
| aws_dynamodb_table | resIcon=mxgraph.aws4.dynamodb | Amazon DynamoDB |
| aws_elasticache_cluster | resIcon=mxgraph.aws4.elasticache | Amazon ElastiCache |
| aws_elasticache_replication_group | resIcon=mxgraph.aws4.elasticache | Amazon ElastiCache |
| aws_redshift_cluster | resIcon=mxgraph.aws4.redshift | Amazon Redshift |
| aws_neptune_cluster | resIcon=mxgraph.aws4.neptune | Amazon Neptune |
| aws_docdb_cluster | resIcon=mxgraph.aws4.documentdb_with_mongodb_compatibility | Amazon DocumentDB |
| aws_memorydb_cluster | resIcon=mxgraph.aws4.memorydb_for_redis | Amazon MemoryDB |
| aws_timestream_database | resIcon=mxgraph.aws4.timestream | Amazon Timestream |

#### Storage

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_s3_bucket | resIcon=mxgraph.aws4.s3 | Amazon S3 |
| aws_efs_file_system | resIcon=mxgraph.aws4.elastic_file_system | Amazon EFS |
| aws_fsx_lustre_file_system | resIcon=mxgraph.aws4.fsx | Amazon FSx |
| aws_fsx_windows_file_system | resIcon=mxgraph.aws4.fsx_for_windows_file_server | Amazon FSx |
| aws_ebs_volume | shape=mxgraph.aws4.volume | Amazon EBS |
| aws_s3_bucket_object | shape=mxgraph.aws4.bucket | S3 Bucket |
| aws_backup_vault | resIcon=mxgraph.aws4.backup | AWS Backup |

#### Application Integration

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_sqs_queue | resIcon=mxgraph.aws4.sqs | Amazon SQS |
| aws_sns_topic | resIcon=mxgraph.aws4.sns | Amazon SNS |
| aws_sfn_state_machine | resIcon=mxgraph.aws4.step_functions | AWS Step Functions |
| aws_cloudwatch_event_rule | resIcon=mxgraph.aws4.eventbridge | Amazon EventBridge |
| aws_scheduler_schedule | resIcon=mxgraph.aws4.eventbridge | Amazon EventBridge Scheduler |
| aws_mq_broker | resIcon=mxgraph.aws4.mq | Amazon MQ |
| aws_appsync_graphql_api | resIcon=mxgraph.aws4.appsync | AWS AppSync |

#### Security, Identity & Compliance

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_security_group | (use Security Group GROUP) | Security group |
| aws_wafv2_web_acl | resIcon=mxgraph.aws4.waf | AWS WAF |
| aws_shield_protection | resIcon=mxgraph.aws4.shield | AWS Shield |
| aws_kms_key | resIcon=mxgraph.aws4.key_management_service | AWS KMS |
| aws_secretsmanager_secret | resIcon=mxgraph.aws4.secrets_manager | AWS Secrets Manager |
| aws_acm_certificate | resIcon=mxgraph.aws4.certificate_manager | AWS Certificate Manager |
| aws_cognito_user_pool | resIcon=mxgraph.aws4.cognito | Amazon Cognito |
| aws_guardduty_detector | resIcon=mxgraph.aws4.guardduty | Amazon GuardDuty |
| aws_inspector2_enabler | resIcon=mxgraph.aws4.inspector | Amazon Inspector |

#### Management & Governance

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_cloudwatch_log_group | resIcon=mxgraph.aws4.cloudwatch | Amazon CloudWatch |
| aws_cloudwatch_metric_alarm | shape=mxgraph.aws4.alarm | CloudWatch Alarm |
| aws_cloudtrail | resIcon=mxgraph.aws4.cloudtrail | AWS CloudTrail |
| aws_config_configuration_recorder | resIcon=mxgraph.aws4.config | AWS Config |
| aws_ssm_parameter | resIcon=mxgraph.aws4.systems_manager | AWS Systems Manager |
| aws_organizations_account | (use AWS Account GROUP) | AWS Account |

#### Analytics

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_kinesis_stream | resIcon=mxgraph.aws4.kinesis | Amazon Kinesis |
| aws_kinesis_firehose_delivery_stream | resIcon=mxgraph.aws4.kinesis_data_firehose | Amazon Data Firehose |
| aws_glue_catalog_database | resIcon=mxgraph.aws4.glue | AWS Glue |
| aws_athena_workgroup | resIcon=mxgraph.aws4.athena | Amazon Athena |
| aws_opensearch_domain | resIcon=mxgraph.aws4.opensearch_service | Amazon OpenSearch Service |
| aws_quicksight_data_source | resIcon=mxgraph.aws4.quicksight | Amazon QuickSight |
| aws_msk_cluster | resIcon=mxgraph.aws4.managed_streaming_for_kafka | Amazon MSK |

#### AI/ML

| Terraform Resource | resIcon / shape | Label |
|---|---|---|
| aws_sagemaker_endpoint | resIcon=mxgraph.aws4.sagemaker | Amazon SageMaker AI |
| aws_bedrock_model_invocation | resIcon=mxgraph.aws4.bedrock | Amazon Bedrock |

#### General / External

| Element | shape | Label |
|---|---|---|
| Users / Internet | shape=mxgraph.aws4.users | Users |
| On-premises server | shape=mxgraph.aws4.traditional_server | On-premises |
| Corporate data center | (use Corporate data center GROUP) | Corporate data center |
| Internet | shape=mxgraph.aws4.internet_alt2 | Internet |
| Client | shape=mxgraph.aws4.client | Client |
| Mobile client | shape=mxgraph.aws4.mobile_client | Mobile client |

> If a resource type is not in this table, use `resIcon=mxgraph.aws4.generic_application` as fallback.

---

## 2. Group Hierarchy & Styles

### Nesting Hierarchy

```
AWS Cloud (outermost)
  └── Region
       ├── AWS Account (optional, multi-account)
       │    └── VPC
       ├── VPC
       │    ├── Availability Zone
       │    │    ├── Public Subnet → resources / Security Group
       │    │    └── Private Subnet → resources / Security Group / ECS Service group
       │    └── Auto Scaling group (may span AZs)
       ├── Security & Compliance (dashed, non-communicating security services)
       └── [Regional services outside VPC]
```

### Group Styles

**AWS Cloud:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Region:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#00A4A6;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#00A4A6;dashed=1;dashPattern=3 3;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**AWS Account:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_account;strokeColor=#E7157B;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#E7157B;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**VPC:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc2;strokeColor=#8C4FFF;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Availability Zone:**
```
fillColor=none;strokeColor=#00A4A6;dashed=1;dashPattern=5 5;fontColor=#00A4A6;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Public Subnet:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#7AA116;fillColor=#E9F3E6;verticalAlign=top;align=left;spacingLeft=30;fontColor=#248814;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Private Subnet:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#147EBA;fillColor=#E6F2F8;verticalAlign=top;align=left;spacingLeft=30;fontColor=#147EBA;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Security Group:**
```
fillColor=none;strokeColor=#DD344C;dashed=0;fontColor=#DD344C;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Auto Scaling Group:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_auto_scaling_group;strokeColor=#ED7100;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#ED7100;dashed=1;dashPattern=5 5;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Security & Compliance Group** (for non-communicating security services at Region level):
```
fillColor=none;strokeColor=#DD344C;dashed=1;dashPattern=5 5;fontColor=#DD344C;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**ECS Service Group** (inside Private Subnet):
```
fillColor=none;strokeColor=#ED7100;dashed=0;fontColor=#ED7100;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=30;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```
Place a 24×24 ECS Service icon (`shape=mxgraph.aws4.ecs_service`) at (x=5, y=5) inside as icon marker. Set `value=""`.

**Corporate Data Center:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_corporate_data_center;strokeColor=#7D8998;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#7D8998;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Generic Group (solid / dashed):**
```
fillColor=none;strokeColor=#7D8998;dashed=0;fontColor=#7D8998;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```
For dashed variant: `dashed=1;dashPattern=5 5`.

### Determining Public vs Private Subnet (from Terraform)

1. Check `aws_route_table_association` → route table → `aws_route` with `gateway_id` pointing to IGW → **Public**
2. Name/tags containing "public" → Public, "private" → Private
3. `map_public_ip_on_launch = true` → likely Public
4. Default: **Private** (more secure assumption)

### Spacing Rules

- Padding: 40px from group border to child content
- Inner groups: minimum 5px buffer from outer group edges
- Child geometry: x ≥ 30, y ≥ 30 (accounting for group icon/label)

---

## 3. Placement Rules

> **Note**: Mandatory nesting rules are defined in SKILL.md > HARD CONSTRAINTS.
> This section provides the Terraform-specific decision logic and special placement details.

### Decision Flowchart (from Terraform attributes)

```
1. Has `subnet_id` / `subnet_ids`?
   YES → Place inside corresponding Subnet group
   NO  → Step 2

2. Has `vpc_id`?
   YES → Place inside VPC (outside Subnet)
   NO  → Step 3

3. Is "conditionally VPC" service? (check vpc_config/network_configuration block)
   Present → Place inside VPC (in subnet if specified)
   Absent  → Region level
   NO  → Step 4

4. Is "always VPC-internal"?
   YES → Resolve from related resources
   NO  → Step 5

5. Is "regional"?
   YES → Region (outside VPC)
   NO  → Step 6

6. Is "global"?
   YES → AWS Cloud level (outside Region)
   NO  → Default to Region level
```

### Always VPC-Internal Resources

| Terraform Resource | How to find VPC |
|---|---|
| aws_subnet | Direct `vpc_id` |
| aws_security_group | Direct `vpc_id` |
| aws_instance | `subnet_id` → subnet → VPC |
| aws_db_instance | `db_subnet_group_name` → subnet group → VPC |
| aws_elasticache_cluster | `subnet_group_name` → subnet group → VPC |
| aws_lb | `subnets` / `subnet_mapping` → subnets → VPC |
| aws_nat_gateway | `subnet_id` → subnet → VPC |
| aws_internet_gateway | `vpc_id` (via attachment) |
| aws_vpc_endpoint | Direct `vpc_id` |
| aws_redshift_cluster | `cluster_subnet_group_name` → subnets → VPC |
| aws_neptune_cluster | `neptune_subnet_group_name` → subnets → VPC |
| aws_docdb_cluster | `db_subnet_group_name` → subnets → VPC |
| aws_mq_broker | `subnet_ids` → subnets → VPC |
| aws_msk_cluster | `broker_node_group_info.client_subnets` → VPC |
| aws_fsx_lustre_file_system | `subnet_ids` → subnets → VPC |
| aws_efs_mount_target | `subnet_id` → subnet → VPC |

### Conditionally VPC-Based Resources

| Terraform Resource | VPC Config Block | If absent, place at |
|---|---|---|
| aws_lambda_function | `vpc_config { subnet_ids }` | Region |
| aws_ecs_service (Fargate) | `network_configuration { subnets }` | Region |
| aws_opensearch_domain | `vpc_options { subnet_ids }` | Region |
| aws_sagemaker_notebook_instance | `subnet_id` | Region |
| aws_apprunner_service | `network_configuration` | Region |
| aws_codebuild_project | `vpc_config` | Region |
| aws_glue_connection | `physical_connection_requirements.subnet_id` | Region |

### Regional Resources (Outside VPC)

S3, DynamoDB, SQS, SNS, Step Functions, EventBridge, CloudWatch, KMS, Secrets Manager, SSM,
ECR, Kinesis, Firehose, Glue, Athena, Backup, ACM, Cognito, API Gateway, Batch, GuardDuty,
Inspector, Config, CloudTrail, WAF (regional), Elastic Beanstalk (control plane),
EKS (control plane).

### Global Resources (Outside Region, inside AWS Cloud)

CloudFront, Route 53, IAM (usually omitted), WAF (CLOUDFRONT scope), ACM (us-east-1 for CF),
Global Accelerator.

### External Elements (Outside AWS Cloud)

Users, Internet, Corporate data center, On-premises servers, Third-party services.

### Security & Compliance Grouping

After determining all arrows, check each security service:
- **Zero arrows** → place inside Security & Compliance group (KMS, GuardDuty, Inspector, Secrets Manager, Config, CloudTrail)
- **Has arrows** → place in normal data flow position (WAF, ACM, Cognito)

### Special Placement Notes

**Internet Gateway (IGW):**
- Place at VPC border (top-center), x-aligned with ALB
- In Multi-AZ: position in gap between AZ groups, NOT inside any AZ
- Arrow chain: `Users → IGW → ALB` (not `Users → ALB` directly)
- Leave 30px between IGW label bottom and AZ group top

**NAT Gateway:**
- Place inside Public Subnet (requires public subnet + EIP)
- Handles outbound traffic only — NOT part of inbound path
- When inbound arrows cross Public Subnet y-level, add exit/entry constraints:
  `exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;`

**Load Balancers (ALB/NLB):**
- Multi-AZ: Place at VPC level (`parent="vpc-main"`), positioned between AZ groups
- Single AZ: Place inside specific subnet
- **Z-order**: ALB/NLB mxCell MUST appear AFTER all AZ and Subnet group cells (and their descendants) in the XML, so the icon and label render on top of overlapping subnet fill colors

**ECS/EKS with Fargate:**
1. ECS Service group (parent = Private Subnet, solid orange border)
2. ECS Service icon marker (24×24, top-left at x=5,y=5, no label)
3. ECS Task icons inside — **all arrows connect to ECS Task** (the communication endpoint)
4. Fargate icon inside (right side) — launch-type indicator only, no arrows to/from it
5. Do NOT place a separate ECS cluster icon at Region level

**RDS Multi-AZ:** Place in primary AZ's subnet; duplicate in both AZs with sync arrow.

**API Gateway (Private):** If `endpoint_configuration { types = ["PRIVATE"] }`, show at Region level with arrow to VPC endpoint.

---

## 4. XML Templates

### File Structure

```xml
<mxfile host="Terraform-to-Drawio" modified="2025-01-01T00:00:00.000Z" type="device">
  <diagram id="aws-architecture" name="AWS Architecture">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1"
                  connect="1" arrows="1" fold="1" page="1" pageScale="1"
                  pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- Groups and resources here -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

### Cell ID Convention

Use descriptive IDs: `cloud-1`, `region-1`, `vpc-main`, `subnet-public-1a`, `ec2-web`, `arrow-1`.

### Group Templates

**AWS Cloud:**
```xml
<mxCell id="cloud-1" value="AWS Cloud" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=0;" vertex="1" parent="1">
  <mxGeometry x="20" y="20" width="1100" height="780" as="geometry" />
</mxCell>
```

**Region:**
```xml
<mxCell id="region-1" value="ap-northeast-1" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#00A4A6;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#00A4A6;dashed=1;dashPattern=3 3;" vertex="1" parent="cloud-1">
  <mxGeometry x="40" y="40" width="1020" height="700" as="geometry" />
</mxCell>
```

**VPC:**
```xml
<mxCell id="vpc-main" value="VPC (10.0.0.0/16)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc2;strokeColor=#8C4FFF;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;" vertex="1" parent="region-1">
  <mxGeometry x="40" y="60" width="940" height="600" as="geometry" />
</mxCell>
```

**Availability Zone:**
```xml
<mxCell id="az-1a" value="Availability Zone (ap-northeast-1a)" style="fillColor=none;strokeColor=#00A4A6;dashed=1;dashPattern=5 5;fontColor=#00A4A6;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="vpc-main">
  <mxGeometry x="20" y="40" width="430" height="540" as="geometry" />
</mxCell>
```

**Public Subnet:**
```xml
<mxCell id="subnet-public-1a" value="Public Subnet (10.0.1.0/24)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#7AA116;fillColor=#E9F3E6;verticalAlign=top;align=left;spacingLeft=30;fontColor=#248814;dashed=0;" vertex="1" parent="az-1a">
  <mxGeometry x="20" y="40" width="390" height="230" as="geometry" />
</mxCell>
```

**Private Subnet:**
```xml
<mxCell id="subnet-private-1a" value="Private Subnet (10.0.2.0/24)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#147EBA;fillColor=#E6F2F8;verticalAlign=top;align=left;spacingLeft=30;fontColor=#147EBA;dashed=0;" vertex="1" parent="az-1a">
  <mxGeometry x="20" y="290" width="390" height="230" as="geometry" />
</mxCell>
```

**Security Group:**
```xml
<mxCell id="sg-web" value="Security Group (web-sg)" style="fillColor=none;strokeColor=#DD344C;dashed=0;fontColor=#DD344C;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="20" y="40" width="350" height="170" as="geometry" />
</mxCell>
```

**Auto Scaling Group:**
```xml
<mxCell id="asg-web" value="Auto Scaling group" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_auto_scaling_group;strokeColor=#ED7100;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#ED7100;dashed=1;dashPattern=5 5;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="20" y="40" width="350" height="170" as="geometry" />
</mxCell>
```

**ECS Service Group + Icon Marker:**
```xml
<mxCell id="ecs-svc-1a" value="ECS Service" style="fillColor=none;strokeColor=#ED7100;dashed=0;fontColor=#ED7100;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=30;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="subnet-priv-app-1a">
  <mxGeometry x="15" y="35" width="510" height="100" as="geometry" />
</mxCell>
<mxCell id="ecs-svc-icon-1a" value="" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#ED7100;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.ecs_service;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="5" y="5" width="24" height="24" as="geometry" />
</mxCell>
```

**Security & Compliance Group:**
```xml
<mxCell id="sec-group" value="Security &amp; Compliance" style="fillColor=none;strokeColor=#DD344C;dashed=1;dashPattern=5 5;fontColor=#DD344C;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="region-1">
  <mxGeometry x="..." y="..." width="..." height="..." as="geometry" />
</mxCell>
```

**Corporate Data Center:**
```xml
<mxCell id="dc-1" value="Corporate Data Center" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_corporate_data_center;strokeColor=#7D8998;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#7D8998;dashed=0;" vertex="1" parent="1">
  <mxGeometry x="20" y="20" width="300" height="200" as="geometry" />
</mxCell>
```

### Service Icon Templates

**Standard Service Icon (gradient):**
```xml
<mxCell id="ec2-web" value="Amazon EC2&lt;br&gt;web" style="sketch=0;points=[[0,0,0],[0.25,0,0],[0.5,0,0],[0.75,0,0],[1,0,0],[0,1,0],[0.25,1,0],[0.5,1,0],[0.75,1,0],[1,1,0],[0,0.25,0],[0,0.5,0],[0,0.75,0],[1,0.25,0],[1,0.5,0],[1,0.75,0]];outlineConnect=0;fontColor=#232F3E;gradientColor=#F78E04;gradientDirection=north;fillColor=#ED7100;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.ec2;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="60" y="60" width="48" height="48" as="geometry" />
</mxCell>
```

**Resource Icon (flat):**
```xml
<mxCell id="task-1a" value="ECS Task" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#ED7100;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.ecs_task;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="60" y="35" width="48" height="48" as="geometry" />
</mxCell>
```

**Fargate Icon (inside ECS Service Group, right side):**
```xml
<mxCell id="fargate-1a" value="AWS Fargate" style="sketch=0;points=[[0,0,0],[0.25,0,0],[0.5,0,0],[0.75,0,0],[1,0,0],[0,1,0],[0.25,1,0],[0.5,1,0],[0.75,1,0],[1,1,0],[0,0.25,0],[0,0.5,0],[0,0.75,0],[1,0.25,0],[1,0.5,0],[1,0.75,0]];outlineConnect=0;fontColor=#232F3E;gradientColor=#F78E04;gradientDirection=north;fillColor=#ED7100;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.fargate;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="420" y="25" width="48" height="48" as="geometry" />
</mxCell>
```

**General Icons (Users, Internet):**
```xml
<mxCell id="users" value="Users" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#232F3E;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.users;" vertex="1" parent="1">
  <mxGeometry x="20" y="350" width="48" height="48" as="geometry" />
</mxCell>
```

### Arrow Templates

**Arrow stroke width**: `strokeWidth=2` for primary flows, `strokeWidth=1` for secondary/dashed flows.

**Standard Arrow:**
```xml
<mxCell id="arrow-1" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=2;endArrow=block;endFill=1;fontSize=12;" edge="1" source="ec2-web" target="rds-main" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

**Arrow with Label:**
```xml
<mxCell id="arrow-2" value="HTTPS" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=2;endArrow=block;endFill=1;fontSize=11;labelBackgroundColor=#ffffff;" edge="1" source="alb-web" target="ec2-web" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

**Bidirectional Arrow:**
```xml
<mxCell id="arrow-3" value="sync" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=2;endArrow=block;endFill=1;startArrow=block;startFill=1;fontSize=11;" edge="1" source="rds-primary" target="rds-standby" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

**Dashed Arrow (optional/conditional):**
```xml
<mxCell id="arrow-4" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#7D8998;strokeWidth=1;dashed=1;endArrow=block;endFill=1;fontSize=11;" edge="1" source="lambda-fn" target="sns-topic" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

**Arrow with Exit/Entry Constraints (bypass obstacles):**
```xml
<mxCell id="arrow-5" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=2;endArrow=block;endFill=1;fontSize=11;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" source="alb" target="task-1a" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Key XML Rules

1. Arrows connecting icons in different groups: use `parent="1"` (root level)
2. All groups: `container=1;collapsible=0;recursiveResize=0`
3. HTML labels: use `html=1` in style, `&lt;br&gt;` for line breaks
4. Child coordinates are relative to parent group's origin
5. Always include `aspect=fixed` for icons
6. Use `edgeStyle=orthogonalEdgeStyle` for all arrows (right-angle routing)
7. Fan-out overlap: when icon has 3+ outgoing arrows, shift peer icons outside the fan-out zone
8. **Z-order (rendering order)**: draw.io renders mxCells in document order — later cells are drawn on top of earlier ones. When a resource icon is a child of a container group (e.g., ALB with `parent="vpc-main"`) but visually overlaps with sibling container groups (e.g., AZ/Subnet groups that also have `parent="vpc-main"`), the resource mxCell **MUST** appear AFTER all sibling group mxCells and their complete subtrees in the XML. Otherwise, the sibling groups' fill colors will cover the resource's icon and label. This commonly affects:
   - **ALB/NLB at VPC level** — positioned between AZ groups, overlaps with Public Subnet fill
   - **IGW at VPC border** — overlaps with AZ group area
   - **Any VPC-level icon** positioned between or on top of AZ/Subnet groups

   **Correct XML order within a VPC group:**
   ```
   VPC group cell
     AZ-1a group cell
       Public Subnet 1a (with fillColor)
         ... children ...
       Private Subnet 1a (with fillColor)
         ... children ...
     AZ-1b group cell
       Public Subnet 1b (with fillColor)
         ... children ...
       Private Subnet 1b (with fillColor)
         ... children ...
     IGW icon cell          ← AFTER all AZ/Subnet groups
     ALB icon cell          ← AFTER all AZ/Subnet groups
   ```
