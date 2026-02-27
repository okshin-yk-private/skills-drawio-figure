---
name: terraform-to-drawio
description: "Generate AWS architecture diagrams in draw.io (.drawio) format from Terraform source code. Use this skill whenever the user asks to create an architecture diagram, infrastructure diagram, or network topology diagram from Terraform files (.tf), Terraform state, or HCL code. Also trigger when the user mentions 構成図, アーキテクチャ図, drawio, or wants to visualize their AWS infrastructure defined in Terraform/OpenTofu/CDK. Produces diagrams that strictly follow the AWS Architecture Icons guidelines (Release 22-2025.07.31) with correct resource placement hierarchy (VPC内/外), group nesting, official icon shapes, and proper arrow/label formatting."
---

# Terraform to Draw.io AWS Architecture Diagram Generator

## Overview

This skill parses Terraform HCL source code, identifies AWS resources and their relationships,
determines correct spatial placement (VPC内, Subnet内, AZ, Region, etc.), and generates a
standards-compliant `.drawio` XML file using official AWS Architecture Icons (mxgraph.aws4.*).

## Before You Begin

1. Read `../shared-references/icon-mapping.md` — Terraform resource type → draw.io shape mapping
2. Read `../shared-references/group-hierarchy.md` — Group nesting rules, colors, and draw.io XML patterns
3. Read `../shared-references/placement-rules.md` — Which AWS resources belong inside which groups
4. Read `../shared-references/drawio-xml-patterns.md` — XML templates for generating valid draw.io files

## Workflow

### Step 1: Parse Terraform Code

Analyze the user's Terraform files to extract:

- All `resource` blocks with their type and logical name
- All `data` blocks referencing existing infrastructure
- All `module` blocks (expand if source is available)
- Key attributes that determine placement:
  - `vpc_id`, `subnet_id`, `subnet_ids` → determines VPC/Subnet membership
  - `availability_zone`, `availability_zones` → determines AZ placement
  - `security_groups`, `vpc_security_group_ids` → Security Group associations
  - References between resources via `resource_type.name.id` patterns

Build an internal dependency graph:

```
{
  "resources": [
    {
      "tf_type": "aws_instance",
      "tf_name": "web",
      "drawio_shape": "mxgraph.aws4.ec2",       // from icon-mapping.md
      "label": "Amazon EC2\nweb",
      "placement": {
        "region": "ap-northeast-1",              // from provider or resource
        "vpc": "aws_vpc.main",                   // resolved from vpc_id reference
        "subnet": "aws_subnet.public_1",         // resolved from subnet_id
        "az": "ap-northeast-1a",                 // from subnet or explicit
        "security_group": "aws_security_group.web_sg"
      }
    }
  ],
  "connections": [
    { "from": "aws_instance.web", "to": "aws_db_instance.main", "label": "MySQL 3306" }
  ]
}
```

### Step 2: Resolve Placement Hierarchy

This is the most critical step. Incorrect placement (e.g., Lambda inside a VPC when no
`vpc_config` is specified, or S3 inside a VPC) produces misleading diagrams.

**Hierarchy (outer → inner):**

```
AWS Cloud
  └── Region
       ├── VPC
       │    ├── Availability Zone (optional grouping)
       │    │    ├── Public Subnet
       │    │    │    └── [resources with public subnet_id]
       │    │    └── Private Subnet
       │    │         └── [resources with private subnet_id]
       │    └── Security Group (optional, overlay)
       │         └── [resources referencing this SG]
       └── [VPC-external regional services: S3, DynamoDB, CloudFront, Route 53, etc.]
```

**Decision rules for placement — consult `../shared-references/placement-rules.md` for the full list:**

