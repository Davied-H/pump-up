//
//  NotificationSettingsView.swift
//  FitnessApp
//
//  通知设置页面
//

import SwiftUI

struct NotificationSettingsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showingPermissionAlert = false

    var body: some View {
        List {
            // 授权状态
            Section {
                HStack {
                    Image(systemName: notificationManager.isAuthorized ? "bell.badge.fill" : "bell.slash.fill")
                        .foregroundColor(notificationManager.isAuthorized ? .green : .red)
                    Text("通知权限")
                    Spacer()
                    Text(notificationManager.isAuthorized ? "已开启" : "已关闭")
                        .foregroundColor(.secondary)
                }

                if !notificationManager.isAuthorized {
                    Button("开启通知") {
                        Task {
                            let granted = await notificationManager.requestAuthorization()
                            if !granted {
                                showingPermissionAlert = true
                            }
                        }
                    }
                }
            } header: {
                Text("通知状态")
            }

            // 提醒设置
            Section {
                Toggle("训练提醒", isOn: $notificationManager.settings.workoutRemindersEnabled)
                    .onChange(of: notificationManager.settings.workoutRemindersEnabled) { _, _ in
                        notificationManager.saveSettings()
                    }

                if notificationManager.settings.workoutRemindersEnabled {
                    DatePicker(
                        "提醒时间",
                        selection: $notificationManager.settings.workoutReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: notificationManager.settings.workoutReminderTime) { _, _ in
                        notificationManager.saveSettings()
                    }
                }
            } header: {
                Text("训练提醒")
            } footer: {
                Text("每天在指定时间提醒你进行训练")
            }

            Section {
                Toggle("冥想提醒", isOn: $notificationManager.settings.meditationRemindersEnabled)
                    .onChange(of: notificationManager.settings.meditationRemindersEnabled) { _, _ in
                        notificationManager.saveSettings()
                    }

                if notificationManager.settings.meditationRemindersEnabled {
                    DatePicker(
                        "提醒时间",
                        selection: $notificationManager.settings.meditationReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: notificationManager.settings.meditationReminderTime) { _, _ in
                        notificationManager.saveSettings()
                    }
                }
            } header: {
                Text("冥想提醒")
            } footer: {
                Text("睡前提醒你进行放松冥想")
            }

            Section {
                Toggle("每日总结", isOn: $notificationManager.settings.dailySummaryEnabled)
                    .onChange(of: notificationManager.settings.dailySummaryEnabled) { _, _ in
                        notificationManager.saveSettings()
                    }

                if notificationManager.settings.dailySummaryEnabled {
                    DatePicker(
                        "总结时间",
                        selection: $notificationManager.settings.dailySummaryTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: notificationManager.settings.dailySummaryTime) { _, _ in
                        notificationManager.saveSettings()
                    }
                }
            } header: {
                Text("每日总结")
            } footer: {
                Text("每天推送你的运动数据总结")
            }

            // 其他通知
            Section {
                Toggle("成就提醒", isOn: $notificationManager.settings.achievementAlertsEnabled)
                    .onChange(of: notificationManager.settings.achievementAlertsEnabled) { _, _ in
                        notificationManager.saveSettings()
                    }

                Toggle("步数目标提醒", isOn: $notificationManager.settings.stepGoalAlertsEnabled)
                    .onChange(of: notificationManager.settings.stepGoalAlertsEnabled) { _, _ in
                        notificationManager.saveSettings()
                    }
            } header: {
                Text("其他通知")
            }

            // Device Token（调试用）
            #if DEBUG
            Section {
                if let token = notificationManager.deviceToken {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Device Token")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(token)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }

                    Button("复制Token") {
                        UIPasteboard.general.string = token
                    }
                } else {
                    Text("未获取到Device Token")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("调试信息")
            }
            #endif
        }
        .navigationTitle("通知设置")
        .alert("需要通知权限", isPresented: $showingPermissionAlert) {
            Button("取消", role: .cancel) { }
            Button("前往设置") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("请在系统设置中开启通知权限，以接收训练提醒和成就通知。")
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
