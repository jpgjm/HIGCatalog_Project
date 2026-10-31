import WidgetKit
import SwiftUI
import AppIntents

/// System experiences > Controls のデモ (iOS 18+)。
/// コントロールセンター / ロック画面 / アクションボタンに置ける「HIG Catalog を開く」ボタン。
struct CatalogControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: CatalogShared.controlKind) {
            ControlWidgetButton(action: OpenCatalogControlIntent()) {
                Label("HIG Catalog", systemImage: "book.pages")
            }
        }
        .displayName("HIG Catalog を開く")
        .description("HIG Catalog アプリを開きます。")
    }
}

/// コントロールから呼ばれる Intent。アプリを開くだけ。
struct OpenCatalogControlIntent: AppIntent {
    static var title: LocalizedStringResource = "HIG Catalog を開く"
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}
