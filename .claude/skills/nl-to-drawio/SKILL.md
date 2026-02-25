---
name: nl-to-drawio
description: "Generate AWS architecture diagrams from natural language descriptions. Use this skill whenever the user asks to create an architecture diagram from a text description (not from Terraform code). Trigger on: 'draw architecture', 'design a system', 'diagram for [service names]', '構成図を作って', '構成図を描いて', 'アーキテクチャ図を作成', or when the user describes AWS services and asks for a visual diagram. Produces diagrams that strictly follow the AWS Architecture Icons guidelines (Release 22-2025.07.31) with correct resource placement hierarchy, group nesting, official icon shapes, and proper arrow/label formatting."
---

# Natural Language to Draw.io AWS Architecture Diagram Generator

## Overview

This skill interprets natural language descriptions of AWS architectures, infers the required services and their relationships, determines correct spatial placement, and generates a standards-compliant `.drawio` XML file using official AWS Architecture Icons (mxgraph.aws4.*).

## Before You Begin

Read these shared reference files (used by all draw.io diagram generation skills):

1. Read `../shared-references/icon-mapping.md` — AWS service → draw.io shape mapping
2. Read `../shared-references/group-hierarchy.md` — Group nesting rules, colors, and draw.io XML patterns
3. Read `../shared-references/placement-rules.md` — Which AWS resources belong inside which groups
4. Read `../shared-references/drawio-xml-patterns.md` — XML templates for generating valid draw.io files

Read these NL-specific reference files:

5. Read `references/architecture-patterns.md` — Common AWS architecture patterns with trigger phrases
6. Read `references/service-alias-map.md` — NL terms (EN/JA) → canonical AWS service names
7. Read `references/abstraction-levels.md` — Overview vs Detailed diagram definitions and detection rules

## Ambiguity Resolution Policy

When generating diagrams from natural language, ambiguity is inherent. Follow these principles:

1. **Generate first, explain later** — Do NOT ask clarifying questions before generating. Produce the diagram immediately, then report all assumptions made and offer adjustment options.

2. **Security & HA defaults** — When placement is ambiguous:
   - Default to private subnet for compute/database resources
   - Default to Multi-AZ for databases in detailed diagrams
   - Default to VPC-internal for services that support both VPC and non-VPC modes

3. **Minimal inference** — Only add services that are:
   - **Explicitly mentioned** by the user
   - **Structurally required** (e.g., VPC requires at least one subnet, public internet access requires IGW)
   - **Strongly implied by the matched pattern** (e.g., a "3-tier web app" implies ALB even if not stated)
   - Do NOT add monitoring, logging, WAF, etc. unless mentioned (but suggest them in Step 6)

4. **Region default** — `ap-northeast-1` unless specified otherwise

5. **Extreme ambiguity fallback** — If the input is too vague to determine any specific pattern (e.g., "Webアプリの構成図" with no further detail), generate a **3-Tier Web Application** (Pattern 1 from architecture-patterns.md) and clearly state this is the default.

## Workflow

### Step 0: Determine Abstraction Level

Consult `references/abstraction-levels.md` and classify the user's request as **Overview** or **Detailed**.

**Decision process:**
1. Check for explicit cues (e.g., "詳細設計図", "overview", "Multi-AZ")
2. Check for implicit cues (e.g., CIDR mentions → Detailed, brief service list → Overview)
3. Default to **Overview** if no cues match

Record the chosen level and the reason for the choice. This affects all subsequent steps.

### Step 1: Interpret Natural Language → Extract Resources & Connections

Analyze the user's text through these sub-steps:

#### Step 1a: Identify Explicitly Mentioned Services

Using `references/service-alias-map.md`, resolve every service mention to its canonical AWS name:

- "ロードバランサー" → Application Load Balancer
- "RDS" → Amazon RDS
- "Lambda" → AWS Lambda
- Handle disambiguation (see Disambiguation Rules in service-alias-map.md)

#### Step 1b: Match Architecture Patterns

Using `references/architecture-patterns.md`, match the description against known patterns:

