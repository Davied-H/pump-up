//
//  APIService.swift
//  FitnessApp
//

import Foundation

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unauthorized
    case serverError(Int, String)
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .invalidResponse:
            return "服务器响应无效"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .unauthorized:
            return "未授权，请重新登录"
        case .serverError(let code, let message):
            return "服务器错误 (\(code)): \(message)"
        case .notFound:
            return "请求的资源不存在"
        }
    }
}

// MARK: - DTOs (Data Transfer Objects)
struct UserDTO: Codable {
    let id: String
    let name: String
    let email: String
    let avatarUrl: String?
    let height: Double
    let weight: Double
    let age: Int
    let gender: String
    let fitnessGoal: String
    let dailyStepGoal: Int
    let dailyCalorieGoal: Int
}

struct DailyActivityDTO: Codable {
    let date: String
    let steps: Int
    let distance: Double
    let caloriesBurned: Double
    let activeMinutes: Int
}

struct WorkoutDTO: Codable {
    let id: String
    let name: String
    let category: String
    let duration: Int
    let caloriesBurned: Int
    let exercises: [ExerciseDTO]?
    let difficulty: String
    let imageName: String
    let description: String
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
}

struct AchievementDTO: Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let isUnlocked: Bool
    let unlockedAt: String?
    let category: String
}

struct StatisticsDTO: Codable {
    let totalWorkouts: Int
    let totalCaloriesBurned: Int
    let totalActiveMinutes: Int
    let currentStreak: Int
    let longestStreak: Int
    let averageStepsPerDay: Int
    let totalMeditationMinutes: Int
}

// MARK: - API Response Wrapper
struct APIResponse<T: Codable>: Codable {
    let code: Int
    let msg: String
    let data: T
}

// MARK: - Auth Response Data
struct LoginResponseData: Codable {
    let token: String
    let user: UserDTO
}

struct RegisterResponseData: Codable {
    let token: String
    let user: UserDTO
}

// Type aliases for wrapped responses
typealias LoginResponse = APIResponse<LoginResponseData>
typealias RegisterResponse = APIResponse<RegisterResponseData>

// MARK: - API Service
actor APIService {
    static let shared = APIService()
    
    private let baseURL = "http://127.0.0.1:8080/api/v1"
    private var authToken: String?
    
    var isLoggedIn: Bool {
        authToken != nil
    }
    
    private init() {
        // Load saved token
        authToken = UserDefaults.standard.string(forKey: "authToken")
    }
    
    // MARK: - Authentication
    func login(email: String, password: String) async throws -> LoginResponseData {
        let endpoint = "\(baseURL)/auth/login"
        let body = ["email": email, "password": password]
        
        let response: LoginResponse = try await performRequest(
            url: endpoint,
            method: "POST",
            body: body,
            requiresAuth: false
        )
        
        authToken = response.data.token
        UserDefaults.standard.set(response.data.token, forKey: "authToken")
        
        return response.data
    }
    
    func register(email: String, password: String, name: String) async throws -> RegisterResponseData {
        let endpoint = "\(baseURL)/auth/register"
        let body = ["email": email, "password": password, "name": name]
        
        let response: RegisterResponse = try await performRequest(
            url: endpoint,
            method: "POST",
            body: body,
            requiresAuth: false
        )
        
        authToken = response.data.token
        UserDefaults.standard.set(response.data.token, forKey: "authToken")
        
        return response.data
    }
    
    func logout() {
        authToken = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    // MARK: - User Profile
    func getProfile() async throws -> UserDTO {
        let endpoint = "\(baseURL)/user/profile"
        let response: APIResponse<UserDTO> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    func updateProfile(_ user: UserDTO) async throws -> UserDTO {
        let endpoint = "\(baseURL)/user/profile"
        let response: APIResponse<UserDTO> = try await performRequest(url: endpoint, method: "PUT", body: user)
        return response.data
    }
    
    // MARK: - Activities
    func getTodayActivity() async throws -> DailyActivityDTO {
        let endpoint = "\(baseURL)/activities/today"
        let response: APIResponse<DailyActivityDTO> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    func getWeeklyActivity() async throws -> [DailyActivityDTO] {
        let endpoint = "\(baseURL)/activities/week"
        let response: APIResponse<[DailyActivityDTO]> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    func updateTodayActivity(steps: Int) async throws -> DailyActivityDTO {
        let endpoint = "\(baseURL)/activities/today"
        let body = ["steps": steps]
        let response: APIResponse<DailyActivityDTO> = try await performRequest(url: endpoint, method: "PUT", body: body)
        return response.data
    }
    
    // MARK: - Workouts
    func getWorkouts() async throws -> [WorkoutDTO] {
        let endpoint = "\(baseURL)/workouts"
        let response: APIResponse<[WorkoutDTO]> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    func getWorkout(id: String) async throws -> WorkoutDTO {
        let endpoint = "\(baseURL)/workouts/\(id)"
        let response: APIResponse<WorkoutDTO> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    // MARK: - Meditations
    func getMeditations() async throws -> [MeditationDTO] {
        let endpoint = "\(baseURL)/meditations"
        let response: APIResponse<[MeditationDTO]> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    // MARK: - Achievements
    func getAchievements() async throws -> [AchievementDTO] {
        let endpoint = "\(baseURL)/achievements"
        let response: APIResponse<[AchievementDTO]> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    // MARK: - Statistics
    func getStatistics() async throws -> StatisticsDTO {
        let endpoint = "\(baseURL)/statistics"
        let response: APIResponse<StatisticsDTO> = try await performRequest(url: endpoint, method: "GET")
        return response.data
    }
    
    // MARK: - Generic Request Handler
    private func performRequest<T: Decodable>(
        url: String,
        method: String,
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(body)
            
            // Debug: Print request body
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request to: \(url)")
                print("📤 Request body: \(jsonString)")
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Debug: Print response
            print("📥 Response status: \(httpResponse.statusCode)")
            print("📥 Response data size: \(data.count) bytes")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 Response body: \(jsonString)")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                // Check if data is empty
                if data.isEmpty {
                    throw APIError.decodingError(
                        NSError(
                            domain: "APIService",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "服务器返回空数据"]
                        )
                    )
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    return try decoder.decode(T.self, from: data)
                } catch let decodingError {
                    print("❌ Decoding error: \(decodingError)")
                    // Print detailed error information
                    if let decodingError = decodingError as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("❌ Missing key: \(key.stringValue) at \(context.codingPath)")
                        case .typeMismatch(let type, let context):
                            print("❌ Type mismatch for type: \(type) at \(context.codingPath)")
                        case .valueNotFound(let type, let context):
                            print("❌ Value not found for type: \(type) at \(context.codingPath)")
                        case .dataCorrupted(let context):
                            print("❌ Data corrupted at \(context.codingPath): \(context.debugDescription)")
                        @unknown default:
                            print("❌ Unknown decoding error")
                        }
                    }
                    throw APIError.decodingError(decodingError)
                }
            case 401:
                throw APIError.unauthorized
            case 404:
                throw APIError.notFound
            case 400...599:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw APIError.serverError(httpResponse.statusCode, message)
            default:
                throw APIError.invalidResponse
            }
        } catch let error as APIError {
            throw error
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
}
