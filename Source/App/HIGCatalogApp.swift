import SwiftUI

@main
struct HIGCatalogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        // iPadOS 26 のメニューバー (Menus and actions > The menu bar) に
        // アプリ独自のメニューを足す。画面上端から下へスワイプすると見える。
        .commands {
            CommandMenu("カタログ") {
                Button("ランダムな部品を開く") {
                    QuickActionStore.shared.request(.random)
                    qlog(.info, "menubar", "メニューバーから「ランダムな部品を開く」")
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
                Divider()
                Button("ログを開く") {
                    QuickActionStore.shared.request(.logs)
                    qlog(.info, "menubar", "メニューバーから「ログを開く」")
                }
                .keyboardShortcut("l", modifiers: [.command, .shift])
            }
        }

        // Presentation > Windows の iPad デモで openWindow(id:) から開く補助ウインドウ。
        WindowGroup("ログ (別ウインドウ)", id: "log-window") {
            NavigationStack {
                LogViewerView()
            }
        }
    }
}
