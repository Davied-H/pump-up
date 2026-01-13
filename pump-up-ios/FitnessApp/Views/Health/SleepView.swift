//
//  SleepView.swift
//  FitnessApp
//
//  睡眠分析页面 - 显示睡眠数据和趋势
//

import SwiftUI
import Charts

@MainActor
class SleepViewModel: ObservableObject {
    @Published var sleepHistory: [SleepAnalysisDTO] = []
    @Published var lastNightSleep: SleepAnalysis?
    @Published var averageSleep: Double?
    @Published var isLoading = false

    func loadData() async {
        isLoading = true

        // 获取昨晚睡眠（从HealthKit）
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        lastNightSleep = await HealthKitManager.shared.fetchSleepAnalysis(for: yesterday)

        // 从服务器获取睡眠历史
        do {
            sleepHistory = try await APIService.shared.getSleepHistory(days: 7)

            // 计算平均睡眠
            if !sleepHistory.isEmpty {
                let totalHours = sleepHistory.reduce(0.0) { $0 + $1.totalSleepHours }
                averageSleep = totalHours / Double(sleepHistory.count)
            }
        } catch {
            print("获取睡眠历史失败: \(error)")
        }

        isLoading = false
    }
}

struct SleepView: View {
    @StateObject private var viewModel = SleepViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 昨晚睡眠大卡片
                LastNightSleepCard(sleep: viewModel.lastNightSleep)

                // 睡眠阶段分布
                if let sleep = viewModel.lastNightSleep {
                    SleepStagesCard(sleep: sleep)
                }

                // 睡眠趋势图
                SleepTrendChart(history: viewModel.sleepHistory)

                // 睡眠统计
                SleepStatsCard(
                    averageHours: viewModel.averageSleep,
                    totalNights: viewModel.sleepHistory.count
                )

                // 睡眠建议
                SleepTipsCard()
            }
            .padding()
        }
        .navigationTitle("睡眠")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadData()
        }
        .task {
            await viewModel.loadData()
        }
    }
}

// MARK: - 昨晚睡眠卡片

struct LastNightSleepCard: View {
    let sleep: SleepAnalysis?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bed.double.fill")
                .font(.system(size: 50))
                .foregroundColor(.indigo)

            if let sleep = sleep {
                let hours = Int(sleep.totalSleepDuration / 3600)
                let minutes = Int((sleep.totalSleepDuration % 3600) / 60)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(hours)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.indigo)
                    Text("小时")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("\(minutes)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.indigo)
                    Text("分钟")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                // 睡眠时间范围
                if let start = sleep.sleepStart, let end = sleep.sleepEnd {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    Text("\(formatter.string(from: start)) - \(formatter.string(from: end))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("--")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.secondary)
            }

            Text("昨晚睡眠")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            LinearGradient(
                colors: [.indigo.opacity(0.1), .purple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

// MARK: - 睡眠阶段卡片

struct SleepStagesCard: View {
    let sleep: SleepAnalysis

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("睡眠阶段")
                .font(.headline)

            // 这里简化显示，因为HealthKit在iOS端的睡眠数据可能没有详细阶段
            VStack(spacing: 12) {
                SleepStageRow(
                    stage: "深度睡眠",
                    icon: "moon.zzz.fill",
                    color: .indigo,
                    percentage: 20,
                    description: "身体修复"
                )

                SleepStageRow(
                    stage: "浅度睡眠",
                    icon: "moon.fill",
                    color: .blue,
                    percentage: 50,
                    description: "大部分睡眠"
                )

                SleepStageRow(
                    stage: "REM睡眠",
                    icon: "brain.head.profile",
                    color: .purple,
                    percentage: 20,
                    description: "做梦阶段"
                )

                SleepStageRow(
                    stage: "清醒",
                    icon: "sun.max.fill",
                    color: .orange,
                    percentage: 10,
                    description: "短暂醒来"
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct SleepStageRow: View {
    let stage: String
    let icon: String
    let color: Color
    let percentage: Int
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(stage)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(percentage)%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 8)
                    }
                }
                .frame(height: 8)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - 睡眠趋势图

struct SleepTrendChart: View {
    let history: [SleepAnalysisDTO]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近7天")
                .font(.headline)

            if history.isEmpty {
                ContentUnavailableView(
                    "暂无数据",
                    systemImage: "moon.zzz",
                    description: Text("睡眠数据将在这里显示")
                )
                .frame(height: 200)
            } else {
                Chart {
                    ForEach(history, id: \.id) { sleep in
                        BarMark(
                            x: .value("日期", formatDate(sleep.date)),
                            y: .value("睡眠时长", sleep.totalSleepHours)
                        )
                        .foregroundStyle(.indigo.gradient)
                        .cornerRadius(6)
                    }

                    // 推荐睡眠时长参考线
                    RuleMark(y: .value("推荐", 8))
                        .foregroundStyle(.green.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let hours = value.as(Double.self) {
                                Text("\(Int(hours))h")
                            }
                        }
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    private func formatDate(_ dateStr: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateStr) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "E"
            displayFormatter.locale = Locale(identifier: "zh_CN")
            return displayFormatter.string(from: date)
        }
        return dateStr
    }
}

// MARK: - 睡眠统计卡片

struct SleepStatsCard: View {
    let averageHours: Double?
    let totalNights: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("统计")
                .font(.headline)

            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    if let avg = averageHours {
                        let h = Int(avg)
                        let m = Int((avg - Double(h)) * 60)
                        Text("\(h)h \(m)m")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    } else {
                        Text("--")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    Text("平均睡眠")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo.opacity(0.1))
                .cornerRadius(12)

                VStack(spacing: 8) {
                    Text("8h 0m")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("推荐睡眠")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - 睡眠建议

struct SleepTipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("睡眠建议")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                SleepTipRow(icon: "clock", tip: "保持规律的睡眠时间")
                SleepTipRow(icon: "moon", tip: "睡前1小时避免使用电子设备")
                SleepTipRow(icon: "cup.and.saucer", tip: "下午避免摄入咖啡因")
                SleepTipRow(icon: "thermometer", tip: "保持卧室温度在18-22°C")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct SleepTipRow: View {
    let icon: String
    let tip: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.indigo)
                .frame(width: 24)

            Text(tip)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SleepView()
    }
}
