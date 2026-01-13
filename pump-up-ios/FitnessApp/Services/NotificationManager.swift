//
//  NotificationManager.swift
//  FitnessApp
//
//  通知管理服务 - 本地通知 + APNs远程推送
//

import Foundation
import UserNotifications
import UIKit

// MARK: - 通知类型

enum NotificationType: String {
    case workoutReminder = "workout_reminder"
    case meditationReminder = "meditation_reminder"
    case dailySummary = "daily_summary"
    case achievement = "achievement"
    case stepGoal = "step_goal"
    case streak = "streak"
}

// MARK: - 通知设置

struct NotificationSettings {
    var workoutRemindersEnabled: Bool = true
    var workoutReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
    var meditationRemindersEnabled: Bool = true
    var meditationReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 21, minute: 0))!
    var dailySummaryEnabled: Bool = true
    var dailySummaryTime: Date = Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!
    var achievementAlertsEnabled: Bool = true
    var stepGoalAlertsEnabled: Bool = true
}

// MARK: - Notification Manager

@MainActor
class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized = false
    @Published var deviceToken: String?
    @Published var settings = NotificationSettings()

    private let notificationCenter = UNUserNotificationCenter.current()
    private let settingsKey = "notification_settings"

    override init() {
        super.init()
        loadSettings()
        checkAuthorizationStatus()
    }

    // MARK: - 权限管理

    /// 检查通知授权状态
    func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    /// 请求通知权限
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            await MainActor.run {
                self.isAuthorized = granted
            }

            if granted {
                await registerForRemoteNotifications()
            }

            return granted
        } catch {
            print("通知授权失败: \(error)")
            return false
        }
    }

    /// 注册远程推送
    private func registerForRemoteNotifications() async {
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    // MARK: - Device Token 管理

    /// 处理成功获取的device token
    func handleDeviceToken(_ deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.deviceToken = tokenString
        print("Device Token: \(tokenString)")

        // 上传到服务器
        Task {
            await registerTokenWithServer(tokenString)
        }
    }

    /// 处理获取device token失败
    func handleDeviceTokenError(_ error: Error) {
        print("获取Device Token失败: \(error)")
    }

    /// 向服务器注册device token
    private func registerTokenWithServer(_ token: String) async {
        do {
            try await APIService.shared.registerDeviceToken(token)
            print("Device token注册成功")
        } catch {
            print("Device token注册失败: \(error)")
        }
    }

    /// 注销device token
    func unregisterDeviceToken() async {
        do {
            try await APIService.shared.unregisterDeviceToken()
            deviceToken = nil
            print("Device token注销成功")
        } catch {
            print("Device token注销失败: \(error)")
        }
    }

    // MARK: - 本地通知

    /// 调度训练提醒
    func scheduleWorkoutReminder() {
        guard settings.workoutRemindersEnabled else {
            cancelNotifications(ofType: .workoutReminder)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "该锻炼了！"
        content.body = "今天还没有完成训练，现在开始一个快速训练吧！"
        content.sound = .default
        content.categoryIdentifier = NotificationType.workoutReminder.rawValue

        let components = Calendar.current.dateComponents([.hour, .minute], from: settings.workoutReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: NotificationType.workoutReminder.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("调度训练提醒失败: \(error)")
            }
        }
    }

    /// 调度冥想提醒
    func scheduleMeditationReminder() {
        guard settings.meditationRemindersEnabled else {
            cancelNotifications(ofType: .meditationReminder)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "放松一下"
        content.body = "睡前来一段冥想，帮助你更好地入睡。"
        content.sound = .default
        content.categoryIdentifier = NotificationType.meditationReminder.rawValue

        let components = Calendar.current.dateComponents([.hour, .minute], from: settings.meditationReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: NotificationType.meditationReminder.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("调度冥想提醒失败: \(error)")
            }
        }
    }

    /// 调度每日总结
    func scheduleDailySummary() {
        guard settings.dailySummaryEnabled else {
            cancelNotifications(ofType: .dailySummary)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "今日总结"
        content.body = "查看你今天的运动成果！"
        content.sound = .default
        content.categoryIdentifier = NotificationType.dailySummary.rawValue

        let components = Calendar.current.dateComponents([.hour, .minute], from: settings.dailySummaryTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: NotificationType.dailySummary.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("调度每日总结失败: \(error)")
            }
        }
    }

    /// 发送成就解锁通知
    func sendAchievementNotification(title: String, description: String) {
        guard settings.achievementAlertsEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "解锁新成就！"
        content.body = "\(title) - \(description)"
        content.sound = .default
        content.categoryIdentifier = NotificationType.achievement.rawValue

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(NotificationType.achievement.rawValue)_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request)
    }

    /// 发送步数目标达成通知
    func sendStepGoalNotification(steps: Int, goal: Int) {
        guard settings.stepGoalAlertsEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "目标达成！"
        content.body = "恭喜你！今日步数已达到 \(steps) 步，超越了 \(goal) 步的目标！"
        content.sound = .default
        content.categoryIdentifier = NotificationType.stepGoal.rawValue

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(NotificationType.stepGoal.rawValue)_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request)
    }

    /// 发送连续打卡通知
    func sendStreakNotification(days: Int) {
        let content = UNMutableNotificationContent()
        content.title = "坚持就是胜利！"
        content.body = "你已经连续打卡 \(days) 天了，继续保持！"
        content.sound = .default
        content.categoryIdentifier = NotificationType.streak.rawValue

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(NotificationType.streak.rawValue)_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request)
    }

    /// 取消指定类型的通知
    func cancelNotifications(ofType type: NotificationType) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [type.rawValue])
    }

    /// 取消所有待发送的通知
    func cancelAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - 通知响应处理

    /// 处理用户点击通知
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let categoryIdentifier = response.notification.request.content.categoryIdentifier

        switch categoryIdentifier {
        case NotificationType.workoutReminder.rawValue:
            // 导航到训练页面
            NotificationCenter.default.post(name: .navigateToWorkout, object: nil)

        case NotificationType.meditationReminder.rawValue:
            // 导航到冥想页面
            NotificationCenter.default.post(name: .navigateToMeditation, object: nil)

        case NotificationType.dailySummary.rawValue:
            // 导航到统计页面
            NotificationCenter.default.post(name: .navigateToStatistics, object: nil)

        case NotificationType.achievement.rawValue:
            // 导航到成就页面
            NotificationCenter.default.post(name: .navigateToAchievements, object: nil)

        default:
            break
        }
    }

    // MARK: - 设置持久化

    /// 保存设置
    func saveSettings() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }

        // 重新调度通知
        scheduleWorkoutReminder()
        scheduleMeditationReminder()
        scheduleDailySummary()
    }

    /// 加载设置
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey) {
            let decoder = JSONDecoder()
            if let savedSettings = try? decoder.decode(NotificationSettings.self, from: data) {
                settings = savedSettings
            }
        }
    }

    /// 重置所有通知调度
    func rescheduleAllNotifications() {
        cancelAllPendingNotifications()
        scheduleWorkoutReminder()
        scheduleMeditationReminder()
        scheduleDailySummary()
    }
}

// MARK: - NotificationSettings Codable

extension NotificationSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case workoutRemindersEnabled
        case workoutReminderTime
        case meditationRemindersEnabled
        case meditationReminderTime
        case dailySummaryEnabled
        case dailySummaryTime
        case achievementAlertsEnabled
        case stepGoalAlertsEnabled
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let navigateToWorkout = Notification.Name("navigateToWorkout")
    static let navigateToMeditation = Notification.Name("navigateToMeditation")
    static let navigateToStatistics = Notification.Name("navigateToStatistics")
    static let navigateToAchievements = Notification.Name("navigateToAchievements")
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    /// 前台收到通知时
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 前台也显示通知
        completionHandler([.banner, .sound, .badge])
    }

    /// 用户点击通知时
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        Task { @MainActor in
            handleNotificationResponse(response)
        }
        completionHandler()
    }
}
