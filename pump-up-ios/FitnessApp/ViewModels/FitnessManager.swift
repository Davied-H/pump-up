//
//  FitnessManager.swift
//  FitnessApp
//
//  ViewModel managing app state and API communication
//

import Foundation
import SwiftUI

// MARK: - App State
enum AppState {
    case loading
    case unauthenticated
    case authenticated
}

@MainActor
class FitnessManager: ObservableObject {
    // MARK: - Published Properties
    @Published var appState: AppState = .loading
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var currentUser: User
    @Published var todayActivity: DailyActivity
    @Published var weeklyActivities: [WeeklyActivity]
    @Published var workouts: [Workout]
    @Published var workoutHistory: [WorkoutSession]
    @Published var meditations: [MeditationSession]
    @Published var achievements: [Achievement]
    @Published var statistics: FitnessStatistics

    private let apiService = APIService.shared

    // MARK: - Initialization
    init() {
        // Initialize with default values
        self.currentUser = User(
            name: "User",
            email: "",
            avatarURL: nil,
            height: 170,
            weight: 65,
            age: 25,
            gender: .male,
            fitnessGoal: .stayFit,
            dailyStepGoal: 10000,
            dailyCalorieGoal: 500
        )

        self.todayActivity = DailyActivity(
            date: Date(),
            steps: 0,
            distance: 0,
            caloriesBurned: 0,
            activeMinutes: 0
        )

        self.weeklyActivities = []
        self.workouts = []
        self.workoutHistory = []
        self.meditations = []
        self.achievements = []
        self.statistics = FitnessStatistics(
            totalWorkouts: 0,
            totalCaloriesBurned: 0,
            totalActiveMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            averageStepsPerDay: 0,
            totalMeditationMinutes: 0
        )

        // Check login status
        Task {
            await checkLoginStatus()
        }
    }

