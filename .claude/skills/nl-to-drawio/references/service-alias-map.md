# Natural Language → AWS Service Name Mapping

This document maps natural language terms (English and Japanese) to canonical AWS service names. The **Label** column matches the `Label` field in `../shared-references/icon-mapping.md`.

## How to Use

1. Tokenize the user's input into service-related phrases
2. Match against the **Aliases** column (case-insensitive, partial match OK)
3. Resolve to the **AWS Service** name
4. Look up the **Label** in `icon-mapping.md` for the correct draw.io shape

When multiple aliases match, prefer the more specific match (e.g., "Aurora" → Amazon Aurora, not Amazon RDS).

---

## Compute

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon EC2 | Amazon EC2 | EC2, instance, virtual machine, VM, server, compute instance | EC2, インスタンス, 仮想マシン, サーバー |
| AWS Lambda | AWS Lambda | Lambda, serverless function, function, FaaS | Lambda, サーバーレス関数, 関数 |
| Amazon Lightsail | Amazon Lightsail | Lightsail, simple server | Lightsail |
| AWS Elastic Beanstalk | AWS Elastic Beanstalk | Beanstalk, elastic beanstalk | Beanstalk |
| AWS Batch | AWS Batch | Batch, batch job, batch processing compute | Batch, バッチ |
| AWS App Runner | AWS App Runner | App Runner, apprunner | App Runner |

## Containers

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon ECS | Amazon ECS | ECS, Elastic Container Service, container service | ECS, コンテナサービス |
| Amazon EKS | Amazon EKS | EKS, Kubernetes, k8s, Elastic Kubernetes | EKS, Kubernetes |
| AWS Fargate | AWS Fargate | Fargate, serverless container | Fargate, サーバーレスコンテナ |
| Amazon ECR | Amazon ECR | ECR, container registry, docker registry | ECR, コンテナレジストリ |

## Networking & Content Delivery

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| VPC | VPC | VPC, virtual private cloud, network | VPC, 仮想プライベートクラウド, ネットワーク |
| Internet gateway | Internet gateway | IGW, internet gateway | IGW, インターネットゲートウェイ |
| NAT gateway | NAT gateway | NAT, NAT gateway | NAT, NATゲートウェイ |
| Application Load Balancer | Application Load Balancer | ALB, load balancer, LB, application load balancer, ロードバランサー | ALB, ロードバランサー, 負荷分散 |
| Network Load Balancer | Network Load Balancer | NLB, network load balancer, TCP load balancer | NLB, ネットワークロードバランサー |
| Amazon CloudFront | Amazon CloudFront | CloudFront, CDN, content delivery, edge cache | CloudFront, CDN, コンテンツ配信 |
| Amazon Route 53 | Amazon Route 53 | Route 53, Route53, DNS, domain name | Route 53, DNS, ドメイン |
| Amazon API Gateway | Amazon API Gateway | API Gateway, APIGW, API GW, REST API endpoint, HTTP API | API Gateway, APIゲートウェイ |
| AWS Transit Gateway | AWS Transit Gateway | Transit Gateway, TGW | Transit Gateway, トランジットゲートウェイ |
| VPC endpoint | VPC endpoint | VPC endpoint, PrivateLink, private link | VPCエンドポイント, PrivateLink |
| AWS Global Accelerator | AWS Global Accelerator | Global Accelerator | Global Accelerator |
| AWS Direct Connect | AWS Direct Connect | Direct Connect, DX, dedicated connection | Direct Connect, DX, 専用線 |
| Elastic IP | Elastic IP | EIP, elastic IP, static IP | EIP, 固定IP |

## Database

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon RDS | Amazon RDS | RDS, relational database, MySQL, PostgreSQL, SQL Server, Oracle, MariaDB | RDS, リレーショナルDB, MySQL, PostgreSQL, データベース |
| Amazon Aurora | Amazon Aurora | Aurora, Aurora MySQL, Aurora PostgreSQL, Aurora Serverless | Aurora, オーロラ |
| Amazon DynamoDB | Amazon DynamoDB | DynamoDB, Dynamo, NoSQL, key-value store | DynamoDB, NoSQL, キーバリュー |
| Amazon ElastiCache | Amazon ElastiCache | ElastiCache, Redis, Memcached, cache, in-memory cache | ElastiCache, Redis, Memcached, キャッシュ |
| Amazon Redshift | Amazon Redshift | Redshift, data warehouse, DWH | Redshift, データウェアハウス, DWH |
| Amazon Neptune | Amazon Neptune | Neptune, graph database, graph DB | Neptune, グラフDB |
| Amazon DocumentDB | Amazon DocumentDB | DocumentDB, MongoDB compatible, document database | DocumentDB, ドキュメントDB |
| Amazon MemoryDB | Amazon MemoryDB | MemoryDB, MemoryDB for Redis, durable Redis | MemoryDB |
| Amazon Timestream | Amazon Timestream | Timestream, time series database, time series DB | Timestream, 時系列DB |

## Storage

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon S3 | Amazon S3 | S3, object storage, bucket, file storage, blob storage | S3, オブジェクトストレージ, バケット, ファイルストレージ |
| Amazon EFS | Amazon EFS | EFS, elastic file system, shared file, NFS | EFS, 共有ファイル, NFS |
| Amazon FSx | Amazon FSx | FSx, Lustre, Windows file server | FSx |
| Amazon EBS | Amazon EBS | EBS, block storage, volume, disk | EBS, ブロックストレージ, ボリューム, ディスク |
| AWS Backup | AWS Backup | Backup, backup vault | Backup, バックアップ |

