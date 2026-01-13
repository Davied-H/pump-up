//
//  HealthKitManager.swift
//  FitnessApp
//
//  HealthKit集成服务 - 管理健康数据的读取和同步
//

import Foundation
import HealthKit

// MARK: - HealthKit数据模型

struct HealthKitActivityData {
    var steps: Int
    var distance: Double // 米
    var activeEnergyBurned: Double // 卡路里
    var exerciseMinutes: Int
}

struct HeartRateSample: Identifiable {
    var id = UUID()
    var value: Double // BPM
    var timestamp: Date
}

struct SleepAnalysis: Identifiable {
    var id = UUID()
    var date: Date
    var totalSleepDuration: TimeInterval // 秒
    var sleepStart: Date?
    var sleepEnd: Date?
}

struct BodyMetrics {
    var height: Double? // cm
    var weight: Double? // kg
    var lastUpdated: Date?
}

// MARK: - HealthKit Manager

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()

    @Published var isAuthorized = false
    @Published var todayActivity: HealthKitActivityData?
    @Published var latestHeartRate: Double?
    @Published var bodyMetrics: BodyMetrics?

    private init() {
        checkAuthorizationStatus()
    }

    // MARK: - 检查HealthKit是否可用
    var isHealthKitAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    // MARK: - 权限相关
    private func checkAuthorizationStatus() {
        guard isHealthKitAvailable else {
            isAuthorized = false
            return
        }

        // 检查步数权限状态作为代表
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let status = healthStore.authorizationStatus(for: stepType)
        isAuthorized = status == .sharingAuthorized
    }

    /// 请求HealthKit权限
    func requestAuthorization() async -> Bool {
        guard isHealthKitAvailable else { return false }

        // 需要读取的数据类型
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]

        // 需要写入的数据类型（可选）
        let writeTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
            checkAuthorizationStatus()
            return isAuthorized
        } catch {
            print("HealthKit授权失败: \(error)")
            return false
        }
    }

    // MARK: - 数据读取

    /// 获取今日活动数据
    func fetchTodayActivity() async -> HealthKitActivityData? {
        guard isAuthorized else { return nil }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        async let steps = fetchSteps(from: startOfDay, to: now)
        async let distance = fetchDistance(from: startOfDay, to: now)
        async let calories = fetchActiveEnergy(from: startOfDay, to: now)
        async let exerciseMinutes = fetchExerciseMinutes(from: startOfDay, to: now)

        let (s, d, c, e) = await (steps, distance, calories, exerciseMinutes)

        let activity = HealthKitActivityData(
            steps: s,
            distance: d,
            activeEnergyBurned: c,
            exerciseMinutes: e
        )

        todayActivity = activity
        return activity
    }

    /// 获取步数
    private func fetchSteps(from startDate: Date, to endDate: Date) async -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return 0 }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: Int(steps))
            }

            healthStore.execute(query)
        }
    }

    /// 获取距离（米）
    private func fetchDistance(from startDate: Date, to endDate: Date) async -> Double {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return 0 }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: distanceType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let distance = result?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                continuation.resume(returning: distance)
            }

            healthStore.execute(query)
        }
    }

    /// 获取活跃能量消耗（卡路里）
    private func fetchActiveEnergy(from startDate: Date, to endDate: Date) async -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return 0 }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: energyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let calories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: calories)
            }

            healthStore.execute(query)
        }
    }

    /// 获取锻炼时间（分钟）
    private func fetchExerciseMinutes(from startDate: Date, to endDate: Date) async -> Int {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return 0 }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: exerciseType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let minutes = result?.sumQuantity()?.doubleValue(for: .minute()) ?? 0
                continuation.resume(returning: Int(minutes))
            }

            healthStore.execute(query)
        }
    }

    /// 获取最新心率
    func fetchLatestHeartRate() async -> Double? {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return nil }

        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                if let sample = samples?.first as? HKQuantitySample {
                    let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    self.latestHeartRate = heartRate
                    continuation.resume(returning: heartRate)
                } else {
                    continuation.resume(returning: nil)
                }
            }

            healthStore.execute(query)
        }
    }

    /// 获取心率历史数据
    func fetchHeartRateHistory(from startDate: Date, to endDate: Date) async -> [HeartRateSample] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let heartRateSamples = (samples as? [HKQuantitySample])?.map { sample in
                    HeartRateSample(
                        value: sample.quantity.doubleValue(for: HKUnit(from: "count/min")),
                        timestamp: sample.startDate
                    )
                } ?? []
                continuation.resume(returning: heartRateSamples)
            }

            healthStore.execute(query)
        }
    }

    /// 获取身体指标（身高、体重）
    func fetchBodyMetrics() async -> BodyMetrics? {
        async let height = fetchLatestHeight()
        async let weight = fetchLatestWeight()

        let (h, w) = await (height, weight)

        let metrics = BodyMetrics(
            height: h,
            weight: w,
            lastUpdated: Date()
        )

        bodyMetrics = metrics
        return metrics
    }

    private func fetchLatestHeight() async -> Double? {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height) else { return nil }

        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: heightType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                if let sample = samples?.first as? HKQuantitySample {
                    let height = sample.quantity.doubleValue(for: .meterUnit(with: .centi))
                    continuation.resume(returning: height)
                } else {
                    continuation.resume(returning: nil)
                }
            }

            healthStore.execute(query)
        }
    }

    private func fetchLatestWeight() async -> Double? {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return nil }

        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                if let sample = samples?.first as? HKQuantitySample {
                    let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                    continuation.resume(returning: weight)
                } else {
                    continuation.resume(returning: nil)
                }
            }

            healthStore.execute(query)
        }
    }

    /// 获取睡眠数据
    func fetchSleepAnalysis(for date: Date) async -> SleepAnalysis? {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return nil }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                guard let sleepSamples = samples as? [HKCategorySample], !sleepSamples.isEmpty else {
                    continuation.resume(returning: nil)
                    return
                }

                // 计算总睡眠时长（只计算实际睡眠，不包括清醒时间）
                var totalSleep: TimeInterval = 0
                var sleepStart: Date?
                var sleepEnd: Date?

                for sample in sleepSamples {
                    // HKCategoryValueSleepAnalysis.asleepUnspecified = 1 (iOS 16+)
                    // 旧版本使用 .inBed 和 .asleep
                    if sample.value != HKCategoryValueSleepAnalysis.awake.rawValue {
                        totalSleep += sample.endDate.timeIntervalSince(sample.startDate)

                        if sleepStart == nil {
                            sleepStart = sample.startDate
                        }
                        sleepEnd = sample.endDate
                    }
                }

                let analysis = SleepAnalysis(
                    date: date,
                    totalSleepDuration: totalSleep,
                    sleepStart: sleepStart,
                    sleepEnd: sleepEnd
                )
                continuation.resume(returning: analysis)
            }

            healthStore.execute(query)
        }
    }

    // MARK: - 同步到服务器

    /// 同步今日活动数据到服务器
    func syncActivityToServer() async {
        guard let activity = await fetchTodayActivity() else { return }

        do {
            _ = try await APIService.shared.updateTodayActivity(
                steps: activity.steps,
                distance: activity.distance / 1000, // 转换为公里
                calories: activity.activeEnergyBurned,
                minutes: activity.exerciseMinutes
            )
            print("HealthKit数据同步成功")
        } catch {
            print("HealthKit数据同步失败: \(error)")
        }
    }
}
