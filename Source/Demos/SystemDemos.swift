import SwiftUI
import ActivityKit
import UserNotifications
import WidgetKit
import AppIntents

// MARK: - App Shortcuts

struct AppShortcutsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("このアプリが登録している App ショートカット:")
            VStack(alignment: .leading, spacing: 6) {
                Label("HIG の部品数を表示  (Siri: 「HIG Catalog の部品数」)", systemImage: "number")
                Label("ランダムな部品を開く", systemImage: "shuffle")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            DemoHeading("アプリ内から実行")
            Button("部品数を表示 (Intent を直接実行)") {
                Task {
                    do {
                        let result = try await ComponentCountIntent().perform()
                        qlog(.info, "appshortcuts", "perform 完了: \(String(describing: result))")
                    } catch {
                        qlog(.error, "appshortcuts", "perform 失敗: \(error)")
                    }
                }
            }
            .buttonStyle(.bordered)
            ShortcutsLink()
            DemoCaption("ShortcutsLink はショートカット App のこのアプリのページを開きます。")
        }
    }
}

// MARK: - Complications (watchOS)

struct ComplicationsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で同じ WidgetKit の仕組みを使うのはロック画面ウィジェットです。このアプリの Widget は accessoryCircular / accessoryRectangular / accessoryInline に対応しています。")
            DemoCaption("確認: ロック画面を長押し → 「カスタマイズ」→ 時計の下の枠 → 「HIG Catalog」。")
        }
    }
}

// MARK: - Controls

struct ControlsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("Widget Extension に「HIG Catalog を開く」ボタンのコントロールがあります。")
            VStack(alignment: .leading, spacing: 6) {
                Label("HIG Catalog を開く (ControlWidgetButton)", systemImage: "book")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            DemoCaption("確認: コントロールセンターを開く → 長押しで編集 → 「コントロールを追加」→ 「HIG Catalog」。ロック画面の下 2 つのボタンやアクションボタンにも割り当てられます。")
            Button("コントロールを再読み込み (ControlCenter.reloadAllControls)") {
                ControlCenter.shared.reloadAllControls()
                qlog(.info, "controls", "reloadAllControls")
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Live Activities

@MainActor
@Observable
final class LiveActivityController {
    static let shared = LiveActivityController()

    private(set) var activity: Activity<CatalogActivityAttributes>?
    private(set) var progress = 0.0
    private(set) var lastError: String?

    var isRunning: Bool { activity != nil }
    var isEnabled: Bool { ActivityAuthorizationInfo().areActivitiesEnabled }

    func start() {
        guard isEnabled else {
            lastError = "Live Activity が無効です (設定 → HIG Catalog → ライブアクティビティ)"
            qlog(.warning, "liveactivity", lastError!)
            return
        }
        let attrs = CatalogActivityAttributes(title: "HIG Catalog のデモ")
        let state = CatalogActivityAttributes.ContentState(progress: 0, message: "開始しました")
        do {
            activity = try Activity.request(
                attributes: attrs,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            progress = 0
            lastError = nil
            qlog(.info, "liveactivity", "開始: id=\(activity?.id ?? "nil")")
        } catch {
            lastError = "開始に失敗: \(error)"
            qlog(.error, "liveactivity", lastError!)
        }
    }

    func advance() {
        guard let activity else { return }
        progress = min(1, progress + 0.2)
        let state = CatalogActivityAttributes.ContentState(progress: progress, message: "進捗 \(Int(progress * 100))%")
        Task {
            await activity.update(.init(state: state, staleDate: nil))
            qlog(.info, "liveactivity", "更新: \(Int(progress * 100))%")
        }
    }

    func end() {
        guard let activity else { return }
        let state = CatalogActivityAttributes.ContentState(progress: 1, message: "終了しました")
        Task {
            await activity.end(.init(state: state, staleDate: nil), dismissalPolicy: .immediate)
            qlog(.info, "liveactivity", "終了")
            self.activity = nil
            self.progress = 0
        }
    }
}

struct LiveActivitiesDemo: View {
    private var controller: LiveActivityController { LiveActivityController.shared }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("開始するとロック画面 (対応 iPhone では Dynamic Island) に表示されます。開始後にロックして確かめてください。")
            LabeledContent("ライブアクティビティの許可", value: controller.isEnabled ? "有効" : "無効")
            LabeledContent("状態", value: controller.isRunning ? "実行中 (\(Int(controller.progress * 100))%)" : "停止")
            HStack {
                Button("開始") { controller.start() }
                    .disabled(controller.isRunning)
                Button("進める (+20%)") { controller.advance() }
                    .disabled(!controller.isRunning)
                Button("終了", role: .destructive) { controller.end() }
                    .disabled(!controller.isRunning)
            }
            .buttonStyle(.bordered)
            if let e = controller.lastError {
                Text(e).font(.caption).foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Notifications

struct NotificationsDemo: View {
    @State private var status: UNAuthorizationStatus = .notDetermined
    @State private var delay = 5.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LabeledContent("通知の許可", value: statusText)
            Button("許可を求める") {
                Task {
                    do {
                        let ok = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                        qlog(.info, "notification", "許可: \(ok)")
                    } catch {
                        qlog(.error, "notification", "許可の要求に失敗: \(error)")
                    }
                    await refresh()
                }
            }
            .buttonStyle(.bordered)
            Stepper("\(Int(delay)) 秒後に通知", value: $delay, in: 1...60)
            Button("ローカル通知を予約") {
                Task { await schedule() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(status == .denied)
            DemoCaption("アプリを前面に置いたままでもバナーが出ます (willPresent で .banner を返しているため)。ホームに戻ってからでも届きます。")
        }
        .task { await refresh() }
    }

    private var statusText: String {
        switch status {
        case .authorized: return "許可"
        case .denied: return "拒否"
        case .notDetermined: return "未決定"
        case .provisional: return "仮許可"
        case .ephemeral: return "一時的"
        @unknown default: return "不明"
        }
    }

    private func refresh() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        status = settings.authorizationStatus
        qlog(.debug, "notification", "authorizationStatus=\(settings.authorizationStatus.rawValue)")
    }

    private func schedule() async {
        let content = UNMutableNotificationContent()
        content.title = "HIG Catalog"
        content.body = "これはローカル通知のデモです (\(Int(delay)) 秒後)。"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: "higcatalog.demo", content: content, trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(request)
            qlog(.info, "notification", "予約: \(Int(delay)) 秒後")
        } catch {
            qlog(.error, "notification", "予約に失敗: \(error)")
        }
    }
}

// MARK: - Snippets

struct SnippetsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("App ショートカット「HIG の部品数を表示」を実行すると、次のビューがスニペットとして出ます。")
            ComponentCountSnippetView(total: CatalogData.items.count, ios: CatalogData.items.filter(\.isAvailableOnIOS).count)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            DemoCaption("確認: ショートカット App → 「HIG Catalog」→ 「部品数を表示」を実行。")
            ShortcutsLink()
        }
    }
}

