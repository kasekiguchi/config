#!/usr/bin/env bash
set -euo pipefail

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
LIST_KEY="$SCHEMA custom-keybindings"
REPLACE=0

usage() {
  cat <<EOF
Usage: $0 [--replace] <csv_file>
  --replace : 既存のカスタムショートカット一覧を置き換える（全消し→CSVで再作成）
  既定は既存の一覧の末尾に「追加」登録
CSV format: name,command,binding  （カンマ区切り、#や空行は無視）
Binding例: C-A-t, Super-e, S-C-F5, C-Return など
C=Ctrl, A=Alt, S=Shift, Super=Winキー, M=Meta をサポート
C-A-t → <Ctrl><Alt>t に自動変換されます
F5, Return, Escape, Left/Right/Up/Down, space, Tab, BackSpace, Delete, Home, End, Page_Up, Page_Down などの特殊キーもOK
EOF
}

# --- 依存確認 ---
command -v gsettings >/dev/null || { echo "gsettings が見つかりません。sudo apt install dconf-cli を実行してください。"; exit 1; }

# --- 引数処理 ---
if [[ $# -lt 1 ]]; then usage; exit 1; fi
if [[ "${1-}" == "--replace" ]]; then REPLACE=1; shift; fi
if [[ $# -ne 1 ]]; then usage; exit 1; fi
CSV="$1"
[[ -f "$CSV" ]] || { echo "CSVが見つかりません: $CSV"; exit 1; }

# --- 既存リスト取得・初期化 ---
get_current_list() {
  gsettings get $SCHEMA custom-keybindings 2>/dev/null || echo "[]"
}
CURRENT_LIST="$(get_current_list)"

# 文字列 "['/org/.../custom0/', '/org/.../custom1/']" → Bash配列 path[]
readarray -t EXISTING_PATHS < <(printf "%s\n" "$CURRENT_LIST" | \
  tr -d "[]" | tr -d "'" | tr "," "\n" | sed 's/^ *//; s/ *$//' | grep -E '^/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom[0-9]+/$' || true)

# 既存エントリを全部削除（--replace のとき）
if [[ $REPLACE -eq 1 ]]; then
  # まず一覧を空に
  gsettings set $SCHEMA custom-keybindings "[]"
  # 中身自体は一覧から切れていれば参照されないのでOK（個別にクリアは不要）
  EXISTING_PATHS=()
fi

# 次に使う customN の番号を決定
max_id=-1
for p in "${EXISTING_PATHS[@]}"; do
  n=$(echo "$p" | grep -oE 'custom[0-9]+' | grep -oE '[0-9]+')
  [[ -n "${n:-}" ]] && (( n > max_id )) && max_id=$n
done
next_id=$((max_id + 1))

# --- バインディング正規化: "C-A-t" -> "<Ctrl><Alt>t" ---
normalize_binding() {
  local raw="$1"
  raw="${raw// /}"               # remove spaces
  raw="${raw//[^A-Za-z0-9_-]/}"  # remove weird chars except - and _
  IFS="-" read -r -a parts <<<"$raw"

  local mods=()
  local key=""

  # 特殊キー名の正規化テーブル（小文字→GSettings表記）
  declare -A mapkey=(
    [return]="Return" [enter]="Return" [esc]="Escape" [escape]="Escape"
    [tab]="Tab" [space]="space" [backspace]="BackSpace" [delete]="Delete"
    [left]="Left" [right]="Right" [up]="Up" [down]="Down"
    [home]="Home" [end]="End" [pageup]="Page_Up" [pagedown]="Page_Down"
  )

  # F-キー判定: F1..F24
  is_fkey() { [[ "$1" =~ ^[Ff][0-9]{1,2}$ ]] && return 0 || return 1; }

  for part in "${parts[@]}"; do
    lp="$(echo "$part" | tr '[:upper:]' '[:lower:]')"
    case "$lp" in
      c|ctrl|control) mods+=("<Ctrl>") ;;
      a|alt)          mods+=("<Alt>") ;;
      s|shift)        mods+=("<Shift>") ;;
      super|win|meta|m) mods+=("<Super>") ;;
      *)
        # キー本体
        if is_fkey "$part"; then
          key="F${part#*[Ff]}"
        else
          if [[ -n "${mapkey[$lp]:-}" ]]; then
            key="${mapkey[$lp]}"
          else
            # 1文字 or 英数記号はそのまま（例: t, e, 1, equal など）
            key="$part"
          fi
        fi
        ;;
    esac
  done

  # mods連結 + key
  printf "%s%s" "$(IFS=; echo "${mods[*]}")" "$key"
}

# --- CSV読み込み & 登録 ---
NEW_PATHS=()
while IFS= read -r line || [[ -n "$line" ]]; do
  # 空行/コメント行スキップ
  [[ -z "${line// /}" ]] && continue
  [[ "${line:0:1}" == "#" ]] && continue

  # CSV3列: name,command,binding
  IFS=, read -r name command binding <<<"$line"

  # ヘッダ行っぽい場合スキップ
  if [[ "$(echo "$name" | tr '[:upper:]' '[:lower:]')" == "name" ]]; then
    continue
  fi

  # 前後空白削除
  name="$(echo "$name" | sed 's/^ *//; s/ *$//')"
  command="$(echo "$command" | sed 's/^ *//; s/ *$//')"
  binding="$(echo "$binding" | sed 's/^ *//; s/ *$//')"

  [[ -z "$name" || -z "$command" || -z "$binding" ]] && { echo "WARN: 不完全な行をスキップ: $line"; continue; }

  norm_binding="$(normalize_binding "$binding")"
  if [[ -z "$norm_binding" ]]; then
    echo "WARN: バインディング変換に失敗: $binding"
    continue
  fi

  keypath="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${next_id}/"
  schema_kb="$SCHEMA.custom-keybinding:$keypath"

  echo "Register: [$name] -> [$command] @ [$norm_binding]"

  # 個別設定
  gsettings set "$schema_kb" name "$name"
  gsettings set "$schema_kb" command "$command"
  gsettings set "$schema_kb" binding "$norm_binding"

  NEW_PATHS+=("$keypath")
  next_id=$((next_id + 1))
done < "$CSV"

# --- 一覧を更新（既存 + 新規 or 置換時は新規のみ） ---
if [[ $REPLACE -eq 1 ]]; then
  ALL_PATHS=( "${NEW_PATHS[@]}" )
else
  ALL_PATHS=( "${EXISTING_PATHS[@]}" "${NEW_PATHS[@]}" )
fi

# gsettings で Python風リスト文字列に整形
list_literal="$(
  {
    for p in "${ALL_PATHS[@]}"; do
      printf "'%s', " "$p"
    done
  } | sed 's/, $//'
)"
gsettings set $SCHEMA custom-keybindings "[$list_literal]"

echo "Done. 現在の一覧:"
gsettings get $SCHEMA custom-keybindings
