# Draw.io XML Patterns for AWS Architecture Diagrams

This document provides validated XML templates for generating `.drawio` files programmatically.
All patterns use the `mxgraph.aws4.*` shape library.

## File Structure

Every `.drawio` file follows this structure:

```xml
<mxfile host="Terraform-to-Drawio" modified="2025-01-01T00:00:00.000Z" type="device">
  <diagram id="aws-architecture" name="AWS Architecture">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1"
                  connect="1" arrows="1" fold="1" page="1" pageScale="1"
                  pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />

        <!-- All groups and resources go here -->

      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

**Important attributes:**
- `pageWidth` and `pageHeight`: Set based on diagram complexity (see SKILL.md Step 3)
- `dx` and `dy`: Canvas scroll offset; set to reasonable defaults (1422, 794)
- Every cell needs a unique `id` (use sequential integers starting from 2, or descriptive strings)
- `parent="1"` means the cell is at the root canvas level
- Group children reference the group's `id` as their `parent`

## Cell ID Strategy

Use descriptive IDs for readability and debugging:

```
cloud-1          → AWS Cloud group
region-1         → Region group
vpc-main         → VPC group (matching TF name)
subnet-public-1a → Subnet group
ec2-web          → EC2 instance (matching TF name)
arrow-1          → Connection arrow
```

## Group Templates

### AWS Cloud Group

```xml
<mxCell id="cloud-1" value="AWS Cloud" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;strokeColor=#232F3E;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#232F3E;dashed=0;" vertex="1" parent="1">
  <mxGeometry x="20" y="20" width="1100" height="780" as="geometry" />
</mxCell>
```

### Region Group

```xml
<mxCell id="region-1" value="ap-northeast-1" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#00A4A6;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#00A4A6;dashed=1;dashPattern=3 3;" vertex="1" parent="cloud-1">
  <mxGeometry x="40" y="40" width="1020" height="700" as="geometry" />
</mxCell>
```

### VPC Group

```xml
<mxCell id="vpc-main" value="VPC (10.0.0.0/16)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc2;strokeColor=#8C4FFF;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;" vertex="1" parent="region-1">
  <mxGeometry x="40" y="60" width="940" height="600" as="geometry" />
</mxCell>
```

### Availability Zone Group

```xml
<mxCell id="az-1a" value="Availability Zone (ap-northeast-1a)" style="fillColor=none;strokeColor=#00A4A6;dashed=1;dashPattern=5 5;fontColor=#00A4A6;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="vpc-main">
  <mxGeometry x="20" y="40" width="430" height="540" as="geometry" />
</mxCell>
```

### Public Subnet Group

```xml
<mxCell id="subnet-public-1a" value="Public Subnet (10.0.1.0/24)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#7AA116;fillColor=#E9F3E6;verticalAlign=top;align=left;spacingLeft=30;fontColor=#248814;dashed=0;" vertex="1" parent="az-1a">
  <mxGeometry x="20" y="40" width="390" height="230" as="geometry" />
</mxCell>
```

### Private Subnet Group

```xml
<mxCell id="subnet-private-1a" value="Private Subnet (10.0.2.0/24)" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#147EBA;fillColor=#E6F2F8;verticalAlign=top;align=left;spacingLeft=30;fontColor=#147EBA;dashed=0;" vertex="1" parent="az-1a">
  <mxGeometry x="20" y="290" width="390" height="230" as="geometry" />
</mxCell>
```

### Security Group

```xml
<mxCell id="sg-web" value="Security Group (web-sg)" style="fillColor=none;strokeColor=#DD344C;dashed=0;fontColor=#DD344C;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=10;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="20" y="40" width="350" height="170" as="geometry" />
</mxCell>
```

### Auto Scaling Group

```xml
<mxCell id="asg-web" value="Auto Scaling group" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_auto_scaling_group;strokeColor=#ED7100;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#ED7100;dashed=1;dashPattern=5 5;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="20" y="40" width="350" height="170" as="geometry" />
</mxCell>
```

### ECS Service Group

Place inside a Private Subnet. Uses a solid orange border container with a small ECS Service
icon placed as a child cell in the top-left corner (mimicking a group icon marker).

```xml
<!-- ECS Service container group -->
<mxCell id="ecs-svc-1a" value="ECS Service" style="fillColor=none;strokeColor=#ED7100;dashed=0;fontColor=#ED7100;fontStyle=1;fontSize=11;verticalAlign=top;align=left;spacingLeft=30;html=1;whiteSpace=wrap;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;" vertex="1" parent="subnet-priv-app-1a">
  <mxGeometry x="15" y="35" width="510" height="100" as="geometry" />
</mxCell>