## Application Integration

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon SQS | Amazon SQS | SQS, message queue, queue, Simple Queue Service | SQS, メッセージキュー, キュー |
| Amazon SNS | Amazon SNS | SNS, notification, Simple Notification, push notification, pub/sub | SNS, 通知, プッシュ通知 |
| AWS Step Functions | AWS Step Functions | Step Functions, state machine, workflow orchestration, step function | Step Functions, ステートマシン, ワークフロー |
| Amazon EventBridge | Amazon EventBridge | EventBridge, event bus, event bridge, CloudWatch Events | EventBridge, イベントバス |
| Amazon MQ | Amazon MQ | MQ, message broker, ActiveMQ, RabbitMQ | MQ, メッセージブローカー |
| AWS AppSync | AWS AppSync | AppSync, GraphQL, graphql | AppSync, GraphQL |

## Security, Identity & Compliance

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| AWS WAF | AWS WAF | WAF, web application firewall, firewall | WAF, ファイアウォール |
| AWS Shield | AWS Shield | Shield, DDoS protection | Shield, DDoS対策 |
| AWS KMS | AWS KMS | KMS, key management, encryption key | KMS, 暗号化キー, 鍵管理 |
| AWS Secrets Manager | AWS Secrets Manager | Secrets Manager, secret, secret management | Secrets Manager, シークレット管理 |
| AWS Certificate Manager | AWS Certificate Manager | ACM, certificate, SSL, TLS, cert | ACM, 証明書, SSL |
| Amazon Cognito | Amazon Cognito | Cognito, user pool, identity pool, authentication, auth | Cognito, 認証, ユーザープール |
| Amazon GuardDuty | Amazon GuardDuty | GuardDuty, threat detection | GuardDuty, 脅威検知 |
| Amazon Inspector | Amazon Inspector | Inspector, vulnerability scanning | Inspector, 脆弱性スキャン |

## Management & Governance

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon CloudWatch | Amazon CloudWatch | CloudWatch, monitoring, metrics, logs, alarm | CloudWatch, 監視, モニタリング, メトリクス |
| AWS CloudTrail | AWS CloudTrail | CloudTrail, audit log, audit trail | CloudTrail, 監査ログ |
| AWS Config | AWS Config | Config, configuration compliance | Config, コンプライアンス |
| AWS Systems Manager | AWS Systems Manager | SSM, Systems Manager, parameter store | SSM, Systems Manager, パラメータストア |

## Analytics

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon Kinesis | Amazon Kinesis | Kinesis, data stream, streaming data | Kinesis, データストリーム, ストリーミング |
| Amazon Data Firehose | Amazon Data Firehose | Firehose, Kinesis Firehose, data firehose, delivery stream | Firehose, データ配信 |
| AWS Glue | AWS Glue | Glue, ETL, data catalog | Glue, ETL, データカタログ |
| Amazon Athena | Amazon Athena | Athena, SQL query on S3, serverless query | Athena, S3クエリ |
| Amazon OpenSearch Service | Amazon OpenSearch Service | OpenSearch, Elasticsearch, full-text search, log analytics | OpenSearch, Elasticsearch, 全文検索 |
| Amazon QuickSight | Amazon QuickSight | QuickSight, BI, business intelligence, dashboard | QuickSight, BI, ダッシュボード |
| Amazon MSK | Amazon MSK | MSK, Kafka, Managed Streaming for Kafka | MSK, Kafka |

## AI/ML

| AWS Service | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Amazon SageMaker AI | Amazon SageMaker AI | SageMaker, ML, machine learning, model training | SageMaker, 機械学習, モデル学習 |
| Amazon Bedrock | Amazon Bedrock | Bedrock, generative AI, GenAI, foundation model, LLM | Bedrock, 生成AI, LLM |

## General / External

| Element | Label (icon-mapping.md) | Aliases (EN) | Aliases (JA) |
|---|---|---|---|
| Users | Users | users, end users, clients, visitors, customers | ユーザー, エンドユーザー, 利用者, 顧客 |
| Internet | Internet | internet, web, external, public internet | インターネット, 外部, Web |
| On-premises | On-premises | on-premises, on-prem, data center, datacenter, local server | オンプレミス, オンプレ, データセンター |
| Client | Client | client, desktop client | クライアント, デスクトップ |
| Mobile client | Mobile client | mobile, mobile app, smartphone, iOS, Android | モバイル, スマホ, スマートフォン |

## Disambiguation Rules

When the same alias could match multiple services:

| Alias | Default Resolution | Override Condition |
|---|---|---|
| "database" / "DB" / "データベース" | Amazon RDS | Use DynamoDB if "NoSQL" or "key-value" mentioned |
| "cache" / "キャッシュ" | Amazon ElastiCache | Use CloudFront if context is CDN/edge caching |
| "queue" / "キュー" | Amazon SQS | Use Amazon MQ if "RabbitMQ" or "ActiveMQ" mentioned |
| "load balancer" / "ロードバランサー" | Application Load Balancer | Use NLB if "TCP", "UDP", or "network" mentioned |
| "serverless" | AWS Lambda | Use Fargate if "container" also mentioned |
| "storage" / "ストレージ" | Amazon S3 | Use EBS if "block" or "volume" mentioned; EFS if "shared" or "NFS" |
| "monitoring" / "監視" | Amazon CloudWatch | — |
| "search" / "検索" | Amazon OpenSearch Service | — |
| "notification" / "通知" | Amazon SNS | — |
