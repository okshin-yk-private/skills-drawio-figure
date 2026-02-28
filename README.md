# AWS Architecture Diagram Skills for Claude Code

自然言語またはTerraformコードからAWS構成図（`.drawio`）を自動生成するClaude Codeスキル集。

## Skills

| Skill | 入力 | 説明 |
|---|---|---|
| **nl-to-drawio** | 自然言語 | テキストの説明からAWS構成図を生成。パターンマッチ・サービスエイリアス解決・抽象度自動判定に対応 |
| **terraform-to-drawio** | Terraform (.tf) | HCLコードを解析し、リソース配置・依存関係を反映した構成図を生成 |

両スキル共通:
- AWS Architecture Icons (Release 22-2025.07.31) 準拠
- 配置ルール強制（VPC内/外、Subnet、AZ等の正しいネスト）
- Visual Verification（Chrome headlessによるスクリーンショット検証）

## 構成

```
.claude/skills/
  nl-to-drawio/
    SKILL.md                         # スキル定義
    references/unified-guideline.md  # NL用リファレンス（パターン・エイリアス含む）
  terraform-to-drawio/
    SKILL.md                         # スキル定義
  shared-references/
    unified-guideline.md             # 共通リファレンス（アイコン・配置・XMLテンプレート）
```

## MCP Servers

| Server | 用途 | 状態 |
|---|---|---|
| drawio | 生成XMLのプレビュー・Visual Verification | 有効 |
| playwright | ブラウザ操作（URL正規化問題により不使用） | 無効 |
| aws-mcp | AWSドキュメント参照・配置判定の補助 | 有効 |
| terraform-mcp | Terraformプロバイダドキュメント参照 | 有効 |
