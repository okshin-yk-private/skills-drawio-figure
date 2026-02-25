# Abstraction Levels for Architecture Diagrams

This document defines two abstraction levels for AWS architecture diagrams generated from natural language. The level determines how much infrastructure detail is shown.

## Level Definitions

### Overview (概要図)

A high-level view focusing on service relationships. Best for presentations, initial design discussions, and communication with non-technical stakeholders.

**Characteristics:**

| Property | Value |
|---|---|
| Target resource count | 5–15 |
| VPC detail | Single VPC box, no subnet breakdown |
| AZ detail | Omitted |
| Subnet detail | Omitted (or simplified as "Public" / "Private" zones) |
| Security Groups | Omitted |
| CIDR blocks | Omitted |
| NAT Gateway | Omitted (implied) |
| Internet Gateway | Omitted (implied) |
| Service icons | Service-level icons only (48x48) |
| Arrows | Major data flows only, no port/protocol labels |
| Groups | AWS Cloud → Region → VPC (collapsed) |

**When to use:** The user wants a quick, clean diagram showing "what services talk to what."

### Detailed (詳細設計図)

A deployment-level view showing full infrastructure hierarchy. Best for implementation planning, security reviews, and infrastructure documentation.

**Characteristics:**

| Property | Value |
|---|---|
| Target resource count | 15–50+ |
| VPC detail | Full VPC with CIDR |
| AZ detail | Multi-AZ layout (2 AZ minimum) |
| Subnet detail | Public + Private subnets with CIDR per AZ |
| Security Groups | Shown as group boundaries |
| CIDR blocks | Shown on VPC and subnet labels |
| NAT Gateway | Shown in public subnet |
| Internet Gateway | Shown on VPC border |
| Service icons | Both service (48x48) and resource (40x40) icons |
| Arrows | Data flows with protocol/port labels |
| Groups | Full hierarchy: AWS Cloud → Region → VPC → AZ → Subnet → SG |

**When to use:** The user wants a deployment diagram showing "exactly how this is wired up."

---

## Level Detection Rules

Determine the abstraction level from the user's input using these cues:

### Explicit Cues (highest priority)

| Cue (EN) | Cue (JA) | Level |
|---|---|---|
| "overview", "high-level", "simple diagram", "bird's eye" | "概要図", "概要", "シンプルな図", "全体像" | Overview |
| "detailed", "detailed design", "deployment diagram", "infrastructure diagram" | "詳細設計図", "詳細", "デプロイ図", "インフラ図" | Detailed |
| "Multi-AZ", "subnet", "CIDR", "security group" | "マルチAZ", "サブネット", "CIDR", "セキュリティグループ" | Detailed |

### Implicit Cues (use when no explicit cue)

| Signal | Level | Reasoning |
|---|---|---|
| User specifies 1–4 services by name only | Overview | Brief description implies wanting a quick diagram |
| User mentions specific network config (CIDR, AZ, SG rules) | Detailed | Network-level specifics imply deployment planning |
| User mentions "Multi-AZ" or "高可用性" / "HA" | Detailed | HA requires showing AZ structure |
| User describes data flows without infra details | Overview | Focus on logical flow, not physical deployment |
| User says "設計図" / "design" (without "detailed") | Overview | Generic design request defaults to overview |
| User says "構成図" / "architecture diagram" | Overview | Standard architecture diagram = overview |
| User provides a long, detailed specification | Detailed | Detailed spec expects detailed output |

### Default Behavior

If no cues match, default to **Overview**. Overview diagrams are faster to iterate on and the user can always request more detail.

---

## Level-Specific Generation Rules

### Overview-Level Rules

1. **Collapse infrastructure:** Represent VPC as a single box. Don't show AZs, subnets, IGW, NAT, or SGs.
2. **One icon per service:** Even if the architecture would have multiple instances (e.g., 2 ECS tasks in 2 AZs), show a single icon.
3. **Omit implied services:** Don't add IGW, NAT Gateway, or Route Tables. These are implied by the VPC.
4. **Simple labels:** Use service names only (e.g., "Amazon ECS"), no instance names or resource identifiers.
5. **Arrows:** Show primary data flow direction. Omit protocol/port details unless the user specified them.
6. **Layout:** Use a compact, top-to-bottom or left-to-right flow. Aim for a canvas size of 800x600 or smaller.

### Detailed-Level Rules

1. **Expand infrastructure:** Show full VPC → AZ → Subnet hierarchy with CIDRs.
2. **Multi-AZ:** Default to 2 AZs (ap-northeast-1a, ap-northeast-1c). Show resources duplicated across AZs where HA is implied.
3. **Show all network components:** IGW, NAT Gateway (per AZ), route associations.
4. **Security Groups:** Show as group boundaries around related resources.
5. **Labels:** Include CIDR blocks on VPC/subnets, instance names, and protocol/port on arrows.
6. **Default CIDRs** (when user doesn't specify):
   - VPC: `10.0.0.0/16`
   - Public Subnet 1a: `10.0.1.0/24`
   - Public Subnet 1c: `10.0.2.0/24`
   - Private Subnet (App) 1a: `10.0.11.0/24`
   - Private Subnet (App) 1c: `10.0.12.0/24`
   - Private Subnet (DB) 1a: `10.0.21.0/24`
   - Private Subnet (DB) 1c: `10.0.22.0/24`
7. **Layout:** Use multi-column AZ layout. Aim for 1200x900 or larger canvas.

---

## Transition Between Levels

Users may request to change the level after seeing an initial diagram:

| User Request | Action |
|---|---|
| "もっと詳しく" / "more detail" / "expand" | Regenerate at Detailed level, keeping the same services |
| "もっとシンプルに" / "simplify" / "high-level view" | Regenerate at Overview level, collapsing infrastructure |
| "サブネットも見せて" / "show subnets" | Switch to Detailed level for the VPC portion only (if possible, otherwise full Detailed) |
| "AZを追加して" / "add AZs" | Switch to Detailed level |