    // MARK: - Authentication
    func checkLoginStatus() async {
        let isLoggedIn = await apiService.isLoggedIn
        if isLoggedIn {
            await loadAllData()
            appState = .authenticated
        } else {
            appState = .unauthenticated
        }
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiService.login(email: email, password: password)
            updateUserFromDTO(response.user)
            await loadAllData()
            appState = .authenticated
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func register(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiService.register(email: email, password: password, name: name)
            updateUserFromDTO(response.user)
            await loadAllData()
            appState = .authenticated
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func logout() async {
        await apiService.logout()
        appState = .unauthenticated
        resetData()
    }

    private func resetData() {
        currentUser = User(
            name: "User",
            email: "",
            avatarURL: nil,
            height: 170,
            weight: 65,
            age: 25,
            gender: .male,
            fitnessGoal: .stayFit,
            dailyStepGoal: 10000,
            dailyCalorieGoal: 500
        )
        todayActivity = DailyActivity(date: Date(), steps: 0, distance: 0, caloriesBurned: 0, activeMinutes: 0)
        weeklyActivities = []
        workouts = []
        meditations = []
        achievements = []
        statistics = FitnessStatistics(totalWorkouts: 0, totalCaloriesBurned: 0, totalActiveMinutes: 0, currentStreak: 0, longestStreak: 0, averageStepsPerDay: 0, totalMeditationMinutes: 0)
    }

    // MARK: - Data Loading
    func loadAllData() async {
        isLoading = true

        async let profileTask: () = loadProfile()
        async let activityTask: () = loadTodayActivity()
        async let weeklyTask: () = loadWeeklyActivity()
        async let workoutsTask: () = loadWorkouts()
        async let meditationsTask: () = loadMeditations()
        async let achievementsTask: () = loadAchievements()
        async let statisticsTask: () = loadStatistics()

        _ = await (profileTask, activityTask, weeklyTask, workoutsTask, meditationsTask, achievementsTask, statisticsTask)

        isLoading = false
    }

    func loadProfile() async {
        do {
            let userDTO = try await apiService.getProfile()
            updateUserFromDTO(userDTO)
        } catch {
            print("Failed to load profile: \(error)")
        }
    }

    func loadTodayActivity() async {
        do {
            let activityDTO = try await apiService.getTodayActivity()
            updateActivityFromDTO(activityDTO)
        } catch {
            print("Failed to load today's activity: \(error)")
        }
    }

    func loadWeeklyActivity() async {
        do {
            let activitiesDTO = try await apiService.getWeeklyActivity()
            updateWeeklyActivitiesFromDTO(activitiesDTO)
        } catch {
            print("Failed to load weekly activities: \(error)")
        }
    }

    func loadWorkouts() async {
        do {
            let workoutsDTO = try await apiService.getWorkouts()
            updateWorkoutsFromDTO(workoutsDTO)
        } catch {
            print("Failed to load workouts: \(error)")
            // Load sample data as fallback
            workouts = Self.generateSampleWorkouts()
        }
    }

    func loadMeditations() async {
        do {
            let meditationsDTO = try await apiService.getMeditations()
            updateMeditationsFromDTO(meditationsDTO)
        } catch {
            print("Failed to load meditations: \(error)")
            // Load sample data as fallback
            meditations = Self.generateSampleMeditations()
        }
    }

    func loadAchievements() async {
        do {
            let achievementsDTO = try await apiService.getAchievements()
            updateAchievementsFromDTO(achievementsDTO)
        } catch {
            print("Failed to load achievements: \(error)")
            // Load sample data as fallback
            achievements = Self.generateAchievements()
        }
    }

    func loadStatistics() async {
        do {
            let statsDTO = try await apiService.getStatistics()
            updateStatisticsFromDTO(statsDTO)
        } catch {
            print("Failed to load statistics: \(error)")
        }
    }

    // MARK: - DTO to Model Conversion
    private func updateUserFromDTO(_ dto: UserDTO) {
        // 使用apiValue扩展从后端英文值转换为iOS枚举
        let gender = Gender(apiValue: dto.gender)
        let goal = FitnessGoal(apiValue: dto.fitnessGoal)

        currentUser = User(
            name: dto.name,
            email: dto.email,
            avatarURL: dto.avatarUrl,
            height: dto.height,
            weight: dto.weight,
            age: dto.age,
            gender: gender,
            fitnessGoal: goal,
            dailyStepGoal: dto.dailyStepGoal,
            dailyCalorieGoal: dto.dailyCalorieGoal
        )
    }

    private func updateActivityFromDTO(_ dto: DailyActivityDTO) {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dto.date) ?? Date()

        todayActivity = DailyActivity(
            date: date,
            steps: dto.steps,
            distance: dto.distance,
            caloriesBurned: dto.caloriesBurned,
            activeMinutes: dto.activeMinutes
        )
    }

    private func updateWeeklyActivitiesFromDTO(_ dtos: [DailyActivityDTO]) {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        let todayIndex = (today + 5) % 7

        weeklyActivities = days.enumerated().map { index, day in
            let steps = index < dtos.count ? dtos[index].steps : 0
            return WeeklyActivity(
                dayOfWeek: day,
                steps: steps,
                isToday: index == todayIndex
            )
        }
    }

    private func updateWorkoutsFromDTO(_ dtos: [WorkoutDTO]) {
        workouts = dtos.map { dto in
            // 使用apiValue扩展从后端英文值转换
            let category = WorkoutCategory(apiValue: dto.category)
            let difficulty = Difficulty(apiValue: dto.difficulty)
            let exercises = dto.exercises?.map { exerciseFromDTO($0) } ?? []

            return Workout(
                name: dto.name,
                category: category,
                duration: dto.duration,
                caloriesBurned: dto.caloriesBurned,
                exercises: exercises,
                difficulty: difficulty,
                imageName: dto.imageName,
                description: dto.description
            )
        }
    }

    private func exerciseFromDTO(_ dto: ExerciseDTO) -> Exercise {
        // 使用MuscleGroup.fromAPIString从逗号分隔的英文字符串解析
        let muscleGroups = MuscleGroup.fromAPIString(dto.muscleGroups)

        return Exercise(
            name: dto.name,
            sets: dto.sets,
            reps: dto.reps,
            duration: dto.duration,
            restTime: dto.restTime,
            description: dto.description,
            muscleGroups: muscleGroups,
            imageName: dto.imageName
        )
    }

    private func updateMeditationsFromDTO(_ dtos: [MeditationDTO]) {
        meditations = dtos.map { dto in
            // 使用apiValue扩展从后端英文值转换
            let category = MeditationCategory(apiValue: dto.category)

            return MeditationSession(
                name: dto.name,
                category: category,
                duration: dto.duration,
                description: dto.description,
                audioFileName: dto.audioFileName,
                imageName: dto.imageName,
                isPremium: dto.isPremium
            )
        }
    }

    private func updateAchievementsFromDTO(_ dtos: [AchievementDTO]) {
        let dateFormatter = ISO8601DateFormatter()

        achievements = dtos.map { dto in
            // 使用apiValue扩展从后端英文值转换
            let category = AchievementCategory(apiValue: dto.category)
            let unlockedDate = dto.unlockedAt.flatMap { dateFormatter.date(from: $0) }

            return Achievement(
                title: dto.title,
                description: dto.description,
                iconName: dto.iconName,
                isUnlocked: dto.isUnlocked,
                unlockedDate: unlockedDate,
                category: category
            )
        }
    }

    private func updateStatisticsFromDTO(_ dto: StatisticsDTO) {
        statistics = FitnessStatistics(
            totalWorkouts: dto.totalWorkouts,
            totalCaloriesBurned: dto.totalCaloriesBurned,
            totalActiveMinutes: dto.totalActiveMinutes,
            currentStreak: dto.currentStreak,
            longestStreak: dto.longestStreak,
            averageStepsPerDay: dto.averageStepsPerDay,
            totalMeditationMinutes: dto.totalMeditationMinutes
        )
    }

    // MARK: - Activity Updates
    func updateSteps(_ steps: Int) async {
        do {
            let activityDTO = try await apiService.updateTodayActivity(steps: steps)
            updateActivityFromDTO(activityDTO)
        } catch {
            // Update locally if API fails
            todayActivity.steps = steps
            todayActivity.distance = Double(steps) * 0.0007
            todayActivity.caloriesBurned = Double(steps) * 0.04
        }
    }

    // MARK: - Workout Management
    func startWorkout(_ workout: Workout) -> WorkoutSession {
        let session = WorkoutSession(
            workout: workout,
            startTime: Date(),
            caloriesBurned: 0,
            completed: false
        )
        return session
    }

    func completeWorkout(_ session: inout WorkoutSession) {
        session.endTime = Date()
        session.completed = true
        session.caloriesBurned = session.workout.caloriesBurned
        workoutHistory.append(session)
        statistics.totalWorkouts += 1
        statistics.totalCaloriesBurned += session.caloriesBurned
        statistics.totalActiveMinutes += session.workout.duration
    }

    func logMeditation(duration: Int) {
        statistics.totalMeditationMinutes += duration
    }

    // MARK: - Sample Data Generators (Fallback)
    static func generateSampleWorkouts() -> [Workout] {
        [
            Workout(
                name: "全身燃脂训练",
                category: .hiit,
                duration: 30,
                caloriesBurned: 350,
                exercises: generateHIITExercises(),
                difficulty: .intermediate,
                imageName: "workout_hiit",
                description: "高强度间歇训练，快速燃烧脂肪"
            ),
            Workout(
                name: "上肢力量",
                category: .strength,
                duration: 45,
                caloriesBurned: 280,
                exercises: generateUpperBodyExercises(),
                difficulty: .intermediate,
                imageName: "workout_upper",
                description: "专注于胸部、背部和手臂的力量训练"
            ),
            Workout(
                name: "腿部塑形",
                category: .strength,
                duration: 40,
                caloriesBurned: 320,
                exercises: generateLegExercises(),
                difficulty: .beginner,
                imageName: "workout_legs",
                description: "强化腿部和臀部肌肉"
            ),
            Workout(
                name: "核心训练",
                category: .strength,
                duration: 20,
                caloriesBurned: 150,
                exercises: generateCoreExercises(),
                difficulty: .beginner,
                imageName: "workout_core",
                description: "增强核心稳定性和腹肌"
            ),
            Workout(
                name: "晨间瑜伽",
                category: .yoga,
                duration: 25,
                caloriesBurned: 120,
                exercises: generateYogaExercises(),
                difficulty: .beginner,
                imageName: "workout_yoga",
                description: "温和的晨间拉伸，唤醒身体"
            ),
            Workout(
                name: "户外跑步",
                category: .cardio,
                duration: 30,
                caloriesBurned: 300,
                exercises: [],
                difficulty: .beginner,
                imageName: "workout_running",
                description: "有氧慢跑，提升心肺功能"
            )
        ]
    }

    static func generateHIITExercises() -> [Exercise] {
        [
            Exercise(name: "开合跳", sets: 3, reps: 20, duration: 30, restTime: 15,
                    description: "双脚跳开同时双手上举", muscleGroups: [.fullBody], imageName: "jumping_jacks"),
            Exercise(name: "波比跳", sets: 3, reps: 10, duration: nil, restTime: 30,
                    description: "下蹲触地，跳回站立", muscleGroups: [.fullBody], imageName: "burpees"),
            Exercise(name: "高抬腿", sets: 3, reps: 30, duration: 30, restTime: 15,
                    description: "原地快速高抬腿", muscleGroups: [.legs, .core], imageName: "high_knees"),
            Exercise(name: "登山者", sets: 3, reps: 20, duration: nil, restTime: 20,
                    description: "平板支撑姿势交替提膝", muscleGroups: [.core, .legs], imageName: "mountain_climbers")
        ]
    }

    static func generateUpperBodyExercises() -> [Exercise] {
        [
            Exercise(name: "俯卧撑", sets: 4, reps: 12, duration: nil, restTime: 60,
                    description: "标准俯卧撑", muscleGroups: [.chest, .arms], imageName: "pushups"),
            Exercise(name: "哑铃划船", sets: 3, reps: 12, duration: nil, restTime: 60,
                    description: "单臂哑铃划船", muscleGroups: [.back, .arms], imageName: "dumbbell_row"),
            Exercise(name: "肩推", sets: 3, reps: 10, duration: nil, restTime: 60,
                    description: "哑铃肩部推举", muscleGroups: [.shoulders], imageName: "shoulder_press"),
            Exercise(name: "二头弯举", sets: 3, reps: 12, duration: nil, restTime: 45,
                    description: "哑铃二头肌弯举", muscleGroups: [.arms], imageName: "bicep_curls")
        ]
    }

    static func generateLegExercises() -> [Exercise] {
        [
            Exercise(name: "深蹲", sets: 4, reps: 15, duration: nil, restTime: 60,
                    description: "自重深蹲", muscleGroups: [.legs, .glutes], imageName: "squats"),
            Exercise(name: "弓步蹲", sets: 3, reps: 12, duration: nil, restTime: 45,
                    description: "交替弓步蹲", muscleGroups: [.legs, .glutes], imageName: "lunges"),
            Exercise(name: "臀桥", sets: 3, reps: 15, duration: nil, restTime: 45,
                    description: "仰卧臀桥", muscleGroups: [.glutes, .core], imageName: "glute_bridge"),
            Exercise(name: "小腿提踵", sets: 3, reps: 20, duration: nil, restTime: 30,
                    description: "站立提踵", muscleGroups: [.legs], imageName: "calf_raises")
        ]
    }

    static func generateCoreExercises() -> [Exercise] {
        [
            Exercise(name: "平板支撑", sets: 3, reps: 1, duration: 45, restTime: 30,
                    description: "保持平板支撑姿势", muscleGroups: [.core], imageName: "plank"),
            Exercise(name: "卷腹", sets: 3, reps: 20, duration: nil, restTime: 30,
                    description: "标准卷腹", muscleGroups: [.core], imageName: "crunches"),
            Exercise(name: "俄罗斯转体", sets: 3, reps: 20, duration: nil, restTime: 30,
                    description: "坐姿转体", muscleGroups: [.core], imageName: "russian_twist"),
            Exercise(name: "死虫", sets: 3, reps: 12, duration: nil, restTime: 30,
                    description: "仰卧交替伸展", muscleGroups: [.core], imageName: "dead_bug")
        ]
    }

    static func generateYogaExercises() -> [Exercise] {
        [
            Exercise(name: "下犬式", sets: 1, reps: 1, duration: 60, restTime: 0,
                    description: "倒V字形伸展", muscleGroups: [.fullBody], imageName: "downward_dog"),
            Exercise(name: "战士一式", sets: 1, reps: 1, duration: 45, restTime: 0,
                    description: "双腿前后分开，上举双臂", muscleGroups: [.legs, .core], imageName: "warrior1"),
            Exercise(name: "猫牛式", sets: 1, reps: 10, duration: nil, restTime: 0,
                    description: "四肢着地，交替弓背和塌腰", muscleGroups: [.back, .core], imageName: "cat_cow"),
            Exercise(name: "婴儿式", sets: 1, reps: 1, duration: 60, restTime: 0,
                    description: "跪坐放松", muscleGroups: [.back], imageName: "child_pose")
        ]
    }

    static func generateSampleMeditations() -> [MeditationSession] {
        [
            MeditationSession(name: "深度放松", category: .stress, duration: 10,
                            description: "释放压力，放松身心", audioFileName: "relax", imageName: "meditation_relax", isPremium: false),
            MeditationSession(name: "专注呼吸", category: .breathing, duration: 5,
                            description: "通过呼吸练习提升专注力", audioFileName: "breathing", imageName: "meditation_breathing", isPremium: false),
            MeditationSession(name: "安眠冥想", category: .sleep, duration: 20,
                            description: "帮助入睡的引导冥想", audioFileName: "sleep", imageName: "meditation_sleep", isPremium: false),
            MeditationSession(name: "晨间能量", category: .morning, duration: 10,
                            description: "开启充满活力的一天", audioFileName: "morning", imageName: "meditation_morning", isPremium: false),
            MeditationSession(name: "感恩练习", category: .gratitude, duration: 15,
                            description: "培养感恩心态", audioFileName: "gratitude", imageName: "meditation_gratitude", isPremium: true),
            MeditationSession(name: "深度专注", category: .focus, duration: 25,
                            description: "提升工作学习效率", audioFileName: "focus", imageName: "meditation_focus", isPremium: true)
        ]
    }

    static func generateAchievements() -> [Achievement] {
        [
            Achievement(title: "初次启程", description: "完成第一次训练", iconName: "star.fill", isUnlocked: true, unlockedDate: Date().addingTimeInterval(-86400 * 30), category: .workout),
            Achievement(title: "步行达人", description: "单日步数达到10000步", iconName: "figure.walk", isUnlocked: true, unlockedDate: Date().addingTimeInterval(-86400 * 7), category: .steps),
            Achievement(title: "坚持一周", description: "连续7天完成训练", iconName: "flame.fill", isUnlocked: true, unlockedDate: Date().addingTimeInterval(-86400 * 3), category: .streak),
            Achievement(title: "冥想大师", description: "累计冥想时间达到5小时", iconName: "brain.head.profile", isUnlocked: false, unlockedDate: nil, category: .meditation),
            Achievement(title: "健身狂人", description: "完成50次训练", iconName: "trophy.fill", isUnlocked: false, unlockedDate: nil, category: .workout),
            Achievement(title: "月度挑战", description: "连续30天完成训练", iconName: "calendar", isUnlocked: false, unlockedDate: nil, category: .streak)
        ]
    }
}
