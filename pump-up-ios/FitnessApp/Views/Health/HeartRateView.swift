//
//  HeartRateView.swift
//  FitnessApp
//
//  心率详情页面 - 显示心率历史和趋势
//

import SwiftUI
import Charts

@MainActor
class HeartRateViewModel: ObservableObject {
    @Published var samples: [HeartRateSample] = []
    @Published var latestRate: Double?
    @Published var averageRate: Double?
    @Published var minRate: Double?
    @Published var maxRate: Double?
    @Published var isLoading = false

    func loadData() async {
        isLoading = true

        let now = Date()
        let dayAgo = Calendar.current.date(byAdding: .hour, value: -24, to: now)!

        // 从HealthKit获取心率数据
        samples = await HealthKitManager.shared.fetchHeartRateHistory(from: dayAgo, to: now)

        // 计算统计
        if !samples.isEmpty {
            let values = samples.map { $0.value }
            latestRate = samples.last?.value
            averageRate = values.reduce(0, +) / Double(values.count)
            minRate = values.min()
            maxRate = values.max()
        }

        // 获取最新心率
        latestRate = await HealthKitManager.shared.fetchLatestHeartRate()

        isLoading = false
    }
}

struct HeartRateView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @State private var selectedTimeRange = 0 // 0: 24小时, 1: 7天

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 当前心率大卡片
                CurrentHeartRateCard(rate: viewModel.latestRate)

                // 时间范围选择
                Picker("时间范围", selection: $selectedTimeRange) {
                    Text("24小时").tag(0)
                    Text("7天").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // 心率图表
                HeartRateChartCard(samples: viewModel.samples)

                // 统计卡片
                HeartRateStatsCard(
                    average: viewModel.averageRate,
                    min: viewModel.minRate,
                    max: viewModel.maxRate
                )

                // 心率区间说明
                HeartRateZonesCard()
            }
            .padding()
        }
        .navigationTitle("心率")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.loadData()
        }
        .task {
            await viewModel.loadData()
        }
    }
}

// MARK: - 当前心率卡片

struct CurrentHeartRateCard: View {
    let rate: Double?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
                .symbolEffect(.pulse)

            if let rate = rate {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(Int(rate))")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.red)
                    Text("BPM")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("--")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.secondary)
            }

            Text("当前心率")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            LinearGradient(
                colors: [.red.opacity(0.1), .pink.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

// MARK: - 心率图表卡片

struct HeartRateChartCard: View {
    let samples: [HeartRateSample]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("心率趋势")
                .font(.headline)

            if samples.isEmpty {
                ContentUnavailableView(
                    "暂无数据",
                    systemImage: "heart.slash",
                    description: Text("开始运动后将显示心率数据")
                )
                .frame(height: 200)
            } else {
                Chart {
                    ForEach(samples) { sample in
                        LineMark(
                            x: .value("时间", sample.timestamp),
                            y: .value("心率", sample.value)
                        )
                        .foregroundStyle(.red.gradient)

                        AreaMark(
                            x: .value("时间", sample.timestamp),
                            y: .value("心率", sample.value)
                        )
                        .foregroundStyle(.red.opacity(0.1).gradient)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisValueLabel(format: .dateTime.hour())
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - 心率统计卡片

struct HeartRateStatsCard: View {
    let average: Double?
    let min: Double?
    let max: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("统计数据")
                .font(.headline)

            HStack(spacing: 20) {
                StatBox(
                    title: "平均",
                    value: average.map { "\(Int($0))" } ?? "--",
                    unit: "BPM",
                    color: .orange
                )

                StatBox(
                    title: "最低",
                    value: min.map { "\(Int($0))" } ?? "--",
                    unit: "BPM",
                    color: .green
                )

                StatBox(
                    title: "最高",
                    value: max.map { "\(Int($0))" } ?? "--",
                    unit: "BPM",
                    color: .red
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - 心率区间说明

struct HeartRateZonesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("心率区间")
                .font(.headline)

            VStack(spacing: 12) {
                HeartRateZoneRow(zone: "静息", range: "60-80", color: .blue, description: "休息或睡眠时")
                HeartRateZoneRow(zone: "燃脂", range: "100-130", color: .green, description: "轻度有氧运动")
                HeartRateZoneRow(zone: "有氧", range: "130-160", color: .orange, description: "中等强度运动")
                HeartRateZoneRow(zone: "无氧", range: "160-180", color: .red, description: "高强度运动")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct HeartRateZoneRow: View {
    let zone: String
    let range: String
    let color: Color
    let description: String

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            Text(zone)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 40, alignment: .leading)

            Text(range)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 70, alignment: .leading)

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        HeartRateView()
    }
}
