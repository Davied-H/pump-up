//
//  MeditationHistoryView.swift
//  FitnessApp
//
//  冥想历史列表视图 + 统计
//

import SwiftUI

@MainActor
class MeditationHistoryViewModel: ObservableObject {
    @Published var logs: [MeditationLogDTO] = []
    @Published var stats: MeditationStatsDTO?
    @Published var isLoading = false
    @Published var hasMore = true
    private var currentPage = 1
    private let pageSize = 20

    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        currentPage = 1

        async let logsTask = loadLogs()
        async let statsTask = loadStats()
        _ = await (logsTask, statsTask)

        isLoading = false
    }

    private func loadLogs() async {
        do {
            let result = try await APIService.shared.getMeditationHistory(page: 1, pageSize: pageSize)
            logs = result.items
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载冥想历史失败: \(error)")
        }
    }

    private func loadStats() async {
        do {
            stats = try await APIService.shared.getMeditationStats()
        } catch {
            print("加载冥想统计失败: \(error)")
        }
    }

    func loadMore() async {
        guard !isLoading && hasMore else { return }
        isLoading = true

        do {
            let result = try await APIService.shared.getMeditationHistory(page: currentPage + 1, pageSize: pageSize)
            logs.append(contentsOf: result.items)
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载更多冥想失败: \(error)")
        }

        isLoading = false
    }
}

struct MeditationHistoryView: View {
    @StateObject private var viewModel = MeditationHistoryViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 统计卡片
                if let stats = viewModel.stats {
                    MeditationStatsCard(stats: stats)
                }

                // 历史列表
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.logs, id: \.id) { log in
                        MeditationLogCard(log: log)
                    }

                    if viewModel.hasMore && !viewModel.logs.isEmpty {
                        ProgressView()
                            .padding()
                            .onAppear {
                                Task { await viewModel.loadMore() }
                            }
                    }

                    if viewModel.logs.isEmpty && !viewModel.isLoading {
                        ContentUnavailableView(
                            "暂无冥想记录",
                            systemImage: "brain.head.profile",
                            description: Text("完成冥想后，你的记录将显示在这里")
                        )
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.loadInitial()
        }
        .task {
            await viewModel.loadInitial()
        }
    }
}

struct MeditationStatsCard: View {
    let stats: MeditationStatsDTO

    var body: some View {
        VStack(spacing: 16) {
            Text("冥想统计")
                .font(.headline)

            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("\(stats.totalMinutes)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.purple)
                    Text("总时长(分钟)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 8) {
                    Text("\(stats.totalSessions)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.purple)
                    Text("总次数")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

struct MeditationLogCard: View {
    let log: MeditationLogDTO

    var body: some View {
        HStack(spacing: 12) {
            // 图标
            Image(systemName: "brain.head.profile")
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 44, height: 44)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)

            // 内容
            VStack(alignment: .leading, spacing: 4) {
                Text(log.meditationSession?.name ?? "冥想")
                    .font(.headline)

                HStack(spacing: 12) {
                    Label("\(log.durationCompleted)分钟", systemImage: "clock")

                    if let category = log.meditationSession?.category {
                        Label(MeditationCategory(apiValue: category).rawValue, systemImage: "tag")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            // 日期
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: log.completedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "zh_CN")
            displayFormatter.dateFormat = "M/d"
            return displayFormatter.string(from: date)
        }
        return ""
    }
}

#Preview {
    MeditationHistoryView()
}
