#!/usr/bin/env bash
# install.sh — draw.io diagram skills for Claude Code installer
# Usage: bash install.sh [OPTIONS]
set -euo pipefail

# ─── Constants ────────────────────────────────────────────────────────────────
DEFAULT_REPO="https://github.com/okshin-yk-private/skills-drawio-figure.git"
DEFAULT_BRANCH="main"
SKILL_DIRS=("nl-to-drawio" "terraform-to-drawio" "shared-references")
MCP_KEYS=("drawio" "aws-mcp" "awslabs_terraform-mcp-server" "playwright")
SETTINGS_MCP_SERVERS=("playwright" "aws-mcp" "awslabs_terraform-mcp-server" "drawio")

# Default settings content (settings.local.json is not tracked in git)
DEFAULT_SETTINGS_JSON='{
  "enabledMcpjsonServers": [
    "playwright",
    "aws-mcp",
    "awslabs_terraform-mcp-server",
    "drawio"
  ],
  "permissions": {
    "allow": [
      "Bash(git:*)"
    ]
  }
}'

# ─── Colours ──────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; CYAN=''; BOLD=''; RESET=''
fi

# ─── Helpers ──────────────────────────────────────────────────────────────────
info()  { printf "${GREEN}[INFO]${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error() { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }
step()  { printf "${CYAN}[STEP]${RESET}  ${BOLD}%s${RESET}\n" "$*"; }

die() { error "$@"; exit 1; }

# ─── Defaults ─────────────────────────────────────────────────────────────────
USER_LEVEL=false
SKIP_MCP=false
SKIP_SETTINGS=false
REPO_URL="$DEFAULT_REPO"
BRANCH="$DEFAULT_BRANCH"
TOKEN=""
UNINSTALL=false
DRY_RUN=false

# ─── Usage ────────────────────────────────────────────────────────────────────
usage() {
  cat <<'USAGE'
Usage: install.sh [OPTIONS]

  draw.io diagram skills for Claude Code をインストール

Options:
  --user              ユーザーレベル (~/.claude/) にインストール
                      (デフォルトはプロジェクトレベル: カレントディレクトリの .claude/)
  --skip-mcp          MCP サーバー設定をスキップ
  --skip-settings     settings.json の更新をスキップ
  --repo URL          リポジトリURL (デフォルト: https://github.com/okshin-yk-private/skills-drawio-figure.git)
  --branch BRANCH     ブランチ名 (デフォルト: main)
  --token TOKEN       GitHub Personal Access Token (privateリポジトリ用)
  --uninstall         インストールしたスキルとMCPエントリを削除
  --dry-run           実際の変更を行わず、実行内容を表示
  --help              ヘルプを表示
USAGE
  exit 0
}

# ─── Argument Parsing ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)         USER_LEVEL=true;   shift ;;
    --skip-mcp)     SKIP_MCP=true;     shift ;;
    --skip-settings) SKIP_SETTINGS=true; shift ;;
    --repo)         REPO_URL="${2:?--repo requires a URL}";   shift 2 ;;
    --branch)       BRANCH="${2:?--branch requires a name}";  shift 2 ;;
    --token)        TOKEN="${2:?--token requires a value}";    shift 2 ;;
    --uninstall)    UNINSTALL=true;    shift ;;
    --dry-run)      DRY_RUN=true;      shift ;;
    --help|-h)      usage ;;
    *) die "Unknown option: $1 (use --help for usage)" ;;
  esac
done

# ─── Path Resolution ─────────────────────────────────────────────────────────
if $USER_LEVEL; then
  SKILLS_DIR="$HOME/.claude/skills"
  MCP_FILE="$HOME/.claude/.mcp.json"
  SETTINGS_FILE="$HOME/.claude/settings.json"
  LEVEL_LABEL="user (~/.claude/)"
else
  SKILLS_DIR="./.claude/skills"
  MCP_FILE="./.mcp.json"
  SETTINGS_FILE="./.claude/settings.local.json"
  LEVEL_LABEL="project ($(pwd)/.claude/)"
