# 動作確認の手順と注意 (v1.0.0)

## インストール

- 上書きインストールでよい (`BGTaskSchedulerPermittedIdentifiers` など installd がキャッシュする項目は使っていない)。
- **App ID を 2 枠使う** (ホスト `com.example.higcatalog` + Widget Extension `com.example.higcatalog.widget`)。
- entitlements は持っていない。Widget / Live Activity / Control / ローカル通知 / App Shortcuts はいずれも entitlement 不要。
- SideStore がインストール時に Bundle ID へチーム ID を付加するが、コードは Bundle ID を直書きしていない。

## 画面構成

- 左: カテゴリ別の一覧 (検索、「iOS のみ」フィルタ、ログボタン)。
- 右: 選んだ部品の「デモ / 概要 / 確認のしかた / 対応プラットフォーム / HIG リンク」。
- iPhone では一覧 → 詳細のスタックになる。

## 別の場所で確認が要る項目

| 項目 | 確認のしかた |
|---|---|
| Home Screen quick actions | アプリを終了し、ホーム画面でアイコンを長押し → 「ランダムな部品を開く」「ログを開く」 |
| The menu bar | iPad のみ。画面上端から下へスワイプ → 「カタログ」メニュー。⇧⌘R / ⇧⌘L でも動く |
| Windows | iPad のみ。「ログを別ウインドウで開く」ボタン。iPhone ではボタンが無効になる |
| App Shortcuts / Snippets | ショートカット App → 「HIG Catalog」→ 「部品数を表示」を実行。スニペットが出る |
| Controls | コントロールセンター → 長押し → 「コントロールを追加」→ 「HIG Catalog」 |
| Live Activities | アプリ内で「開始」→ 端末をロック。対応 iPhone なら Dynamic Island にも出る |
| Notifications | 初回に許可ダイアログ。拒否した場合は設定 App → HIG Catalog → 通知から変更 |
| Widgets | ホーム画面長押し → 「編集」→ 「ウィジェットを追加」→ 「HIG Catalog」。ロック画面のカスタマイズにも出る |

## Widget Extension が出てこないとき

1. アプリを一度起動する (Extension はホスト起動後にシステムに登録される)。
2. 「Widgets」の項目にある「ウィジェットを再読み込み」「設定済みウィジェットをログに出す」でログを確認する。
3. それでも出ない場合は端末を再起動する。
4. SideStore の設定で「Use Main Profile」が有効か確認する (無効だと appex のプロファイルが別になり起動しないことがある)。

## ログ

- 右上の「ログ」から閲覧。レベル (DEBUG / INFO / WARN / ERROR) で絞り込み、共有シートで書き出し。
- 保存先は `Documents/logs/higcatalog.log` (JSON Lines)。`UIFileSharingEnabled` が有効なので「ファイル」App の「このiPhone内 / HIG Catalog」からも取り出せる。
- 起動時はファイル末尾 500 行を読み戻す。メモリ上は 2000 行まで。

## HIG の対応プラットフォーム表記について

各項目の「HIG が対応を明記しているプラットフォーム」は 2026-11 時点の HIG 各ページ冒頭の表記を写したもの。HIG の更新で変わることがある。

## 既知の制限

- Web views のデモは通信が要る。
- Table は iPhone では先頭列しか表示されない (iOS の仕様)。
- Push 通知 (リモート通知) は有料アカウントが要るため扱っていない。
