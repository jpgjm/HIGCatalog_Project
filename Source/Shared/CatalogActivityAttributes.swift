import ActivityKit
import Foundation

/// Live Activity の属性。ホストアプリ (開始・更新・終了) と
/// Widget Extension (表示) の両方にコンパイルされる。
struct CatalogActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// 0.0 〜 1.0
        var progress: Double
        var message: String
    }

    /// 開始時に決まる固定値。
    var title: String
}

/// ホストと Widget Extension で共有する定数。
enum CatalogShared {
    /// ウィジェットの kind (Extension 内で一意ならよい)。
    static let widgetKind = "HIGCatalogWidget"
    static let controlKind = "HIGCatalogControl"
    /// HIG の部品総数 (Widget は CatalogData を持たないので値だけ共有する)。
    static let componentCount = 64
    static let iosComponentCount = 48
}
