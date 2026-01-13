//
//  LocalizationHelper.swift
//  FitnessApp
//
//  本地化辅助工具
//

import Foundation
import SwiftUI

/// 本地化字符串命名空间
enum L10n {

    // MARK: - 应用核心
    enum App {
        static let name = LocalizedStringKey("FitLife")
    }

    // MARK: - Tab 标签
    enum Tab {
        static let home = LocalizedStringKey("Home")
        static let workout = LocalizedStringKey("Workout")
        static let meditation = LocalizedStringKey("Meditation")
        static let profile = LocalizedStringKey("Profile")
    }

    // MARK: - 通用
    enum Common {
        static let cancel = LocalizedStringKey("common.cancel")
        static let done = LocalizedStringKey("common.done")
        static let save = LocalizedStringKey("common.save")
        static let edit = LocalizedStringKey("common.edit")
        static let delete = LocalizedStringKey("common.delete")
        static let confirm = LocalizedStringKey("common.confirm")
        static let ok = LocalizedStringKey("common.ok")
        static let yes = LocalizedStringKey("common.yes")
        static let no = LocalizedStringKey("common.no")
        static let loading = LocalizedStringKey("common.loading")
        static let error = LocalizedStringKey("common.error")
        static let success = LocalizedStringKey("common.success")
        static let retry = LocalizedStringKey("common.retry")
        static let seeAll = LocalizedStringKey("common.see_all")
        static let viewAll = LocalizedStringKey("common.view_all")
        static let about = LocalizedStringKey("common.about")
        static let version = LocalizedStringKey("common.version")
        static let today = LocalizedStringKey("common.today")
        static let yesterday = LocalizedStringKey("common.yesterday")
        static let thisWeek = LocalizedStringKey("common.this_week")
        static let thisMonth = LocalizedStringKey("common.this_month")
        static let all = LocalizedStringKey("common.all")
        static let none = LocalizedStringKey("common.none")
        static let start = LocalizedStringKey("common.start")
        static let stop = LocalizedStringKey("common.stop")
        static let pause = LocalizedStringKey("common.pause")
        static let resume = LocalizedStringKey("common.resume")
        static let finish = LocalizedStringKey("common.finish")
        static let skip = LocalizedStringKey("common.skip")
        static let next = LocalizedStringKey("common.next")
        static let previous = LocalizedStringKey("common.previous")
        static let back = LocalizedStringKey("common.back")
        static let close = LocalizedStringKey("common.close")
        static let search = LocalizedStringKey("common.search")
        static let filter = LocalizedStringKey("common.filter")
        static let sort = LocalizedStringKey("common.sort")
        static let share = LocalizedStringKey("common.share")
        static let more = LocalizedStringKey("common.more")
        static let less = LocalizedStringKey("common.less")
        static let settings = LocalizedStringKey("common.settings")
        static let help = LocalizedStringKey("common.help")
        static let feedback = LocalizedStringKey("common.feedback")
        static let privacyPolicy = LocalizedStringKey("common.privacy_policy")
        static let termsOfService = LocalizedStringKey("common.terms_of_service")
    }

    // MARK: - 认证
    enum Auth {
        static let welcomeBack = LocalizedStringKey("auth.welcome_back")
        static let startJourney = LocalizedStringKey("auth.start_journey")
        static let login = LocalizedStringKey("auth.login")
        static let register = LocalizedStringKey("auth.register")
        static let email = LocalizedStringKey("auth.email")
        static let password = LocalizedStringKey("auth.password")
        static let name = LocalizedStringKey("auth.name")
        static let confirmPassword = LocalizedStringKey("auth.confirm_password")
        static let passwordMismatch = LocalizedStringKey("auth.password_mismatch")
        static let noAccount = LocalizedStringKey("auth.no_account")
        static let haveAccount = LocalizedStringKey("auth.have_account")
        static let demoLogin = LocalizedStringKey("auth.demo_login")
        static let forgotPassword = LocalizedStringKey("auth.forgot_password")
        static let resetPassword = LocalizedStringKey("auth.reset_password")
        static let logout = LocalizedStringKey("auth.logout")
        static let logoutConfirm = LocalizedStringKey("auth.logout_confirm")
    }

