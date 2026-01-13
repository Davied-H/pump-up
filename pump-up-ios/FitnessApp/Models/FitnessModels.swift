//
//  FitnessModels.swift
//  FitnessApp
//

import Foundation
import SwiftUI

// MARK: - Type Aliases for convenience
typealias Gender = User.Gender
typealias FitnessGoal = User.FitnessGoal
typealias WorkoutCategory = Workout.WorkoutCategory
typealias Difficulty = Workout.Difficulty
typealias MuscleGroup = Exercise.MuscleGroup
typealias MeditationCategory = MeditationSession.MeditationCategory
typealias AchievementCategory = Achievement.AchievementCategory

// MARK: - User Model
struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var avatarURL: String?
    var height: Double // cm
    var weight: Double // kg
    var age: Int
    var gender: Gender
    var fitnessGoal: FitnessGoal
    var dailyStepGoal: Int
    var dailyCalorieGoal: Int

    enum Gender: String, Codable, CaseIterable {
        case male = "男"
        case female = "女"
        case other = "其他"
    }

    enum FitnessGoal: String, Codable, CaseIterable {
        case loseWeight = "减重"
        case buildMuscle = "增肌"
        case stayFit = "保持健康"
        case improveEndurance = "提高耐力"
    }
}

// MARK: - Activity Data
struct DailyActivity: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var steps: Int
    var distance: Double // km
    var caloriesBurned: Double
    var activeMinutes: Int
}

// MARK: - Weekly Activity
struct WeeklyActivity: Identifiable {
    var id = UUID()
    var dayOfWeek: String
    var steps: Int
    var isToday: Bool
}

// MARK: - Workout Models
struct Workout: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: WorkoutCategory
    var duration: Int // minutes
    var caloriesBurned: Int
    var exercises: [Exercise]
    var difficulty: Difficulty
    var imageName: String
    var description: String

    enum WorkoutCategory: String, Codable, CaseIterable {
        case strength = "力量训练"
        case cardio = "有氧运动"
        case flexibility = "柔韧性"
        case hiit = "HIIT"
        case yoga = "瑜伽"
        case outdoor = "户外运动"
    }

    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "初级"
        case intermediate = "中级"
        case advanced = "高级"
    }
}

struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var duration: Int? // seconds, for timed exercises
    var restTime: Int // seconds
    var description: String
    var muscleGroups: [MuscleGroup]
    var imageName: String

    enum MuscleGroup: String, Codable, CaseIterable {
        case chest = "胸部"
        case back = "背部"
        case shoulders = "肩部"
        case arms = "手臂"
        case core = "核心"
        case legs = "腿部"
        case glutes = "臀部"
        case fullBody = "全身"
    }
}

// MARK: - Workout Session
struct WorkoutSession: Identifiable, Codable {
    var id = UUID()
    var workout: Workout
    var startTime: Date
    var endTime: Date?
    var caloriesBurned: Int
    var completed: Bool
    var notes: String?
}

// MARK: - Meditation Models
struct MeditationSession: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: MeditationCategory
    var duration: Int // minutes
    var description: String
    var audioFileName: String?
    var imageName: String
    var isPremium: Bool

    enum MeditationCategory: String, Codable, CaseIterable {
        case sleep = "睡眠"
        case stress = "减压"
        case focus = "专注"
        case breathing = "呼吸"
        case morning = "晨间冥想"
        case gratitude = "感恩"
    }
}

// MARK: - Achievement Models
struct Achievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var iconName: String
    var isUnlocked: Bool
    var unlockedDate: Date?
    var category: AchievementCategory

    enum AchievementCategory: String, Codable, CaseIterable {
        case steps = "步数"
        case workout = "训练"
        case meditation = "冥想"
        case streak = "连续打卡"
    }
}

// MARK: - Nutrition Models
struct NutritionEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var mealType: MealType
    var foodName: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double

    enum MealType: String, Codable, CaseIterable {
        case breakfast = "早餐"
        case lunch = "午餐"
        case dinner = "晚餐"
        case snack = "零食"
    }
}

