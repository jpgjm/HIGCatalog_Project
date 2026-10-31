import WidgetKit
import SwiftUI

/// Widget Extension の入口。
/// Widgets / Live Activities / Controls の 3 つをまとめて提供する。
@main
struct HIGCatalogWidgetBundle: WidgetBundle {
    var body: some Widget {
        CatalogWidget()
        CatalogLiveActivity()
        CatalogControl()
    }
}
