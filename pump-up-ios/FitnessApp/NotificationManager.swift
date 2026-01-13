//
//  NotificationManager.swift
//  FitnessApp
//
//  管理本地和远程推送通知
//

import Foundation
import UserNotifications
import UIKit

// MARK: - Notification Names
extension Notification.Name {
    static let navigateToWorkout = Notification.Name("navigateToWorkout")
    static let navigateToMeditation = Notification.Name("navigateToMeditation")
    static let navigateToStatistics = Notification.Name("navigateToStatistics")
    static let navigateToAchievements = Notification.Name("navigateToAchievements")
}

// MARK: - Notification Manager
@MainActor
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    @Published var isAuthorized: Bool = false
    @Published var deviceToken: String?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Authorization
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            isAuthorized = granted
            
            if granted {
                // 注册远程推送
                await UIApplication.shared.registerForRemoteNotifications()
            }
        } catch {
            print("通知授权失败: \(error)")
            isAuthorized = false
        }
    }
    
    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - Device Token
    nonisolated func handleDeviceToken(_ deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        Task { @MainActor in
            self.deviceToken = token
            print("设备推送令牌: \(token)")
            
            // 发送令牌到服务器
            await self.sendTokenToServer(token)
        }
    }
    
    nonisolated func handleDeviceTokenError(_ error: Error) {
        Task { @MainActor in
            print("获取设备令牌失败: \(error)")
        }
    }
    
    private func sendTokenToServer(_ token: String) async {
        // 实现发送令牌到服务器的逻辑
        // 例如: try await APIService.shared.registerDeviceToken(token)
        print("发送设备令牌到服务器: \(token)")
    }
    
    // MARK: - Local Notifications
    func scheduleWorkoutReminder(at date: Date, workoutName: String) async {
        let content = UNMutableNotificationContent()
        content.title = "训练提醒"
        content.body = "该开始\(workoutName)了！"
        content.sound = .default
        content.categoryIdentifier = "WORKOUT_REMINDER"
        content.userInfo = ["type": "workout", "name": workoutName]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "workout_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("训练提醒已设置: \(workoutName)")
        } catch {
            print("设置训练提醒失败: \(error)")
        }
    }
    
    func scheduleDailyStepReminder() async {
        let content = UNMutableNotificationContent()
        content.title = "步数提醒"
        content.body = "今天还没达到步数目标，出去走走吧！"
        content.sound = .default
        content.categoryIdentifier = "STEP_REMINDER"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18 // 下午6点提醒
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily_step_reminder",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("每日步数提醒已设置")
        } catch {
            print("设置步数提醒失败: \(error)")
        }
    }
    
    func scheduleMeditationReminder() async {
        let content = UNMutableNotificationContent()
        content.title = "冥想时间"
        content.body = "休息一下，做个冥想吧"
        content.sound = .default
        content.categoryIdentifier = "MEDITATION_REMINDER"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 晚上8点提醒
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "meditation_reminder",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("冥想提醒已设置")
        } catch {
            print("设置冥想提醒失败: \(error)")
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("已取消所有通知")
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("已取消通知: \(identifier)")
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 应用在前台时如何显示通知
        completionHandler([.banner, .sound, .badge])
    }
    
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // 处理通知点击
        Task { @MainActor in
            await self.handleNotificationTap(userInfo: userInfo)
        }
        
        completionHandler()
    }
    
    private func handleNotificationTap(userInfo: [AnyHashable: Any]) async {
        guard let type = userInfo["type"] as? String else { return }
        
        // 根据通知类型发送导航通知
        switch type {
        case "workout":
            NotificationCenter.default.post(name: .navigateToWorkout, object: nil)
        case "meditation":
            NotificationCenter.default.post(name: .navigateToMeditation, object: nil)
        case "statistics":
            NotificationCenter.default.post(name: .navigateToStatistics, object: nil)
        case "achievement":
            NotificationCenter.default.post(name: .navigateToAchievements, object: nil)
        default:
            break
        }
    }
}