    // MARK: - 首页
    enum Home {
        static let welcomeBack = LocalizedStringKey("home.welcome_back")
        static let goodMorning = LocalizedStringKey("home.good_morning")
        static let goodAfternoon = LocalizedStringKey("home.good_afternoon")
        static let goodEvening = LocalizedStringKey("home.good_evening")
        static let recentActivity = LocalizedStringKey("home.recent_activity")
        static let todayProgress = LocalizedStringKey("home.today_progress")
        static let steps = LocalizedStringKey("home.steps")
        static let calories = LocalizedStringKey("home.calories")
        static let duration = LocalizedStringKey("home.duration")
        static let distance = LocalizedStringKey("home.distance")
        static let trendingWorkout = LocalizedStringKey("home.trending_workout")
        static let recommendedForYou = LocalizedStringKey("home.recommended_for_you")
        static let quickStart = LocalizedStringKey("home.quick_start")
        static let continueWorkout = LocalizedStringKey("home.continue_workout")
        static let dailyGoal = LocalizedStringKey("home.daily_goal")
        static let weeklyGoal = LocalizedStringKey("home.weekly_goal")
        static let streak = LocalizedStringKey("home.streak")
        static let daysStreak = LocalizedStringKey("home.days_streak")
        static let noRecentActivity = LocalizedStringKey("home.no_recent_activity")
        static let startFirstWorkout = LocalizedStringKey("home.start_first_workout")
    }

    // MARK: - 训练
    enum Workout {
        static let title = LocalizedStringKey("workout.title")
        static let chooseTraining = LocalizedStringKey("workout.choose_training")
        static let quickStart = LocalizedStringKey("workout.quick_start")
        static let recommended = LocalizedStringKey("workout.recommended")
        static let myPlans = LocalizedStringKey("workout.my_plans")
        static let allWorkouts = LocalizedStringKey("workout.all_workouts")
        static let favorites = LocalizedStringKey("workout.favorites")
        static let history = LocalizedStringKey("workout.history")
        static let createPlan = LocalizedStringKey("workout.create_plan")
        static let startWorkout = LocalizedStringKey("workout.start_workout")
        static let endWorkout = LocalizedStringKey("workout.end_workout")
        static let pauseWorkout = LocalizedStringKey("workout.pause_workout")
        static let resumeWorkout = LocalizedStringKey("workout.resume_workout")
        static let workoutComplete = LocalizedStringKey("workout.workout_complete")
        static let greatJob = LocalizedStringKey("workout.great_job")
        static let duration = LocalizedStringKey("workout.duration")
        static let caloriesBurned = LocalizedStringKey("workout.calories_burned")
        static let exercisesCompleted = LocalizedStringKey("workout.exercises_completed")
        static let sets = LocalizedStringKey("workout.sets")
        static let reps = LocalizedStringKey("workout.reps")
        static let weight = LocalizedStringKey("workout.weight")
        static let rest = LocalizedStringKey("workout.rest")
        static let restTime = LocalizedStringKey("workout.rest_time")
        static let nextExercise = LocalizedStringKey("workout.next_exercise")
        static let skipExercise = LocalizedStringKey("workout.skip_exercise")
        static let addExercise = LocalizedStringKey("workout.add_exercise")
        static let removeExercise = LocalizedStringKey("workout.remove_exercise")
        static let exerciseDetails = LocalizedStringKey("workout.exercise_details")
        static let howToPerform = LocalizedStringKey("workout.how_to_perform")
        static let musclesWorked = LocalizedStringKey("workout.muscles_worked")
        static let equipment = LocalizedStringKey("workout.equipment")
        static let difficulty = LocalizedStringKey("workout.difficulty")
        static let beginner = LocalizedStringKey("workout.beginner")
        static let intermediate = LocalizedStringKey("workout.intermediate")
        static let advanced = LocalizedStringKey("workout.advanced")
        static let noWorkouts = LocalizedStringKey("workout.no_workouts")
        static let findWorkout = LocalizedStringKey("workout.find_workout")

