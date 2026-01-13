//
//  ActivityHistoryView.swift
//  FitnessApp
//
//  活动历史列表视图
//

import SwiftUI

@MainActor
class ActivityHistoryViewModel: ObservableObject {
    @Published var activities: [DailyActivityDTO] = []
    @Published var isLoading = false
    @Published var hasMore = true
    private var currentPage = 1
    private let pageSize = 30

    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        currentPage = 1

        do {
            let result = try await APIService.shared.getActivityHistory(page: 1, pageSize: pageSize)
            activities = result.items
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载活动历史失败: \(error)")
        }

        isLoading = false
    }

    func loadMore() async {
        guard !isLoading && hasMore else { return }
        isLoading = true

        do {
            let result = try await APIService.shared.getActivityHistory(page: currentPage + 1, pageSize: pageSize)
            activities.append(contentsOf: result.items)
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载更多活动失败: \(error)")
        }

        isLoading = false
    }
}

struct ActivityHistoryView: View {
    @StateObject private var viewModel = ActivityHistoryViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.activities, id: \.id) { activity in
                    ActivityHistoryCard(activity: activity)
                }

                if viewModel.hasMore && !viewModel.activities.isEmpty {
                    ProgressView()
                        .padding()
                        .onAppear {
                            Task { await viewModel.loadMore() }
                        }
                }

                if viewModel.activities.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "暂无活动记录",
                        systemImage: "figure.walk",
                        description: Text("开始运动后，你的活动数据将显示在这里")
                    )
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

struct ActivityHistoryCard: View {
    let activity: DailyActivityDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 日期
            Text(formattedDate)
                .font(.headline)
                .foregroundColor(.primary)

            // 数据网格
            HStack(spacing: 20) {
                StatItem(icon: "figure.walk", value: "\(activity.steps)", label: "步数")
                StatItem(icon: "map", value: String(format: "%.1f", activity.distance), label: "公里")
                StatItem(icon: "flame.fill", value: String(format: "%.0f", activity.caloriesBurned), label: "卡路里")
                StatItem(icon: "clock", value: "\(activity.activeMinutes)", label: "分钟")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: activity.date) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "zh_CN")
            displayFormatter.dateFormat = "M月d日 EEEE"
            return displayFormatter.string(from: date)
        }
        return activity.date
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ActivityHistoryView()
}
