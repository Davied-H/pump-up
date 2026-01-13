//
//  HealthKitSettingsView.swift
//  FitnessApp
//
//  HealthKit权限设置页面
//

import SwiftUI

struct HealthKitSettingsView: View {
    @StateObject private var healthKitManager = HealthKitManager.shared
    @State private var autoSyncEnabled = true
    @State private var syncFrequency = 1 // 0: 手动, 1: 每小时, 2: 每天
    @State private var isSyncing = false
    @State private var lastSyncTime: Date?
    @State private var showingSyncAlert = false

    var body: some View {
        List {
            // 授权状态
            Section {
                HStack {
                    Image(systemName: healthKitManager.isAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(healthKitManager.isAuthorized ? .green : .red)
                    Text("HealthKit 授权")
                    Spacer()
                    Text(healthKitManager.isAuthorized ? "已授权" : "未授权")
                        .foregroundColor(.secondary)
                }

                if !healthKitManager.isAuthorized {
                    Button("请求授权") {
                        Task {
                            _ = await healthKitManager.requestAuthorization()
                        }
                    }
                } else {
                    Button("在设置中管理权限") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            } header: {
                Text("授权状态")
            } footer: {
                Text("授权后可读取Apple健康中的步数、心率、睡眠等数据")
            }

            // 数据类型
            Section {
                DataTypeRow(icon: "figure.walk", title: "步数", isEnabled: true)
                DataTypeRow(icon: "flame.fill", title: "活动能量", isEnabled: true)
                DataTypeRow(icon: "heart.fill", title: "心率", isEnabled: true)
                DataTypeRow(icon: "bed.double.fill", title: "睡眠", isEnabled: true)
                DataTypeRow(icon: "scalemass", title: "体重", isEnabled: true)
                DataTypeRow(icon: "ruler", title: "身高", isEnabled: true)
            } header: {
                Text("同步的数据类型")
            }

            // 同步设置
            Section {
                Toggle("自动同步", isOn: $autoSyncEnabled)

                if autoSyncEnabled {
                    Picker("同步频率", selection: $syncFrequency) {
                        Text("每小时").tag(1)
                        Text("每天").tag(2)
                    }
                }
            } header: {
                Text("同步设置")
            }

            // 手动同步
            Section {
                Button(action: {
                    Task {
                        await syncNow()
                    }
                }) {
                    HStack {
                        if isSyncing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        Text(isSyncing ? "同步中..." : "立即同步")
                    }
                }
                .disabled(isSyncing || !healthKitManager.isAuthorized)

                if let lastSync = lastSyncTime {
                    HStack {
                        Text("上次同步")
                        Spacer()
                        Text(lastSync, style: .relative)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("数据同步")
            }

            // 隐私说明
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("数据安全", systemImage: "lock.shield")
                        .font(.headline)

                    Text("您的健康数据通过加密传输到服务器，仅用于分析您的健身进度。我们不会与第三方共享您的个人健康信息。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)

                Link(destination: URL(string: "https://example.com/privacy")!) {
                    HStack {
                        Text("隐私政策")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                    }
                }
            } header: {
                Text("隐私")
            }

            // 断开连接
            if healthKitManager.isAuthorized {
                Section {
                    Button(role: .destructive) {
                        // 这里只是UI提示，实际断开需要用户去系统设置
                        showingSyncAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "link.badge.plus")
                            Text("断开HealthKit连接")
                        }
                    }
                } footer: {
                    Text("断开后将停止同步健康数据")
                }
            }
        }
        .navigationTitle("健康数据设置")
        .alert("断开连接", isPresented: $showingSyncAlert) {
            Button("取消", role: .cancel) { }
            Button("前往设置", role: .destructive) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("要断开HealthKit连接，请前往系统设置 > 隐私与安全性 > 健康 > FitnessApp，关闭数据访问权限。")
        }
    }

    private func syncNow() async {
        isSyncing = true
        await healthKitManager.syncActivityToServer()
        lastSyncTime = Date()
        isSyncing = false
    }
}

// MARK: - 数据类型行

struct DataTypeRow: View {
    let icon: String
    let title: String
    let isEnabled: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled ? .red : .gray)
                .frame(width: 24)

            Text(title)

            Spacer()

            Image(systemName: isEnabled ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isEnabled ? .green : .gray)
        }
    }
}

#Preview {
    NavigationStack {
        HealthKitSettingsView()
    }
}
