# HIG Catalog

Apple の Human Interface Guidelines「[Components](https://developer.apple.com/design/human-interface-guidelines/components)」に載っている全 64 項目を、iPhone / iPad の実機でどう見えるか確かめるためのカタログアプリ。

- Swift / SwiftUI、iOS・iPadOS 26.0 以上
- 各部品ごとに「デモ → 日本語の概要 → HIG が対応を明記しているプラットフォーム → HIG へのリンク (英語 / 日本語)」
- iOS / iPadOS に無い 16 項目 (macOS / tvOS / watchOS / visionOS 専用) は「iOS にはない」と表示し、iOS で近いことをする手段を載せている
- Widgets / Live Activities / Controls は Widget Extension (`HIGCatalogWidget`) で実物を提供する
- 操作はすべてアプリ内ログに残り、「ログ」画面から共有できる

ビルドは GitHub Actions (`.github/workflows/build-ipa.yml`、汎用 rev9)、配布は SideStore。詳細は `docs/` を参照。

| ドキュメント | 内容 |
|---|---|
| `docs/components.md` | 64 項目の一覧と iOS での可否 |
| `docs/verification.md` | インストール・動作確認の手順と注意 |
