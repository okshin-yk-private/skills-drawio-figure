# Unified Reference Guideline — NL-to-Drawio

This file consolidates all reference material needed to generate AWS architecture diagrams
from natural language. It covers icon mapping, group hierarchy, placement rules, XML templates,
architecture patterns, service alias mapping, and abstraction levels.

---

## 1. Icon Mapping (AWS Service → draw.io Shape)

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

| Service | resIcon / shape | Label |
|---|---|---|
| EC2 | resIcon=mxgraph.aws4.ec2 | Amazon EC2 |
| Lambda | resIcon=mxgraph.aws4.lambda | AWS Lambda |
| Lightsail | resIcon=mxgraph.aws4.lightsail | Amazon Lightsail |
| Elastic Beanstalk | resIcon=mxgraph.aws4.elastic_beanstalk | AWS Elastic Beanstalk |
| Batch | resIcon=mxgraph.aws4.batch | AWS Batch |
| App Runner | resIcon=mxgraph.aws4.app_runner | AWS App Runner |

#### Containers

| Service | resIcon / shape | Label |
|---|---|---|
| ECS | resIcon=mxgraph.aws4.ecs | Amazon ECS |
| ECS Service | shape=mxgraph.aws4.ecs_service | ECS Service |
| ECS Task | shape=mxgraph.aws4.ecs_task | ECS Task |
| EKS | resIcon=mxgraph.aws4.eks | Amazon EKS |
| ECR | resIcon=mxgraph.aws4.ecr | Amazon ECR |
| Fargate | resIcon=mxgraph.aws4.fargate | AWS Fargate |

#### Networking & Content Delivery

| Service | resIcon / shape | Label |
|---|---|---|
| VPC | (use VPC GROUP) | VPC |
| Subnet | (use Subnet GROUP) | Public/Private Subnet |
| Internet Gateway | resIcon=mxgraph.aws4.internet_gateway | Internet gateway |
| NAT Gateway | resIcon=mxgraph.aws4.nat_gateway | NAT gateway |
| ALB | resIcon=mxgraph.aws4.application_load_balancer | Application Load Balancer |
| NLB | resIcon=mxgraph.aws4.network_load_balancer | Network Load Balancer |
| GLB | resIcon=mxgraph.aws4.gateway_load_balancer | Gateway Load Balancer |
| CloudFront | resIcon=mxgraph.aws4.cloudfront | Amazon CloudFront |
| Route 53 | resIcon=mxgraph.aws4.route_53 | Amazon Route 53 |
| VPN Gateway | resIcon=mxgraph.aws4.vpn_gateway | VPN gateway |
| Customer Gateway | resIcon=mxgraph.aws4.customer_gateway | Customer gateway |
| Transit Gateway | resIcon=mxgraph.aws4.transit_gateway | AWS Transit Gateway |
| VPC Endpoint | resIcon=mxgraph.aws4.vpc_endpoints | VPC endpoint |
| API Gateway | resIcon=mxgraph.aws4.api_gateway | Amazon API Gateway |
| Global Accelerator | resIcon=mxgraph.aws4.global_accelerator | AWS Global Accelerator |
| Direct Connect | resIcon=mxgraph.aws4.direct_connect | AWS Direct Connect |
| Elastic IP | shape=mxgraph.aws4.elastic_ip_address | Elastic IP |

#### Database

| Service | resIcon / shape | Label |
|---|---|---|
| RDS | resIcon=mxgraph.aws4.rds | Amazon RDS |
| Aurora | resIcon=mxgraph.aws4.aurora | Amazon Aurora |
| DynamoDB | resIcon=mxgraph.aws4.dynamodb | Amazon DynamoDB |
| ElastiCache | resIcon=mxgraph.aws4.elasticache | Amazon ElastiCache |
| Redshift | resIcon=mxgraph.aws4.redshift | Amazon Redshift |
| Neptune | resIcon=mxgraph.aws4.neptune | Amazon Neptune |
| DocumentDB | resIcon=mxgraph.aws4.documentdb_with_mongodb_compatibility | Amazon DocumentDB |
| MemoryDB | resIcon=mxgraph.aws4.memorydb_for_redis | Amazon MemoryDB |
| Timestream | resIcon=mxgraph.aws4.timestream | Amazon Timestream |