<!-- ECS Service icon marker (top-left corner of the group) -->
<mxCell id="ecs-svc-icon-1a" value="" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#ED7100;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.ecs_service;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="5" y="5" width="24" height="24" as="geometry" />
</mxCell>
```

### ECS Task Icon (inside ECS Service Group)

The ECS Task is the actual communication endpoint. **All arrows (incoming from ALB, outgoing
to databases, etc.) MUST connect to the ECS Task icon.**

```xml
<mxCell id="task-1a" value="ECS Task" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#ED7100;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.ecs_task;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="60" y="35" width="48" height="48" as="geometry" />
</mxCell>
```

### Fargate Icon (inside ECS Service Group)

When using the Fargate launch type, place the Fargate icon inside the ECS Service group.
**Position it away from the ECS Task icon (e.g., right side of the group) so it does not
overlap with communication arrow paths.** The Fargate icon is a launch-type indicator —
never connect arrows to/from it.

```xml
<mxCell id="fargate-1a" value="AWS Fargate" style="sketch=0;points=[[0,0,0],[0.25,0,0],[0.5,0,0],[0.75,0,0],[1,0,0],[0,1,0],[0.25,1,0],[0.5,1,0],[0.75,1,0],[1,1,0],[0,0.25,0],[0,0.5,0],[0,0.75,0],[1,0.25,0],[1,0.5,0],[1,0.75,0]];outlineConnect=0;fontColor=#232F3E;gradientColor=#F78E04;gradientDirection=north;fillColor=#ED7100;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.fargate;" vertex="1" parent="ecs-svc-1a">
  <mxGeometry x="420" y="25" width="48" height="48" as="geometry" />
</mxCell>
```

### Corporate Data Center Group

```xml
<mxCell id="dc-1" value="Corporate Data Center" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_corporate_data_center;strokeColor=#7D8998;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#7D8998;dashed=0;" vertex="1" parent="1">
  <mxGeometry x="20" y="20" width="300" height="200" as="geometry" />
</mxCell>
```

## Service Icon Templates

### Standard Service Icon (with gradient background)

```xml
<mxCell id="ec2-web" value="Amazon EC2&lt;br&gt;web" style="sketch=0;points=[[0,0,0],[0.25,0,0],[0.5,0,0],[0.75,0,0],[1,0,0],[0,1,0],[0.25,1,0],[0.5,1,0],[0.75,1,0],[1,1,0],[0,0.25,0],[0,0.5,0],[0,0.75,0],[1,0.25,0],[1,0.5,0],[1,0.75,0]];outlineConnect=0;fontColor=#232F3E;gradientColor=#F78E04;gradientDirection=north;fillColor=#ED7100;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.ec2;" vertex="1" parent="subnet-public-1a">
  <mxGeometry x="60" y="60" width="48" height="48" as="geometry" />
</mxCell>
```

The key properties per category:
- `fillColor`: Category base color
- `gradientColor`: Category gradient color
- `gradientDirection=north`: Standard gradient direction
- `strokeColor=#ffffff`: White border
- `resIcon=mxgraph.aws4.{service}`: The actual icon

### Resource Icon (small, flat)

```xml
<mxCell id="lambda-fn" value="Lambda Function&lt;br&gt;handler" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#ED7100;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.lambda_function;" vertex="1" parent="region-1">
  <mxGeometry x="100" y="100" width="40" height="40" as="geometry" />
</mxCell>
```

### General Icons (Users, Internet, etc.)

```xml
<!-- Users -->
<mxCell id="users" value="Users" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#232F3E;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.users;" vertex="1" parent="1">
  <mxGeometry x="20" y="350" width="48" height="48" as="geometry" />
</mxCell>

<!-- Internet -->
<mxCell id="internet" value="Internet" style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#232F3E;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.internet_alt2;" vertex="1" parent="1">
  <mxGeometry x="20" y="350" width="48" height="48" as="geometry" />
</mxCell>
```

## Arrow Templates

### Standard Arrow (orthogonal, right-angle routing)

```xml
<mxCell id="arrow-1" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=1;endArrow=block;endFill=1;fontSize=12;" edge="1" source="ec2-web" target="rds-main" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Arrow with Label

```xml
<mxCell id="arrow-2" value="HTTPS" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=1;endArrow=block;endFill=1;fontSize=11;labelBackgroundColor=#ffffff;" edge="1" source="alb-web" target="ec2-web" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Bidirectional Arrow

```xml
<mxCell id="arrow-3" value="sync" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#232F3E;strokeWidth=1;endArrow=block;endFill=1;startArrow=block;startFill=1;fontSize=11;" edge="1" source="rds-primary" target="rds-standby" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Dashed Arrow (optional/conditional flow)

```xml
<mxCell id="arrow-4" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;strokeColor=#7D8998;strokeWidth=1;dashed=1;endArrow=block;endFill=1;fontSize=11;" edge="1" source="lambda-fn" target="sns-topic" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Arrow with Exit/Entry Constraints (routing around obstacles)

