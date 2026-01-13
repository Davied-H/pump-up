//
//  APIService.swift
//  FitnessApp
//
//  Network layer for communicating with backend API
//

import Foundation

// MARK: - API Configuration
enum APIConfig {
    #if DEBUG
    static let baseURL = "http://localhost:8080/api/v1"
    #else
    static let baseURL = "https://your-production-domain.com/api/v1"
    #endif

    static let timeout: TimeInterval = 30
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int, String)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - API Response Models
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}

struct PaginatedResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let page: Int
    let pageSize: Int
    let totalCount: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case success, data, page
        case pageSize = "page_size"
        case totalCount = "total_count"
        case totalPages = "total_pages"
    }
}

// MARK: - Auth Models
struct AuthResponse: Codable {
    let token: String
    let user: UserDTO
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

// MARK: - DTO Models (Data Transfer Objects)
struct UserDTO: Codable {
    let id: String
    let email: String
    let name: String
    let avatarUrl: String?
    let height: Double
    let weight: Double
    let age: Int
    let gender: String
    let fitnessGoal: String
    let dailyStepGoal: Int
    let dailyCalorieGoal: Int

    enum CodingKeys: String, CodingKey {
        case id, email, name, height, weight, age, gender
        case avatarUrl = "avatar_url"
        case fitnessGoal = "fitness_goal"
        case dailyStepGoal = "daily_step_goal"
        case dailyCalorieGoal = "daily_calorie_goal"
    }
}

struct DailyActivityDTO: Codable {
    let id: String
    let userId: String
    let date: String
    let steps: Int
    let distance: Double
    let caloriesBurned: Double
    let activeMinutes: Int

    enum CodingKeys: String, CodingKey {
        case id, date, steps, distance
        case userId = "user_id"
        case caloriesBurned = "calories_burned"
        case activeMinutes = "active_minutes"
    }
}

struct WorkoutDTO: Codable {
    let id: String
    let name: String
    let category: String
    let duration: Int
    let caloriesBurned: Int
    let difficulty: String
    let imageName: String
    let description: String
    let exercises: [ExerciseDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, category, duration, difficulty, description, exercises
        case caloriesBurned = "calories_burned"
        case imageName = "image_name"
    }
}

struct ExerciseDTO: Codable {
    let id: String
    let name: String
    let sets: Int
    let reps: Int
    let duration: Int?
    let restTime: Int
    let description: String
    let muscleGroups: String
    let imageName: String

    enum CodingKeys: String, CodingKey {
        case id, name, sets, reps, duration, description
        case restTime = "rest_time"
        case muscleGroups = "muscle_groups"
        case imageName = "image_name"
    }
}

struct MeditationDTO: Codable {
    let id: String
    let name: String
    let category: String
    let duration: Int
    let description: String
    let audioFileName: String?
    let imageName: String
    let isPremium: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, category, duration, description
        case audioFileName = "audio_file_name"
        case imageName = "image_name"
        case isPremium = "is_premium"
    }
}

struct AchievementDTO: Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let category: String
    let isUnlocked: Bool
    let unlockedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, category
        case iconName = "icon_name"
        case isUnlocked = "is_unlocked"
        case unlockedAt = "unlocked_at"
    }
}

struct StatisticsDTO: Codable {
    let totalWorkouts: Int
    let totalCaloriesBurned: Int
    let totalActiveMinutes: Int
    let currentStreak: Int
    let longestStreak: Int
    let averageStepsPerDay: Int
    let totalMeditationMinutes: Int

    enum CodingKeys: String, CodingKey {
        case totalWorkouts = "total_workouts"
        case totalCaloriesBurned = "total_calories_burned"
        case totalActiveMinutes = "total_active_minutes"
        case currentStreak = "current_streak"
        case longestStreak = "longest_streak"
        case averageStepsPerDay = "average_steps_per_day"
        case totalMeditationMinutes = "total_meditation_minutes"
    }
}

// MARK: - New DTO Models for API补全

/// 分页结果通用模型
struct PaginatedResult<T> {
    let items: [T]
    let page: Int
    let pageSize: Int
    let totalCount: Int
    let totalPages: Int

    var hasNextPage: Bool {
        return page < totalPages
    }
}