        // 分类
        enum Category {
            static let all = LocalizedStringKey("workout.category.all")
            static let strength = LocalizedStringKey("workout.category.strength")
            static let cardio = LocalizedStringKey("workout.category.cardio")
            static let hiit = LocalizedStringKey("workout.category.hiit")
            static let yoga = LocalizedStringKey("workout.category.yoga")
            static let stretch = LocalizedStringKey("workout.category.stretch")
            static let pilates = LocalizedStringKey("workout.category.pilates")
            static let bodyweight = LocalizedStringKey("workout.category.bodyweight")
            static let running = LocalizedStringKey("workout.category.running")
            static let cycling = LocalizedStringKey("workout.category.cycling")
            static let swimming = LocalizedStringKey("workout.category.swimming")
            static let walking = LocalizedStringKey("workout.category.walking")
        }

        // 计时器
        enum Timer {
            static let timeRemaining = LocalizedStringKey("workout.timer.time_remaining")
            static let timeElapsed = LocalizedStringKey("workout.timer.time_elapsed")
            static let getReady = LocalizedStringKey("workout.timer.get_ready")
            static let go = LocalizedStringKey("workout.timer.go")
            static let rest = LocalizedStringKey("workout.timer.rest")
            static let nextUp = LocalizedStringKey("workout.timer.next_up")
            static let finished = LocalizedStringKey("workout.timer.finished")
            static let skip = LocalizedStringKey("workout.timer.skip")
            static let addTime = LocalizedStringKey("workout.timer.add_time")
        }
    }

    // MARK: - 冥想
    enum Meditation {
        static let title = LocalizedStringKey("meditation.title")
        static let findPeace = LocalizedStringKey("meditation.find_peace")
        static let dailyCalm = LocalizedStringKey("meditation.daily_calm")
        static let forYou = LocalizedStringKey("meditation.for_you")
        static let quickSessions = LocalizedStringKey("meditation.quick_sessions")
        static let guidedMeditation = LocalizedStringKey("meditation.guided_meditation")
        static let breathingExercise = LocalizedStringKey("meditation.breathing_exercise")
        static let sleepStories = LocalizedStringKey("meditation.sleep_stories")
        static let favorites = LocalizedStringKey("meditation.favorites")
        static let history = LocalizedStringKey("meditation.history")
        static let startSession = LocalizedStringKey("meditation.start_session")
        static let endSession = LocalizedStringKey("meditation.end_session")
        static let sessionComplete = LocalizedStringKey("meditation.session_complete")
        static let wellDone = LocalizedStringKey("meditation.well_done")
        static let duration = LocalizedStringKey("meditation.duration")
        static let totalMinutes = LocalizedStringKey("meditation.total_minutes")
        static let sessionsCompleted = LocalizedStringKey("meditation.sessions_completed")
        static let currentStreak = LocalizedStringKey("meditation.current_streak")
        static let longestStreak = LocalizedStringKey("meditation.longest_streak")
        static let noSessions = LocalizedStringKey("meditation.no_sessions")
        static let discoverMeditation = LocalizedStringKey("meditation.discover_meditation")

        // 分类
        enum Category {
            static let all = LocalizedStringKey("meditation.category.all")
            static let sleep = LocalizedStringKey("meditation.category.sleep")
            static let stress = LocalizedStringKey("meditation.category.stress")
            static let focus = LocalizedStringKey("meditation.category.focus")
            static let breathe = LocalizedStringKey("meditation.category.breathe")
            static let morning = LocalizedStringKey("meditation.category.morning")
            static let anxiety = LocalizedStringKey("meditation.category.anxiety")
            static let relaxation = LocalizedStringKey("meditation.category.relaxation")
            static let gratitude = LocalizedStringKey("meditation.category.gratitude")
            static let selfLove = LocalizedStringKey("meditation.category.self_love")
        }
    }

