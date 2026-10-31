import SwiftUI

// MARK: - Action sheets

struct ActionSheetsDemo: View {
    @State private var show = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button("削除の確認を出す (confirmationDialog)") { show = true }
                .buttonStyle(.bordered)
                .confirmationDialog("この項目を削除しますか？", isPresented: $show, titleVisibility: .visible) {
                    Button("削除", role: .destructive) { qlog(.info, "actionsheet", "削除") }
                    Button("アーカイブ") { qlog(.info, "actionsheet", "アーカイブ") }
                    Button("キャンセル", role: .cancel) { qlog(.info, "actionsheet", "キャンセル") }
                } message: {
                    Text("この操作は取り消せません。")
                }
            DemoCaption("iPhone では下から、iPad ではボタンからのポップオーバーで出ます。")
        }
    }
}

// MARK: - Alerts

struct AlertsDemo: View {
    @State private var showOK = false
    @State private var showTwo = false
    @State private var showInput = false
    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button("ボタン 1 つ (OK だけ)") { showOK = true }
                .buttonStyle(.bordered)
                .alert("保存しました", isPresented: $showOK) {
                    // ボタンを書かないと OK が自動で付く
                } message: {
                    Text("ファイルを書き出しました。")
                }
            Button("ボタン 2 つ (キャンセル / 削除)") { showTwo = true }
                .buttonStyle(.bordered)
                .alert("削除しますか？", isPresented: $showTwo) {
                    Button("削除", role: .destructive) { qlog(.info, "alert", "削除") }
                    Button("キャンセル", role: .cancel) {}
                } message: {
                    Text("この操作は取り消せません。")
                }
            Button("テキスト入力付き") { showInput = true }
                .buttonStyle(.bordered)
                .alert("名前を入力", isPresented: $showInput) {
                    TextField("名前", text: $name)
                    Button("OK") { qlog(.info, "alert", "入力: \(name)") }
                    Button("キャンセル", role: .cancel) {}
                }
        }
    }
}

// MARK: - Page controls

struct PageControlsDemo: View {
    @State private var page = 0
    private let colors: [Color] = [.blue, .green, .orange, .purple]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TabView(selection: $page) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors[i].gradient)
                        .overlay(Text("ページ \(i + 1)").font(.title).foregroundStyle(.white))
                        .padding(.horizontal, 4)
                        .tag(i)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 200)
            .onChange(of: page) { _, p in qlog(.debug, "pagecontrol", "ページ: \(p + 1)") }
            DemoCaption("横にスワイプ。下の点がページコントロール。")
        }
    }
}

// MARK: - Panels (macOS)

struct PanelsDemo: View {
    @State private var showInspector = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iPad では .inspector が右側のパネルになります。iPhone ではシートになります。")
            FullScreenDemoButton(title: "inspector を全画面で見る") {
                NavigationStack {
                    InspectorHost()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

struct InspectorHost: View {
    @State private var show = true
    var body: some View {
        Text("本文")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Panel の代替")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { DemoCloseButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { show.toggle() } label: { Image(systemName: "sidebar.trailing") }
                }
            }
            .inspector(isPresented: $show) {
                Form {
                    Section("インスペクタ") {
                        LabeledContent("幅", value: "320")
                        LabeledContent("高さ", value: "240")
                        Toggle("表示", isOn: .constant(true))
                    }
                }
                .inspectorColumnWidth(min: 200, ideal: 280, max: 360)
            }
    }
}

// MARK: - Popovers

struct PopoversDemo: View {
    @State private var show = false
    @State private var showCompact = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button("ポップオーバーを出す") { show = true }
                .buttonStyle(.bordered)
                .popover(isPresented: $show) {
                    VStack(spacing: 12) {
                        Text("ポップオーバーの内容")
                        Button("閉じる") { show = false }
                    }
                    .padding()
                }
            Button("iPhone でも吹き出しのまま") { showCompact = true }
                .buttonStyle(.bordered)
                .popover(isPresented: $showCompact, arrowEdge: .top) {
                    Text("presentationCompactAdaptation(.popover)")
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            DemoCaption("1 つ目は iPhone ではシートになり、iPad では吹き出しになります。")
        }
    }
}

// MARK: - Scroll views

struct ScrollViewsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DemoHeading("縦 (既定)")
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(0..<20, id: \.self) { i in
                        Text("行 \(i)").frame(maxWidth: .infinity).padding(6)
                            .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
            .frame(height: 150)
            DemoHeading("横・ページ送り (.paging)")
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hue: Double(i) / 5, saturation: 0.5, brightness: 0.9))
                            .overlay(Text("ページ \(i + 1)"))
                            .containerRelativeFrame(.horizontal)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .frame(height: 120)
            DemoHeading("横・項目ごとにスナップ (.viewAligned)")
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(0..<8, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.teal.opacity(0.6))
                            .frame(width: 140, height: 90)
                            .overlay(Text("\(i + 1)"))
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .frame(height: 100)
        }
    }
}

// MARK: - Sheets

struct SheetsDemo: View {
    @State private var showSheet = false
    @State private var showDetents = false
    @State private var showFull = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button("シート (.sheet)") { showSheet = true }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showSheet) {
                    NavigationStack {
                        Text("シートの内容")
                            .navigationTitle("シート")
                            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("閉じる") { showSheet = false } } }
                    }
                }
            Button("高さ段階付き (presentationDetents)") { showDetents = true }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showDetents) {
                    VStack(spacing: 12) {
                        Capsule().frame(width: 40, height: 5).foregroundStyle(.secondary)
                        Text("上にドラッグすると大きくなります")
                        Spacer()
                    }
                    .padding()
                    .presentationDetents([.fraction(0.25), .medium, .large])
                    .presentationDragIndicator(.hidden)
                }
            Button("全画面 (.fullScreenCover)") { showFull = true }
                .buttonStyle(.bordered)
                .fullScreenCover(isPresented: $showFull) {
                    NavigationStack {
                        Text("全画面カバー")
                            .navigationTitle("全画面")
                            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("閉じる") { showFull = false } } }
                    }
                }
        }
    }
}

// MARK: - Windows

struct WindowsDemo: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption(supportsMultipleWindows
                        ? "この端末は複数ウインドウに対応しています。別ウインドウでログを開けます。"
                        : "この端末 (iPhone) は複数ウインドウに対応していません。iPad で試してください。")
            Button("ログを別ウインドウで開く (openWindow)") {
                qlog(.info, "windows", "openWindow(id: log-window)")
                openWindow(id: "log-window")
            }
            .buttonStyle(.bordered)
            .disabled(!supportsMultipleWindows)
            DemoCaption("iPad ではアプリアイコンを Dock から画面端へドラッグしても新しいウインドウを開けます。")
        }
    }
}