#### Storage

| Service | resIcon / shape | Label |
|---|---|---|
| S3 | resIcon=mxgraph.aws4.s3 | Amazon S3 |
| EFS | resIcon=mxgraph.aws4.elastic_file_system | Amazon EFS |
| FSx | resIcon=mxgraph.aws4.fsx | Amazon FSx |
| EBS | shape=mxgraph.aws4.volume | Amazon EBS |
| Backup | resIcon=mxgraph.aws4.backup | AWS Backup |

#### Application Integration

| Service | resIcon / shape | Label |
|---|---|---|
| SQS | resIcon=mxgraph.aws4.sqs | Amazon SQS |
| SNS | resIcon=mxgraph.aws4.sns | Amazon SNS |
| Step Functions | resIcon=mxgraph.aws4.step_functions | AWS Step Functions |
| EventBridge | resIcon=mxgraph.aws4.eventbridge | Amazon EventBridge |
| MQ | resIcon=mxgraph.aws4.mq | Amazon MQ |
| AppSync | resIcon=mxgraph.aws4.appsync | AWS AppSync |

#### Security, Identity & Compliance

| Service | resIcon / shape | Label |
|---|---|---|
| WAF | resIcon=mxgraph.aws4.waf | AWS WAF |
| Shield | resIcon=mxgraph.aws4.shield | AWS Shield |
| KMS | resIcon=mxgraph.aws4.key_management_service | AWS KMS |
| Secrets Manager | resIcon=mxgraph.aws4.secrets_manager | AWS Secrets Manager |
| ACM | resIcon=mxgraph.aws4.certificate_manager | AWS Certificate Manager |
| Cognito | resIcon=mxgraph.aws4.cognito | Amazon Cognito |
| GuardDuty | resIcon=mxgraph.aws4.guardduty | Amazon GuardDuty |
| Inspector | resIcon=mxgraph.aws4.inspector | Amazon Inspector |

#### Management & Governance

| Service | resIcon / shape | Label |
|---|---|---|
| CloudWatch | resIcon=mxgraph.aws4.cloudwatch | Amazon CloudWatch |
| CloudWatch Alarm | shape=mxgraph.aws4.alarm | CloudWatch Alarm |
| CloudTrail | resIcon=mxgraph.aws4.cloudtrail | AWS CloudTrail |
| Config | resIcon=mxgraph.aws4.config | AWS Config |
| Systems Manager | resIcon=mxgraph.aws4.systems_manager | AWS Systems Manager |

#### Analytics

| Service | resIcon / shape | Label |
|---|---|---|
| Kinesis | resIcon=mxgraph.aws4.kinesis | Amazon Kinesis |
| Data Firehose | resIcon=mxgraph.aws4.kinesis_data_firehose | Amazon Data Firehose |
| Glue | resIcon=mxgraph.aws4.glue | AWS Glue |
| Athena | resIcon=mxgraph.aws4.athena | Amazon Athena |
| OpenSearch | resIcon=mxgraph.aws4.opensearch_service | Amazon OpenSearch Service |
| QuickSight | resIcon=mxgraph.aws4.quicksight | Amazon QuickSight |
| MSK | resIcon=mxgraph.aws4.managed_streaming_for_kafka | Amazon MSK |

#### AI/ML

| Service | resIcon / shape | Label |
|---|---|---|
| SageMaker | resIcon=mxgraph.aws4.sagemaker | Amazon SageMaker AI |
| Bedrock | resIcon=mxgraph.aws4.bedrock | Amazon Bedrock |

#### General / External

