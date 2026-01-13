//
//  StrengthTrainingModels.swift
//  FitnessApp
//
//  Models for strength training tracking
//

import Foundation

// MARK: - Set Type
enum SetType: String, Codable {
    case warmup = "热身组"
    case working = "工作组"
    case target = "目标组"
}

// MARK: - Strength Exercise
struct StrengthExercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var nameEnglish: String
    var icon: String
    var targetSets: Int
    var targetReps: Int
    var targetWeight: Double
    var muscleGroups: [Exercise.MuscleGroup]
    var description: String
    
    init(
        name: String,
        nameEnglish: String,
        icon: String,
        targetSets: Int = 3,
        targetReps: Int = 12,
        targetWeight: Double = 20.0,
        muscleGroups: [Exercise.MuscleGroup] = [],
        description: String = ""
    ) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.icon = icon
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.targetWeight = targetWeight
        self.muscleGroups = muscleGroups
        self.description = description
    }
}

// MARK: - Training Record
struct TrainingRecord: Identifiable, Codable {
    var id = UUID()
    var exerciseId: UUID
    var exerciseName: String
    var setType: SetType
    var weight: Double
    var reps: Double
    var timestamp: Date
    
    var volume: Double {
        weight * reps
    }
    
    init(
        exerciseId: UUID,
        exerciseName: String,
        setType: SetType,
        weight: Double,
        reps: Double,
        timestamp: Date = Date()
    ) {
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.setType = setType
        self.weight = weight
        self.reps = reps
        self.timestamp = timestamp
    }
}