- If a resource has `subnet_id` or `subnet_ids` → place inside the corresponding Subnet group
- If a resource has `vpc_id` but no subnet → place inside VPC but outside any Subnet
- If a resource has neither `vpc_id` nor `subnet_id` → place outside VPC (regional or global service)
- Some resources like Lambda are conditionally VPC-based: only if `vpc_config` block is present
- **Security service grouping**: After determining all arrows, check if security services (KMS, GuardDuty, Inspector, Secrets Manager, etc.) have zero arrows. If so, group them in a "Security & Compliance" dashed group at Region level. See `placement-rules.md` > "Security & Compliance Grouping" for details.
- For resources where placement is ambiguous, consult the AWS public documentation.
  If MCP tools are available, use them to verify. If not, use web search to confirm.

### Step 3: Calculate Layout Geometry

Compute the (x, y, width, height) for each group and resource icon.

**Layout algorithm:**

1. Start with the outermost group (AWS Cloud) at position (0, 0)
2. Add padding: 40px on all sides for each group level
3. Service icons are 48x48 (standard) or 64x64 (service icons in the deck are 762000 EMU ≈ 64px equivalent)
4. Resource icons are 40x40 (457200 EMU ≈ 40px equivalent)
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

2. **X-align Tier 0 icon with its primary ingress target** (±24px tolerance, half an icon width). This ensures the entry point and the first service are vertically aligned regardless of which tier the target belongs to.

3. **Continue the chain**: for each icon in the primary chain, its primary downstream target (the target carrying the main request flow — typically the arrow without a branch label, or the one with the highest fan-out) should also be x-aligned when in adjacent tiers.

4. **Top-to-bottom placement**: Tier 0 icons are placed **above** the AWS Cloud group boundary. The Tier 0 icon's y-position should be `cloud_y - tier_gap - icon_height` so that a straight downward arrow reaches the target.

5. **Secondary services off the main axis**: Services that connect **to** the primary flow but are not **on** the primary flow (e.g., Route 53 providing DNS resolution, ACM providing certificates) should be placed to the **side** (left or right) of the primary chain, not between the Tier 0 icon and the primary target.

**Rule B — Fan-Out Zone Reservation**

When an icon has **3 or more outgoing arrows**, compute the fan-out zone:

```
fan_left  = min(target_x for all targets) - 40px
fan_right = max(target_x + icon_width for all targets) + 40px
fan_y_top = source_y + icon_height
fan_y_bot = min(target_y for all targets)
```

- No **other** icon's center (on the same tier as the source) may fall within `[fan_left, fan_right]`.
- On conflict: shift the colliding icon away from the source center — left if already left, right if already right.

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
- When multiple arrows exist, take the union of all bounding boxes to form a **combined arrow corridor**.

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
and Chrome headless screenshot. This step catches layout issues that structural validation
(Step 5) cannot detect: icon overlap, arrow-icon intersection, label truncation, and
overall readability.

**Prerequisites:**
- `google-chrome` or `chromium` is available on the system
- For the primary method (Step 1-2b): drawio MCP server is configured (`mcp__drawio__open_drawio_xml` available)
- For the HTML fallback (Step 2c): `node` is available and internet access for CDN

**IMPORTANT — Why Chrome headless instead of Playwright:**
draw.io MCP generates `#create=` URLs with compressed, Base64-encoded, percent-encoded XML
in the hash fragment. Playwright's `page.goto()` normalizes URLs via Node.js's `URL()`
constructor (WHATWG URL Standard), which decodes percent-encoded characters in the hash
fragment (`%2B` → `+`, `%2F` → `/`, etc.), corrupting the Base64 data and causing `atob()`
failures. Chrome's headless `--screenshot` mode bypasses this entirely by passing the URL
directly to the Chromium engine without JavaScript URL normalization.

**Verification flow:**

1. **Open in lightbox mode**: Call `mcp__drawio__open_drawio_xml` with the generated XML
   content and `lightbox=true`. Extract the URL from the response.

