import SwiftUI

// MARK: - Activity views

struct ActivityViewsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ShareLink(item: "HIG Catalog から共有したテキスト") {
                Label("テキストを共有 (ShareLink)", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.bordered)
            ShareLink(item: URL(string: "https://developer.apple.com/design/human-interface-guidelines/activity-views")!) {
                Label("URL を共有", systemImage: "link")
            }
            .buttonStyle(.bordered)
            ShareLink("ラベルだけの ShareLink", item: "共有される文字列")
        }
    }
}

// MARK: - Buttons

struct ButtonsDemo: View {
    @State private var count = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("スタイル")
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Button("automatic") { tap("automatic") }
                    Button("bordered") { tap("bordered") }.buttonStyle(.bordered)
                    Button("borderedProminent") { tap("borderedProminent") }.buttonStyle(.borderedProminent)
                }
                HStack {
                    Button("borderless") { tap("borderless") }.buttonStyle(.borderless)
                    Button("plain") { tap("plain") }.buttonStyle(.plain)
                }
                HStack {
                    Button("glass") { tap("glass") }.buttonStyle(.glass)
                    Button("glassProminent") { tap("glassProminent") }.buttonStyle(.glassProminent)
                }
            }
            DemoHeading("役割 (role)")
            HStack {
                Button("destructive", role: .destructive) { tap("destructive") }.buttonStyle(.bordered)
                Button("cancel", role: .cancel) { tap("cancel") }.buttonStyle(.bordered)
            }
            DemoHeading("大きさ (controlSize)")
            HStack {
                Button("mini") { tap("mini") }.controlSize(.mini)
                Button("small") { tap("small") }.controlSize(.small)
                Button("regular") { tap("regular") }
                Button("large") { tap("large") }.controlSize(.large)
            }
            .buttonStyle(.bordered)
            DemoHeading("アイコン付き・無効")
            HStack {
                Button { tap("icon") } label: { Label("追加", systemImage: "plus") }.buttonStyle(.borderedProminent)
                Button { tap("iconOnly") } label: { Image(systemName: "heart") }.buttonStyle(.bordered)
                Button("無効") {}.buttonStyle(.bordered).disabled(true)
            }
            DemoCaption("タップ回数: \(count)")
        }
    }

    private func tap(_ name: String) {
        count += 1
        qlog(.info, "buttons", "タップ: \(name)")
    }
}

// MARK: - Context menus

struct ContextMenusDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("長押しでメニューが出ます。")
            Text("ここを長押し")
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                .contextMenu {
                    Button { qlog(.info, "contextmenu", "コピー") } label: { Label("コピー", systemImage: "doc.on.doc") }
                    Button { qlog(.info, "contextmenu", "共有") } label: { Label("共有", systemImage: "square.and.arrow.up") }
                    Divider()
                    Button(role: .destructive) { qlog(.info, "contextmenu", "削除") } label: { Label("削除", systemImage: "trash") }
                }
            Text("プレビュー付き (長押し)")
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                .contextMenu {
                    Button("開く") { qlog(.info, "contextmenu", "開く (プレビュー付き)") }
                } preview: {
                    VStack {
                        Image(systemName: "photo").font(.system(size: 60))
                        Text("プレビュー")
                    }
                    .padding(40)
                }
        }
    }
}

// MARK: - Dock menus (macOS)

struct DockMenusDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DemoCaption("iOS でアイコン長押しに相当するのは Home Screen quick actions です。このアプリのアイコンをホーム画面で長押しすると「ランダムな部品を開く」「ログを開く」が出ます。")
        }
    }
}

// MARK: - Edit menus

struct EditMenusDemo: View {
    @State private var text = "この欄で文字を選択すると編集メニューが出ます"
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("入力", text: $text)
                .textFieldStyle(.roundedBorder)
            Text("Text でも .textSelection(.enabled) を付けると長押しで選択とメニューが出ます。")
                .textSelection(.enabled)
        }
    }
}

// MARK: - Home Screen quick actions