fi

# ─── JSON Processor Detection ────────────────────────────────────────────────
detect_json_tool() {
  if ! command -v python3 &>/dev/null; then
    die "python3 が必要です。インストールしてください。"
  fi
}

# ─── JSON Helpers ─────────────────────────────────────────────────────────────

# Merge MCP servers: add keys from source that don't exist in target
# Outputs merged JSON to stdout, ADDED:/SKIPPED: lines to stderr
# Args: target_file source_file
merge_mcp() {
  local target="$1" source="$2"
  python3 -c "
import json, sys
with open(sys.argv[1]) as f: src = json.load(f)
with open(sys.argv[2]) as f: tgt = json.load(f)
src_servers = src.get('mcpServers', {})
tgt_servers = tgt.get('mcpServers', {})
added = []
skipped = []
for k, v in src_servers.items():
    if k in tgt_servers:
        skipped.append(k)
    else:
        tgt_servers[k] = v
        added.append(k)
tgt['mcpServers'] = tgt_servers
for a in added: print(f'ADDED:{a}', file=sys.stderr)
for sk in skipped: print(f'SKIPPED:{sk}', file=sys.stderr)
print(json.dumps(tgt, indent=2, ensure_ascii=False))
" "$source" "$target"
}

# Merge settings: add enabledMcpjsonServers entries, optionally merge permissions
# Args: target_file source_file is_user_level
merge_settings() {
  local target="$1" source="$2" is_user="$3"
  python3 -c "
import json, sys

with open(sys.argv[1]) as f: src = json.load(f)
with open(sys.argv[2]) as f: tgt = json.load(f)
is_user = sys.argv[3] == 'true'

# Merge enabledMcpjsonServers (deduplicate)
src_servers = src.get('enabledMcpjsonServers', [])
tgt_servers = tgt.get('enabledMcpjsonServers', [])
added = []
for s_entry in src_servers:
    if s_entry not in tgt_servers:
        tgt_servers.append(s_entry)
        added.append(s_entry)
tgt['enabledMcpjsonServers'] = tgt_servers

# Merge permissions only for project level
if not is_user:
    src_perms = src.get('permissions', {})
    tgt_perms = tgt.get('permissions', {})
    for key in src_perms:
        if key not in tgt_perms:
            tgt_perms[key] = src_perms[key]
        else:
            # Merge arrays with dedup
            if isinstance(src_perms[key], list) and isinstance(tgt_perms[key], list):
                for item in src_perms[key]:
                    if item not in tgt_perms[key]:
                        tgt_perms[key].append(item)
    if tgt_perms:
        tgt['permissions'] = tgt_perms

for a in added: print(f'ADDED:{a}', file=sys.stderr)
print(json.dumps(tgt, indent=2, ensure_ascii=False))
" "$source" "$target" "$is_user"
}

# Remove MCP keys from .mcp.json
remove_mcp_keys() {
  local file="$1"
  shift
  local keys=("$@")
  python3 -c "
import json, sys
with open(sys.argv[1]) as f: data = json.load(f)
keys = sys.argv[2:]
servers = data.get('mcpServers', {})
removed = []
for k in keys:
    if k in servers:
        del servers[k]
        removed.append(k)
data['mcpServers'] = servers
for r in removed: print(f'REMOVED:{r}', file=sys.stderr)
print(json.dumps(data, indent=2, ensure_ascii=False))
" "$file" "${keys[@]}"
}

# Remove entries from enabledMcpjsonServers in settings
remove_settings_entries() {
  local file="$1"
  shift
  local entries=("$@")
  python3 -c "
import json, sys
with open(sys.argv[1]) as f: data = json.load(f)
entries = sys.argv[2:]
servers = data.get('enabledMcpjsonServers', [])
removed = []
for e in entries:
    if e in servers:
        servers.remove(e)
        removed.append(e)
data['enabledMcpjsonServers'] = servers
for r in removed: print(f'REMOVED:{r}', file=sys.stderr)
print(json.dumps(data, indent=2, ensure_ascii=False))
" "$file" "${entries[@]}"
}

