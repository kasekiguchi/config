#!/usr/bin/env bash
set -euo pipefail

USER_NAME="sekiguchi"   # ←あなたのユーザー名に
USER_UID="$(id -u "$USER_NAME")"

# --- 1) rootで呼ばれたらユーザーに切替えて「このスクリプト」を再実行 ---
if [[ $EUID -eq 0 ]]; then
  exec /usr/sbin/runuser -u "$USER_NAME" -- "$0" --as-user
fi

# --- 2) ここからは“ユーザー権限”で動く ---
# GUIセッションのDBusに確実に繋ぐ
export XDG_RUNTIME_DIR="/run/user/$USER_UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# Wayland/XのDISPLAYも念のため
if [[ -z "${WAYLAND_DISPLAY-}" ]] && compgen -G "${XDG_RUNTIME_DIR}/wayland-*">/dev/null; then
  export WAYLAND_DISPLAY="$(basename "$(ls "${XDG_RUNTIME_DIR}"/wayland-* | head -n1)")"
fi
export DISPLAY="${DISPLAY-:0}"

# IBus再起動
ibus exit || true
pkill -f ibus-daemon || true
rm -rf ~/.cache/ibus/bus/* 2>/dev/null || true
ibus-daemon -rd

