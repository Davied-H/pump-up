//
//  HealthKitManager.swift
//  FitnessApp
//
//  管理 HealthKit 数据同步
//

import Foundation
import HealthKit

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    @Published var isAuthorized: Bool = false
    
    private init() {}
    
    // MARK: - Authorization
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit 在此设备上不可用")
            return
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
            isAuthorized = true
            print("HealthKit 授权成功")
        } catch {
            print("HealthKit 授权失败: \(error)")
            isAuthorized = false
        }
    }
    
    // MARK: - Reading Data
    func fetchTodaySteps() async -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return 0
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let steps = Int(sum.doubleValue(for: HKUnit.count()))
                continuation.resume(returning: steps)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayDistance() async -> Double {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return 0
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: distanceType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let distance = sum.doubleValue(for: HKUnit.meter()) / 1000.0 // 转换为公里
                continuation.resume(returning: distance)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayCalories() async -> Double {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return 0
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: calorieType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                continuation.resume(returning: calories)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayActiveMinutes() async -> Int {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            return 0
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: exerciseType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let minutes = Int(sum.doubleValue(for: HKUnit.minute()))
                continuation.resume(returning: minutes)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Writing Data
    func saveWorkout(name: String, startDate: Date, endDate: Date, calories: Double) async {
        let workoutType = HKWorkoutActivityType.traditionalStrengthTraining
        let energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        
        let workout = HKWorkout(
            activityType: workoutType,
            start: startDate,
            end: endDate,
            duration: endDate.timeIntervalSince(startDate),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: ["name": name]
        )
        
        do {
            try await healthStore.save(workout)
            print("训练已保存到 HealthKit: \(name)")
        } catch {
            print("保存训练失败: \(error)")
        }
    }
    
    // MARK: - Sync to Server
    func syncActivityToServer() async {
        let steps = await fetchTodaySteps()
        let distance = await fetchTodayDistance()
        let calories = await fetchTodayCalories()
        let activeMinutes = await fetchTodayActiveMinutes()
        
        print("同步活动数据到服务器:")
        print("  步数: \(steps)")
        print("  距离: \(distance) km")
        print("  卡路里: \(calories) kcal")
        print("  活跃分钟: \(activeMinutes) min")
        
        // 实现发送数据到服务器的逻辑
        // 例如: try await APIService.shared.syncActivity(steps: steps, distance: distance, calories: calories, activeMinutes: activeMinutes)
    }
    
    // MARK: - Background Observation
    func enableBackgroundDelivery() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        do {
            try await healthStore.enableBackgroundDelivery(
                for: stepType,
                frequency: .hourly
            )
            print("HealthKit 后台更新已启用")
        } catch {
            print("启用 HealthKit 后台更新失败: \(error)")
        }
    }
    
    func observeStepChanges(handler: @escaping () -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { _, completionHandler, error in
            if let error = error {
                print("步数观察查询错误: \(error)")
                return
            }
            
            // 调用处理器
            Task { @MainActor in
                handler()
            }
            
            // 必须调用以允许后台更新
            completionHandler()
        }
        
        healthStore.execute(query)
    }
}
