# AWS Architecture Diagram Skills for Claude Code

自然言語またはTerraformコードからAWS構成図（`.drawio`）を自動生成するClaude Codeスキル集。

## インストール

任意のプロジェクトにワンコマンドでインストールできます。

```bash
# プロジェクトレベル（カレントディレクトリの .claude/ に導入）
bash <(curl -fsSL https://raw.githubusercontent.com/okshin-yk-private/skills-drawio-figure/main/install.sh)

# ユーザーレベル（~/.claude/ に導入、全プロジェクトで利用可能）
bash <(curl -fsSL https://raw.githubusercontent.com/okshin-yk-private/skills-drawio-figure/main/install.sh) --user

# dry-run で変更内容をプレビュー
bash <(curl -fsSL https://raw.githubusercontent.com/okshin-yk-private/skills-drawio-figure/main/install.sh) --dry-run
```

プライベートリポジトリの場合は `--token` オプションで GitHub PAT を指定してください。

```bash
bash install.sh --token ghp_xxxx
```

### アンインストール

```bash
bash install.sh --uninstall
```

### オプション一覧

| オプション | 説明 |
|---|---|
| `--user` | ユーザーレベル (`~/.claude/`) にインストール |
| `--skip-mcp` | MCP サーバー設定 (`.mcp.json`) の更新をスキップ |
| `--skip-settings` | settings.json の更新をスキップ |
| `--repo URL` | リポジトリURL を指定 |
| `--branch BRANCH` | ブランチ名を指定 (デフォルト: `main`) |
| `--token TOKEN` | GitHub Personal Access Token |
| `--uninstall` | インストールしたファイルと設定を削除 |
| `--dry-run` | 実際の変更を行わず実行内容を表示 |

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
install.sh                           # インストールスクリプト
```

## MCP Servers

| Server | 用途 | 状態 |
|---|---|---|
| drawio | 生成XMLのプレビュー・Visual Verification | 有効 |
| playwright | ブラウザ操作（URL正規化問題により不使用） | 無効 |
| aws-mcp | AWSドキュメント参照・配置判定の補助 | 有効 |
| terraform-mcp | Terraformプロバイダドキュメント参照 | 有効 |
