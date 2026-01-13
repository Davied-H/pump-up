//
//  WorkoutView.swift
//  FitnessApp
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var selectedCategory: Workout.WorkoutCategory?
    @State private var selectedWorkout: Workout?
    @State private var showWorkoutDetail = false
    @State private var showSearch = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    // Header with Search Button
                    WorkoutHeaderView(showSearch: $showSearch)

                    // Category Filter
                    CategoryFilterView(selectedCategory: $selectedCategory)

                    // Quick Start Section
                    QuickStartSection()

                    // Workouts List
                    WorkoutListSection(
                        workouts: filteredWorkouts,
                        selectedWorkout: $selectedWorkout,
                        showDetail: $showWorkoutDetail
                    )

                    // My Plans Section
                    MyPlansSection()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .sheet(isPresented: $showWorkoutDetail) {
                if let workout = selectedWorkout {
                    WorkoutDetailView(workout: workout)
                }
            }
            .overlay {
                // 搜索界面覆盖
                if showSearch {
                    WorkoutSearchOverlay(isPresented: $showSearch)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .zIndex(999)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showSearch)
        }
    }

    private var filteredWorkouts: [Workout] {
        if let category = selectedCategory {
            return fitnessManager.workouts.filter { $0.category == category }
        }
        return fitnessManager.workouts
    }
}

// MARK: - Workout Header
struct WorkoutHeaderView: View {
    @Binding var showSearch: Bool
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Workout")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("Choose your training plan")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()
            
            // 搜索按钮
            Button {
                // 触感反馈
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showSearch = true
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(neonYellow)
                            .shadow(color: neonYellow.opacity(0.4), radius: 8, x: 0, y: 2)
                    )
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Category Filter
struct CategoryFilterView: View {
    @Binding var selectedCategory: Workout.WorkoutCategory?

    let categories: [(Workout.WorkoutCategory?, String, String)] = [
        (nil, "All", "square.grid.2x2.fill"),
        (.strength, "Strength", "dumbbell.fill"),
        (.cardio, "Cardio", "figure.run"),
        (.hiit, "HIIT", "bolt.fill"),
        (.yoga, "Yoga", "figure.yoga"),
        (.flexibility, "Stretch", "figure.flexibility")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.1) { category, name, icon in
                    CategoryChip(
                        name: name,
                        icon: icon,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
}

struct CategoryChip: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(name)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "D4FF00") : Color(hex: "1C1C1E"))
            )
        }
    }
}

// MARK: - Quick Start Section
struct QuickStartSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Start")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 15) {
                QuickStartCard(
                    title: "Free Run",
                    subtitle: "Start running now",
                    icon: "figure.run",
                    color: Color.green
                )

                QuickStartCard(
                    title: "Timer",
                    subtitle: "Custom workout",
                    icon: "timer",
                    color: Color.orange
                )
            }
        }
    }
}

struct QuickStartCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 10) {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 45, height: 45)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(color)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }
}

