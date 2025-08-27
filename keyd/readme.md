## 使い方
```bash
sudo systemctl stop keyd
sudo keyd -c ./ubuntu_shortcuts
```

デフォルトは /etc/keyd/default.conf を読むサービス
このファイルを書き換えた場合は以下のコマンド
```bash
sudo systemctl enable --now keyd
sudo keyd reload
```
## サービス設定を恒久的に変える

もし毎回自作の config を使いたいなら systemd の override で ExecStart を変更できます：

sudo systemctl edit keyd


そして以下を記述：

[Service]
ExecStart=
ExecStart=/usr/bin/keyd -c /home/youruser/my_keyd.conf


保存後に反映：

sudo systemctl daemon-reexec
sudo systemctl restart keyd


### デバッグに便利
sudo keyd monitor

## ubuntu_shortcutsファイルの説明
メモ

overloadt2(alt, macro(...), 200) は「200ms 以内にタップ→macro, それ以外（押し続ける/修飾に使う）→Alt 層」という意味です。

macro(M-f13) は Super+F13 を送る指定（M=Meta/Super, A=Alt）。macro/レイヤ構文は keyd のマニュアル参照。
Arch Wiki