- Check trigger phrases for pattern matches
- A description may match multiple patterns (combine them per Pattern Combination Rules)
- Add **Required Components** from matched patterns that weren't explicitly mentioned
- Do NOT auto-add Optional Components unless the user mentions them

#### Step 1c: Infer Implicit Infrastructure

Add structurally necessary infrastructure that the user didn't mention:

| If these exist... | Then add... | Reason |
|---|---|---|
| Any VPC-internal resource | VPC | Container required |
| VPC with internet-facing resources | Internet Gateway | Structural requirement |
| VPC with private subnet resources needing internet | NAT Gateway | Outbound access |
| Any internet-facing service | Users icon | Traffic source |
| ALB, CloudFront, or API Gateway as entry point | Users → entry point arrow | Traffic flow |

For **Overview** level: Only add VPC (as a simple box). Omit IGW, NAT, subnets.
For **Detailed** level: Add full subnet hierarchy, IGW, NAT, per-AZ duplication.

#### Step 1d: Infer Connection Relationships

Determine arrows between services based on:

1. **Explicit flow** mentioned by user (e.g., "CloudFront → ALB → ECS")
2. **Pattern topology** from matched patterns (e.g., Serverless API: API GW → Lambda → DynamoDB)
3. **Standard conventions**:
   - Users → first internet-facing service (CloudFront, ALB, API Gateway)
   - Load balancer → compute (EC2, ECS, Lambda)
   - Compute → database/cache
   - Compute → queue/notification → downstream compute

#### Step 1e: Build Internal Representation (JSON)

Construct the same internal representation used by the terraform-to-drawio skill:

```json
{
  "abstraction_level": "overview|detailed",
  "resources": [
    {
      "service_type": "ecs_fargate",
      "label": "Amazon ECS\n(Fargate)",
      "drawio_shape": "resIcon=mxgraph.aws4.fargate",
      "placement": {
        "region": "ap-northeast-1",
        "vpc": true,
        "subnet_type": "private",
        "az": "ap-northeast-1a"
      },
      "source": "explicit|pattern|inferred"
    }
  ],
  "connections": [
    { "from": "alb", "to": "ecs-task", "label": "HTTPS" }
  ]
}
```

The `source` field tracks why each resource was included:
- `explicit` — user directly mentioned it
- `pattern` — added as a required component of a matched pattern
- `inferred` — structurally necessary infrastructure

### Step 2: Resolve Placement Hierarchy

Consult `../shared-references/placement-rules.md` for placement rules.

Since NL input doesn't have Terraform attributes (`vpc_id`, `subnet_id`), resolve placement by **service type**:

| Placement Logic | Rule |
|---|---|
| Service is always VPC-internal (EC2, RDS, ALB, etc.) | Place inside VPC → Subnet |
| Service is conditionally VPC (Lambda, ECS Fargate) | Default: inside VPC (private subnet) unless user says otherwise |
| Service is regional (S3, DynamoDB, SQS, SNS, etc.) | Place inside Region, outside VPC |
| Service is global (CloudFront, Route 53) | Place inside AWS Cloud, outside Region |
| External elements (Users, Internet, On-premises) | Place outside AWS Cloud |

**For Overview level:**
- Place VPC-internal services inside a single VPC group (no subnet/AZ breakdown)
- Place regional services inside Region
- Place global services inside AWS Cloud

**For Detailed level:**
- Apply full placement hierarchy: AWS Cloud → Region → VPC → AZ → Subnet
- Duplicate per-AZ resources across 2 AZs
- Place IGW at VPC border, NAT in public subnet
- Follow all ECS/EKS/RDS placement rules from placement-rules.md

### Step 3: Calculate Layout Geometry

Compute the (x, y, width, height) for each group and resource icon.

**Layout algorithm:**

1. Start with the outermost group (AWS Cloud) at position (0, 0)
2. Add padding: 40px on all sides for each group level
3. Service icons are 48x48 (standard) or 64x64 (service icons in the deck are 762000 EMU ~ 64px equivalent)
4. Resource icons are 40x40 (457200 EMU ~ 40px equivalent)
5. Labels are placed below icons (verticalLabelPosition=bottom)
6. Spacing between icons: minimum 80px horizontal, 60px vertical
7. Groups grow to contain all their children plus padding
8. Inner groups have at least 5px buffer from outer group edges (per AWS guideline)
9. Callout numbers: order left→right, top→bottom, or clockwise

