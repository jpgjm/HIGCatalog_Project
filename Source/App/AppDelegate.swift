import UIKit
import UserNotifications
import Observation

/// ホーム画面のクイックアクション / メニューバーから届いた要求を
/// RootView に伝えるための置き場。
@MainActor
@Observable
final class QuickActionStore {
    static let shared = QuickActionStore()

    enum Action: String {
        case random
        case logs
    }

    /// 未処理の要求。RootView が消費して nil に戻す。
    var pending: Action?

    func request(_ action: Action) {
        pending = action
    }

    func request(shortcutType: String) {
        guard let action = Action(rawValue: shortcutType) else {
            qlog(.warning, "quickaction", "不明なクイックアクション: \(shortcutType)")
            return
        }
        qlog(.info, "quickaction", "クイックアクション受信: \(action.rawValue)")
        pending = action
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        qlog(.info, "lifecycle", "didFinishLaunching bundleID=\(Bundle.main.bundleIdentifier ?? "nil") version=\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?")")
        // 前面にいるときも通知バナーを出すために delegate を設定する。
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }

    // MARK: UNUserNotificationCenterDelegate

    /// 前面でも通知を表示する。
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        qlog(.info, "notification", "前面で通知を受信: \(notification.request.identifier)")
        return [.banner, .list, .sound]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        qlog(.info, "notification", "通知がタップされた: \(response.notification.request.identifier) action=\(response.actionIdentifier)")
    }
}

/// クイックアクションを受け取るためだけの SceneDelegate。
/// ウインドウは作らない (SwiftUI が WindowGroup を描く)。
final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        qlog(.debug, "lifecycle", "scene willConnect role=\(session.role.rawValue)")
        if let item = connectionOptions.shortcutItem {
            qlog(.info, "quickaction", "起動時のクイックアクション: \(item.type)")
            Task { @MainActor in
                QuickActionStore.shared.request(shortcutType: item.type)
            }
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        Task { @MainActor in
            QuickActionStore.shared.request(shortcutType: shortcutItem.type)
            completionHandler(true)
        }
    }
}