2. **Save URL and take screenshot**: The URL from drawio MCP is very long (3000+ chars).
   Save it to a temporary file to avoid shell quoting issues, then use Chrome headless.

   **Step 2a — Detect Chrome binary and temp directory:**

   Run the appropriate detection command for the current platform:

   ```bash
   # Detect platform and Chrome binary
   case "$(uname -s)" in
     Linux*)
       CHROME=$(which google-chrome || which chromium || which chromium-browser || which google-chrome-stable || echo "")
       TMPDIR_PATH="/tmp"
       SANDBOX_FLAG="--no-sandbox"
       ;;
     Darwin*)
       CHROME=$(which google-chrome 2>/dev/null || echo "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
       TMPDIR_PATH="${TMPDIR:-/tmp}"
       SANDBOX_FLAG=""
       ;;
   esac
   echo "Chrome: $CHROME"
   ```

   On **Windows** (Git Bash / WSL), the Chrome binary is typically at:
   `"/c/Program Files/Google/Chrome/Application/chrome.exe"` (Git Bash) or
   `/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe` (WSL).

   If no Chrome binary is found, skip visual verification.

   **Step 2b — Save URL and take screenshot:**

   ```bash
   # Save the full URL to a file (use heredoc to avoid shell interpretation)
   cat << 'URLEOF' > "$TMPDIR_PATH/drawio-url.txt"
   {url_from_step_1}
   URLEOF

   # Take screenshot with Chrome headless
   URL=$(cat "$TMPDIR_PATH/drawio-url.txt" | tr -d '\n')
   "$CHROME" --headless=new --disable-gpu $SANDBOX_FLAG \
     --screenshot=/path/to/output/diagram-verify.png \
     --window-size=1920,1200 \
     --virtual-time-budget=20000 \
     "$URL"
   ```

   **Key parameters:**
   - `--headless=new`: Use Chrome's new headless mode (required for modern Chrome)
   - `--virtual-time-budget=20000`: Allow 20 seconds of virtual time for draw.io to
     fully load and render all AWS icons (increase to 30000 for complex diagrams)
   - `--window-size=1920,1200`: Wide viewport to capture the full diagram
   - `--no-sandbox`: Linux only, required in some CI/container environments (omit on macOS/Windows)
   - `--disable-gpu`: Recommended for headless mode on all platforms

   **Step 2c — HTML viewer fallback (if MCP URL fails):**

   The MCP `#create=` URL contains compressed, Base64-encoded, percent-encoded XML.
   This multi-layer encoding is fragile — Chrome may still produce zlib decompression
   errors (`"invalid code lengths set"`) or Base64 decode errors (`"atob()"` failures)
   even in headless mode. If the screenshot from Step 2b shows an error dialog (C4),
   **skip the MCP URL entirely** and use this fallback:

   ```bash
   # 1. Strip XML comments from the .drawio file (comments can contain problematic chars)
   sed '/<!--/d' /path/to/diagram.drawio | sed '/^$/d' > "$TMPDIR_PATH/drawio-clean.xml"

   # 2. Create a self-contained HTML file with draw.io viewer
   node -e "
   const fs = require('fs');
   const xml = fs.readFileSync('$TMPDIR_PATH/drawio-clean.xml', 'utf8');
   const data = JSON.stringify({
     highlight: '#0000ff', nav: false, resize: true,
     toolbar: '', edit: '_blank', xml: xml
   });
   const escaped = data
     .replace(/&/g, '&amp;')
     .replace(/\"/g, '&quot;')
     .replace(/</g, '&lt;')
     .replace(/>/g, '&gt;');
   const html = \`<!DOCTYPE html>
   <html><head><meta charset=\"utf-8\">
   <style>body{margin:0;padding:20px;background:white}</style></head>
   <body>
   <div class=\"mxgraph\" style=\"max-width:100%;border:none;\"
        data-mxgraph=\"\${escaped}\"></div>
   <script src=\"https://viewer.diagrams.net/js/viewer-static.min.js\"></script>
   </body></html>\`;
   fs.writeFileSync('$TMPDIR_PATH/drawio-viewer.html', html);
   "

   # 3. Take screenshot (file:// URL — no encoding issues)
   "$CHROME" --headless=new --disable-gpu $SANDBOX_FLAG \
     --screenshot=/path/to/output/diagram-verify.png \
     --window-size=1920,1400 \
     --virtual-time-budget=30000 \
     "file://$TMPDIR_PATH/drawio-viewer.html"
   ```

   **Why this works:** The XML is embedded as a JSON string inside an HTML attribute.
   No URL percent-encoding, no Base64, no zlib compression — the draw.io viewer JS
   (`viewer-static.min.js`) receives the raw XML directly from the DOM.

   **Requirements:**
   - `node` must be available (for JSON escaping of XML with special characters)
   - Internet access is needed to load `viewer-static.min.js` from the CDN
   - Use `--virtual-time-budget=30000` (higher than MCP URL) because the viewer JS
     must first download from CDN before rendering

   **When to use this fallback:**
   - Screenshot shows error dialog: "ファイル読み込みエラー", "invalid code lengths set",
     "invalid literal", or any other data corruption message
   - The MCP URL is extremely long (>4000 chars) and may be truncated by the shell
   - drawio MCP is not available but Chrome is