// MARK: - Workout List Section
struct WorkoutListSection: View {
    let workouts: [Workout]
    @Binding var selectedWorkout: Workout?
    @Binding var showDetail: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recommended")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {}) {
                    Text("See All")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "D4FF00"))
                }
            }

            VStack(spacing: 12) {
                ForEach(workouts) { workout in
                    WorkoutCard(workout: workout) {
                        selectedWorkout = workout
                        showDetail = true
                    }
                }
            }
        }
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Workout Icon
                RoundedRectangle(cornerRadius: 12)
                    .fill(categoryGradient(for: workout.category))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: workoutIcon(for: workout.category))
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    )

                // Workout Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(workout.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    HStack(spacing: 12) {
                        Label("\(workout.duration)min", systemImage: "clock")
                        Label("\(workout.caloriesBurned)kcal", systemImage: "flame")
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                }

                Spacer()

                // Difficulty Badge
                Text(workout.difficulty.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(difficultyColor(workout.difficulty))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(difficultyColor(workout.difficulty).opacity(0.2))
                    )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }

    private func workoutIcon(for category: Workout.WorkoutCategory) -> String {
        switch category {
        case .strength: return "dumbbell.fill"
        case .cardio: return "figure.run"
        case .flexibility: return "figure.flexibility"
        case .hiit: return "bolt.fill"
        case .yoga: return "figure.yoga"
        case .outdoor: return "sun.max.fill"
        }
    }

    private func categoryGradient(for category: Workout.WorkoutCategory) -> LinearGradient {
        let colors: [Color]
        switch category {
        case .strength: colors = [Color.purple, Color.purple.opacity(0.6)]
        case .cardio: colors = [Color.green, Color.green.opacity(0.6)]
        case .flexibility: colors = [Color.pink, Color.pink.opacity(0.6)]
        case .hiit: colors = [Color.orange, Color.orange.opacity(0.6)]
        case .yoga: colors = [Color.cyan, Color.cyan.opacity(0.6)]
        case .outdoor: colors = [Color.yellow, Color.yellow.opacity(0.6)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func difficultyColor(_ difficulty: Workout.Difficulty) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// MARK: - My Plans Section
struct MyPlansSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("My Plans")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Circle().fill(Color(hex: "D4FF00")))
                }
            }

            // Empty State or Plans List
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)

                Text("No custom plans yet")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Button(action: {}) {
                    Text("Create Plan")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color(hex: "D4FF00"))
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }
}

// MARK: - Workout UI Helper
struct WorkoutUIHelper {
    static func workoutIcon(for category: Workout.WorkoutCategory) -> String {
        switch category {
        case .strength: return "dumbbell.fill"
        case .cardio: return "figure.run"
        case .flexibility: return "figure.flexibility"
        case .hiit: return "bolt.fill"
        case .yoga: return "figure.yoga"
        case .outdoor: return "sun.max.fill"
        }
    }
    
