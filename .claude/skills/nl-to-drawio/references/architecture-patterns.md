# Common AWS Architecture Patterns

This document defines reusable AWS architecture patterns that can be identified from natural language descriptions. Each pattern includes required components, optional enhancements, connection topology, and trigger phrases (EN/JA) that suggest the pattern.

## How to Use

1. Match the user's description against **Trigger Phrases** to identify candidate patterns
2. Multiple patterns may combine (e.g., "serverless API with a static frontend" = Static Website + Serverless REST API)
3. Required components are always included; optional components are added only when explicitly mentioned or strongly implied
4. When no pattern matches clearly, default to **3-Tier Web Application**

---

## Pattern 1: 3-Tier Web Application

**Trigger Phrases:**
- EN: "web app", "web application", "three-tier", "3-tier", "typical web", "standard web"
- JA: "Webアプリ", "ウェブアプリ", "3層", "三層", "一般的なWeb"

**Required Components:**
- VPC with public + private subnets (2 AZ)
- Application Load Balancer (public subnet)
- Compute: EC2 or ECS Fargate (private subnet)
- Database: RDS or Aurora (private subnet)
- Internet Gateway
- NAT Gateway (public subnet)

**Optional Components:**
- CloudFront (CDN)
- Route 53 (DNS)
- ElastiCache (session/cache)
- S3 (static assets)
- WAF
- Auto Scaling Group / ECS Service

**Connection Topology:**
```
Users → [CloudFront →] ALB → Compute → Database
                                    → [ElastiCache]
```

---

## Pattern 2: Serverless REST API

**Trigger Phrases:**
- EN: "serverless API", "Lambda API", "API Gateway + Lambda", "REST API serverless", "serverless backend"
- JA: "サーバーレスAPI", "Lambda API", "サーバーレス", "API Gateway + Lambda"

**Required Components:**
- API Gateway (REST or HTTP)
- Lambda function(s)
- DynamoDB or RDS (data store)

**Optional Components:**
- Cognito (authentication)
- S3 (file storage)
- SQS (async processing)
- Step Functions (orchestration)
- CloudWatch (monitoring)
- WAF (API protection)
- CloudFront (API caching)

**Connection Topology:**
```
Users → API Gateway → Lambda → DynamoDB/RDS
                            → [SQS → Lambda]
                            → [S3]
```

---

## Pattern 3: Static Website

**Trigger Phrases:**
- EN: "static site", "static website", "SPA", "single page app", "frontend hosting", "S3 website"
- JA: "静的サイト", "静的ウェブサイト", "SPA", "フロントエンドホスティング", "S3ウェブサイト"

**Required Components:**
- S3 (static content)
- CloudFront (CDN)

**Optional Components:**
- Route 53 (custom domain)
- ACM (SSL certificate)
- WAF
- Lambda@Edge (URL rewriting)

**Connection Topology:**
```
Users → [Route 53 →] CloudFront → S3
```

---

## Pattern 4: Container Microservices

**Trigger Phrases:**
- EN: "microservices", "container", "containerized", "ECS", "EKS", "Fargate", "docker", "kubernetes"
- JA: "マイクロサービス", "コンテナ", "ECS", "EKS", "Fargate", "Docker", "Kubernetes"

**Required Components:**
- VPC with public + private subnets (2 AZ)
- ALB (public subnet)
- ECS Fargate or EKS (private subnet) with multiple services
- ECR (container registry)
- Internet Gateway
- NAT Gateway

**Optional Components:**
- Service Discovery (Cloud Map)
- SQS/SNS (inter-service messaging)
- RDS/Aurora, DynamoDB (per-service databases)
- ElastiCache
- CloudWatch (monitoring/logging)
- Auto Scaling
- API Gateway (as frontend)

**Connection Topology:**
```
Users → ALB → ECS Service A → Database A
              ECS Service B → Database B
              ECS Service C → [SQS] → ECS Service D
```

---

## Pattern 5: Event-Driven Architecture

**Trigger Phrases:**
- EN: "event-driven", "event driven", "EventBridge", "pub/sub", "event bus", "async processing"
- JA: "イベント駆動", "イベントドリブン", "非同期処理", "pub/sub"