// MARK: - Status bars

struct StatusBarsDemo: View {
    @State private var hidden = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("全画面でステータスバーの表示/非表示を切り替えられます。")
            FullScreenDemoButton(title: "ステータスバーのデモを開く") {
                StatusBarFullDemo()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct StatusBarFullDemo: View {
    @State private var hidden = false
    @State private var dark = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            (dark ? Color.black : Color.white).ignoresSafeArea()
            VStack(spacing: 20) {
                Toggle("ステータスバーを隠す (.statusBarHidden)", isOn: $hidden)
                Toggle("背景を暗くする (文字色が自動で白になる)", isOn: $dark)
                Button("閉じる") { dismiss() }.buttonStyle(.borderedProminent)
            }
            .padding()
            .foregroundStyle(dark ? .white : .black)
        }
        .statusBarHidden(hidden)
        .preferredColorScheme(dark ? .dark : .light)
        .onChange(of: hidden) { _, v in qlog(.info, "statusbar", v ? "隠す" : "表示") }
    }
}

// MARK: - Top Shelf (tvOS)

struct TopShelfDemo: View {
    var body: some View {
        DemoCaption("iOS でホーム画面にアプリの内容を見せる仕組みは Widgets です。「Widgets」の項目を参照してください。")
    }
}

// MARK: - Watch faces (watchOS)

struct WatchFacesDemo: View {
    var body: some View {
        DemoCaption("iOS に相当するものはありません。ロック画面のカスタマイズに近いですが、アプリが提供できるのはロック画面ウィジェット (Widgets) までです。")
    }
}

// MARK: - Widgets

struct WidgetsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("Widget Extension が提供するウィジェット:")
            VStack(alignment: .leading, spacing: 6) {
                Label("ホーム画面: 小 / 中", systemImage: "square.grid.2x2")
                Label("ロック画面: circular / rectangular / inline", systemImage: "lock")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            DemoCaption("確認: ホーム画面を長押し → 「編集」→ 「ウィジェットを追加」→ 「HIG Catalog」。")
            Button("ウィジェットを再読み込み (reloadAllTimelines)") {
                WidgetCenter.shared.reloadAllTimelines()
                qlog(.info, "widgets", "reloadAllTimelines")
            }
            .buttonStyle(.bordered)
            Button("設定済みウィジェットをログに出す") {
                WidgetCenter.shared.getCurrentConfigurations { result in
                    switch result {
                    case .success(let infos):
                        qlog(.info, "widgets", "設定済み: \(infos.map { "\($0.kind)/\($0.family)" })")
                    case .failure(let e):
                        qlog(.error, "widgets", "取得失敗: \(e)")
                    }
                }
            }
            .buttonStyle(.bordered)
        }
    }
}
