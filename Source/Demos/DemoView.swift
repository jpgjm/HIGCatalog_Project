import SwiftUI

/// 部品 ID からデモ View を選ぶ。
struct DemoView: View {
    let itemID: String

    var body: some View {
        switch itemID {
        // Content
        case "charts": ChartsDemo()
        case "image-views": ImageViewsDemo()
        case "text-views": TextViewsDemo()
        case "web-views": WebViewsDemo()
        // Layout and organization
        case "boxes": BoxesDemo()
        case "collections": CollectionsDemo()
        case "column-views": ColumnViewsDemo()
        case "disclosure-controls": DisclosureControlsDemo()
        case "labels": LabelsDemo()
        case "lists-and-tables": ListsAndTablesDemo()
        case "lockups": LockupsDemo()
        case "outline-views": OutlineViewsDemo()
        case "split-views": SplitViewsDemo()
        case "tab-views": TabViewsDemo()
        // Menus and actions
        case "activity-views": ActivityViewsDemo()
        case "buttons": ButtonsDemo()
        case "context-menus": ContextMenusDemo()
        case "dock-menus": DockMenusDemo()
        case "edit-menus": EditMenusDemo()
        case "home-screen-quick-actions": HomeScreenQuickActionsDemo()
        case "menus": MenusDemo()
        case "ornaments": OrnamentsDemo()
        case "pop-up-buttons": PopUpButtonsDemo()
        case "pull-down-buttons": PullDownButtonsDemo()
        case "the-menu-bar": MenuBarDemo()
        case "toolbars": ToolbarsDemo()
        // Navigation and search
        case "path-controls": PathControlsDemo()
        case "search-fields": SearchFieldsDemo()
        case "sidebars": SidebarsDemo()
        case "tab-bars": TabBarsDemo()
        case "token-fields": TokenFieldsDemo()
        // Presentation
        case "action-sheets": ActionSheetsDemo()
        case "alerts": AlertsDemo()
        case "page-controls": PageControlsDemo()
        case "panels": PanelsDemo()
        case "popovers": PopoversDemo()
        case "scroll-views": ScrollViewsDemo()
        case "sheets": SheetsDemo()
        case "windows": WindowsDemo()
        // Selection and input
        case "color-wells": ColorWellsDemo()
        case "combo-boxes": ComboBoxesDemo()
        case "digit-entry-views": DigitEntryViewsDemo()
        case "image-wells": ImageWellsDemo()
        case "pickers": PickersDemo()
        case "segmented-controls": SegmentedControlsDemo()
        case "sliders": SlidersDemo()
        case "steppers": SteppersDemo()
        case "text-fields": TextFieldsDemo()
        case "toggles": TogglesDemo()
        case "virtual-keyboards": VirtualKeyboardsDemo()
        // Status
        case "activity-rings": ActivityRingsDemo()
        case "gauges": GaugesDemo()
        case "progress-indicators": ProgressIndicatorsDemo()
        case "rating-indicators": RatingIndicatorsDemo()
        // System experiences
        case "app-shortcuts": AppShortcutsDemo()
        case "complications": ComplicationsDemo()
        case "controls": ControlsDemo()
        case "live-activities": LiveActivitiesDemo()
        case "notifications": NotificationsDemo()
        case "snippets": SnippetsDemo()
        case "status-bars": StatusBarsDemo()
        case "top-shelf": TopShelfDemo()
        case "watch-faces": WatchFacesDemo()
        case "widgets": WidgetsDemo()
        default:
            Text("デモ未実装: \(itemID)")
                .foregroundStyle(.secondary)
                .onAppear { qlog(.error, "demo", "デモ未実装: \(itemID)") }
        }
    }
}

/// デモ内の説明文。
struct DemoCaption: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}

/// デモ内の小見出し。
struct DemoHeading: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.subheadline.bold())
            .padding(.top, 4)
    }
}

/// 「このデモは別画面で全画面表示する」用のボタン + fullScreenCover。
struct FullScreenDemoButton<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    @State private var isPresented = false

    var body: some View {
        Button {
            qlog(.debug, "demo", "全画面デモを開く: \(title)")
            isPresented = true
        } label: {
            Label(title, systemImage: "arrow.up.left.and.arrow.down.right")
        }
        .fullScreenCover(isPresented: $isPresented) {
            content()
        }
    }
}

/// 全画面デモの共通の閉じるボタン。
struct DemoCloseButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button("閉じる") { dismiss() }
    }
}