/// 锻炼会话DTO（包含嵌套的Workout）
struct WorkoutSessionDTO: Codable {
    let id: String
    let userId: String
    let workoutId: String
    let startTime: String
    let endTime: String?
    let caloriesBurned: Int
    let completed: Bool
    let notes: String?
    let workout: WorkoutDTO?

    enum CodingKeys: String, CodingKey {
        case id, completed, notes, workout
        case userId = "user_id"
        case workoutId = "workout_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case caloriesBurned = "calories_burned"
    }
}

/// 冥想记录DTO（包含嵌套的MeditationSession）
struct MeditationLogDTO: Codable {
    let id: String
    let userId: String
    let meditationSessionId: String
    let completedAt: String
    let durationCompleted: Int
    let meditationSession: MeditationDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case meditationSessionId = "meditation_session_id"
        case completedAt = "completed_at"
        case durationCompleted = "duration_completed"
        case meditationSession = "meditation_session"
    }
}

/// 冥想统计DTO
struct MeditationStatsDTO: Codable {
    let totalMinutes: Int
    let totalSessions: Int

    enum CodingKeys: String, CodingKey {
        case totalMinutes = "total_minutes"
        case totalSessions = "total_sessions"
    }
}

/// 用户成就DTO（已解锁的成就）
struct UserAchievementDTO: Codable {
    let id: String
    let userId: String
    let achievementId: String
    let unlockedAt: String
    let achievement: AchievementBaseDTO?

    enum CodingKeys: String, CodingKey {
        case id, achievement
        case userId = "user_id"
        case achievementId = "achievement_id"
        case unlockedAt = "unlocked_at"
    }
}

/// 成就基础信息DTO
struct AchievementBaseDTO: Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let category: String
    let threshold: Int

    enum CodingKeys: String, CodingKey {
        case id, title, description, category, threshold
        case iconName = "icon_name"
    }
}