# ─── Backup ───────────────────────────────────────────────────────────────────
backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    local backup="${file}.bak.${ts}"
    if $DRY_RUN; then
      info "[dry-run] バックアップ: $file → $backup"
    else
      cp "$file" "$backup"
      info "バックアップ: $backup"
    fi
  fi
}

# ─── Cleanup ──────────────────────────────────────────────────────────────────
TMPDIR_WORK=""
cleanup() {
  if [[ -n "$TMPDIR_WORK" && -d "$TMPDIR_WORK" ]]; then
    rm -rf "$TMPDIR_WORK"
  fi
}
trap cleanup EXIT

# ─── Repo URL Helpers ─────────────────────────────────────────────────────────
# Convert git URL to HTTPS tarball URL
tarball_url() {
  local url="$1" branch="$2"
  # Extract owner/repo from various URL formats
  local path
  path=$(echo "$url" | sed -E 's#(https?://github\.com/|git@github\.com:)##; s#\.git$##')
  echo "https://github.com/${path}/archive/refs/heads/${branch}.tar.gz"
}

# Build git clone URL with optional token
clone_url() {
  local url="$1" token="$2"
  if [[ -n "$token" ]]; then
    # Insert token into HTTPS URL
    echo "$url" | sed -E "s#https://#https://${token}@#"
  else
    echo "$url"
  fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# UNINSTALL
# ═══════════════════════════════════════════════════════════════════════════════
do_uninstall() {
  step "アンインストール開始 (level: $LEVEL_LABEL)"
  detect_json_tool

  # 1. Remove skill directories
  local removed_skills=()
  for dir in "${SKILL_DIRS[@]}"; do
    local target="$SKILLS_DIR/$dir"
    if [[ -d "$target" ]]; then
      if $DRY_RUN; then
        info "[dry-run] 削除: $target"
      else
        rm -rf "$target"
        info "削除: $target"
      fi
      removed_skills+=("$dir")
    else
      warn "スキップ (存在しない): $target"
    fi
  done

  # 2. Remove MCP entries from .mcp.json
  if [[ -f "$MCP_FILE" ]] && ! $SKIP_MCP; then
    backup_file "$MCP_FILE"
    if $DRY_RUN; then
      info "[dry-run] MCP キー削除: ${MCP_KEYS[*]}"
    else
      local result
      result=$(remove_mcp_keys "$MCP_FILE" "${MCP_KEYS[@]}" 2>&1 1>/dev/null) || true
      local json_out
      json_out=$(remove_mcp_keys "$MCP_FILE" "${MCP_KEYS[@]}" 2>/dev/null)
      echo "$json_out" > "$MCP_FILE"
      # Parse stderr for removed keys
      while IFS= read -r line; do
        case "$line" in
          REMOVED:*) info "MCP 削除: ${line#REMOVED:}" ;;
        esac
      done <<< "$result"
    fi
  fi

  # 3. Remove entries from settings
  if [[ -f "$SETTINGS_FILE" ]] && ! $SKIP_SETTINGS; then
    backup_file "$SETTINGS_FILE"
    if $DRY_RUN; then
      info "[dry-run] Settings エントリ削除: ${SETTINGS_MCP_SERVERS[*]}"
    else
      local result
      result=$(remove_settings_entries "$SETTINGS_FILE" "${SETTINGS_MCP_SERVERS[@]}" 2>&1 1>/dev/null) || true
      local json_out
      json_out=$(remove_settings_entries "$SETTINGS_FILE" "${SETTINGS_MCP_SERVERS[@]}" 2>/dev/null)
      echo "$json_out" > "$SETTINGS_FILE"
      while IFS= read -r line; do
        case "$line" in
          REMOVED:*) info "Settings 削除: ${line#REMOVED:}" ;;
        esac
      done <<< "$result"
    fi
  fi

  echo ""
  step "アンインストール完了"
  if [[ ${#removed_skills[@]} -gt 0 ]]; then
    info "削除したスキル: ${removed_skills[*]}"
  fi
  info "Claude Code を再起動して変更を反映してください。"
}

# ═══════════════════════════════════════════════════════════════════════════════
# INSTALL
# ═══════════════════════════════════════════════════════════════════════════════
do_install() {
  echo ""
  printf "${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
  printf "${BOLD}║  draw.io diagram skills for Claude Code — installer    ║${RESET}\n"
  printf "${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
  echo ""

  step "Phase 1: 初期化"
  info "インストール先: $LEVEL_LABEL"
  info "リポジトリ: $REPO_URL (branch: $BRANCH)"
  $DRY_RUN && warn "DRY-RUN モード: 実際の変更は行いません"
  $SKIP_MCP && info "MCP 設定: スキップ"
  $SKIP_SETTINGS && info "Settings 更新: スキップ"

  detect_json_tool

  # ── Phase 2: Fetch repository ───────────────────────────────────────────────
  step "Phase 2: リポジトリ取得"
  TMPDIR_WORK=$(mktemp -d)
  local repo_dir="$TMPDIR_WORK/repo"
  local fetch_ok=false

  # Method 1: git clone
  if command -v git &>/dev/null; then
    info "git clone を試行中..."
    local url
    url=$(clone_url "$REPO_URL" "$TOKEN")
    if git clone --depth 1 --branch "$BRANCH" "$url" "$repo_dir" 2>/dev/null; then
      fetch_ok=true
      info "git clone 成功"
    else
      warn "git clone 失敗 — フォールバックを試行"
    fi
  fi

  # Method 2: curl tarball
  if ! $fetch_ok && command -v curl &>/dev/null; then
    info "curl (tarball) を試行中..."
    local tb_url
    tb_url=$(tarball_url "$REPO_URL" "$BRANCH")
    local curl_args=(-fsSL)
    if [[ -n "$TOKEN" ]]; then
      curl_args+=(-H "Authorization: token $TOKEN")
    fi
    if curl "${curl_args[@]}" "$tb_url" | tar xz -C "$TMPDIR_WORK" 2>/dev/null; then
      # tar extracts to repo-name-branch/ directory
      local extracted
      extracted=$(find "$TMPDIR_WORK" -maxdepth 1 -mindepth 1 -type d ! -name repo | head -1)
      if [[ -n "$extracted" ]]; then
        mv "$extracted" "$repo_dir"
        fetch_ok=true
        info "curl tarball 成功"
      fi
    else
      warn "curl tarball 失敗 — フォールバックを試行"
    fi
  fi

  # Method 3: wget tarball
  if ! $fetch_ok && command -v wget &>/dev/null; then
    info "wget (tarball) を試行中..."
    local tb_url
    tb_url=$(tarball_url "$REPO_URL" "$BRANCH")
    local wget_args=(-q -O -)
    if [[ -n "$TOKEN" ]]; then
      wget_args+=(--header="Authorization: token $TOKEN")
    fi
    if wget "${wget_args[@]}" "$tb_url" | tar xz -C "$TMPDIR_WORK" 2>/dev/null; then
      local extracted
      extracted=$(find "$TMPDIR_WORK" -maxdepth 1 -mindepth 1 -type d ! -name repo | head -1)
      if [[ -n "$extracted" ]]; then
        mv "$extracted" "$repo_dir"
        fetch_ok=true
        info "wget tarball 成功"
      fi
    else
      warn "wget tarball 失敗"
    fi
  fi

  if ! $fetch_ok; then
    die "リポジトリの取得に失敗しました。ネットワーク接続と URL を確認してください: $REPO_URL"
  fi

  # Verify expected structure
  if [[ ! -d "$repo_dir/.claude/skills" ]]; then
    die "取得したリポジトリに .claude/skills/ が見つかりません。リポジトリ構造を確認してください。"
  fi

  # ── Phase 3: Copy skill files ───────────────────────────────────────────────
  step "Phase 3: スキルファイルコピー"
  local copied_skills=()
  for dir in "${SKILL_DIRS[@]}"; do
    local src="$repo_dir/.claude/skills/$dir"
    local dst="$SKILLS_DIR/$dir"
    if [[ -d "$src" ]]; then
      if $DRY_RUN; then
        info "[dry-run] コピー: $src → $dst"
      else
        mkdir -p "$dst"
        cp -R "$src"/ "$dst"/
        info "コピー: $dir → $dst"
      fi
      copied_skills+=("$dir")
    else
      warn "スキップ (ソースに存在しない): $dir"
    fi
  done

  # ── Phase 4: MCP config merge ───────────────────────────────────────────────
  local mcp_added=()
  local mcp_skipped=()
  if ! $SKIP_MCP; then
    step "Phase 4: MCP 設定マージ"
    local src_mcp="$repo_dir/.mcp.json"

    if [[ ! -f "$src_mcp" ]]; then
      warn "ソースに .mcp.json が見つかりません — スキップ"
    elif [[ ! -f "$MCP_FILE" ]]; then
      # Target doesn't exist — copy directly
      if $DRY_RUN; then
        info "[dry-run] 新規作成: $MCP_FILE"
      else
        local mcp_dir
        mcp_dir=$(dirname "$MCP_FILE")
        mkdir -p "$mcp_dir"
        cp "$src_mcp" "$MCP_FILE"
        info "新規作成: $MCP_FILE"
      fi
      mcp_added=("${MCP_KEYS[@]}")
    else
      # Merge
      backup_file "$MCP_FILE"
      if $DRY_RUN; then
        info "[dry-run] マージ: $src_mcp → $MCP_FILE"
        # Show what would happen
        local merge_info
        merge_info=$(merge_mcp "$MCP_FILE" "$src_mcp" 2>&1 1>/dev/null) || true
        while IFS= read -r line; do
          case "$line" in
            ADDED:*)   info "[dry-run]   追加: ${line#ADDED:}"; mcp_added+=("${line#ADDED:}") ;;
            SKIPPED:*) info "[dry-run]   既存: ${line#SKIPPED:}"; mcp_skipped+=("${line#SKIPPED:}") ;;
          esac
        done <<< "$merge_info"
      else
        local merge_info merged_json
        # Capture stderr (info) and stdout (json) separately
        merged_json=$(merge_mcp "$MCP_FILE" "$src_mcp" 2>"$TMPDIR_WORK/merge_info.txt")
        echo "$merged_json" > "$MCP_FILE"
        while IFS= read -r line; do
          case "$line" in
            ADDED:*)   info "MCP 追加: ${line#ADDED:}"; mcp_added+=("${line#ADDED:}") ;;
            SKIPPED:*) info "MCP 既存 (スキップ): ${line#SKIPPED:}"; mcp_skipped+=("${line#SKIPPED:}") ;;
          esac
        done < "$TMPDIR_WORK/merge_info.txt"
      fi
    fi
  fi

  # ── Phase 5: Settings merge ─────────────────────────────────────────────────
  local settings_added=()
  if ! $SKIP_SETTINGS; then
    step "Phase 5: Settings マージ"
    local src_settings="$repo_dir/.claude/settings.local.json"

    # If the source file doesn't exist in the repo (not tracked in git), create it from default
    if [[ ! -f "$src_settings" ]]; then
      echo "$DEFAULT_SETTINGS_JSON" > "$TMPDIR_WORK/default_settings.json"
      src_settings="$TMPDIR_WORK/default_settings.json"
      info "デフォルト Settings テンプレートを使用"
    fi

    if [[ ! -f "$SETTINGS_FILE" ]]; then
      # Target doesn't exist
      if $USER_LEVEL; then
        # For user level: copy without permissions
        if $DRY_RUN; then
          info "[dry-run] 新規作成 (permissions除外): $SETTINGS_FILE"
        else
          local settings_dir
          settings_dir=$(dirname "$SETTINGS_FILE")
          mkdir -p "$settings_dir"
          python3 -c "