**Arrow-aware layout rules (prevent icon / arrow-path overlap):**

> Apply these rules **after** initial icon placement (rules 1-9 above) and **before** finalizing canvas size.

**Rule A — Row-Based Tier Assignment**

Assign every icon to a horizontal row (tier) based on its depth in the connection graph:

| Tier | Category | Examples |
|------|----------|----------|
| 0 | External | Users, Internet |
| 1 | Global services | Route 53, CloudFront, ACM, WAF |
| 2 | Regional edge | API Gateway, S3, ALB/NLB, CloudWatch |
| 3+ | Internal services | Lambda, DynamoDB, RDS, ECS, SQS, etc. |

- Icons in different tiers must be separated by at least `tier_gap = max(100px, 60px + label_height)`.
- Icons within the same tier share the same y-center.

**Rule A+ — Primary Flow Alignment**

After tier assignment, identify the **primary ingress target** for each Tier 0 icon and align them vertically:

1. **Identify the primary ingress target** (Tier に関係なく):
   - From each Tier 0 icon (Users, Internet), examine all outgoing arrows.
   - The **primary ingress target** is the directly-connected service that has the **most outgoing arrows to downstream services** (i.e., the highest fan-out count). This heuristic selects the main request-routing service (e.g., CloudFront, API Gateway, ALB) over auxiliary services (e.g., Route 53 for DNS).
   - Tie-breaker: prefer the service in the lower-numbered tier (closer to external). If still tied, prefer the service that appears first left-to-right.

2. **X-align Tier 0 icon with its primary ingress target** (±24px tolerance, half an icon width).

3. **Continue the chain**: for each icon in the primary chain, its primary downstream target should also be x-aligned when in adjacent tiers.

4. **Top-to-bottom placement**: Tier 0 icons are placed **above** the AWS Cloud group boundary.

5. **Secondary services off the main axis**: Services that connect **to** the primary flow but are not **on** the primary flow (e.g., Route 53, ACM) should be placed to the **side**.

**Rule B — Fan-Out Zone Reservation**

When an icon has **3 or more outgoing arrows**, compute the fan-out zone:

```
fan_left  = min(target_x for all targets) - 40px
fan_right = max(target_x + icon_width for all targets) + 40px
fan_y_top = source_y + icon_height
fan_y_bot = min(target_y for all targets)
```

- No **other** icon's center (on the same tier as the source) may fall within `[fan_left, fan_right]`.

**Rule C — Arrow Path Bounding Box**

For each arrow, compute the orthogonal-route bounding box with ±10 px padding:

```
arrow_bbox = {
  x: min(source_center_x, target_center_x) - 10,
  y: min(source_center_y, target_center_y) - 10,
  w: |source_center_x - target_center_x| + 20,
  h: |source_center_y - target_center_y| + 20
}
```

- No **unrelated** icon's center may fall within any `arrow_bbox`.

**Rule D — Post-Placement Overlap Validation**

After all icons are placed, run a validation pass:

1. For every icon, check whether its center is inside any `arrow_bbox` (Rule C) or fan-out zone (Rule B) to which it is not an endpoint.
2. On conflict: shift the icon horizontally away from the arrow's source (minimum 40 px buffer from the bbox/zone edge).
3. Run up to **3 iterations**. If conflicts remain after 3 iterations, increase `tier_gap` by 40 px and re-run the full layout from Rule A.

**Recommended canvas sizing:**

- Simple diagrams (< 10 resources): 800 x 600
- Medium diagrams (10-30 resources): 1200 x 900
- Complex diagrams (30+ resources): 1600 x 1200+

### Step 4: Generate Draw.io XML

Use the templates in `../shared-references/drawio-xml-patterns.md` to assemble the XML.

**Key principles:**

