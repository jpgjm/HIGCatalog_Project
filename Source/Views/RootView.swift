import SwiftUI

struct RootView: View {
    @State private var selectedItem: CatalogItem?
    @State private var searchText = ""
    @State private var onlyIOS = false
    @State private var showLogs = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    private var store: QuickActionStore { QuickActionStore.shared }

    private func filtered(_ category: ComponentCategory) -> [CatalogItem] {
        CatalogData.items(in: category).filter { item in
            if onlyIOS && !item.isAvailableOnIOS { return false }
            if searchText.isEmpty { return true }
            let q = searchText.lowercased()
            return item.title.lowercased().contains(q)
                || item.titleJA.contains(searchText)
                || item.id.contains(q)
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedItem) {
                ForEach(ComponentCategory.allCases) { category in
                    let items = filtered(category)
                    if !items.isEmpty {
                        Section {
                            ForEach(items) { item in
                                NavigationLink(value: item) {
                                    CatalogRow(item: item)
                                }
                            }
                        } header: {
                            Label("\(category.title)  \(category.titleJA)", systemImage: category.symbolName)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("HIG Catalog")
            .searchable(text: $searchText, prompt: "部品名で検索")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $onlyIOS) {
                        Label("iOS のみ", systemImage: "iphone")
                    }
                    .toggleStyle(.button)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLogs = true
                    } label: {
                        Label("ログ", systemImage: "doc.text.magnifyingglass")
                    }
                }
            }
        } detail: {
            if let item = selectedItem {
                ComponentDetailView(item: item)
                    .id(item.id)
            } else {
                AboutView()
            }
        }
        .sheet(isPresented: $showLogs) {
            NavigationStack {
                LogViewerView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("閉じる") { showLogs = false }
                        }
                    }
            }
        }
        .onChange(of: store.pending) { _, action in
            if let action { handle(action) }
        }
        .onAppear {
            // 起動完了前に届いたクイックアクションを拾う。
            if let action = store.pending {
                qlog(.debug, "quickaction", "onAppear で保留中のクイックアクションを処理: \(action.rawValue)")
                handle(action)
            }
        }
    }

    private func handle(_ action: QuickActionStore.Action) {
        switch action {
        case .random:
            if let item = CatalogData.items.randomElement() {
                qlog(.info, "quickaction", "ランダム表示: \(item.title)")
                selectedItem = item
            }
        case .logs:
            showLogs = true
        }
        store.pending = nil
    }
}

struct CatalogRow: View {
    let item: CatalogItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                Text(item.titleJA)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if !item.isAvailableOnIOS {
                Text("iOS にはない")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.orange.opacity(0.2), in: Capsule())
                    .foregroundStyle(.orange)
            }
        }
    }
}

struct AboutView: View {
    private var total: Int { CatalogData.items.count }
    private var iosCount: Int { CatalogData.items.filter(\.isAvailableOnIOS).count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("HIG Catalog")
                    .font(.largeTitle.bold())
                Text("Apple の Human Interface Guidelines「Components」に載っている全 \(total) 項目を、実機でどう見えるか確かめるためのカタログです。")
                Text("iPhone / iPad で使えるものは \(iosCount) 項目。残りの \(total - iosCount) 項目は macOS / tvOS / watchOS / visionOS 専用で、「iOS にはない」の印を付け、iOS で近いことをする手段を書いてあります。")
                GroupBox("使い方") {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("左の一覧から部品を選ぶ", systemImage: "1.circle")
                        Label("上のデモを操作して見た目を確かめる", systemImage: "2.circle")
                        Label("「HIG を開く」で Apple の解説を読む", systemImage: "3.circle")
                        Label("操作の記録は右上の「ログ」から見る・共有する", systemImage: "4.circle")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Link("HIG Components (英語)", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/components")!)
                Link("HIG Components (日本語)", destination: URL(string: "https://developer.apple.com/jp/design/human-interface-guidelines/components")!)
            }
            .padding()
            .frame(maxWidth: 600, alignment: .leading)
        }
    }
}
