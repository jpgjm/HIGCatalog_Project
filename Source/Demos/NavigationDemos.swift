import SwiftUI

// MARK: - Path controls (macOS)

struct PathControlsDemo: View {
    private let path = ["ホーム", "書類", "プロジェクト", "HIGCatalog", "Source"]
    @State private var current = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で近いのはパン屑 (breadcrumb) の自作。タップでその階層へ戻る想定。")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(Array(path.prefix(current + 1).enumerated()), id: \.offset) { i, name in
                        if i > 0 {
                            Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.secondary)
                        }
                        Button(name) {
                            current = i
                            qlog(.info, "pathcontrol", "階層へ移動: \(name)")
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(i == current ? .primary : .secondary)
                        .font(i == current ? .body.bold() : .body)
                    }
                }
                .padding(8)
            }
            .background(.regularMaterial, in: Capsule())
            Button("最下層へ戻す") { current = path.count - 1 }
                .buttonStyle(.bordered)
        }
    }
}

// MARK: - Search fields

struct SearchFieldsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("この画面の一覧 (左) にも .searchable が付いています。全画面では候補とスコープ付きの検索を試せます。")
            FullScreenDemoButton(title: "検索フィールドを全画面で見る") {
                SearchFieldFullDemo()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SearchFieldFullDemo: View {
    @State private var query = ""
    @State private var scope = 0
    private let all = CatalogData.items

    private var results: [CatalogItem] {
        all.filter { item in
            let scopeOK = scope == 0 || item.isAvailableOnIOS
            let q = query.lowercased()
            return scopeOK && (q.isEmpty || item.title.lowercased().contains(q) || item.titleJA.contains(query))
        }
    }

    var body: some View {
        NavigationStack {
            List(results) { item in
                CatalogRow(item: item)
            }
            .navigationTitle("検索")
            .searchable(text: $query, prompt: "部品名")
            .searchSuggestions {
                if query.isEmpty {
                    Text("Buttons").searchCompletion("Buttons")
                    Text("Sheets").searchCompletion("Sheets")
                    Text("Gauges").searchCompletion("Gauges")
                }
            }
            .searchScopes($scope) {
                Text("すべて").tag(0)
                Text("iOS のみ").tag(1)
            }
            .onChange(of: query) { _, q in qlog(.debug, "search", "検索語: \(q)") }
            .toolbar { ToolbarItem(placement: .cancellationAction) { DemoCloseButton() } }
        }
    }
}

// MARK: - Sidebars

struct SidebarsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("このアプリの左の一覧がサイドバー (List の .sidebar スタイル) です。iPad を横にすると常に表示され、縦では左端からスワイプで出ます。")
            List {
                Section("ライブラリ") {
                    Label("最近の項目", systemImage: "clock")
                    Label("お気に入り", systemImage: "star")
                }
                Section("フォルダ") {
                    Label("書類", systemImage: "folder")
                    Label("ダウンロード", systemImage: "arrow.down.circle")
                }
            }
            .listStyle(.sidebar)
            .frame(height: 240)
        }
    }
}

// MARK: - Tab bars

struct TabBarsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS 26 のタブバー: ガラスの帯、スクロールで縮む、検索タブは右端に分離。")
            FullScreenDemoButton(title: "タブバーを全画面で見る") {
                TabBarFullDemo()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct TabBarFullDemo: View {
    @State private var selection = 0
    @State private var query = ""

    var body: some View {
        TabView(selection: $selection) {
            Tab("ホーム", systemImage: "house", value: 0) {
                NavigationStack {
                    List(0..<40, id: \.self) { Text("ホームの行 \($0)") }
                        .navigationTitle("ホーム")
                        .toolbar { ToolbarItem(placement: .cancellationAction) { DemoCloseButton() } }
                }
            }
            Tab("お気に入り", systemImage: "star", value: 1) {
                NavigationStack {
                    Text("お気に入り").navigationTitle("お気に入り")
                }
            }
            Tab("設定", systemImage: "gear", value: 2) {
                NavigationStack {
                    Text("設定").navigationTitle("設定")
                }
            }
            Tab(value: 3, role: .search) {
                NavigationStack {
                    List(CatalogData.items.filter { query.isEmpty || $0.title.lowercased().contains(query.lowercased()) }) { item in
                        Text(item.title)
                    }
                    .navigationTitle("検索")
                    .searchable(text: $query)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: selection) { _, v in qlog(.info, "tabbar", "タブ切替: \(v)") }
    }
}

// MARK: - Token fields (macOS)

struct TokenFieldsDemo: View {
    @State private var tokens = ["佐藤", "鈴木"]
    @State private var input = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で自作する場合の例。Return で入力語がトークンになり、トークンの × で外せます。")
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    ForEach(tokens, id: \.self) { t in
                        HStack(spacing: 4) {
                            Text(t).font(.callout)
                            Button {
                                tokens.removeAll { $0 == t }
                                qlog(.info, "tokens", "削除: \(t)")
                            } label: {
                                Image(systemName: "xmark.circle.fill").font(.caption)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.blue.opacity(0.15), in: Capsule())
                    }
                }
                TextField("名前を入力して Return", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        let t = input.trimmingCharacters(in: .whitespaces)
                        guard !t.isEmpty else { return }
                        tokens.append(t)
                        qlog(.info, "tokens", "追加: \(t)")
                        input = ""
                    }
            }
        }
    }
}