| Element | shape | Label |
|---|---|---|
| Users | shape=mxgraph.aws4.users | Users |
| On-premises | shape=mxgraph.aws4.traditional_server | On-premises |
| Internet | shape=mxgraph.aws4.internet_alt2 | Internet |
| Client | shape=mxgraph.aws4.client | Client |
| Mobile client | shape=mxgraph.aws4.mobile_client | Mobile client |

> If a service is not in this table, use `resIcon=mxgraph.aws4.generic_application` as fallback.

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
For dashed variant: change `dashed=0` to `dashed=1;dashPattern=5 5`.

### Spacing Rules

- Padding: 40px from group border to child content
- Inner groups: minimum 5px buffer from outer group edges
- Child geometry: x ≥ 30, y ≥ 30 (accounting for group icon/label)

---

## 3. Placement Rules (Supplementary)

> **Note**: Mandatory placement rules are defined in SKILL.md > HARD CONSTRAINTS.
> This section provides supplementary decision logic and special placement details.

### NL Placement Decision (by service type)

| Placement Logic | Rule |
|---|---|
| Always VPC-internal (EC2, RDS, ALB, ElastiCache, etc.) | Place inside VPC → Subnet |
| Conditionally VPC (Lambda, ECS Fargate) | Default: inside VPC (private subnet) unless user says otherwise |
| Regional (S3, DynamoDB, SQS, SNS, API GW, etc.) | Place inside Region, outside VPC |
| Global (CloudFront, Route 53) | Place inside AWS Cloud, outside Region |
| External (Users, Internet, On-premises) | Place outside AWS Cloud |
| Security services with no arrows | Group in "Security & Compliance" dashed group at Region level |

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

**RDS Multi-AZ:**
Place in primary AZ's subnet; arrow/notation for standby, or duplicate icon in both AZs with sync arrow.

---

## 4. XML Templates

### File Structure