    // MARK: - 个人资料
    enum Profile {
        static let title = LocalizedStringKey("profile.title")
        static let statistics = LocalizedStringKey("profile.statistics")
        static let achievements = LocalizedStringKey("profile.achievements")
        static let dailyGoals = LocalizedStringKey("profile.daily_goals")
        static let weeklyGoals = LocalizedStringKey("profile.weekly_goals")
        static let editProfile = LocalizedStringKey("profile.edit_profile")
        static let settings = LocalizedStringKey("profile.settings")
        static let totalWorkouts = LocalizedStringKey("profile.total_workouts")
        static let totalMinutes = LocalizedStringKey("profile.total_minutes")
        static let totalCalories = LocalizedStringKey("profile.total_calories")
        static let averagePerWeek = LocalizedStringKey("profile.average_per_week")
        static let memberSince = LocalizedStringKey("profile.member_since")
        static let personalInfo = LocalizedStringKey("profile.personal_info")
        static let firstName = LocalizedStringKey("profile.first_name")
        static let lastName = LocalizedStringKey("profile.last_name")
        static let email = LocalizedStringKey("profile.email")
        static let phone = LocalizedStringKey("profile.phone")
        static let dateOfBirth = LocalizedStringKey("profile.date_of_birth")
        static let gender = LocalizedStringKey("profile.gender")
        static let height = LocalizedStringKey("profile.height")
        static let weight = LocalizedStringKey("profile.weight")
        static let fitnessLevel = LocalizedStringKey("profile.fitness_level")
        static let goals = LocalizedStringKey("profile.goals")
        static let noAchievements = LocalizedStringKey("profile.no_achievements")
        static let keepWorking = LocalizedStringKey("profile.keep_working")

        // 设置
        enum Settings {
            static let account = LocalizedStringKey("profile.settings.account")
            static let preferences = LocalizedStringKey("profile.settings.preferences")
            static let notifications = LocalizedStringKey("profile.settings.notifications")
            static let privacy = LocalizedStringKey("profile.settings.privacy")
            static let help = LocalizedStringKey("profile.settings.help")
            static let about = LocalizedStringKey("profile.settings.about")
            static let signOut = LocalizedStringKey("profile.settings.sign_out")
            static let deleteAccount = LocalizedStringKey("profile.settings.delete_account")
        }
    }

    // MARK: - 设置
    enum Settings {
        static let title = LocalizedStringKey("settings.title")
        static let notifications = LocalizedStringKey("settings.notifications")
        static let darkMode = LocalizedStringKey("settings.dark_mode")
        static let language = LocalizedStringKey("settings.language")
        static let units = LocalizedStringKey("settings.units")
        static let metric = LocalizedStringKey("settings.metric")
        static let imperial = LocalizedStringKey("settings.imperial")
        static let sound = LocalizedStringKey("settings.sound")
        static let vibration = LocalizedStringKey("settings.vibration")
        static let autoPlay = LocalizedStringKey("settings.auto_play")
        static let downloadOverWifi = LocalizedStringKey("settings.download_over_wifi")
        static let clearCache = LocalizedStringKey("settings.clear_cache")
        static let cacheCleared = LocalizedStringKey("settings.cache_cleared")
        static let privacyPolicy = LocalizedStringKey("settings.privacy_policy")
        static let termsOfService = LocalizedStringKey("settings.terms_of_service")
        static let appVersion = LocalizedStringKey("settings.app_version")
        static let rateApp = LocalizedStringKey("settings.rate_app")
        static let shareApp = LocalizedStringKey("settings.share_app")
        static let contactUs = LocalizedStringKey("settings.contact_us")
        static let faq = LocalizedStringKey("settings.faq")
    }

