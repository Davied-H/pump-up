//
//  FitnessApp.swift
//  FitnessApp
//
//  健身追踪 iOS 应用
//

import SwiftUI
import UserNotifications

// MARK: - App Delegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // 设置通知代理
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        return true
    }

    // MARK: - Remote Notifications

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleDeviceToken(deviceToken)
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleDeviceTokenError(error)
        }
    }

    // 处理静默推送或后台推送
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // 处理远程推送数据
        print("收到远程推送: \(userInfo)")

        // 可以在这里触发数据同步等操作
        Task {
            await HealthKitManager.shared.syncActivityToServer()
            completionHandler(.newData)
        }
    }
}

// MARK: - Main App

@main
struct FitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var fitnessManager = FitnessManager()
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fitnessManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(.dark)
                .onReceive(NotificationCenter.default.publisher(for: .navigateToWorkout)) { _ in
                    // 处理导航到训练页面
                }
                .onReceive(NotificationCenter.default.publisher(for: .navigateToMeditation)) { _ in
                    // 处理导航到冥想页面
                }
                .onReceive(NotificationCenter.default.publisher(for: .navigateToStatistics)) { _ in
                    // 处理导航到统计页面
                }
                .onReceive(NotificationCenter.default.publisher(for: .navigateToAchievements)) { _ in
                    // 处理导航到成就页面
                }
        }
    }
}
