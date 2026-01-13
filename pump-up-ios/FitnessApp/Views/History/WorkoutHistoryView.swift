//
//  WorkoutHistoryView.swift
//  FitnessApp
//
//  训练历史列表视图
//

import SwiftUI

@MainActor
class WorkoutHistoryViewModel: ObservableObject {
    @Published var sessions: [WorkoutSessionDTO] = []
    @Published var isLoading = false
    @Published var hasMore = true
    private var currentPage = 1
    private let pageSize = 20

    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        currentPage = 1

        do {
            let result = try await APIService.shared.getWorkoutHistory(page: 1, pageSize: pageSize)
            sessions = result.items
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载训练历史失败: \(error)")
        }

        isLoading = false
    }

    func loadMore() async {
        guard !isLoading && hasMore else { return }
        isLoading = true

        do {
            let result = try await APIService.shared.getWorkoutHistory(page: currentPage + 1, pageSize: pageSize)
            sessions.append(contentsOf: result.items)
            hasMore = result.hasNextPage
            currentPage = result.page
        } catch {
            print("加载更多训练失败: \(error)")
        }

        isLoading = false
    }
}

struct WorkoutHistoryView: View {
    @StateObject private var viewModel = WorkoutHistoryViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sessions, id: \.id) { session in
                    WorkoutSessionCard(session: session)
                }

                if viewModel.hasMore && !viewModel.sessions.isEmpty {
                    ProgressView()
                        .padding()
                        .onAppear {
                            Task { await viewModel.loadMore() }
                        }
                }

                if viewModel.sessions.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "暂无训练记录",
                        systemImage: "dumbbell",
                        description: Text("完成训练后，你的记录将显示在这里")
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

struct WorkoutSessionCard: View {
    let session: WorkoutSessionDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // 训练名称
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.workout?.name ?? "训练")
                        .font(.headline)

                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 完成状态
                if session.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            // 训练详情
            HStack(spacing: 20) {
                Label("\(session.workout?.duration ?? 0)分钟", systemImage: "clock")
                Label("\(session.caloriesBurned)卡", systemImage: "flame.fill")

                if let category = session.workout?.category {
                    Label(WorkoutCategory(apiValue: category).rawValue, systemImage: "tag")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)

            // 备注
            if let notes = session.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: session.startTime) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "zh_CN")
            displayFormatter.dateFormat = "M月d日 HH:mm"
            return displayFormatter.string(from: date)
        }
        return session.startTime
    }
}

#Preview {
    WorkoutHistoryView()
}