3. **Analyze results**: Read the screenshot using the Read tool (supports images).
   Perform the following checks **in order** (Critical → Important → Minor).
   Compare the screenshot against the Terraform source and the generated XML to verify
   correctness.

   **Critical checks (must fix before presenting to user):**

   | # | Check | What to look for | How to verify |
   |---|-------|-----------------|---------------|
   | C1 | Network topology accuracy | Arrows (connections) must reflect the actual data flow defined in Terraform. Verify: (a) every arrow connects the correct source/target pair, (b) no arrow exists that has no corresponding Terraform relationship, (c) no expected connection is missing. | Cross-reference each arrow's `source` and `target` cell IDs against the Terraform dependency graph from Step 1. |
   | C2 | Icon overlap | Two or more icons must not visually overlap. Each icon should have clear spacing (minimum 20px visual gap). | Scan the screenshot for any stacked or overlapping icons. Pay special attention to dense areas like subnets with multiple services. |
   | C3 | Label text errors | Service names and labels must match the actual AWS service names and Terraform resource names. Check for: typos, wrong service names (e.g., "Amazon RDS" labeled as "Amazon Aurora"), truncated names, garbled characters, HTML entities showing as raw text (e.g., `&lt;br&gt;` instead of line break). | Compare every visible label in the screenshot against the `value` attribute of the corresponding mxCell in the XML. |
   | C4 | Error dialogs | If a modal error dialog is visible (e.g., "File load error", "invalid literal"), the screenshot is unusable. | Look for any modal overlay in the center of the screenshot. |

   **Important checks (should fix if possible):**

   | # | Check | What to look for | How to verify |
   |---|-------|-----------------|---------------|
   | I1 | Group containment | Every resource icon must be visually inside its correct parent group. E.g., EC2 instances inside their Subnet, Subnets inside their AZ, AZs inside VPC. Resources that should be outside VPC (S3, CloudFront, SNS, etc.) must not appear inside VPC. | Compare the visual position of each icon against the group hierarchy defined in Step 2 (placement rules). |
   | I2 | Arrow direction | Arrows must flow in the correct direction reflecting data/request flow (typically top-to-bottom: Users → Edge → Compute → Database). Bidirectional arrows (e.g., Multi-AZ replication) must show arrows on both ends. | Verify arrow direction matches the Terraform resource relationships and typical AWS data flow patterns. |
   | I3 | Label readability | Labels must not overlap each other, must not be cut off by group boundaries, and must be readable at normal zoom. Multi-line labels should break cleanly between words. | Scan for any overlapping text, text extending beyond group borders, or illegibly small labels. |
   | I4 | AZ symmetry | In Multi-AZ deployments, both Availability Zones should have mirrored layout structure (same resource types at similar vertical positions, similar sizing). | Compare the left AZ and right AZ side-by-side for structural symmetry. |

   **Minor checks (fix if time permits):**

   | # | Check | What to look for |
   |---|-------|-----------------|
   | M1 | Overall flow clarity | Primary traffic flow should be visually obvious (top-to-bottom or left-to-right) |
   | M2 | Empty regions | Large empty spaces that could be compacted to improve readability |
   | M3 | Arrow routing | Arrows should use clean orthogonal routes without unnecessary detours |