// MARK: - Statistics
struct FitnessStatistics {
    var totalWorkouts: Int
    var totalCaloriesBurned: Int
    var totalActiveMinutes: Int
    var currentStreak: Int
    var longestStreak: Int
    var averageStepsPerDay: Int
    var totalMeditationMinutes: Int
}

// MARK: - API Value Mapping Extensions
// 用于iOS端中文枚举值与后端英文值之间的转换

extension User.Gender {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "male": self = .male
        case "female": self = .female
        default: self = .other
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        case .other: return "other"
        }
    }
}

extension User.FitnessGoal {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "lose_weight": self = .loseWeight
        case "build_muscle": self = .buildMuscle
        case "stay_fit": self = .stayFit
        case "improve_endurance": self = .improveEndurance
        default: self = .stayFit
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .loseWeight: return "lose_weight"
        case .buildMuscle: return "build_muscle"
        case .stayFit: return "stay_fit"
        case .improveEndurance: return "improve_endurance"
        }
    }
}

extension Workout.WorkoutCategory {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "strength": self = .strength
        case "cardio": self = .cardio
        case "flexibility": self = .flexibility
        case "hiit": self = .hiit
        case "yoga": self = .yoga
        case "outdoor": self = .outdoor
        default: self = .strength
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .strength: return "strength"
        case .cardio: return "cardio"
        case .flexibility: return "flexibility"
        case .hiit: return "hiit"
        case .yoga: return "yoga"
        case .outdoor: return "outdoor"
        }
    }
}

extension Workout.Difficulty {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "beginner": self = .beginner
        case "intermediate": self = .intermediate
        case "advanced": self = .advanced
        default: self = .beginner
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .beginner: return "beginner"
        case .intermediate: return "intermediate"
        case .advanced: return "advanced"
        }
    }
}

extension Exercise.MuscleGroup {
    /// 从后端API值初始化（可失败，用于解析逗号分隔字符串）
    init?(apiValue: String) {
        switch apiValue.lowercased().trimmingCharacters(in: .whitespaces) {
        case "chest": self = .chest
        case "back": self = .back
        case "shoulders": self = .shoulders
        case "arms": self = .arms
        case "core": self = .core
        case "legs": self = .legs
        case "glutes": self = .glutes
        case "full_body", "fullbody": self = .fullBody
        default: return nil
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .chest: return "chest"
        case .back: return "back"
        case .shoulders: return "shoulders"
        case .arms: return "arms"
        case .core: return "core"
        case .legs: return "legs"
        case .glutes: return "glutes"
        case .fullBody: return "full_body"
        }
    }

    /// 从逗号分隔的字符串解析肌肉群数组
    static func fromAPIString(_ string: String) -> [MuscleGroup] {
        return string.components(separatedBy: ",")
            .compactMap { MuscleGroup(apiValue: $0) }
    }

    /// 将肌肉群数组转换为逗号分隔的字符串
    static func toAPIString(_ groups: [MuscleGroup]) -> String {
        return groups.map { $0.apiValue }.joined(separator: ",")
    }
}

extension MeditationSession.MeditationCategory {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "sleep": self = .sleep
        case "stress": self = .stress
        case "focus": self = .focus
        case "breathing": self = .breathing
        case "morning": self = .morning
        case "gratitude": self = .gratitude
        default: self = .breathing
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .sleep: return "sleep"
        case .stress: return "stress"
        case .focus: return "focus"
        case .breathing: return "breathing"
        case .morning: return "morning"
        case .gratitude: return "gratitude"
        }
    }
}

extension Achievement.AchievementCategory {
    /// 从后端API值初始化
    init(apiValue: String) {
        switch apiValue.lowercased() {
        case "steps": self = .steps
        case "workout": self = .workout
        case "meditation": self = .meditation
        case "streak": self = .streak
        default: self = .workout
        }
    }

    /// 转换为后端API值
    var apiValue: String {
        switch self {
        case .steps: return "steps"
        case .workout: return "workout"
        case .meditation: return "meditation"
        case .streak: return "streak"
        }
    }
}