    // MARK: - 健康数据
    enum Health {
        static let title = LocalizedStringKey("health.title")
        static let healthData = LocalizedStringKey("health.health_data")
        static let steps = LocalizedStringKey("health.steps")
        static let heartRate = LocalizedStringKey("health.heart_rate")
        static let sleep = LocalizedStringKey("health.sleep")
        static let calories = LocalizedStringKey("health.calories")
        static let activeCalories = LocalizedStringKey("health.active_calories")
        static let restingCalories = LocalizedStringKey("health.resting_calories")
        static let distance = LocalizedStringKey("health.distance")
        static let flightsClimbed = LocalizedStringKey("health.flights_climbed")
        static let exerciseMinutes = LocalizedStringKey("health.exercise_minutes")
        static let standHours = LocalizedStringKey("health.stand_hours")
        static let weight = LocalizedStringKey("health.weight")
        static let bodyFat = LocalizedStringKey("health.body_fat")
        static let bmi = LocalizedStringKey("health.bmi")
        static let bloodPressure = LocalizedStringKey("health.blood_pressure")
        static let bloodOxygen = LocalizedStringKey("health.blood_oxygen")
        static let respiratoryRate = LocalizedStringKey("health.respiratory_rate")
        static let bodyTemperature = LocalizedStringKey("health.body_temperature")
        static let waterIntake = LocalizedStringKey("health.water_intake")
        static let connectHealthKit = LocalizedStringKey("health.connect_health_kit")
        static let healthKitConnected = LocalizedStringKey("health.health_kit_connected")
        static let healthKitDisconnected = LocalizedStringKey("health.health_kit_disconnected")
        static let syncNow = LocalizedStringKey("health.sync_now")
        static let lastSynced = LocalizedStringKey("health.last_synced")
        static let noDataAvailable = LocalizedStringKey("health.no_data_available")
        static let enableHealthKit = LocalizedStringKey("health.enable_health_kit")
        static let goal = LocalizedStringKey("health.goal")
        static let average = LocalizedStringKey("health.average")
        static let minimum = LocalizedStringKey("health.minimum")
        static let maximum = LocalizedStringKey("health.maximum")
        static let current = LocalizedStringKey("health.current")
        static let bpm = LocalizedStringKey("health.bpm")
        static let hoursSlept = LocalizedStringKey("health.hours_slept")
        static let sleepQuality = LocalizedStringKey("health.sleep_quality")
        static let awake = LocalizedStringKey("health.awake")
        static let lightSleep = LocalizedStringKey("health.light_sleep")
        static let deepSleep = LocalizedStringKey("health.deep_sleep")
        static let remSleep = LocalizedStringKey("health.rem_sleep")
    }

    // MARK: - 历史记录
    enum History {
        static let title = LocalizedStringKey("history.title")
        static let activityHistory = LocalizedStringKey("history.activity_history")
        static let workoutHistory = LocalizedStringKey("history.workout_history")
        static let meditationHistory = LocalizedStringKey("history.meditation_history")
        static let allActivity = LocalizedStringKey("history.all_activity")
        static let noHistory = LocalizedStringKey("history.no_history")
        static let startTracking = LocalizedStringKey("history.start_tracking")
        static let deleteEntry = LocalizedStringKey("history.delete_entry")
        static let deleteConfirm = LocalizedStringKey("history.delete_confirm")
        static let exportData = LocalizedStringKey("history.export_data")
        static let filterByDate = LocalizedStringKey("history.filter_by_date")
        static let filterByType = LocalizedStringKey("history.filter_by_type")
        static let sortByDate = LocalizedStringKey("history.sort_by_date")
        static let sortByDuration = LocalizedStringKey("history.sort_by_duration")
        static let sortByCalories = LocalizedStringKey("history.sort_by_calories")
        static let newest = LocalizedStringKey("history.newest")
        static let oldest = LocalizedStringKey("history.oldest")
    }

