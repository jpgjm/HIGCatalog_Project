import WidgetKit
import SwiftUI

/// System experiences > Widgets のデモ。
/// ホーム画面 (小 / 中) とロック画面 (circular / rectangular / inline) に対応する。
struct CatalogEntry: TimelineEntry {
    let date: Date
    let componentName: String
    let componentNameJA: String
}

struct CatalogProvider: TimelineProvider {
    /// Widget は CatalogData を持たないので、表示用の名前をここに持つ。
    private static let samples: [(String, String)] = [
        ("Buttons", "ボタン"), ("Sheets", "シート"), ("Gauges", "ゲージ"), ("Toolbars", "ツールバー"),
        ("Tab bars", "タブバー"), ("Alerts", "アラート"), ("Pickers", "ピッカー"), ("Menus", "メニュー"),
        ("Widgets", "ウィジェット"), ("Charts", "チャート"), ("Sliders", "スライダー"), ("Toggles", "トグル"),
    ]

    func placeholder(in context: Context) -> CatalogEntry {
        CatalogEntry(date: Date(), componentName: "Buttons", componentNameJA: "ボタン")
    }

    func getSnapshot(in context: Context, completion: @escaping (CatalogEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CatalogEntry>) -> Void) {
        // 1 時間ごとに別の部品名へ切り替える。
        let now = Date()
        var entries: [CatalogEntry] = []
        for i in 0..<6 {
            let date = Calendar.current.date(byAdding: .hour, value: i, to: now) ?? now
            let (en, ja) = Self.samples[(Int(now.timeIntervalSince1970 / 3600) + i) % Self.samples.count]
            entries.append(CatalogEntry(date: date, componentName: en, componentNameJA: ja))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct CatalogWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CatalogEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Image(systemName: "book.pages").font(.title3)
                    Text("\(CatalogShared.componentCount)").font(.caption.bold())
                }
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Label("HIG Catalog", systemImage: "book.pages").font(.headline)
                Text(entry.componentName).font(.body)
                Text(entry.componentNameJA).font(.caption)
            }
        case .accessoryInline:
            Label("HIG: \(entry.componentName)", systemImage: "book.pages")
        case .systemMedium:
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("HIG Catalog", systemImage: "book.pages").font(.headline)
                    Text("全 \(CatalogShared.componentCount) 項目").font(.caption).foregroundStyle(.secondary)
                    Text("iOS で使える \(CatalogShared.iosComponentCount) 項目").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("今の 1 つ").font(.caption2).foregroundStyle(.secondary)
                    Text(entry.componentName).font(.title3.bold())
                    Text(entry.componentNameJA).font(.caption)
                }
            }
        default:
            VStack(alignment: .leading, spacing: 4) {
                Label("HIG", systemImage: "book.pages").font(.headline)
                Spacer()
                Text(entry.componentName).font(.title3.bold()).minimumScaleFactor(0.6)
                Text(entry.componentNameJA).font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

struct CatalogWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: CatalogShared.widgetKind, provider: CatalogProvider()) { entry in
            CatalogWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("HIG Catalog")
        .description("HIG の部品名をひとつ表示します。")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
