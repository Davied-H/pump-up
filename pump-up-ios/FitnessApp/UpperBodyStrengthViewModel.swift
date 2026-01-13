//
//  UpperBodyStrengthViewModel.swift
//  FitnessApp
//
//  ViewModel for upper body strength training
//

import Foundation
import SwiftUI
import Combine

@MainActor
class UpperBodyStrengthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var exercises: [StrengthExercise] = []
    @Published var currentExerciseIndex: Int = 0
    @Published var trainingHistory: [TrainingRecord] = []
    
    @Published var currentWeight: Double = 20.0
    @Published var currentReps: Double = 12.0
    @Published var currentSetType: SetType = .working
    
    @Published var isTimerRunning: Bool = false
    @Published var timerSeconds: Int = 0
    @Published var timerProgress: CGFloat = 0.0
    
    @Published var sessionStartTime: Date = Date()
    @Published var sessionDuration: String = "00:00"
    
    // Timer
    private var timer: Timer?
    private var sessionTimer: Timer?
    private let restDuration: Int = 90 // 90 seconds rest
    
    // MARK: - Computed Properties
    var currentExercise: StrengthExercise {
        exercises.indices.contains(currentExerciseIndex) ? exercises[currentExerciseIndex] : exercises[0]
    }
    
    var totalSets: Int {
        trainingHistory.count
    }
    
    var totalVolume: Double {
        trainingHistory.reduce(0) { $0 + $1.volume }
    }
    
    var overallProgress: CGFloat {
        let totalTargetSets = exercises.reduce(0) { $0 + $1.targetSets }
        return totalTargetSets > 0 ? CGFloat(totalSets) / CGFloat(totalTargetSets) : 0.0
    }
    
    var timerDisplay: String {
        let minutes = timerSeconds / 60
        let seconds = timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Initialization
    init() {
        setupExercises()
        startSessionTimer()
    }
    
    deinit {
        timer?.invalidate()
        sessionTimer?.invalidate()
    }
    
    // MARK: - Setup
    private func setupExercises() {
        exercises = [
            StrengthExercise(
                name: "卧推",
                nameEnglish: "Bench Press",
                icon: "figure.strengthtraining.traditional",
                targetSets: 4,
                targetReps: 10,
                targetWeight: 60.0,
                muscleGroups: [.chest, .arms],
                description: "经典的胸部训练动作"
            ),
            StrengthExercise(
                name: "哑铃飞鸟",
                nameEnglish: "Dumbbell Flyes",
                icon: "figure.mixed.cardio",
                targetSets: 3,
                targetReps: 12,
                targetWeight: 15.0,
                muscleGroups: [.chest],
                description: "孤立胸部肌肉的动作"
            ),
            StrengthExercise(
                name: "肩推",
                nameEnglish: "Shoulder Press",
                icon: "figure.arms.open",
                targetSets: 4,
                targetReps: 10,
                targetWeight: 25.0,
                muscleGroups: [.shoulders, .arms],
                description: "全面发展肩部力量"
            ),
            StrengthExercise(
                name: "侧平举",
                nameEnglish: "Lateral Raise",
                icon: "figure.stand",
                targetSets: 3,
                targetReps: 15,
                targetWeight: 10.0,
                muscleGroups: [.shoulders],
                description: "强化肩部侧面"
            ),
            StrengthExercise(
                name: "二头弯举",
                nameEnglish: "Bicep Curl",
                icon: "figure.strengthtraining.functional",
                targetSets: 3,
                targetReps: 12,
                targetWeight: 15.0,
                muscleGroups: [.arms],
                description: "增强二头肌力量"
            ),
            StrengthExercise(
                name: "三头臂屈伸",
                nameEnglish: "Tricep Dips",
                icon: "figure.core.training",
                targetSets: 3,
                targetReps: 12,
                targetWeight: 0.0,
                muscleGroups: [.arms],
                description: "锻炼三头肌"
            )
        ]
        
        // 设置初始重量和次数
        let firstExercise = exercises[0]
        currentWeight = firstExercise.targetWeight
        currentReps = Double(firstExercise.targetReps)
    }
    
    // MARK: - Session Timer
    private func startSessionTimer() {
        sessionStartTime = Date()
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateSessionDuration()
            }
        }
    }
    
    private func updateSessionDuration() {
        let elapsed = Int(Date().timeIntervalSince(sessionStartTime))
        let minutes = elapsed / 60
        let seconds = elapsed % 60
        sessionDuration = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Exercise Selection
    func selectExercise(at index: Int) {
        guard exercises.indices.contains(index) else { return }
        currentExerciseIndex = index
        
        // Update weight and reps based on selected exercise
        let exercise = exercises[index]
        currentWeight = exercise.targetWeight
        currentReps = Double(exercise.targetReps)
    }
    
    // MARK: - Adjustments
    func adjustWeight(_ delta: Double) {
        let newWeight = currentWeight + delta
        currentWeight = max(0, newWeight) // Prevent negative weight
    }
    
    func adjustReps(_ delta: Double) {
        let newReps = currentReps + delta
        currentReps = max(1, newReps) // Minimum 1 rep
    }
    
    // MARK: - Timer Control
    func toggleTimer() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        timerSeconds = restDuration
        timerProgress = 1.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if self.timerSeconds > 0 {
                    self.timerSeconds -= 1
                    self.timerProgress = CGFloat(self.timerSeconds) / CGFloat(self.restDuration)
                } else {
                    self.stopTimer()
                    
                    // Play haptic feedback when timer ends
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.success)
                }
            }
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        timerSeconds = 0
        timerProgress = 0.0
    }
    
    // MARK: - Log Set
    func logSet() {
        let record = TrainingRecord(
            exerciseId: currentExercise.id,
            exerciseName: currentExercise.name,
            setType: currentSetType,
            weight: currentWeight,
            reps: currentReps,
            timestamp: Date()
        )
        
        // Insert at beginning for most recent first
        trainingHistory.insert(record, at: 0)
        
        // Automatically start rest timer
        if !isTimerRunning {
            startTimer()
        }
        
        // Play haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    // MARK: - Completion
    func completeWorkout() {
        stopTimer()
        sessionTimer?.invalidate()
        sessionTimer = nil
        
        // TODO: Save workout to FitnessManager
        // For now, just clear the history
        // trainingHistory.removeAll()
    }
}