    // MARK: - 通知
    enum Notification {
        static let title = LocalizedStringKey("notification.title")
        static let settings = LocalizedStringKey("notification.settings")
        static let enabled = LocalizedStringKey("notification.enabled")
        static let disabled = LocalizedStringKey("notification.disabled")
        static let dailyReminder = LocalizedStringKey("notification.daily_reminder")
        static let workoutReminder = LocalizedStringKey("notification.workout_reminder")
        static let meditationReminder = LocalizedStringKey("notification.meditation_reminder")
        static let goalReminder = LocalizedStringKey("notification.goal_reminder")
        static let achievementAlert = LocalizedStringKey("notification.achievement_alert")
        static let weeklyReport = LocalizedStringKey("notification.weekly_report")
        static let reminderTime = LocalizedStringKey("notification.reminder_time")
        static let frequency = LocalizedStringKey("notification.frequency")
        static let daily = LocalizedStringKey("notification.daily")
        static let weekdays = LocalizedStringKey("notification.weekdays")
        static let weekends = LocalizedStringKey("notification.weekends")
        static let custom = LocalizedStringKey("notification.custom")
        static let soundOn = LocalizedStringKey("notification.sound_on")
        static let vibrationOn = LocalizedStringKey("notification.vibration_on")
        static let notificationPermission = LocalizedStringKey("notification.permission")
        static let enableNotifications = LocalizedStringKey("notification.enable")
        static let goToSettings = LocalizedStringKey("notification.go_to_settings")
    }

    // MARK: - 单位
    enum Unit {
        static let steps = LocalizedStringKey("unit.steps")
        static let calories = LocalizedStringKey("unit.calories")
        static let kcal = LocalizedStringKey("unit.kcal")
        static let minutes = LocalizedStringKey("unit.minutes")
        static let hours = LocalizedStringKey("unit.hours")
        static let seconds = LocalizedStringKey("unit.seconds")
        static let km = LocalizedStringKey("unit.km")
        static let miles = LocalizedStringKey("unit.miles")
        static let meters = LocalizedStringKey("unit.meters")
        static let feet = LocalizedStringKey("unit.feet")
        static let kg = LocalizedStringKey("unit.kg")
        static let lbs = LocalizedStringKey("unit.lbs")
        static let cm = LocalizedStringKey("unit.cm")
        static let inch = LocalizedStringKey("unit.inch")
        static let bpm = LocalizedStringKey("unit.bpm")
        static let percent = LocalizedStringKey("unit.percent")
    }

    // MARK: - 时间
    enum Time {
        static let seconds = LocalizedStringKey("time.seconds")
        static let minutes = LocalizedStringKey("time.minutes")
        static let hours = LocalizedStringKey("time.hours")
        static let days = LocalizedStringKey("time.days")
        static let weeks = LocalizedStringKey("time.weeks")
        static let months = LocalizedStringKey("time.months")
        static let years = LocalizedStringKey("time.years")
        static let ago = LocalizedStringKey("time.ago")
        static let remaining = LocalizedStringKey("time.remaining")
        static let elapsed = LocalizedStringKey("time.elapsed")
    }

    // MARK: - 辅助方法：获取字符串值（非 SwiftUI）
    static func string(_ key: String, comment: String = "") -> String {
        NSLocalizedString(key, comment: comment)
    }
}

// MARK: - String Extension for Localization
extension String {
    /// 将字符串转换为本地化字符串
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// 带参数的本地化字符串
    func localized(with arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}

// MARK: - 使用示例
/*

 在 SwiftUI 视图中使用：

 ```swift
 // 方法 1: 使用 L10n 枚举（推荐，类型安全）
 Text(L10n.Auth.login)
 Text(L10n.Workout.Category.strength)

 // 方法 2: 直接使用 LocalizedStringKey
 Text(LocalizedStringKey("auth.login"))

 // 方法 3: 使用 String extension（在非 SwiftUI 代码中）
 let loginText = "auth.login".localized
 ```

 带参数的本地化：

 ```swift
 // 在 Localizable.xcstrings 中定义：
 // "workout.completed" : "完成了 %d 次锻炼"

 let message = "workout.completed".localized(with: 5)
 // 输出: "完成了 5 次锻炼"
 ```

 */