    static func categoryGradient(for category: Workout.WorkoutCategory) -> LinearGradient {
        let colors: [Color]
        switch category {
        case .strength: colors = [Color.purple, Color.purple.opacity(0.6)]
        case .cardio: colors = [Color.green, Color.green.opacity(0.6)]
        case .flexibility: colors = [Color.pink, Color.pink.opacity(0.6)]
        case .hiit: colors = [Color.orange, Color.orange.opacity(0.6)]
        case .yoga: colors = [Color.cyan, Color.cyan.opacity(0.6)]
        case .outdoor: colors = [Color.yellow, Color.yellow.opacity(0.6)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static func categoryShadowColor(for category: Workout.WorkoutCategory) -> Color {
        switch category {
        case .strength: return Color.purple.opacity(0.5)
        case .cardio: return Color.green.opacity(0.5)
        case .flexibility: return Color.pink.opacity(0.5)
        case .hiit: return Color.orange.opacity(0.5)
        case .yoga: return Color.cyan.opacity(0.5)
        case .outdoor: return Color.yellow.opacity(0.5)
        }
    }
    
    static func difficultyColor(_ difficulty: Workout.Difficulty) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}
// MARK: - Workout Detail View
struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    @State private var isWorkoutStarted = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Hero Image
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "2C2C2E"), Color(hex: "1C1C1E")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: workoutIcon(for: workout.category))
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.2))
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.category.rawValue)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "D4FF00"))

                            Text(workout.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                    }

                    // Stats
                    HStack(spacing: 20) {
                        StatItem(icon: "clock", value: "\(workout.duration)", unit: "min")
                        StatItem(icon: "flame", value: "\(workout.caloriesBurned)", unit: "kcal")
                        StatItem(icon: "chart.bar", value: workout.difficulty.rawValue, unit: "")
                    }
                    .padding(.horizontal)

                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(workout.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Exercises
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Exercises (\(workout.exercises.count))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                            ExerciseRow(exercise: exercise, index: index + 1)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .overlay(alignment: .bottom) {
                StartWorkoutButton(isStarted: $isWorkoutStarted)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func workoutIcon(for category: Workout.WorkoutCategory) -> String {
        switch category {
        case .strength: return "dumbbell.fill"
        case .cardio: return "figure.run"
        case .flexibility: return "figure.flexibility"
        case .hiit: return "bolt.fill"
        case .yoga: return "figure.yoga"
        case .outdoor: return "sun.max.fill"
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "D4FF00"))

            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let index: Int

    var body: some View {
        HStack(spacing: 15) {
            // Index
            Text("\(index)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color(hex: "D4FF00")))

            // Exercise Info
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                if let duration = exercise.duration {
                    Text("\(duration)s")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                } else {
                    Text("\(exercise.sets) sets × \(exercise.reps) reps")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Rest Time
            HStack(spacing: 4) {
                Image(systemName: "pause.circle")
                    .font(.system(size: 12))
                Text("\(exercise.restTime)s")
                    .font(.system(size: 12))
            }
            .foregroundColor(.gray)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "1C1C1E"))
        )
        .padding(.horizontal)
    }
}

struct StartWorkoutButton: View {
    @Binding var isStarted: Bool

    var body: some View {
        Button(action: { isStarted = true }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Start Workout")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "D4FF00"))
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - 锻炼搜索覆盖视图
// MARK: - 全屏健身搜索界面
struct WorkoutSearchOverlay: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var opacity: Double = 0
    @FocusState private var searchFieldFocus: Bool
    
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        ZStack {
            // 全屏深色背景 - 纯黑渐变
            ZStack {
                // 基础深黑背景
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(hex: "0A0A0F"),
                        Color(hex: "1A1A1E")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // 顶部霓虹光晕
                RadialGradient(
                    colors: [
                        neonYellow.opacity(0.1),
                        Color.clear
                    ],
                    center: .top,
                    startRadius: 0,
                    endRadius: 450
                )
                
                // 底部微光
                LinearGradient(
                    colors: [
                        Color.clear,
                        neonYellow.opacity(0.04)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            .opacity(opacity)
            
            // 主内容区域
            VStack(spacing: 0) {
                // 顶部导航栏
                HStack(spacing: 16) {
                    // 返回按钮
                    Button {
                        dismissSearch()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("返回")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(neonYellow)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .opacity(opacity)
                
                // 搜索框
                HStack(spacing: 14) {
                    // 搜索图标
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        neonYellow.opacity(searchText.isEmpty ? 0.18 : 0.25),
                                        neonYellow.opacity(searchText.isEmpty ? 0.1 : 0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(neonYellow)
                    }
                    .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
                    
                    // 输入框
                    TextField("搜索训练、课程计划...", text: $searchText)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.white)
                        .tint(neonYellow)
                        .focused($searchFieldFocus)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                    
                    // 清除按钮
                    if !searchText.isEmpty {
                        Button {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                searchText = ""
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            neonYellow.opacity(searchFieldFocus ? 0.4 : 0.15),
                                            neonYellow.opacity(searchFieldFocus ? 0.2 : 0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(
                            color: neonYellow.opacity(searchFieldFocus ? 0.25 : 0),
                            radius: 25,
                            x: 0,
                            y: 10
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .animation(.easeInOut(duration: 0.3), value: searchFieldFocus)
                .opacity(opacity)
                
                // 搜索结果区域
                WorkoutSearchResults(searchText: searchText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // 淡入动画
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 1
            }
            
            // 延迟聚焦
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                searchFieldFocus = true
            }
        }
    }
    
    private func dismissSearch() {
        searchFieldFocus = false
        
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
        
        // 淡出动画
        withAnimation(.easeIn(duration: 0.25)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
            searchText = ""
        }
    }
    
    private func performSearch() {
        print("搜索：\(searchText)")
        searchFieldFocus = false
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

// MARK: - 健身搜索结果（精简版）
struct WorkoutSearchResults: View {
    let searchText: String
    let neonYellow = Color(hex: "D4FF00")
    
    // 模拟数据
    let quickActions = [
        ("有氧训练", "figure.run", "燃烧卡路里"),
        ("力量训练", "dumbbell.fill", "增强肌肉"),
        ("HIIT 训练", "bolt.fill", "高效燃脂")
    ]
    
    let recentSearches = ["HIIT训练", "胸部训练", "晨间瑜伽"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                if searchText.isEmpty {
                    // 空状态 - 快速操作
                    VStack(alignment: .leading, spacing: 18) {
                        Text("快速开始")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(quickActions.enumerated()), id: \.offset) { index, action in
                                WorkoutQuickActionCard(
                                    title: action.0,
                                    icon: action.1,
                                    subtitle: action.2,
                                    delay: Double(index) * 0.05
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 最近搜索
                    if !recentSearches.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("最近搜索")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.4))
                                
                                Spacer()
                                
                                Button("清除") {
                                    // 清除历史
                                }
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(neonYellow.opacity(0.7))
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                ForEach(Array(recentSearches.enumerated()), id: \.offset) { index, search in
                                    WorkoutRecentSearchRow(
                                        searchText: search,
                                        isLast: index == recentSearches.count - 1
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                } else {
                    // 搜索结果
                    VStack(alignment: .leading, spacing: 16) {
                        Text("找到 5 个课程")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { index in
                                WorkoutSearchResultCard(
                                    title: "HIIT 高强度训练 \(index + 1)",
                                    duration: "\(20 + index * 5) 分钟",
                                    calories: "\(250 + index * 50) 卡路里",
                                    difficulty: index % 3 == 0 ? "初级" : (index % 3 == 1 ? "中级" : "高级"),
                                    delay: Double(index) * 0.04
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 120)
        }
    }
}

// MARK: - 健身快速操作卡片
struct WorkoutQuickActionCard: View {
    let title: String
    let icon: String
    let subtitle: String
    let delay: Double
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 16) {
                // 图标容器
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    neonYellow.opacity(0.18),
                                    neonYellow.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(neonYellow)
                }
                
                // 文本信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.04))
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .buttonStyle(WorkoutScaleButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                appeared = true
            }
        }
    }
}

// MARK: - 最近搜索行（精简版）
struct WorkoutRecentSearchRow: View {
    let searchText: String
    let isLast: Bool
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Image(systemName: "clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.35))
                    
                    Text(searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.85))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(neonYellow.opacity(0.6))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                
                if !isLast {
                    Divider()
                        .background(Color.white.opacity(0.06))
                        .padding(.leading, 46)
                }
            }
            .background(Color.white.opacity(0.02))
            .opacity(appeared ? 1 : 0)
            .offset(x: appeared ? 0 : -20)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }
}

// MARK: - 健身搜索结果卡片
struct WorkoutSearchResultCard: View {
    let title: String
    let duration: String
    let calories: String
    let difficulty: String
    let delay: Double
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var difficultyColor: Color {
        switch difficulty {
        case "初级": return .green
        case "中级": return .orange
        case "高级": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 14) {
                // 左侧渐变条
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 14) {
                        // 时长
                        HStack(spacing: 5) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 11))
                            Text(duration)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.55))
                        
                        // 卡路里
                        HStack(spacing: 5) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 11))
                            Text(calories)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.orange.opacity(0.8))
                        
                        // 难度
                        HStack(spacing: 5) {
                            Circle()
                                .fill(difficultyColor)
                                .frame(width: 6, height: 6)
                            Text(difficulty)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.55))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
                    )
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .buttonStyle(WorkoutScaleButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                appeared = true
            }
        }
    }
}

// MARK: - 健身缩放按钮样式
struct WorkoutScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    WorkoutView()
        .environmentObject(FitnessManager())
        .preferredColorScheme(.dark)
}