struct HomeScreenQuickActionsDemo: View {
    private var store: QuickActionStore { QuickActionStore.shared }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("ホーム画面でこのアプリのアイコンを長押しすると、次の 2 つが出ます。")
            VStack(alignment: .leading, spacing: 6) {
                Label("ランダムな部品を開く", systemImage: "shuffle")
                Label("ログを開く", systemImage: "doc.text.magnifyingglass")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            DemoCaption("アプリ内から同じ動きを試すには:")
            Button("ランダムな部品を開く (アプリ内から)") {
                store.request(.random)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Menus

struct MenusDemo: View {
    @State private var checked = true
    @State private var sort = "名前"
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Menu {
                Button { qlog(.info, "menus", "新規") } label: { Label("新規", systemImage: "plus") }
                Button { qlog(.info, "menus", "複製") } label: { Label("複製", systemImage: "doc.on.doc") }
                Divider()
                Toggle("チェック項目", isOn: $checked)
                Picker("並び順", selection: $sort) {
                    Text("名前").tag("名前")
                    Text("日付").tag("日付")
                }
                Menu("サブメニュー") {
                    Button("項目 A") { qlog(.info, "menus", "A") }
                    Button("項目 B") { qlog(.info, "menus", "B") }
                }
                Divider()
                Button(role: .destructive) { qlog(.info, "menus", "削除") } label: { Label("削除", systemImage: "trash") }
            } label: {
                Label("メニューを開く", systemImage: "ellipsis.circle")
            }
            .buttonStyle(.bordered)
            DemoCaption("チェック: \(checked ? "オン" : "オフ") / 並び順: \(sort)")
        }
    }
}

// MARK: - Ornaments (visionOS)

struct OrnamentsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS では画面下のツールバー (bottomBar) が同じ役割。全画面で確かめられます。")
            FullScreenDemoButton(title: "下部ツールバーを全画面で見る") {
                NavigationStack {
                    List(0..<30, id: \.self) { Text("行 \($0)") }
                        .navigationTitle("Ornament の代替")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) { DemoCloseButton() }
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button { qlog(.info, "ornaments", "戻る") } label: { Image(systemName: "chevron.left") }
                                Spacer()
                                Button { qlog(.info, "ornaments", "共有") } label: { Image(systemName: "square.and.arrow.up") }
                                Spacer()
                                Button { qlog(.info, "ornaments", "進む") } label: { Image(systemName: "chevron.right") }
                            }
                        }
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Pop-up buttons

struct PopUpButtonsDemo: View {
    @State private var fruit = "りんご"
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("果物", selection: $fruit) {
                Text("りんご").tag("りんご")
                Text("みかん").tag("みかん")
                Text("ぶどう").tag("ぶどう")
            }
            .pickerStyle(.menu)
            .onChange(of: fruit) { _, v in qlog(.info, "popup", "選択: \(v)") }
            DemoCaption("選択中: \(fruit) — ボタンに現在の値が出るのがポップアップボタン。")
        }
    }
}

// MARK: - Pull-down buttons

struct PullDownButtonsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Menu("追加…") {
                Button("ファイルを追加") { qlog(.info, "pulldown", "ファイル") }
                Button("フォルダを追加") { qlog(.info, "pulldown", "フォルダ") }
            }
            .buttonStyle(.bordered)
            Menu {
                Button("操作 1") { qlog(.info, "pulldown", "操作 1") }
                Button("操作 2") { qlog(.info, "pulldown", "操作 2") }
            } label: {
                Label("操作", systemImage: "chevron.down")
            } primaryAction: {
                qlog(.info, "pulldown", "primaryAction (本体をタップ)")
            }
            .buttonStyle(.bordered)
            DemoCaption("2 つ目は本体タップで既定の操作、長押しで一覧 (primaryAction)。")
        }
    }
}

// MARK: - The menu bar (iPadOS 26 / macOS)

struct MenuBarDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iPad で画面上端から下へスワイプするとメニューバーが出ます。このアプリは「カタログ」メニューに次の 2 つを追加しています。")
            VStack(alignment: .leading, spacing: 6) {
                Label("ランダムな部品を開く  ⇧⌘R", systemImage: "shuffle")
                Label("ログを開く  ⇧⌘L", systemImage: "doc.text.magnifyingglass")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            DemoCaption("iPhone にはメニューバーがありません。ハードウェアキーボードを繋いだ iPad ではショートカットキーでも動きます。")
        }
    }
}

// MARK: - Toolbars

struct ToolbarsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("この画面の上端のナビゲーションバーもツールバーの一種です。全画面で上下のツールバーと ToolbarSpacer を確かめられます。")
            FullScreenDemoButton(title: "ツールバーを全画面で見る") {
                NavigationStack {
                    List(0..<40, id: \.self) { Text("行 \($0)") }
                        .navigationTitle("ツールバー")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) { DemoCloseButton() }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button { qlog(.info, "toolbars", "検索") } label: { Image(systemName: "magnifyingglass") }
                            }
                            ToolbarSpacer(.fixed, placement: .topBarTrailing)
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                Button { qlog(.info, "toolbars", "お気に入り") } label: { Image(systemName: "heart") }
                                Button { qlog(.info, "toolbars", "その他") } label: { Image(systemName: "ellipsis") }
                            }
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button { qlog(.info, "toolbars", "編集") } label: { Label("編集", systemImage: "pencil") }
                                Spacer()
                                Text("40 件").font(.caption)
                                Spacer()
                                Button { qlog(.info, "toolbars", "作成") } label: { Label("作成", systemImage: "square.and.pencil") }
                            }
                        }
                }
            }
            .buttonStyle(.bordered)
        }
    }
}
