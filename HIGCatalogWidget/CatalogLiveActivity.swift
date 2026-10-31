import ActivityKit
import WidgetKit
import SwiftUI

/// System experiences > Live Activities の表示側。
/// 開始・更新・終了はホストアプリ (LiveActivityController) が行う。
struct CatalogLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CatalogActivityAttributes.self) { context in
            // ロック画面 / 通知センター / StandBy
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(context.attributes.title, systemImage: "book.pages").font(.headline)
                    Spacer()
                    Text("\(Int(context.state.progress * 100))%").font(.headline.monospacedDigit())
                }
                ProgressView(value: context.state.progress)
                Text(context.state.message).font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .activityBackgroundTint(.clear)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("HIG", systemImage: "book.pages")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(Int(context.state.progress * 100))%").monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: context.state.progress)
                        Text(context.state.message).font(.caption)
                    }
                }
            } compactLeading: {
                Image(systemName: "book.pages")
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%").monospacedDigit()
            } minimal: {
                Image(systemName: "book.pages")
            }
        }
    }
}
