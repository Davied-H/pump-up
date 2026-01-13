//
//  HomeView.swift
//  FitnessApp
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    HeaderView(user: fitnessManager.currentUser)

                    // Date Selector
                    DateSelectorView(selectedDate: $selectedDate)

                    // Recent Activity Section
                    RecentActivitySection(
                        activity: fitnessManager.todayActivity,
                        weeklyActivities: fitnessManager.weeklyActivities
                    )

                    // Calories & Duration Cards
                    HStack(spacing: 15) {
                        CaloriesCard(calories: Int(fitnessManager.todayActivity.caloriesBurned))
                        DurationCard(minutes: fitnessManager.todayActivity.activeMinutes)
                    }

                    // Trending Workouts
                    TrendingWorkoutsSection(workouts: fitnessManager.workouts)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color.black)
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    let user: User

    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Hi,\(user.name)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Text(L10n.Home.welcomeBack)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Notification Bell
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Date Selector View
struct DateSelectorView: View {
    @Binding var selectedDate: Date
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geometry in
            let itemWidth = geometry.size.width / 7
            
            ZStack(alignment: .leading) {
                // 背景滑块
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "D4FF00"))
                    .frame(width: itemWidth, height: geometry.size.height)
                    .offset(x: itemWidth * CGFloat(selectedDayIndex()))
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedDate)
                
                HStack(spacing: 0) {
                    ForEach(getDaysOfWeek(), id: \.date) { dayInfo in
                        VStack(spacing: 8) {
                            Text(dayInfo.dayName)
                                .font(.system(size: 12))
                                .foregroundColor(dayInfo.isSelected ? .black : .gray)
                                .animation(.easeInOut(duration: 0.2), value: dayInfo.isSelected)
                            
                            Text("\(dayInfo.dayNumber)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(dayInfo.isSelected ? .black : .white)
                                .animation(.easeInOut(duration: 0.2), value: dayInfo.isSelected)
                        }
                        .frame(width: itemWidth)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                selectedDate = dayInfo.date
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 70)
    }
    
    private func selectedDayIndex() -> Int {
        let days = getDaysOfWeek()
        return days.firstIndex { $0.isSelected } ?? 0
    }

    private func getDaysOfWeek() -> [DayInfo] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayName = dayFormatter.string(from: date)

            return DayInfo(
                date: date,
                dayName: dayName,
                dayNumber: calendar.component(.day, from: date),
                isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
            )
        }
    }
}

struct DayInfo {
    let date: Date
    let dayName: String
    let dayNumber: Int
    let isSelected: Bool
}

// MARK: - Recent Activity Section
struct RecentActivitySection: View {
    let activity: DailyActivity
    let weeklyActivities: [WeeklyActivity]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.Home.recentActivity)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            // Steps Card
            VStack(spacing: 15) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(Color(hex: "D4FF00"))
                        Text(L10n.Home.steps)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(activity.steps)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text(String(format: "%.2f km | %.2f kcal", activity.distance, activity.caloriesBurned))
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    // Weekly Chart
                    WeeklyStepsChart(weeklyActivities: weeklyActivities)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }
}

// MARK: - Weekly Steps Chart
struct WeeklyStepsChart: View {
    let weeklyActivities: [WeeklyActivity]

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(weeklyActivities) { activity in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(activity.isToday ? Color(hex: "D4FF00") : Color(hex: "D4FF00").opacity(0.6))
                        .frame(width: 12, height: barHeight(for: activity.steps))

                    Text(activity.dayOfWeek)
                        .font(.system(size: 10))
                        .foregroundColor(activity.isToday ? Color(hex: "D4FF00") : .gray)
                }
            }
        }
    }

    private func barHeight(for steps: Int) -> CGFloat {
        let maxHeight: CGFloat = 50
        let maxSteps: CGFloat = 10000
        return max(5, CGFloat(steps) / maxSteps * maxHeight)
    }
}

// MARK: - Calories Card
struct CaloriesCard: View {
    let calories: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text(L10n.Home.calories)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }

            HStack {
                Text("\(calories) kcal")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)

                    Circle()
                        .trim(from: 0, to: min(CGFloat(calories) / 500, 1.0))
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 40, height: 40)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - Duration Card
struct DurationCard: View {
    let minutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
                Text(L10n.Home.duration)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }

            HStack {
                Text("\(minutes) min")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)

                    Circle()
                        .trim(from: 0, to: min(CGFloat(minutes) / 60, 1.0))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 40, height: 40)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - Trending Workouts Section
struct TrendingWorkoutsSection: View {
    let workouts: [Workout]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.Home.trendingWorkout)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(workouts.prefix(4)) { workout in
                        TrendingWorkoutCard(workout: workout)
                    }
                }
            }
        }
    }
}

struct TrendingWorkoutCard: View {
    let workout: Workout

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image Placeholder
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2C2C2E"), Color(hex: "1C1C1E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 160, height: 180)
                .overlay(
                    Image(systemName: workoutIcon(for: workout.category))
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.2))
                )

            // Workout Info
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text("\(workout.duration) min • \(workout.caloriesBurned) kcal")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            .padding(12)
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
}

#Preview {
    HomeView()
        .environmentObject(FitnessManager())
        .preferredColorScheme(.dark)
}