```xml
<mxfile host="app.diagrams.net" type="device">
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
Set `fillColor` and `gradientColor` per category (see Category Colors table).

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

---

## 5. Architecture Patterns

Match user descriptions against trigger phrases to identify patterns. Multiple patterns may combine.

### Pattern 1: 3-Tier Web Application

**Triggers:** "web app", "web application", "three-tier", "3-tier" / "Webアプリ", "3層", "三層"

**Required:** VPC (public+private, 2AZ), ALB, Compute (EC2/ECS Fargate), Database (RDS/Aurora), IGW, NAT GW
**Optional:** CloudFront, Route 53, ElastiCache, S3, WAF, Auto Scaling

**Topology:** `Users → [CloudFront →] ALB → Compute → Database [→ ElastiCache]`

### Pattern 2: Serverless REST API

**Triggers:** "serverless API", "Lambda API", "API Gateway + Lambda" / "サーバーレスAPI", "サーバーレス"

**Required:** API Gateway, Lambda, DynamoDB or RDS
**Optional:** Cognito, S3, SQS, Step Functions, CloudWatch, WAF, CloudFront

**Topology:** `Users → API Gateway → Lambda → DynamoDB/RDS [→ SQS → Lambda]`

### Pattern 3: Static Website

**Triggers:** "static site", "SPA", "single page app", "S3 website" / "静的サイト", "SPA"

**Required:** S3, CloudFront
**Optional:** Route 53, ACM, WAF, Lambda@Edge

**Topology:** `Users → [Route 53 →] CloudFront → S3`

### Pattern 4: Container Microservices

**Triggers:** "microservices", "container", "ECS", "EKS", "Fargate", "docker" / "マイクロサービス", "コンテナ"

**Required:** VPC (public+private, 2AZ), ALB, ECS Fargate or EKS, ECR, IGW, NAT GW
**Optional:** Service Discovery, SQS/SNS, RDS/DynamoDB, ElastiCache, CloudWatch, Auto Scaling, API Gateway

**Topology:** `Users → ALB → ECS Service A → DB A / ECS Service B → DB B / ECS Service C → SQS → ECS Service D`

### Pattern 5: Event-Driven Architecture

**Triggers:** "event-driven", "EventBridge", "pub/sub", "async processing" / "イベント駆動", "非同期処理"

**Required:** EventBridge or SNS, Lambda or SQS
**Optional:** S3, DynamoDB Streams, Step Functions, SQS DLQ, CloudWatch

**Topology:** `Event Source → EventBridge/SNS → Lambda A / SQS → Lambda B / Step Functions`

### Pattern 6: Data Pipeline (ETL/ELT)

**Triggers:** "data pipeline", "ETL", "data lake", "data warehouse" / "データパイプライン", "ETL", "データレイク"

**Required:** S3 (data lake), Glue or Lambda, Target (Redshift/Athena/DynamoDB)
**Optional:** Kinesis/Firehose, Step Functions, QuickSight, CloudWatch

**Topology:** `Data Sources → [Kinesis →] S3 (raw) → Glue → S3 (processed) → Athena/Redshift [→ QuickSight]`

### Pattern 7: Real-Time Streaming

**Triggers:** "real-time", "streaming", "Kinesis", "stream processing" / "リアルタイム", "ストリーミング"

**Required:** Kinesis Data Streams or MSK, Lambda or KDA, Storage (S3/DynamoDB/OpenSearch)
**Optional:** Firehose, API GW WebSocket, ElastiCache, CloudWatch

**Topology:** `Producers → Kinesis → Lambda → DynamoDB/OpenSearch / Firehose → S3`

### Pattern 8: Batch Processing

**Triggers:** "batch processing", "batch job", "scheduled job", "cron" / "バッチ処理", "定期実行"

**Required:** EventBridge Scheduler, Compute (Lambda/Batch/Step Functions), S3
**Optional:** SQS, SNS, DynamoDB, CloudWatch

**Topology:** `EventBridge (schedule) → Lambda/Batch → S3 [→ SNS notification]`

### Pattern 9: Hybrid Connectivity

**Triggers:** "hybrid", "VPN", "Direct Connect", "on-premises" / "ハイブリッド", "VPN", "オンプレミス"

**Required:** VPC, VPN GW or DX GW, Customer GW, Corporate DC group
**Optional:** Transit GW, Route 53, AD Connector, CloudWatch

**Topology:** `Corporate DC → VPN/DX → VPN Gateway → VPC → Resources`

### Pattern 10: ML/AI Pipeline

**Triggers:** "machine learning", "ML pipeline", "SageMaker", "Bedrock" / "機械学習", "SageMaker", "Bedrock"

**Required:** S3 (data/artifacts), SageMaker or Bedrock
**Optional:** Step Functions, Lambda, API GW, ECR, Glue, CloudWatch

**Topology:** `S3 (data) → SageMaker Training → S3 (model) → SageMaker Endpoint → API GW → Users`

### Pattern 11: GraphQL API

**Triggers:** "GraphQL", "AppSync" / "GraphQL", "AppSync"

**Required:** AppSync, Data source (DynamoDB/Lambda/RDS)
**Optional:** Cognito, ElastiCache, S3, Lambda resolvers

**Topology:** `Users → AppSync → DynamoDB / Lambda → external`

### Pattern 12: Multi-Region / DR

**Triggers:** "multi-region", "disaster recovery", "DR", "failover" / "マルチリージョン", "DR"

**Required:** 2 Regions, Route 53 (DNS failover), Core services in both
**Optional:** S3 CRR, RDS Read Replica, DynamoDB Global Tables, CloudFront

**Topology:** `Users → Route 53 → Region A: ALB → Compute → DB / Region B: ALB → Compute → DB (replica)`

### Pattern 13: CI/CD Pipeline

**Triggers:** "CI/CD", "deployment pipeline", "CodePipeline" / "CI/CD", "デプロイパイプライン"

**Required:** CodePipeline or Step Functions, CodeBuild, Target (ECS/Lambda/S3/EC2)
**Optional:** CodeCommit/GitHub, ECR, CodeDeploy, SNS, S3 artifacts

**Topology:** `Source → CodeBuild → [ECR] → CodeDeploy → Target`

### Pattern 14: Message Queue Architecture

**Triggers:** "message queue", "SQS", "async", "decoupled", "worker" / "メッセージキュー", "SQS", "非同期"

**Required:** SQS, Producer (API GW+Lambda or ECS), Consumer (Lambda or ECS)
**Optional:** SQS DLQ, SNS fan-out, CloudWatch, Auto Scaling

**Topology:** `Producer → SQS → Consumer [→ DLQ]`

### Pattern 15: CDN + API Backend

**Triggers:** "CDN", "CloudFront + API", "edge caching" / "CDN", "CloudFront + API", "コンテンツ配信"

**Required:** CloudFront, Origin (S3 static + ALB or API GW dynamic)
**Optional:** Route 53, ACM, WAF, Lambda@Edge, S3 logs

**Topology:** `Users → CloudFront → S3 (static) / ALB or API GW → Backend`

### Pattern Combination Rules

1. Identify primary pattern (main use case)
2. Identify secondary patterns (supporting capabilities)
3. Merge shared components (don't duplicate VPC, Route 53, etc.)
4. Connect at integration points

---

## 6. Service Alias Map (NL → Canonical AWS Name)

### Compute

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon EC2 | EC2, instance, virtual machine, VM, server | EC2, インスタンス, 仮想マシン, サーバー |
| AWS Lambda | Lambda, serverless function, function, FaaS | Lambda, サーバーレス関数, 関数 |
| Amazon Lightsail | Lightsail, simple server | Lightsail |
| AWS Elastic Beanstalk | Beanstalk, elastic beanstalk | Beanstalk |
| AWS Batch | Batch, batch job | Batch, バッチ |
| AWS App Runner | App Runner, apprunner | App Runner |

### Containers

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon ECS | ECS, Elastic Container Service, container service | ECS, コンテナサービス |
| Amazon EKS | EKS, Kubernetes, k8s | EKS, Kubernetes |
| AWS Fargate | Fargate, serverless container | Fargate, サーバーレスコンテナ |
| Amazon ECR | ECR, container registry | ECR, コンテナレジストリ |

### Networking & Content Delivery

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| VPC | VPC, virtual private cloud, network | VPC, ネットワーク |
| Internet gateway | IGW, internet gateway | IGW, インターネットゲートウェイ |
| NAT gateway | NAT, NAT gateway | NAT, NATゲートウェイ |
| Application Load Balancer | ALB, load balancer, LB | ALB, ロードバランサー, 負荷分散 |
| Network Load Balancer | NLB, network load balancer | NLB, ネットワークロードバランサー |
| Amazon CloudFront | CloudFront, CDN, content delivery | CloudFront, CDN, コンテンツ配信 |
| Amazon Route 53 | Route 53, Route53, DNS | Route 53, DNS, ドメイン |
| Amazon API Gateway | API Gateway, APIGW, REST API endpoint | API Gateway, APIゲートウェイ |
| AWS Transit Gateway | Transit Gateway, TGW | Transit Gateway |
| VPC endpoint | VPC endpoint, PrivateLink | VPCエンドポイント, PrivateLink |
| AWS Global Accelerator | Global Accelerator | Global Accelerator |
| AWS Direct Connect | Direct Connect, DX | Direct Connect, DX, 専用線 |

### Database

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon RDS | RDS, relational database, MySQL, PostgreSQL, SQL Server | RDS, リレーショナルDB, MySQL, PostgreSQL, データベース |
| Amazon Aurora | Aurora, Aurora MySQL, Aurora PostgreSQL | Aurora, オーロラ |
| Amazon DynamoDB | DynamoDB, Dynamo, NoSQL, key-value store | DynamoDB, NoSQL, キーバリュー |
| Amazon ElastiCache | ElastiCache, Redis, Memcached, cache | ElastiCache, Redis, キャッシュ |
| Amazon Redshift | Redshift, data warehouse, DWH | Redshift, データウェアハウス |
| Amazon Neptune | Neptune, graph database | Neptune, グラフDB |
| Amazon DocumentDB | DocumentDB, MongoDB compatible | DocumentDB, ドキュメントDB |
| Amazon MemoryDB | MemoryDB, durable Redis | MemoryDB |
| Amazon Timestream | Timestream, time series DB | Timestream, 時系列DB |

### Storage

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon S3 | S3, object storage, bucket, file storage | S3, オブジェクトストレージ, バケット |
| Amazon EFS | EFS, elastic file system, shared file, NFS | EFS, 共有ファイル, NFS |
| Amazon FSx | FSx, Lustre, Windows file server | FSx |
| Amazon EBS | EBS, block storage, volume, disk | EBS, ブロックストレージ, ディスク |
| AWS Backup | Backup, backup vault | Backup, バックアップ |

### Application Integration

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon SQS | SQS, message queue, queue | SQS, メッセージキュー, キュー |
| Amazon SNS | SNS, notification, pub/sub | SNS, 通知, プッシュ通知 |
| AWS Step Functions | Step Functions, state machine, workflow | Step Functions, ステートマシン, ワークフロー |
| Amazon EventBridge | EventBridge, event bus, CloudWatch Events | EventBridge, イベントバス |
| Amazon MQ | MQ, message broker, ActiveMQ, RabbitMQ | MQ, メッセージブローカー |
| AWS AppSync | AppSync, GraphQL | AppSync, GraphQL |

### Security, Identity & Compliance

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| AWS WAF | WAF, web application firewall | WAF, ファイアウォール |
| AWS Shield | Shield, DDoS protection | Shield, DDoS対策 |
| AWS KMS | KMS, key management, encryption key | KMS, 暗号化キー, 鍵管理 |
| AWS Secrets Manager | Secrets Manager, secret management | Secrets Manager, シークレット管理 |
| AWS Certificate Manager | ACM, certificate, SSL, TLS | ACM, 証明書, SSL |
| Amazon Cognito | Cognito, user pool, authentication, auth | Cognito, 認証, ユーザープール |
| Amazon GuardDuty | GuardDuty, threat detection | GuardDuty, 脅威検知 |
| Amazon Inspector | Inspector, vulnerability scanning | Inspector, 脆弱性スキャン |

### Management & Governance

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon CloudWatch | CloudWatch, monitoring, metrics, logs | CloudWatch, 監視, モニタリング |
| AWS CloudTrail | CloudTrail, audit log | CloudTrail, 監査ログ |
| AWS Config | Config, configuration compliance | Config, コンプライアンス |
| AWS Systems Manager | SSM, Systems Manager, parameter store | SSM, パラメータストア |

### Analytics

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon Kinesis | Kinesis, data stream, streaming data | Kinesis, データストリーム |
| Amazon Data Firehose | Firehose, Kinesis Firehose, delivery stream | Firehose, データ配信 |
| AWS Glue | Glue, ETL, data catalog | Glue, ETL, データカタログ |
| Amazon Athena | Athena, SQL query on S3 | Athena, S3クエリ |
| Amazon OpenSearch Service | OpenSearch, Elasticsearch, full-text search | OpenSearch, 全文検索 |
| Amazon QuickSight | QuickSight, BI, dashboard | QuickSight, BI, ダッシュボード |
| Amazon MSK | MSK, Kafka | MSK, Kafka |

### AI/ML

| AWS Service | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Amazon SageMaker AI | SageMaker, ML, machine learning | SageMaker, 機械学習 |
| Amazon Bedrock | Bedrock, generative AI, GenAI, LLM | Bedrock, 生成AI, LLM |

### General / External

| Element | Aliases (EN) | Aliases (JA) |
|---|---|---|
| Users | users, end users, clients, visitors | ユーザー, エンドユーザー, 利用者, 顧客 |
| Internet | internet, web, external | インターネット, 外部, Web |
| On-premises | on-premises, on-prem, data center | オンプレミス, オンプレ, データセンター |
| Client | client, desktop client | クライアント, デスクトップ |
| Mobile client | mobile, mobile app, smartphone | モバイル, スマホ, スマートフォン |

### Disambiguation Rules

| Alias | Default | Override Condition |
|---|---|---|
| "database" / "データベース" | Amazon RDS | DynamoDB if "NoSQL"/"key-value" mentioned |
| "cache" / "キャッシュ" | Amazon ElastiCache | CloudFront if CDN context |
| "queue" / "キュー" | Amazon SQS | Amazon MQ if "RabbitMQ"/"ActiveMQ" |
| "load balancer" / "ロードバランサー" | ALB | NLB if "TCP"/"UDP"/"network" |
| "serverless" | AWS Lambda | Fargate if "container" also mentioned |
| "storage" / "ストレージ" | Amazon S3 | EBS if "block"/"volume"; EFS if "shared"/"NFS" |

---

## 7. Abstraction Levels

### Overview (概要図)

High-level view focusing on service relationships.

| Property | Value |
|---|---|
| Resource count | 5–15 |
| VPC detail | Single VPC box, no subnet breakdown |
| AZ / Subnet / SG / CIDR | Omitted |
| NAT GW / IGW | Omitted (implied) |
| Icons | Service-level (48×48) only |
| Arrows | Major data flows, no port/protocol labels |
| Groups | AWS Cloud → Region → VPC (collapsed) |

**Rules:**
1. Collapse infrastructure — VPC as single box, no AZs/subnets/IGW/NAT/SGs
2. One icon per service (even if multi-instance)
3. Simple labels (service names only)
4. Compact layout, 800×600 or smaller

### Detailed (詳細設計図)

Deployment-level view with full infrastructure hierarchy.

| Property | Value |
|---|---|
| Resource count | 15–50+ |
| VPC | Full with CIDR |
| AZ | Multi-AZ (2 AZ minimum) |
| Subnet | Public + Private with CIDR per AZ |
| SG | Shown as group boundaries |
| NAT GW / IGW | Shown |
| Icons | Both service (48×48) and resource (40×40) |
| Arrows | Data flows with protocol/port labels |
| Groups | Full: AWS Cloud → Region → VPC → AZ → Subnet → SG |

**Rules:**
1. Full VPC → AZ → Subnet hierarchy with CIDRs
2. Multi-AZ: 2 AZs (ap-northeast-1a, 1c), resources duplicated where HA implied
3. Show IGW, NAT GW (per AZ), SGs
4. Labels include CIDRs, instance names, protocol/port on arrows
5. Default CIDRs: VPC `10.0.0.0/16`, Public `10.0.1.0/24`/`10.0.2.0/24`, Private App `10.0.11.0/24`/`10.0.12.0/24`, Private DB `10.0.21.0/24`/`10.0.22.0/24`
6. Layout: 1200×900 or larger

### Detection Rules

**Explicit cues (highest priority):**

| Cue (EN) | Cue (JA) | Level |
|---|---|---|
| "overview", "high-level", "simple" | "概要図", "概要", "シンプル", "全体像" | Overview |
| "detailed", "deployment diagram" | "詳細設計図", "詳細", "インフラ図" | Detailed |
| "Multi-AZ", "subnet", "CIDR", "security group" | "マルチAZ", "サブネット", "CIDR", "セキュリティグループ" | Detailed |

**Implicit cues:**

| Signal | Level |
|---|---|
| 1–4 services named briefly | Overview |
| Specific network config (CIDR, AZ, SG rules) | Detailed |
| "Multi-AZ", "高可用性", "HA" | Detailed |
| Data flow description without infra details | Overview |
| "構成図" / "architecture diagram" | Overview |
| Long, detailed specification | Detailed |

**Default:** Overview (if no cues match).