import json, sys
with open(sys.argv[1]) as f: data = json.load(f)
data.pop('permissions', None)
print(json.dumps(data, indent=2, ensure_ascii=False))
" "$src_settings" > "$SETTINGS_FILE"
          info "新規作成 (permissions除外): $SETTINGS_FILE"
        fi
      else
        if $DRY_RUN; then
          info "[dry-run] 新規作成: $SETTINGS_FILE"
        else
          local settings_dir
          settings_dir=$(dirname "$SETTINGS_FILE")
          mkdir -p "$settings_dir"
          cp "$src_settings" "$SETTINGS_FILE"
          info "新規作成: $SETTINGS_FILE"
        fi
      fi
      settings_added=("${SETTINGS_MCP_SERVERS[@]}")
    else
      # Merge
      backup_file "$SETTINGS_FILE"
      if $DRY_RUN; then
        info "[dry-run] マージ: $src_settings → $SETTINGS_FILE"
        local merge_info
        merge_info=$(merge_settings "$SETTINGS_FILE" "$src_settings" "$USER_LEVEL" 2>&1 1>/dev/null) || true
        while IFS= read -r line; do
          case "$line" in
            ADDED:*) info "[dry-run]   追加: ${line#ADDED:}"; settings_added+=("${line#ADDED:}") ;;
          esac
        done <<< "$merge_info"
      else
        local merged_json
        merged_json=$(merge_settings "$SETTINGS_FILE" "$src_settings" "$USER_LEVEL" 2>"$TMPDIR_WORK/settings_info.txt")
        echo "$merged_json" > "$SETTINGS_FILE"
        while IFS= read -r line; do
          case "$line" in
            ADDED:*) info "Settings 追加: ${line#ADDED:}"; settings_added+=("${line#ADDED:}") ;;
          esac
        done < "$TMPDIR_WORK/settings_info.txt"
      fi
    fi
  fi

  # ── Phase 6: Report ─────────────────────────────────────────────────────────
  echo ""
  printf "${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
  printf "${BOLD}║  インストール完了                                       ║${RESET}\n"
  printf "${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
  echo ""

  # Skills summary
  step "スキル"
  for dir in "${copied_skills[@]}"; do
    info "  $SKILLS_DIR/$dir"
  done

  # MCP summary
  if ! $SKIP_MCP; then
    echo ""
    step "MCP サーバー"
    if [[ ${#mcp_added[@]} -gt 0 ]]; then
      for key in "${mcp_added[@]}"; do
        info "  追加: $key"
      done
    fi
    if [[ ${#mcp_skipped[@]} -gt 0 ]]; then
      for key in "${mcp_skipped[@]}"; do
        info "  既存 (スキップ): $key"
      done
    fi
    if [[ ${#mcp_added[@]} -eq 0 && ${#mcp_skipped[@]} -eq 0 ]]; then
      info "  変更なし"
    fi
  fi

  # Settings summary
  if ! $SKIP_SETTINGS; then
    echo ""
    step "Settings"
    if [[ ${#settings_added[@]} -gt 0 ]]; then
      for entry in "${settings_added[@]}"; do
        info "  追加: $entry"
      done
    else
      info "  変更なし (すべて既存)"
    fi
    if $USER_LEVEL; then
      info "  ※ permissions はユーザーレベルではスキップされました"
    fi
  fi

  # Next steps
  echo ""
  step "次のステップ"
  info "1. Claude Code を再起動してください"
  info "2. 使い方の例:"
  info "     「3層Webアプリのアーキテクチャ図を描いて」"
  info "     「このTerraformコードからアーキテクチャ図を生成して」"
  if $DRY_RUN; then
    echo ""
    warn "これは dry-run です。実際にインストールするには --dry-run を外して再実行してください。"
  fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════
if $UNINSTALL; then
  do_uninstall
else
  do_install
fi
