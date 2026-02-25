# Group Hierarchy and Visual Properties

This document defines the group types, their nesting rules, visual properties (colors, dash patterns),
and corresponding draw.io XML style strings. All values are derived from the AWS Architecture Icons
Deck Release 22-2025.07.31 (Dark BG variant, adapted for light BG diagrams).

## Group Nesting Hierarchy

The valid nesting order from outermost to innermost:

```
AWS Cloud                    (outermost)
  └── Region
       ├── AWS Account       (optional, for multi-account diagrams)
       │    └── VPC
       │         ├── Availability Zone
       │         │    ├── Public Subnet
       │         │    │    └── resources / Security Group
       │         │    └── Private Subnet
       │         │         ├── resources / Security Group
       │         │         └── ECS Service group
       │         │              └── Fargate tasks (icons)
       │         └── Auto Scaling group (may span AZs)
       │              └── EC2 instances
       └── [Regional services outside VPC]
```

**Rules:**
- A Subnet MUST be inside a VPC
- An Availability Zone MUST be inside a Region (and typically inside a VPC for visual clarity)
- A Security Group overlays resources but should not break the subnet boundary
- Auto Scaling group may cross AZ boundaries within a VPC
- VPC-external services (S3, DynamoDB, CloudFront, etc.) sit at the Region level or outside

## Group Definitions

### AWS Cloud
The outermost group representing the AWS environment.

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #232F3E                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| lineWidth     | 2                              |
| grIcon        | mxgraph.aws4.group_aws_cloud_alt |
| fontColor     | #232F3E                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Region
A dotted-border group inside AWS Cloud.

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #00A4A6                        |
| fillColor     | none                           |
| dashPattern   | dotted (SQUARE_DOT)            |
| lineWidth     | 2                              |
| grIcon        | mxgraph.aws4.group_region      |
| fontColor     | #00A4A6                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#00A4A6;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#00A4A6;dashed=1;dashPattern=3 3;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### AWS Account
For multi-account architectures.

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #E7157B                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_account     |
| fontColor     | #E7157B                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_account;strokeColor=#E7157B;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#E7157B;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Virtual Private Cloud (VPC)

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #8C4FFF                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_vpc2        |
| fontColor     | #AAB7B8                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc2;strokeColor=#8C4FFF;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Availability Zone

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #00A4A6                        |
| fillColor     | none                           |
| dashPattern   | dashed                         |
| grIcon        | (none — text label only)       |
| fontColor     | #00A4A6                        |

**draw.io style:**
```
fillColor=none;strokeColor=#00A4A6;dashed=1;dashPattern=5 5;fontColor=#00A4A6;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Public Subnet

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #7AA116                        |
| fillColor     | #E9F3E6 (light green tint)     |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_security_group (reused with green color) |
| fontColor     | #248814                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#7AA116;fillColor=#E9F3E6;verticalAlign=top;align=left;spacingLeft=30;fontColor=#248814;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Private Subnet

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #00A4A6                        |
| fillColor     | #E6F2F8 (light blue tint)      |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_security_group (reused with blue color) |
| fontColor     | #147EBA                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#147EBA;fillColor=#E6F2F8;verticalAlign=top;align=left;spacingLeft=30;fontColor=#147EBA;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Security Group

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #DD344C                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | (none — text label only)       |
| fontColor     | #DD344C                        |

**draw.io style:**
```
fillColor=none;strokeColor=#DD344C;dashed=0;fontColor=#DD344C;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Auto Scaling Group

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #ED7100                        |
| fillColor     | none                           |
| dashPattern   | dashed                         |
| grIcon        | mxgraph.aws4.group_auto_scaling_group |
| fontColor     | #ED7100                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_auto_scaling_group;strokeColor=#ED7100;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#ED7100;dashed=1;dashPattern=5 5;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### ECS Service Group

A container group for ECS tasks running inside a Private Subnet.

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #ED7100                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | (none — see Icon Marker below) |
| fontColor     | #ED7100                        |

**draw.io style:**
```
fillColor=none;strokeColor=#ED7100;dashed=0;fontColor=#ED7100;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=30;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

**Icon Marker:** `mxgraph.aws4.group_ecs_service` does NOT exist as a valid grIcon. Instead, place a
small (24x24) ECS Service icon (`shape=mxgraph.aws4.ecs_service`) as a child cell at the top-left
corner of the container (x=5, y=5). This mimics the group icon behavior seen in official AWS diagrams.

**Nesting:** Place inside a Private Subnet. Contains:
- An ECS Service icon marker (24x24, top-left corner, no label)
- ECS Task icons (`shape=mxgraph.aws4.ecs_task`)
- AWS Fargate icon (`resIcon=mxgraph.aws4.fargate`) when using Fargate launch type

### EC2 Instance Contents

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #ED7100                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_ec2_instance_contents |
| fontColor     | #ED7100                        |

### Corporate Data Center

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #7D8998                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| grIcon        | mxgraph.aws4.group_corporate_data_center |
| fontColor     | #7D8998                        |

**draw.io style:**
```
shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_corporate_data_center;strokeColor=#7D8998;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#7D8998;dashed=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Generic Group (solid)

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #7D8998                        |
| fillColor     | none                           |
| dashPattern   | solid                          |
| fontColor     | #7D8998                        |

**draw.io style:**
```
fillColor=none;strokeColor=#7D8998;dashed=0;fontColor=#7D8998;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

### Generic Group (dashed)

| Property      | Value                          |
|---------------|--------------------------------|
| strokeColor   | #7D8998                        |
| fillColor     | none                           |
| dashPattern   | dashed                         |
| fontColor     | #7D8998                        |

**draw.io style:**
```
fillColor=none;strokeColor=#7D8998;dashed=1;dashPattern=5 5;fontColor=#7D8998;fontStyle=1;verticalAlign=top;align=left;spacingLeft=10;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;
```

## Determining Public vs Private Subnet

From Terraform, determine subnet type by:

1. **Explicit**: Check if there's an `aws_route_table_association` linking the subnet to a route table
   that has an `aws_route` with `gateway_id` pointing to an `aws_internet_gateway` → **Public**
2. **Name-based heuristic**: Subnet name/tags containing "public" → Public, "private" → Private
3. **CIDR heuristic**: Often public subnets have smaller CIDR blocks, but this is not reliable
4. **`map_public_ip_on_launch`**: If `true` → likely Public

If uncertain, default to **Private** (more conservative/secure assumption) and annotate.

## Buffer and Spacing Rules

Per the AWS Architecture Icons guidelines:
- Inner groups should have at least 5px (0.05") buffer from outer group edges on all sides
- In draw.io terms, this means child geometry should have x >= 30 (to account for group icon/label), y >= 30
- Recommended practical padding: 40px from group border to child content