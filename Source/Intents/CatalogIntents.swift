import AppIntents
import SwiftUI

/// App Shortcuts (System experiences > App Shortcuts) と
/// Snippets (System experiences > Snippets) のデモ。
///
/// Siri / Spotlight / ショートカット App から「HIG の部品数を表示」を実行すると
/// スニペット (小さなビュー) が返る。
struct ComponentCountIntent: AppIntent {
    static var title: LocalizedStringResource = "HIG の部品数を表示"
    static var description = IntentDescription("HIG Components の部品数と、そのうち iOS で使える数を表示します。")

    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let total = CatalogData.items.count
        let ios = CatalogData.items.filter(\.isAvailableOnIOS).count
        qlog(.info, "intent", "ComponentCountIntent 実行: total=\(total) ios=\(ios)")
        return .result(
            dialog: "HIG の部品は \(total) 個、そのうち iOS で使えるのは \(ios) 個です。",
            view: ComponentCountSnippetView(total: total, ios: ios)
        )
    }
}

/// Snippets のデモ: Intent の結果として表示される小さなビュー。
struct ComponentCountSnippetView: View {
    let total: Int
    let ios: Int

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "book.pages")
                .font(.largeTitle)
                .foregroundStyle(.blue)
            VStack(alignment: .leading) {
                Text("HIG Components").font(.headline)
                Text("全 \(total) 項目 / iOS で使える \(ios) 項目").font(.subheadline)
            }
            Spacer()
        }
        .padding()
    }
}

/// アプリを開いてランダムな部品を表示する。
struct OpenRandomComponentIntent: AppIntent {
    static var title: LocalizedStringResource = "ランダムな部品を開く"
    static var description = IntentDescription("HIG Catalog を開いて、部品をひとつランダムに表示します。")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        qlog(.info, "intent", "OpenRandomComponentIntent 実行")
        QuickActionStore.shared.request(.random)
        return .result()
    }
}

struct CatalogShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ComponentCountIntent(),
            phrases: [
                "\(.applicationName) の部品数",
                "\(.applicationName) で部品数を表示",
            ],
            shortTitle: "部品数を表示",
            systemImageName: "number"
        )
        AppShortcut(
            intent: OpenRandomComponentIntent(),
            phrases: [
                "\(.applicationName) でランダムな部品を開く",
            ],
            shortTitle: "ランダムな部品",
            systemImageName: "shuffle"
        )
    }
}