// MARK: - API Service
actor APIService {
    static let shared = APIService()

    private var token: String? {
        get { UserDefaults.standard.string(forKey: "auth_token") }
        set { UserDefaults.standard.set(newValue, forKey: "auth_token") }
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    // Token刷新状态管理
    private var isRefreshing = false
    private var refreshContinuations: [CheckedContinuation<Void, Error>] = []

    private init() {}

    // MARK: - Helper Methods
    private func createRequest(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        requiresAuth: Bool = true
    ) throws -> URLRequest {
        guard let url = URL(string: "\(APIConfig.baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = APIConfig.timeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth, let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        return request
    }

    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        if httpResponse.statusCode >= 400 {
            if let errorResponse = try? decoder.decode(APIResponse<String>.self, from: data) {
                throw APIError.serverError(httpResponse.statusCode, errorResponse.error ?? "Unknown error")
            }
            throw APIError.serverError(httpResponse.statusCode, "Server error")
        }

        do {
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            if let responseData = apiResponse.data {
                return responseData
            }
            throw APIError.noData
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        }
    }

    /// 执行分页请求
    private func performPaginatedRequest<T: Codable>(_ request: URLRequest) async throws -> PaginatedResult<T> {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        if httpResponse.statusCode >= 400 {
            if let errorResponse = try? decoder.decode(APIResponse<String>.self, from: data) {
                throw APIError.serverError(httpResponse.statusCode, errorResponse.error ?? "Unknown error")
            }
            throw APIError.serverError(httpResponse.statusCode, "Server error")
        }

        do {
            let paginatedResponse = try decoder.decode(PaginatedResponse<[T]>.self, from: data)
            return PaginatedResult(
                items: paginatedResponse.data ?? [],
                page: paginatedResponse.page,
                pageSize: paginatedResponse.pageSize,
                totalCount: paginatedResponse.totalCount,
                totalPages: paginatedResponse.totalPages
            )
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        }
    }

    /// 带自动Token刷新的请求方法
    private func performRequestWithRefresh<T: Codable>(_ request: URLRequest) async throws -> T {
        do {
            return try await performRequest(request)
        } catch APIError.unauthorized {
            // Token过期，尝试刷新
            try await refreshTokenIfNeeded()
            // 用新token重试请求
            var newRequest = request
            if let token = token {
                newRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return try await performRequest(newRequest)
        }
    }

    /// 刷新Token（如果需要）
    private func refreshTokenIfNeeded() async throws {
        if isRefreshing {
            // 已在刷新中，等待完成
            try await withCheckedThrowingContinuation { continuation in
                refreshContinuations.append(continuation)
            }
            return
        }

        isRefreshing = true
        defer {
            isRefreshing = false
            // 通知所有等待的请求
            for continuation in refreshContinuations {
                continuation.resume()
            }
            refreshContinuations.removeAll()
        }

        _ = try await refreshToken()
    }

    // MARK: - Auth API
    func login(email: String, password: String) async throws -> AuthResponse {
        let body = try encoder.encode(LoginRequest(email: email, password: password))
        let request = try createRequest(endpoint: "/auth/login", method: "POST", body: body, requiresAuth: false)
        let response: AuthResponse = try await performRequest(request)
        self.token = response.token
        return response
    }

    func register(email: String, password: String, name: String) async throws -> AuthResponse {
        let body = try encoder.encode(RegisterRequest(email: email, password: password, name: name))
        let request = try createRequest(endpoint: "/auth/register", method: "POST", body: body, requiresAuth: false)
        let response: AuthResponse = try await performRequest(request)
        self.token = response.token
        return response
    }

    /// 刷新JWT Token
    func refreshToken() async throws -> String {
        let request = try createRequest(endpoint: "/auth/refresh", method: "POST")
        let response: [String: String] = try await performRequest(request)
        guard let newToken = response["token"] else {
            throw APIError.noData
        }
        self.token = newToken
        return newToken
    }

    func logout() {
        self.token = nil
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }

    var isLoggedIn: Bool {
        return token != nil
    }

    // MARK: - User API
    func getProfile() async throws -> UserDTO {
        let request = try createRequest(endpoint: "/user/profile")
        return try await performRequest(request)
    }

    func updateProfile(_ updates: [String: Any]) async throws -> UserDTO {
        let body = try JSONSerialization.data(withJSONObject: updates)
        let request = try createRequest(endpoint: "/user/profile", method: "PUT", body: body)
        return try await performRequest(request)
    }

    func getStatistics() async throws -> StatisticsDTO {
        let request = try createRequest(endpoint: "/user/statistics")
        return try await performRequest(request)
    }

    // MARK: - Activity API
    func getTodayActivity() async throws -> DailyActivityDTO {
        let request = try createRequest(endpoint: "/activity/today")
        return try await performRequest(request)
    }

    func updateTodayActivity(steps: Int? = nil, distance: Double? = nil, calories: Double? = nil, minutes: Int? = nil) async throws -> DailyActivityDTO {
        var updates: [String: Any] = [:]
        if let steps = steps { updates["steps"] = steps }
        if let distance = distance { updates["distance"] = distance }
        if let calories = calories { updates["calories_burned"] = calories }
        if let minutes = minutes { updates["active_minutes"] = minutes }

        let body = try JSONSerialization.data(withJSONObject: updates)
        let request = try createRequest(endpoint: "/activity/today", method: "PUT", body: body)
        return try await performRequest(request)
    }

    func getWeeklyActivity() async throws -> [DailyActivityDTO] {
        let request = try createRequest(endpoint: "/activity/weekly")
        return try await performRequest(request)
    }

    /// 获取活动历史（分页）
    func getActivityHistory(page: Int = 1, pageSize: Int = 30) async throws -> PaginatedResult<DailyActivityDTO> {
        let endpoint = "/activity/history?page=\(page)&page_size=\(pageSize)"
        let request = try createRequest(endpoint: endpoint)
        return try await performPaginatedRequest(request)
    }

    // MARK: - Workout API
    func getWorkouts(category: String? = nil, difficulty: String? = nil) async throws -> [WorkoutDTO] {
        var endpoint = "/workouts"
        var queryItems: [String] = []
        if let category = category { queryItems.append("category=\(category)") }
        if let difficulty = difficulty { queryItems.append("difficulty=\(difficulty)") }
        if !queryItems.isEmpty { endpoint += "?\(queryItems.joined(separator: "&"))" }

        let request = try createRequest(endpoint: endpoint)
        return try await performRequest(request)
    }

    func getWorkout(id: String) async throws -> WorkoutDTO {
        let request = try createRequest(endpoint: "/workouts/\(id)")
        return try await performRequest(request)
    }

    func startWorkout(workoutId: String) async throws -> [String: Any] {
        let body = try JSONSerialization.data(withJSONObject: ["workout_id": workoutId])
        let request = try createRequest(endpoint: "/workouts/sessions/start", method: "POST", body: body)
        return try await performRequest(request)
    }

    func completeWorkout(sessionId: String, caloriesBurned: Int, notes: String? = nil) async throws -> [String: Any] {
        var updates: [String: Any] = ["calories_burned": caloriesBurned]
        if let notes = notes { updates["notes"] = notes }

        let body = try JSONSerialization.data(withJSONObject: updates)
        let request = try createRequest(endpoint: "/workouts/sessions/\(sessionId)/complete", method: "PUT", body: body)
        return try await performRequest(request)
    }

    /// 获取锻炼历史（分页）
    func getWorkoutHistory(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResult<WorkoutSessionDTO> {
        let endpoint = "/workouts/sessions?page=\(page)&page_size=\(pageSize)"
        let request = try createRequest(endpoint: endpoint)
        return try await performPaginatedRequest(request)
    }

    // MARK: - Meditation API
    func getMeditations(category: String? = nil) async throws -> [MeditationDTO] {
        var endpoint = "/meditations"
        if let category = category { endpoint += "?category=\(category)" }

        let request = try createRequest(endpoint: endpoint)
        return try await performRequest(request)
    }

    func logMeditation(meditationId: String, durationCompleted: Int) async throws -> [String: Any] {
        let body = try JSONSerialization.data(withJSONObject: [
            "meditation_session_id": meditationId,
            "duration_completed": durationCompleted
        ])
        let request = try createRequest(endpoint: "/meditations/log", method: "POST", body: body)
        return try await performRequest(request)
    }

    /// 获取单个冥想详情
    func getMeditation(id: String) async throws -> MeditationDTO {
        let request = try createRequest(endpoint: "/meditations/\(id)")
        return try await performRequest(request)
    }

    /// 获取冥想历史（分页）
    func getMeditationHistory(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResult<MeditationLogDTO> {
        let endpoint = "/meditations/history?page=\(page)&page_size=\(pageSize)"
        let request = try createRequest(endpoint: endpoint)
        return try await performPaginatedRequest(request)
    }

    /// 获取冥想统计
    func getMeditationStats() async throws -> MeditationStatsDTO {
        let request = try createRequest(endpoint: "/meditations/stats")
        return try await performRequest(request)
    }

    // MARK: - Achievement API
    func getAchievements(category: String? = nil) async throws -> [AchievementDTO] {
        var endpoint = "/achievements"
        if let category = category { endpoint += "?category=\(category)" }

        let request = try createRequest(endpoint: endpoint)
        return try await performRequest(request)
    }

    /// 获取已解锁的成就
    func getUnlockedAchievements() async throws -> [UserAchievementDTO] {
        let request = try createRequest(endpoint: "/achievements/unlocked")
        return try await performRequest(request)
    }

    // MARK: - Public API (无需认证)
    /// 获取公开的训练列表（预览）
    func getPublicWorkouts() async throws -> [WorkoutDTO] {
        let request = try createRequest(endpoint: "/public/workouts", requiresAuth: false)
        return try await performRequest(request)
    }

    /// 获取公开的冥想列表（预览）
    func getPublicMeditations() async throws -> [MeditationDTO] {
        let request = try createRequest(endpoint: "/public/meditations", requiresAuth: false)
        return try await performRequest(request)
    }

    // MARK: - Device Token API (推送通知)
    /// 注册设备推送Token
    func registerDeviceToken(_ token: String) async throws {
        let deviceInfo: [String: Any] = [
            "token": token,
            "platform": "ios",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
            "device_model": "iPhone",
            "os_version": ProcessInfo.processInfo.operatingSystemVersionString
        ]

        let body = try JSONSerialization.data(withJSONObject: deviceInfo)
        let request = try createRequest(endpoint: "/user/device-token", method: "POST", body: body)
        let _: [String: String] = try await performRequest(request)
    }

    /// 注销设备推送Token
    func unregisterDeviceToken() async throws {
        let request = try createRequest(endpoint: "/user/device-token", method: "DELETE")
        let _: [String: String] = try await performRequest(request)
    }

    // MARK: - Health API (HealthKit同步)

    /// 同步心率数据
    func syncHeartRate(samples: [HeartRateSyncSample]) async throws -> SyncResultDTO {
        let requestBody = HeartRateSyncRequest(samples: samples)
        let body = try encoder.encode(requestBody)
        let request = try createRequest(endpoint: "/health/heart-rate/sync", method: "POST", body: body)
        return try await performRequest(request)
    }

    /// 获取心率历史
    func getHeartRateHistory(startDate: Date? = nil, endDate: Date? = nil, page: Int = 1, pageSize: Int = 100) async throws -> PaginatedResult<HeartRateSampleDTO> {
        var endpoint = "/health/heart-rate?page=\(page)&page_size=\(pageSize)"
        let formatter = ISO8601DateFormatter()
        if let startDate = startDate {
            endpoint += "&start_date=\(formatter.string(from: startDate))"
        }
        if let endDate = endDate {
            endpoint += "&end_date=\(formatter.string(from: endDate))"
        }
        let request = try createRequest(endpoint: endpoint)
        return try await performPaginatedRequest(request)
    }

    /// 获取最新心率
    func getLatestHeartRate() async throws -> HeartRateSampleDTO {
        let request = try createRequest(endpoint: "/health/heart-rate/latest")
        return try await performRequest(request)
    }

    /// 同步睡眠数据
    func syncSleep(records: [SleepSyncRecord]) async throws -> SyncResultDTO {
        let requestBody = SleepSyncRequest(records: records)
        let body = try encoder.encode(requestBody)
        let request = try createRequest(endpoint: "/health/sleep/sync", method: "POST", body: body)
        return try await performRequest(request)
    }

    /// 获取睡眠历史
    func getSleepHistory(days: Int = 30) async throws -> [SleepAnalysisDTO] {
        let request = try createRequest(endpoint: "/health/sleep?days=\(days)")
        return try await performRequest(request)
    }

    /// 获取指定日期睡眠数据
    func getSleepForDate(_ date: Date) async throws -> SleepAnalysisDTO {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date)
        let request = try createRequest(endpoint: "/health/sleep/date?date=\(dateStr)")
        return try await performRequest(request)
    }

    /// 同步体重身高数据
    func syncBodyMetrics(records: [BodyMetricsSyncRecord]) async throws -> SyncResultDTO {
        let requestBody = BodyMetricsSyncRequest(records: records)
        let body = try encoder.encode(requestBody)
        let request = try createRequest(endpoint: "/health/body-metrics/sync", method: "POST", body: body)
        return try await performRequest(request)
    }

    /// 获取体重身高历史
    func getBodyMetricsHistory(days: Int = 90) async throws -> [BodyMetricsHistoryDTO] {
        let request = try createRequest(endpoint: "/health/body-metrics?days=\(days)")
        return try await performRequest(request)
    }

    /// 批量同步健康数据
    func batchSyncHealthData(_ syncData: BatchHealthSyncRequest) async throws -> BatchSyncResultDTO {
        let body = try encoder.encode(syncData)
        let request = try createRequest(endpoint: "/health/sync", method: "POST", body: body)
        return try await performRequest(request)
    }

    /// 获取健康数据摘要
    func getHealthSummary() async throws -> HealthSummaryDTO {
        let request = try createRequest(endpoint: "/health/summary")
        return try await performRequest(request)
    }
}

// MARK: - Health Sync DTOs

/// 心率同步请求
struct HeartRateSyncRequest: Codable {
    let samples: [HeartRateSyncSample]
}

struct HeartRateSyncSample: Codable {
    let value: Double
    let timestamp: String
    let context: String?
}

/// 心率样本DTO
struct HeartRateSampleDTO: Codable {
    let id: String
    let userId: String
    let value: Double
    let timestamp: String
    let context: String?
    let source: String

    enum CodingKeys: String, CodingKey {
        case id, value, timestamp, context, source
        case userId = "user_id"
    }
}

/// 睡眠同步请求
struct SleepSyncRequest: Codable {
    let records: [SleepSyncRecord]
}

struct SleepSyncRecord: Codable {
    let date: String
    let totalSleepDuration: Int
    let deepSleepDuration: Int?
    let remSleepDuration: Int?
    let lightSleepDuration: Int?
    let sleepStart: String?
    let sleepEnd: String?
    let qualityScore: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case totalSleepDuration = "total_sleep_duration"
        case deepSleepDuration = "deep_sleep_duration"
        case remSleepDuration = "rem_sleep_duration"
        case lightSleepDuration = "light_sleep_duration"
        case sleepStart = "sleep_start"
        case sleepEnd = "sleep_end"
        case qualityScore = "quality_score"
    }
}

/// 睡眠分析DTO
struct SleepAnalysisDTO: Codable {
    let id: String
    let userId: String
    let date: String
    let totalSleepDuration: Int
    let deepSleepDuration: Int
    let remSleepDuration: Int
    let lightSleepDuration: Int
    let sleepStart: String?
    let sleepEnd: String?
    let qualityScore: Int?

    enum CodingKeys: String, CodingKey {
        case id, date
        case userId = "user_id"
        case totalSleepDuration = "total_sleep_duration"
        case deepSleepDuration = "deep_sleep_duration"
        case remSleepDuration = "rem_sleep_duration"
        case lightSleepDuration = "light_sleep_duration"
        case sleepStart = "sleep_start"
        case sleepEnd = "sleep_end"
        case qualityScore = "quality_score"
    }

    /// 总睡眠时长（小时）
    var totalSleepHours: Double {
        return Double(totalSleepDuration) / 3600
    }
}

/// 体重身高同步请求
struct BodyMetricsSyncRequest: Codable {
    let records: [BodyMetricsSyncRecord]
}

struct BodyMetricsSyncRecord: Codable {
    let recordedAt: String
    let height: Double?
    let weight: Double?
    let bodyFatPercentage: Double?

    enum CodingKeys: String, CodingKey {
        case height, weight
        case recordedAt = "recorded_at"
        case bodyFatPercentage = "body_fat_percentage"
    }
}

/// 体重身高历史DTO
struct BodyMetricsHistoryDTO: Codable {
    let id: String
    let userId: String
    let recordedAt: String
    let height: Double?
    let weight: Double?
    let bmi: Double?
    let bodyFatPercentage: Double?

    enum CodingKeys: String, CodingKey {
        case id, height, weight, bmi
        case userId = "user_id"
        case recordedAt = "recorded_at"
        case bodyFatPercentage = "body_fat_percentage"
    }
}

/// 批量同步请求
struct BatchHealthSyncRequest: Codable {
    let heartRates: [HeartRateSyncSample]?
    let sleep: [SleepSyncRecord]?
    let bodyMetrics: [BodyMetricsSyncRecord]?
    let activity: ActivitySyncData?

    enum CodingKeys: String, CodingKey {
        case sleep, activity
        case heartRates = "heart_rates"
        case bodyMetrics = "body_metrics"
    }
}

struct ActivitySyncData: Codable {
    let steps: Int?
    let distance: Double?
    let caloriesBurned: Double?
    let activeMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case steps, distance
        case caloriesBurned = "calories_burned"
        case activeMinutes = "active_minutes"
    }
}

/// 同步结果DTO
struct SyncResultDTO: Codable {
    let message: String?
    let syncedCount: Int?
    let totalSent: Int?

    enum CodingKeys: String, CodingKey {
        case message
        case syncedCount = "synced_count"
        case totalSent = "total_sent"
    }
}

/// 批量同步结果DTO
struct BatchSyncResultDTO: Codable {
    let message: String?
    let heartRatesSynced: Int?
    let sleepSynced: Int?
    let bodyMetricsSynced: Int?
    let activitySynced: Bool?

    enum CodingKeys: String, CodingKey {
        case message
        case heartRatesSynced = "heart_rates_synced"
        case sleepSynced = "sleep_synced"
        case bodyMetricsSynced = "body_metrics_synced"
        case activitySynced = "activity_synced"
    }
}

/// 健康摘要DTO
struct HealthSummaryDTO: Codable {
    let latestHeartRate: Double?
    let averageHeartRate: Double?
    let restingHeartRate: Double?
    let lastNightSleep: Int?
    let averageSleepQuality: Int?
    let currentWeight: Double?
    let currentHeight: Double?
    let currentBMI: Double?
    let weightTrend: String?

    enum CodingKeys: String, CodingKey {
        case latestHeartRate = "latest_heart_rate"
        case averageHeartRate = "average_heart_rate"
        case restingHeartRate = "resting_heart_rate"
        case lastNightSleep = "last_night_sleep"
        case averageSleepQuality = "average_sleep_quality"
        case currentWeight = "current_weight"
        case currentHeight = "current_height"
        case currentBMI = "current_bmi"
        case weightTrend = "weight_trend"
    }

    /// 昨晚睡眠时长（小时）
    var lastNightSleepHours: Double? {
        guard let seconds = lastNightSleep else { return nil }
        return Double(seconds) / 3600
    }
}
