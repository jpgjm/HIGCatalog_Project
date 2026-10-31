import SwiftUI

// MARK: - Boxes

struct BoxesDemo: View {
    @State private var on = true
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GroupBox("見出し付きの GroupBox") {
                Toggle("設定 A", isOn: $on)
                Toggle("設定 B", isOn: .constant(false))
            }
            GroupBox {
                Text("見出しなしの GroupBox。関連する内容を枠でまとめる。")
            }
        }
    }
}

// MARK: - Collections

struct CollectionsDemo: View {
    private let columns = [GridItem(.adaptive(minimum: 72), spacing: 8)]
    private let colors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DemoHeading("LazyVGrid (adaptive)")
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(colors.enumerated()), id: \.offset) { i, c in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(c.gradient)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(Text("\(i + 1)").foregroundStyle(.white).bold())
                        .onTapGesture { qlog(.debug, "collections", "タップ: \(i + 1)") }
                }
            }
            DemoHeading("LazyHGrid (横スクロール)")
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 8) {
                    ForEach(0..<12, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colors[i % colors.count].opacity(0.6))
                            .frame(width: 90)
                            .overlay(Text("項目 \(i + 1)").font(.caption))
                    }
                }
            }
            .frame(height: 130)
        }
    }
}

// MARK: - Column views (macOS)

struct ColumnViewsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iPad の横向きで 3 カラム (サイドバー / 一覧 / 詳細) が並びます。iPhone では画面を進める形になります。")
            FullScreenDemoButton(title: "3 カラムの NavigationSplitView を開く") {
                ThreeColumnDemo()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct ThreeColumnDemo: View {
    @State private var folder: String? = "書類"
    @State private var file: String?
    private let folders = ["書類", "写真", "音楽"]
    private func files(in folder: String) -> [String] { (1...5).map { "\(folder) \($0)" } }

    var body: some View {
        NavigationSplitView {
            List(folders, id: \.self, selection: $folder) { Text($0) }
                .navigationTitle("フォルダ")
                .toolbar { ToolbarItem(placement: .cancellationAction) { DemoCloseButton() } }
        } content: {
            if let folder {
                List(files(in: folder), id: \.self, selection: $file) { Text($0) }
                    .navigationTitle(folder)
            } else {
                Text("フォルダを選択")
            }
        } detail: {
            Text(file ?? "ファイルを選択").font(.title2)
        }
    }
}

// MARK: - Disclosure controls

struct DisclosureControlsDemo: View {
    @State private var expanded = true
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DisclosureGroup("詳細を表示 (DisclosureGroup)", isExpanded: $expanded) {
                VStack(alignment: .leading) {
                    Text("展開された内容 1")
                    Text("展開された内容 2")
                }
                .padding(.top, 4)
            }
            .onChange(of: expanded) { _, v in qlog(.debug, "disclosure", v ? "展開" : "折りたたみ") }
            DisclosureGroup("入れ子") {
                DisclosureGroup("さらに入れ子") {
                    Text("一番内側")
                }
            }
        }
    }
}

// MARK: - Labels

struct LabelsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("アイコン + 文字 (既定)", systemImage: "star")
            Label("文字だけ (.titleOnly)", systemImage: "star").labelStyle(.titleOnly)
            Label("アイコンだけ (.iconOnly)", systemImage: "star").labelStyle(.iconOnly)
            Label("縦並び (自作スタイル)", systemImage: "star").labelStyle(VerticalLabelStyle())
            DemoHeading("リストの中では")
            List {
                Label("Wi-Fi", systemImage: "wifi")
                Label("Bluetooth", systemImage: "wave.3.right")
                LabeledContent("LabeledContent", value: "値")
            }
            .frame(height: 150)
            .scrollDisabled(true)
        }
    }
}

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 4) {
            configuration.icon.font(.title)
            configuration.title.font(.caption)
        }
    }
}

// MARK: - Lists and tables

struct ListsAndTablesDemo: View {
    struct Person: Identifiable {
        let id = UUID()
        let name: String
        let city: String
        let age: Int
    }

