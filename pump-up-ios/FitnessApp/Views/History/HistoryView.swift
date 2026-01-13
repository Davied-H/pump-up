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
                Picker("历史类型", selection: $selectedTab) {
                    Text("活动").tag(0)
                    Text("训练").tag(1)
                    Text("冥想").tag(2)
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
            .navigationTitle("历史记录")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    HistoryView()
}
