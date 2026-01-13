//
//  HealthDashboardView.swift
//  FitnessApp
//
//  健康数据仪表盘 - 显示HealthKit综合数据
//

import SwiftUI

@MainActor
class HealthDashboardViewModel: ObservableObject {
    @Published var summary: HealthSummaryDTO?
    @Published var todayActivity: HealthKitActivityData?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadData() async {
        isLoading = true
        errorMessage = nil

        // 并行获取本地HealthKit数据和服务器摘要
        async let localActivity = HealthKitManager.shared.fetchTodayActivity()
        async let serverSummary = fetchServerSummary()

        todayActivity = await localActivity
        summary = await serverSummary

        isLoading = false
    }

    private func fetchServerSummary() async -> HealthSummaryDTO? {
        do {
            return try await APIService.shared.getHealthSummary()
        } catch {
            print("获取健康摘要失败: \(error)")
            return nil
        }
    }

    func syncToServer() async {
        await HealthKitManager.shared.syncActivityToServer()
    }
}

struct HealthDashboardView: View {
    @StateObject private var viewModel = HealthDashboardViewModel()
    @StateObject private var healthKitManager = HealthKitManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // HealthKit授权状态
                    if !healthKitManager.isAuthorized {
                        HealthKitAuthCard {
                            Task {
                                _ = await healthKitManager.requestAuthorization()
                            }
                        }
                    }

                    // 今日活动卡片
                    if let activity = viewModel.todayActivity {
                        TodayActivityCard(activity: activity)
                    }

                    // 心率卡片
                    NavigationLink(destination: HeartRateView()) {
                        HeartRateCard(
                            latestRate: viewModel.summary?.latestHeartRate,
                            averageRate: viewModel.summary?.averageHeartRate,
                            restingRate: viewModel.summary?.restingHeartRate
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    // 睡眠卡片
                    NavigationLink(destination: SleepView()) {
                        SleepCard(
                            lastNightSleep: viewModel.summary?.lastNightSleepHours,
                            qualityScore: viewModel.summary?.averageSleepQuality
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    // 体重趋势卡片
                    BodyMetricsCard(
                        weight: viewModel.summary?.currentWeight,
                        height: viewModel.summary?.currentHeight,
                        bmi: viewModel.summary?.currentBMI,
                        trend: viewModel.summary?.weightTrend
                    )
                }
                .padding()
            }
            .navigationTitle("健康数据")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HealthKitSettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

// MARK: - HealthKit授权卡片

struct HealthKitAuthCard: View {
    let onAuthorize: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text("连接健康数据")
                .font(.headline)

            Text("授权后可同步Apple健康中的步数、心率、睡眠等数据")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("授权访问") {
                onAuthorize()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - 今日活动卡片

struct TodayActivityCard: View {
    let activity: HealthKitActivityData

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今日活动")
                    .font(.headline)
                Spacer()
                Text("来自Apple健康")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 20) {
                ActivityStatView(
                    icon: "figure.walk",
                    value: "\(activity.steps)",
                    label: "步数",
                    color: .orange
                )

                ActivityStatView(
                    icon: "map",
                    value: String(format: "%.1f", activity.distance / 1000),
                    label: "公里",
                    color: .green
                )

                ActivityStatView(
                    icon: "flame.fill",
                    value: String(format: "%.0f", activity.activeEnergyBurned),
                    label: "卡路里",
                    color: .red
                )

                ActivityStatView(
                    icon: "clock",
                    value: "\(activity.exerciseMinutes)",
                    label: "分钟",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct ActivityStatView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 心率卡片

struct HeartRateCard: View {
    let latestRate: Double?
    let averageRate: Double?
    let restingRate: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("心率")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 30) {
                HeartRateItem(
                    value: latestRate.map { "\(Int($0))" } ?? "--",
                    label: "当前",
                    color: .red
                )

                HeartRateItem(
                    value: averageRate.map { "\(Int($0))" } ?? "--",
                    label: "平均",
                    color: .orange
                )

                HeartRateItem(
                    value: restingRate.map { "\(Int($0))" } ?? "--",
                    label: "静息",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct HeartRateItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
                Text("BPM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 睡眠卡片

struct SleepCard: View {
    let lastNightSleep: Double?
    let qualityScore: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bed.double.fill")
                    .foregroundColor(.indigo)
                Text("睡眠")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    if let hours = lastNightSleep {
                        let h = Int(hours)
                        let m = Int((hours - Double(h)) * 60)
                        Text("\(h)h \(m)m")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.indigo)
                    } else {
                        Text("--")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    Text("昨晚睡眠")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 4) {
                    if let score = qualityScore {
                        Text("\(score)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(qualityColor(score))
                    } else {
                        Text("--")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    Text("睡眠质量")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    private func qualityColor(_ score: Int) -> Color {
        if score >= 80 { return .green }
        if score >= 60 { return .orange }
        return .red
    }
}

// MARK: - 体重趋势卡片

struct BodyMetricsCard: View {
    let weight: Double?
    let height: Double?
    let bmi: Double?
    let trend: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "scalemass")
                    .foregroundColor(.cyan)
                Text("体重")
                    .font(.headline)
                Spacer()

                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trendIcon(trend))
                        Text(trendText(trend))
                    }
                    .font(.caption)
                    .foregroundColor(trendColor(trend))
                }
            }

            HStack(spacing: 30) {
                VStack(spacing: 4) {
                    if let weight = weight {
                        Text(String(format: "%.1f", weight))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.cyan)
                        + Text(" kg")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("--")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    Text("体重")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 4) {
                    if let bmi = bmi {
                        Text(String(format: "%.1f", bmi))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(bmiColor(bmi))
                    } else {
                        Text("--")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    Text("BMI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 4) {
                    if let height = height {
                        Text(String(format: "%.0f", height))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.gray)
                        + Text(" cm")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("--")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    Text("身高")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    private func trendIcon(_ trend: String) -> String {
        switch trend {
        case "up": return "arrow.up.right"
        case "down": return "arrow.down.right"
        default: return "arrow.right"
        }
    }

    private func trendText(_ trend: String) -> String {
        switch trend {
        case "up": return "上升"
        case "down": return "下降"
        default: return "稳定"
        }
    }

    private func trendColor(_ trend: String) -> Color {
        switch trend {
        case "up": return .red
        case "down": return .green
        default: return .gray
        }
    }

    private func bmiColor(_ bmi: Double) -> Color {
        if bmi < 18.5 { return .blue }
        if bmi < 24 { return .green }
        if bmi < 28 { return .orange }
        return .red
    }
}

#Preview {
    HealthDashboardView()
}
