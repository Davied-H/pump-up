//
//  HistoryView.swift
//  FitnessApp
//
//  历史记录主页面 - Tab切换
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab选择器
                Picker(L10n.History.title, selection: $selectedTab) {
                    Text(L10n.History.activityHistory).tag(0)
                    Text(L10n.History.workoutHistory).tag(1)
                    Text(L10n.History.meditationHistory).tag(2)
                }
                .pickerStyle(.segmented)
                .padding()

                // 内容区域
                TabView(selection: $selectedTab) {
                    ActivityHistoryView().tag(0)
                    WorkoutHistoryView().tag(1)
                    MeditationHistoryView().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle(L10n.History.title)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    HistoryView()
}