**Required Components:**
- EventBridge or SNS (event bus/topic)
- Lambda or SQS (event consumers)

**Optional Components:**
- S3 (event source — object created)
- DynamoDB Streams
- Step Functions (orchestration)
- SQS (dead letter queue)
- CloudWatch (monitoring)

**Connection Topology:**
```
Event Source → EventBridge/SNS → Lambda A
                               → SQS → Lambda B
                               → Step Functions
```

---

## Pattern 6: Data Pipeline (ETL/ELT)

**Trigger Phrases:**
- EN: "data pipeline", "ETL", "ELT", "data lake", "data warehouse", "analytics pipeline", "batch processing data"
- JA: "データパイプライン", "ETL", "データレイク", "データウェアハウス", "分析基盤"

**Required Components:**
- S3 (data lake / raw data)
- Glue or Lambda (transformation)
- Target: Redshift, Athena, or DynamoDB

**Optional Components:**
- Kinesis / Kinesis Firehose (ingestion)
- Step Functions (orchestration)
- QuickSight (visualization)
- Lake Formation
- CloudWatch (monitoring)

**Connection Topology:**
```
Data Sources → [Kinesis →] S3 (raw) → Glue → S3 (processed) → Athena/Redshift
                                                              → [QuickSight]
```

---

## Pattern 7: Real-Time Streaming

**Trigger Phrases:**
- EN: "real-time", "streaming", "Kinesis", "real time processing", "stream processing", "IoT ingestion"
- JA: "リアルタイム", "ストリーミング", "Kinesis", "リアルタイム処理", "ストリーム処理"

**Required Components:**
- Kinesis Data Streams or MSK
- Lambda or KDA (stream processing)
- Storage target (S3, DynamoDB, OpenSearch)

**Optional Components:**
- Kinesis Firehose (delivery)
- API Gateway WebSocket (real-time push)
- ElastiCache (fast lookup)
- CloudWatch (monitoring)

**Connection Topology:**
```
Producers → Kinesis Data Streams → Lambda → DynamoDB/OpenSearch
                                 → Kinesis Firehose → S3
```

---

## Pattern 8: Batch Processing

**Trigger Phrases:**
- EN: "batch processing", "batch job", "AWS Batch", "scheduled job", "cron", "periodic processing"
- JA: "バッチ処理", "バッチジョブ", "定期実行", "スケジュール実行"

**Required Components:**
- EventBridge Scheduler or CloudWatch Events (trigger)
- Compute: Lambda, AWS Batch, or Step Functions
- S3 (input/output)

**Optional Components:**
- SQS (job queue)
- SNS (completion notification)
- DynamoDB (job status tracking)
- CloudWatch (monitoring)

**Connection Topology:**
```
EventBridge (schedule) → Lambda/Batch → S3
                                      → [SNS notification]
```

---

## Pattern 9: Hybrid Connectivity (VPN / Direct Connect)

**Trigger Phrases:**
- EN: "hybrid", "VPN", "Direct Connect", "on-premises", "on-prem", "datacenter connection", "hybrid cloud"
- JA: "ハイブリッド", "VPN", "Direct Connect", "オンプレミス", "オンプレ", "データセンター接続"

**Required Components:**
- VPC
- VPN Gateway or Direct Connect Gateway
- Customer Gateway (on-premises side)
- Corporate Data Center group

**Optional Components:**
- Transit Gateway (multi-VPC)
- Route 53 (DNS resolution)
- AD Connector / Directory Service
- CloudWatch (monitoring)

**Connection Topology:**
```
Corporate DC → [VPN/DX] → VPN Gateway → VPC → Resources
```

---

## Pattern 10: ML/AI Pipeline

**Trigger Phrases:**
- EN: "machine learning", "ML pipeline", "SageMaker", "AI", "model training", "inference", "Bedrock"
- JA: "機械学習", "MLパイプライン", "SageMaker", "AI", "モデル学習", "推論", "Bedrock"

**Required Components:**
- S3 (training data / model artifacts)
- SageMaker or Bedrock

**Optional Components:**
- Step Functions (pipeline orchestration)
- Lambda (pre/post processing)
- API Gateway (inference endpoint)
- ECR (custom containers)
- Glue (data preparation)
- CloudWatch (monitoring)