- Every group is a `container=1` mxCell with `collapsible=0;recursiveResize=0`
- Children reference their parent group via the `parent` attribute
- Service icons use `shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.{service_name}`
- Resource icons use `shape=mxgraph.aws4.{resource_name}` (smaller, no gradient background)
- Arrows use `edgeStyle=orthogonalEdgeStyle` for right-angle lines (per AWS guideline)
- Labels: 12px Arial, service names on max 2 lines
- Use short forms only after full name appears once in the diagram

**File structure:**

```xml
<mxfile host="app.diagrams.net" type="device">
  <diagram id="..." name="AWS Architecture">
    <mxGraphModel dx="..." dy="..." grid="1" gridSize="10" guides="1" tooltips="1"
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

### Step 5: Validate and Output

Before writing the file:

1. Verify every resource is placed in a valid group (no orphaned icons floating outside all groups)
2. Verify group nesting is correct (no Subnet outside a VPC, no AZ outside a Region)
3. Verify all `parent` attributes reference valid cell IDs
4. Verify no overlapping geometries within the same parent
5. Verify no icon center falls within any arrow's bounding box or fan-out zone (per Arrow-aware layout rules in Step 3). If overlap exists, apply Rule D shifts before generating output.
6. Verify arrows connect to valid source/target cell IDs
7. Write the `.drawio` file to Current Directory

### Step 5.5: Visual Verification (Optional)

After writing the `.drawio` file, perform a visual verification loop using the drawio MCP
and Playwright MCP tools. This step catches layout issues that structural validation (Step 5)
cannot detect: icon overlap, arrow-icon intersection, label truncation, and overall readability.

**Prerequisites:**
- drawio MCP server is configured (`mcp__drawio__open_drawio_xml` available)
- Playwright MCP server is configured (`@playwright/mcp` in `.mcp.json`)

**Verification flow:**

1. **Open in lightbox mode**: Call `mcp__drawio__open_drawio_xml` with the generated XML
   content and `lightbox=true`. Extract the URL from the response.

2. **Launch Playwright agent**: Use the Task tool to launch a `playwright-test-planner` agent
   with the following instructions:

   ```
   Task(
     subagent_type="playwright-test-planner",
     description="Screenshot drawio diagram for visual verification",
     prompt="
       1. Navigate to this URL: {url_from_step_1}
       2. Wait for the diagram to fully render:
          - Use browser_wait_for to wait for the SVG canvas to appear
            (wait for 'svg' element or '.geDiagramContainer' to be visible)
          - Wait an additional 2 seconds for icon rendering to complete
       3. Take a full-page screenshot using browser_take_screenshot
       4. Use browser_evaluate to extract element position data:
          - Run JavaScript to find all SVG <g> elements with 'data-cell-id' attributes
          - For each element, extract: cell-id, transform (x, y), bounding box (width, height)
          - Return as JSON array
       5. Report back:
          - The screenshot file path
          - The position data JSON
          - Any rendering errors visible in the console (use browser_console_messages)
     "
   )
   ```

3. **Analyze results**: Read the screenshot using the Read tool (supports images).
   Check for these visual issues:

   | Check | What to look for |
   |-------|-----------------|
   | Icon overlap | Two or more icons visually overlapping |
   | Arrow-icon intersection | An arrow passing through an unrelated icon |
   | Label truncation | Labels cut off or overlapping other elements |
   | Group containment | Icons visually outside their parent group boundary |
   | Overall flow clarity | Primary traffic flow should be visually obvious (top-to-bottom or left-to-right) |
   | Empty regions | Large empty spaces that could be compacted |

4. **Fix and iterate**: If issues are found:
   a. Identify the specific resources/groups with problems
   b. Adjust the XML geometry (x, y, width, height) values
   c. Re-write the `.drawio` file
   d. Repeat from step 1 (maximum **2 iterations**)

5. **Skip conditions**: Skip this step if:
   - The diagram has fewer than 5 resources (simple diagrams rarely have layout issues)
   - The user explicitly requests to skip visual verification
   - drawio MCP or Playwright MCP is not available

**Example Playwright JavaScript for position extraction:**

```javascript
// Run via browser_evaluate
(() => {
  const cells = document.querySelectorAll('g[data-cell-id]');
  return Array.from(cells).map(g => {
    const rect = g.getBoundingClientRect();
    return {
      cellId: g.getAttribute('data-cell-id'),
      x: Math.round(rect.x),
      y: Math.round(rect.y),
      width: Math.round(rect.width),
      height: Math.round(rect.height)
    };
  });
})()
```

### Step 6: Present to User

Provide a comprehensive summary after generating the diagram:

#### 6a: Diagram Metadata
- **Abstraction level used**: Overview or Detailed (with reason)
- **Architecture pattern(s) matched**: Which patterns from architecture-patterns.md were identified
- **Total resources**: Count of services in the diagram

#### 6b: Service Attribution
Present services in three categories:

**Explicitly requested** (user mentioned these):
- List each service the user named

**Added from pattern** (required by matched architecture pattern):
- List each service with the pattern that required it
- Example: "ALB — required by 3-Tier Web Application pattern"

**Inferred infrastructure** (structurally necessary):
- List each service with the reason it was added
- Example: "Internet Gateway — required for public internet access to VPC"
- Example: "NAT Gateway — required for private subnet outbound internet access"

#### 6c: Improvement Suggestions
Suggest optional enhancements the user might want to add:

- **Monitoring**: "CloudWatch を追加すると監視が可能です"
- **Security**: "WAF を CloudFront/ALB の前に追加すると Web アプリの保護が強化されます"
- **High Availability**: "Multi-AZ 構成にすると可用性が向上します" (for Overview level)
- **Caching**: "ElastiCache を追加するとパフォーマンスが向上します"
- **CDN**: "CloudFront を追加するとレスポンスが高速化されます"

Only suggest improvements that are relevant to the specific architecture.

#### 6d: Adjustment Options
Offer concrete next steps:

- "詳細設計図に切り替えたい場合は「詳細に」とお伝えください" (if Overview was generated)
- "概要図に切り替えたい場合は「シンプルに」とお伝えください" (if Detailed was generated)
- "サービスの追加/削除: 「ElastiCache を追加して」「NAT Gatewayを削除して」"
- "接続の変更: 「Lambda から DynamoDB への矢印を追加して」"

## Guidelines from AWS Architecture Icons Deck (Release 22-2025.07.31)

### DO
- Use icons at their predefined size, color, and format
- Use straight lines and right angles for arrows
- Break service name labels after the second word if necessary
- Use short forms (e.g., "Amazon EC2") after full name mentioned once
- Order callout numbers linearly: left→right, top→bottom, or clockwise
- Use the correct group border colors and dash patterns (see group-hierarchy.md)

### DON'T
- Crop, flip, rotate, or reshape icons
- Create groups with non-approved AWS icons
- Resize group icons
- Mix callout sizes within the same diagram
- Break a line in the middle of a word
- Use short forms without first mentioning the full service name

## Resource Filtering

**Always include:** Compute (EC2, Lambda, ECS, EKS, Fargate), Networking (VPC, Subnet, IGW, NAT, ALB/NLB, CloudFront, Route 53, Transit Gateway, VPN), Database (RDS, Aurora, DynamoDB, ElastiCache, Redshift), Storage (S3, EFS, EBS), Application Integration (SQS, SNS, EventBridge, Step Functions, API Gateway), Security (WAF, Shield, KMS, Secrets Manager, ACM), Management (CloudWatch, CloudTrail), Analytics (Kinesis, Glue, Athena, OpenSearch)

**Exclude by default (unless user requests):** IAM (policies, roles, instance profiles), Security Group rules (the SG group box suffices), Route table entries, CloudWatch log groups/metrics (unless CloudWatch is explicitly mentioned), Tags

## Error Handling

- If the user's description is in a language other than English or Japanese, attempt to interpret but warn that EN/JA provides best results
- If service names are misspelled, attempt fuzzy matching against service-alias-map.md
- If the architecture doesn't make logical sense (e.g., "Lambda inside RDS"), generate the closest valid interpretation and flag the issue
- If too many services are requested (>50), suggest splitting into multiple diagrams