4. **Report findings**: After analysis, produce a structured findings report:

   ```
   ## Visual Verification Report

   ### Screenshot
   - File: {screenshot_path}
   - Rendering: OK / ERROR (describe error)

   ### Critical Issues (must fix)
   - [ ] C1: {description} — affected resources: {list}
   - [ ] C2: {description} — overlapping icons: {icon_a} and {icon_b}
   - [ ] C3: {description} — wrong label: "{actual}" should be "{expected}"
   (or "None found" if all checks pass)

   ### Important Issues (should fix)
   - [ ] I1: {description}
   (or "None found")

   ### Minor Issues (optional)
   - [ ] M1: {description}
   (or "None found")
   ```

5. **Fix and re-verify**: For each issue found:

   | Issue type | Fix approach |
   |-----------|-------------|
   | C1: Wrong/missing arrow | Add or correct `<mxCell>` edge elements — fix `source` and `target` attributes |
   | C2: Icon overlap | Shift one icon's `<mxGeometry x="..." y="...">` by at least 80px horizontally or 60px vertically. If inside a group, also expand the group's width/height if needed. |
   | C3: Label text error | Fix the `value` attribute of the affected `<mxCell>`. For line breaks, use `&lt;br&gt;` (HTML entity). |
   | C4: Error dialog | Use the **HTML viewer fallback** (Step 2c) to bypass MCP URL data corruption. If the HTML fallback also fails, re-check the XML for syntax errors (unclosed tags, invalid characters). |
   | I1: Group containment | Move the icon inside the correct parent group by adjusting its `<mxGeometry>` and ensuring the `parent` attribute references the correct group cell ID. |
   | I2: Arrow direction | Swap `source` and `target` attributes, or add `startArrow`/`endArrow` to the edge style. |
   | I3: Label readability | Adjust icon spacing, shorten labels, or expand group dimensions to give labels more room. |
   | I4: AZ asymmetry | Mirror the x/y offsets of resources in AZ-1 to AZ-2 (adjust for the AZ group's x-offset). |

   After applying fixes:
   a. Re-write the `.drawio` file
   b. Repeat from step 1 (re-take screenshot and re-verify)
   c. Maximum **2 fix iterations**. If Critical issues remain after 2 iterations, present
      the diagram with a warning listing the unresolved issues.

6. **Skip conditions**: Skip this step if:
   - The diagram has fewer than 5 resources (simple diagrams rarely have layout issues)
   - The user explicitly requests to skip visual verification
   - No Chrome/Chromium binary is found on the system
   - Neither drawio MCP nor `node` is available (both screenshot methods require one of these)

### Step 6: Present to User

Use `present_files` to share the `.drawio` file. Provide a brief summary:
- Number of resources identified
- Group hierarchy used
- Any resources whose placement was ambiguous (and how it was resolved)
- Any Terraform resources that were skipped (e.g., `aws_iam_policy` — not typically shown in architecture diagrams)

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

Not all Terraform resources warrant inclusion in an architecture diagram. By default:

**Include:** Compute (EC2, Lambda, ECS, EKS, Fargate), Networking (VPC, Subnet, IGW, NAT, ALB/NLB, CloudFront, Route 53, Transit Gateway, VPN), Database (RDS, Aurora, DynamoDB, ElastiCache, Redshift), Storage (S3, EFS, EBS), Application Integration (SQS, SNS, EventBridge, Step Functions, API Gateway), Security (WAF, Shield, KMS, Secrets Manager, ACM), Management (CloudWatch, CloudTrail), Analytics (Kinesis, Glue, Athena, OpenSearch)

**Exclude by default (unless user requests):** IAM (policies, roles, instance profiles), Security Group rules (the SG group box suffices), Route table entries, CloudWatch log groups/metrics, Tags, Terraform backend/provider config

## Error Handling

- If Terraform code references modules without visible source, note which modules were not expanded
- If resource types are unrecognized, use a generic AWS icon (`mxgraph.aws4.resourceIcon`) and flag it
- If VPC/Subnet relationships cannot be resolved, place the resource at the Region level and annotate