draw.io's `orthogonalEdgeStyle` does NOT automatically avoid icons in the path.
When an arrow would cross through a non-communication icon (e.g., NAT Gateway in a
Public Subnet), add **exit/entry constraints** to the edge style to force the routing direction.

| Property | Value | Effect |
|----------|-------|--------|
| `exitX`  | 0–1   | Horizontal position on source (0=left, 0.5=center, 1=right) |
| `exitY`  | 0–1   | Vertical position on source (0=top, 0.5=middle, 1=bottom) |
| `entryX` | 0–1   | Horizontal position on target |
| `entryY` | 0–1   | Vertical position on target |
| `exitDx` / `exitDy` | 0 | Pixel offset (normally 0) |
| `entryDx` / `entryDy` | 0 | Pixel offset (normally 0) |

**Common pattern — top-to-bottom routing (bypass Public Subnet level):**

```xml
<!-- ALB → ECS Task: exit bottom, enter top → routes below Public Subnet -->
<mxCell id="arrow-5" value="" style="edgeStyle=orthogonalEdgeStyle;html=1;rounded=0;
  strokeColor=#232F3E;strokeWidth=1;endArrow=block;endFill=1;fontSize=11;
  exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;"
  edge="1" source="alb" target="task-1a" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

**Route produced:** ALB bottom → straight down → horizontal turn → ECS Task top.
This bypasses any icons (NAT Gateway, etc.) in the Public Subnet at the ALB's y-level.
Unlike waypoints, exit/entry constraints do not require absolute coordinate calculations
and work correctly regardless of layout changes.

## Numbered Callouts

```xml
<!-- Large callout -->
<mxCell id="callout-1" value="1" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#FFFFFF;strokeColor=#232F3E;strokeWidth=2;fontSize=14;fontStyle=1;fontColor=#232F3E;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="30" height="30" as="geometry" />
</mxCell>

<!-- Small callout -->
<mxCell id="callout-2" value="2" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#FFFFFF;strokeColor=#232F3E;strokeWidth=1.5;fontSize=10;fontStyle=1;fontColor=#232F3E;" vertex="1" parent="1">
  <mxGeometry x="200" y="200" width="20" height="20" as="geometry" />
</mxCell>
```

## Common Gotchas

1. **Parent references across groups**: Arrows connecting icons in different groups should have
   `parent="1"` (root level), NOT the parent of either endpoint. This avoids clipping issues.

2. **Container flag**: All groups MUST have `container=1;collapsible=0;recursiveResize=0` in their
   style to properly contain children.

3. **HTML labels**: Use `html=1` in style and `&lt;br&gt;` for line breaks in `value` attribute.
   Encode `<` as `&lt;` and `>` as `&gt;` in XML attribute values.

4. **Geometry coordinates**: Child element coordinates are relative to their parent group's origin.
   A child at `(20, 30)` is 20px right and 30px down from the parent's top-left corner.

5. **Icon aspect ratio**: Always include `aspect=fixed` for icons to prevent stretching.

6. **Points array**: The `points=[[0,0,0],...,[1,0.75,0]]` in group styles define connection anchor
   points. Include the full set for groups; use the short 16-point set for service icons.

7. **Edge routing**: Set `edgeStyle=orthogonalEdgeStyle` for right-angle routing per AWS guidelines.
   Avoid `curved=1` or bezier edges.

8. **Font**: All labels should use `fontSize=12` (standard) or `fontSize=11` (compact).
   The AWS guidelines specify 12pt Arial. draw.io uses sans-serif by default which is close enough.

9. **Arrow path overlap prevention**: When a fan-out icon (e.g., CloudFront) sends arrows to 3+
   targets, peer icons at the same y-level can visually collide with the arrow paths.

   **Mitigation checklist:**
   - Identify every icon with 3 or more outgoing arrows (fan-out source).
   - Compute the horizontal span of all targets: `[min(target_x) - 40px, max(target_x + width) + 40px]`.
   - Check whether any peer icon (same y-level, not a target) has its center within that span.
   - If so, shift the peer icon horizontally past the span edge (away from the source center).

   ```
   WRONG — Route 53 and ACM sit on the arrow paths from CloudFront to S3 buckets:

        Users
          |
      CloudFront ──→ S3-A
    Route53  ACM  ──→ S3-B     ← icons overlap arrows
                  ──→ S3-C

   CORRECT — Route 53 and ACM are shifted outside the fan-out zone:

   Route53   ACM        Users
      \       |           |
       \      |       CloudFront
        \     |      /    |    \
         \    |    S3-A  S3-B  S3-C
   ```