**Connection Topology:**
```
S3 (data) → SageMaker Training → S3 (model) → SageMaker Endpoint
                                              → API Gateway → Users
```

---

## Pattern 11: GraphQL API

**Trigger Phrases:**
- EN: "GraphQL", "AppSync", "GraphQL API"
- JA: "GraphQL", "AppSync"

**Required Components:**
- AppSync
- Data source: DynamoDB, Lambda, or RDS

**Optional Components:**
- Cognito (authentication)
- ElastiCache (caching)
- S3 (file storage)
- Lambda (resolvers)

**Connection Topology:**
```
Users → AppSync → DynamoDB
                → Lambda → [external services]
```

---

## Pattern 12: Multi-Region / Disaster Recovery

**Trigger Phrases:**
- EN: "multi-region", "disaster recovery", "DR", "failover", "active-passive", "active-active"
- JA: "マルチリージョン", "ディザスタリカバリ", "DR", "フェイルオーバー"

**Required Components:**
- 2 Regions (primary + secondary)
- Route 53 (DNS failover)
- Core services duplicated in both regions

**Optional Components:**
- S3 Cross-Region Replication
- RDS Read Replica (cross-region)
- DynamoDB Global Tables
- CloudFront (global edge)

**Connection Topology:**
```
Users → Route 53 → Region A (primary): ALB → Compute → DB
                  → Region B (secondary): ALB → Compute → DB (replica)
```

---

## Pattern 13: CI/CD Pipeline

**Trigger Phrases:**
- EN: "CI/CD", "deployment pipeline", "CodePipeline", "build and deploy", "continuous delivery"
- JA: "CI/CD", "デプロイパイプライン", "ビルドパイプライン", "継続的デリバリー"

**Required Components:**
- CodePipeline or Step Functions (orchestration)
- CodeBuild (build)
- Target: ECS, Lambda, S3, or EC2

**Optional Components:**
- CodeCommit or GitHub connection (source)
- ECR (container images)
- CodeDeploy (deployment)
- SNS (notifications)
- S3 (artifact store)

**Connection Topology:**
```
Source (CodeCommit/GitHub) → CodeBuild → [ECR] → CodeDeploy → Target (ECS/Lambda/EC2)
```

---

## Pattern 14: Message Queue Architecture

**Trigger Phrases:**
- EN: "message queue", "SQS", "queue", "async", "decoupled", "worker", "producer-consumer"
- JA: "メッセージキュー", "SQS", "キュー", "非同期", "疎結合", "ワーカー"

**Required Components:**
- SQS (queue)
- Producer: API Gateway + Lambda, or ECS
- Consumer: Lambda, or ECS

**Optional Components:**
- SQS Dead Letter Queue
- SNS (fan-out)
- CloudWatch (queue metrics/alarms)
- Auto Scaling (based on queue depth)

**Connection Topology:**
```
Producer → SQS → Consumer (Lambda/ECS)
              → [DLQ]
```

---

## Pattern 15: CDN + API Backend

**Trigger Phrases:**
- EN: "CDN", "CloudFront + API", "edge caching", "global distribution", "content delivery"
- JA: "CDN", "CloudFront + API", "エッジキャッシング", "グローバル配信", "コンテンツ配信"

**Required Components:**
- CloudFront
- Origin: S3 (static) + ALB or API Gateway (dynamic)

**Optional Components:**
- Route 53
- ACM
- WAF
- Lambda@Edge
- S3 (logs)

**Connection Topology:**
```
Users → CloudFront → S3 (static assets)
                   → ALB/API Gateway → Backend
```

---

## Pattern Combination Rules

When a user's description matches multiple patterns:

1. **Identify the primary pattern** (the main use case described)
2. **Identify secondary patterns** (supporting capabilities mentioned)
3. **Merge shared components** (e.g., don't duplicate VPC, Route 53)
4. **Connect at integration points** (e.g., API Gateway of serverless API feeds into event-driven backend)

**Example:** "Webアプリ with バッチ処理" = Pattern 1 (3-Tier Web) + Pattern 8 (Batch Processing), sharing the VPC, S3, and CloudWatch.