    private let people = [
        Person(name: "佐藤", city: "東京", age: 28),
        Person(name: "鈴木", city: "大阪", age: 34),
        Person(name: "高橋", city: "名古屋", age: 41),
    ]
    @State private var style = 0
    @State private var selection: Person.ID?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("スタイル", selection: $style) {
                Text("insetGrouped").tag(0)
                Text("plain").tag(1)
                Text("grouped").tag(2)
                Text("sidebar").tag(3)
            }
            .pickerStyle(.segmented)
            listView
                .frame(height: 220)
            DemoHeading("Table (iPad は 3 列、iPhone は先頭列のみ)")
            Table(people, selection: $selection) {
                TableColumn("名前", value: \.name)
                TableColumn("都市", value: \.city)
                TableColumn("年齢") { Text("\($0.age)") }
            }
            .frame(height: 180)
        }
    }

    @ViewBuilder
    private var listView: some View {
        let base = List {
            Section("セクション 1") {
                ForEach(people) { p in
                    HStack {
                        Text(p.name)
                        Spacer()
                        Text(p.city).foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button("削除", role: .destructive) { qlog(.info, "lists", "スワイプで削除: \(p.name)") }
                    }
                }
            }
            Section("セクション 2") {
                Text("スワイプで操作が出ます")
            }
        }
        switch style {
        case 1: base.listStyle(.plain)
        case 2: base.listStyle(.grouped)
        case 3: base.listStyle(.sidebar)
        default: base.listStyle(.insetGrouped)
        }
    }
}

// MARK: - Lockups (tvOS)

struct LockupsDemo: View {
    @State private var pressed = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で同じ役割のカード。長押しで浮き上がります。")
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 120)
                    .overlay(Image(systemName: "film").font(.largeTitle).foregroundStyle(.white))
                Text("タイトル").font(.headline)
                Text("サブタイトルや説明文").font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .scaleEffect(pressed ? 1.05 : 1)
            .shadow(radius: pressed ? 12 : 2)
            .animation(.spring, value: pressed)
            .onLongPressGesture(minimumDuration: 0.1, perform: {}, onPressingChanged: { pressed = $0 })
            .frame(maxWidth: 260)
        }
    }
}

// MARK: - Outline views

struct OutlineViewsDemo: View {
    struct Node: Identifiable {
        let id = UUID()
        let name: String
        var children: [Node]?
    }

    private let tree: [Node] = [
        Node(name: "Content", children: [
            Node(name: "Charts"), Node(name: "Image views"), Node(name: "Text views"), Node(name: "Web views"),
        ]),
        Node(name: "Status", children: [
            Node(name: "Gauges"), Node(name: "Progress indicators"),
        ]),
        Node(name: "子なしの項目"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DemoHeading("List(children:)")
            List(tree, children: \.children) { node in
                Label(node.name, systemImage: node.children == nil ? "doc" : "folder")
            }
            .frame(height: 260)
        }
    }
}

// MARK: - Split views

struct SplitViewsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("このアプリ自体が NavigationSplitView (一覧 + 詳細) です。iPad の横向きで 2 カラム、iPhone ではスタックになります。")
            FullScreenDemoButton(title: "2 カラムの NavigationSplitView を開く") {
                TwoColumnDemo()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct TwoColumnDemo: View {
    @State private var selected: String? = "りんご"
    private let items = ["りんご", "みかん", "ぶどう", "もも"]
    var body: some View {
        NavigationSplitView {
            List(items, id: \.self, selection: $selected) { Text($0) }
                .navigationTitle("一覧")
                .toolbar { ToolbarItem(placement: .cancellationAction) { DemoCloseButton() } }
        } detail: {
            Text(selected ?? "選択してください").font(.largeTitle)
        }
    }
}

// MARK: - Tab views (macOS / visionOS)

struct TabViewsDemo: View {
    @State private var tab = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で画面の一部を切り替えるなら Segmented control + 条件分岐。")
            Picker("", selection: $tab) {
                Text("一般").tag(0)
                Text("表示").tag(1)
                Text("詳細").tag(2)
            }
            .pickerStyle(.segmented)
            Group {
                switch tab {
                case 0: Text("「一般」の内容")
                case 1: Text("「表示」の内容")
                default: Text("「詳細」の内容")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
        }
    }
}
