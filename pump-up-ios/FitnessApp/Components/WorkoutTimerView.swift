//
//  WorkoutTimerView.swift
//  FitnessApp
//

import SwiftUI

struct WorkoutTimerView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    @State private var currentExerciseIndex = 0
    @State private var isResting = false
    @State private var timeRemaining = 0
    @State private var totalElapsedTime = 0
    @State private var isRunning = false
    @State private var showCompletionView = false

    var currentExercise: Exercise? {
        guard currentExerciseIndex < workout.exercises.count else { return nil }
        return workout.exercises[currentExerciseIndex]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("\(currentExerciseIndex + 1)/\(workout.exercises.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Spacer()

                if let exercise = currentExercise {
                    // Exercise Info
                    VStack(spacing: 15) {
                        Text(isResting ? "Rest" : exercise.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        if !isResting {
                            if let duration = exercise.duration {
                                Text("\(duration) seconds")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(exercise.sets) sets × \(exercise.reps) reps")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // Timer Circle
                    ZStack {
                        // Background Circle
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                            .frame(width: 220, height: 220)

                        // Progress Circle
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(
                                isResting ? Color.blue : Color(hex: "D4FF00"),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: timeRemaining)

                        // Time Display
                        VStack(spacing: 5) {
                            Text(formatTime(timeRemaining))
                                .font(.system(size: 56, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)

                            Text(isResting ? "Get Ready" : "Keep Going!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }

                    // Next Exercise Preview
                    if currentExerciseIndex < workout.exercises.count - 1 {
                        VStack(spacing: 5) {
                            Text("NEXT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                                .tracking(2)

                            Text(workout.exercises[currentExerciseIndex + 1].name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                    }
                }

                Spacer()

                // Controls
                HStack(spacing: 40) {
                    // Previous
                    Button(action: previousExercise) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 24))
                            .foregroundColor(currentExerciseIndex > 0 ? .white : .gray)
                    }
                    .disabled(currentExerciseIndex == 0)

                    // Play/Pause
                    Button(action: toggleTimer) {
                        Circle()
                            .fill(Color(hex: "D4FF00"))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            )
                    }

                    // Next/Skip
                    Button(action: nextExercise) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }

                // Total Time
                HStack {
                    Image(systemName: "clock")
                    Text("Total: \(formatTime(totalElapsedTime))")
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            setupTimer()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if isRunning {
                tick()
            }
        }
        .fullScreenCover(isPresented: $showCompletionView) {
            WorkoutCompletionView(workout: workout, totalTime: totalElapsedTime)
        }
    }

    private var progressValue: Double {
        guard let exercise = currentExercise else { return 0 }
        let total = isResting ? Double(exercise.restTime) : Double(exercise.duration ?? 30)
        return Double(timeRemaining) / total
    }

    private func setupTimer() {
        if let exercise = currentExercise {
            timeRemaining = exercise.duration ?? 30
        }
    }

    private func toggleTimer() {
        isRunning.toggle()
    }

    private func tick() {
        totalElapsedTime += 1

        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            // Time's up
            if isResting {
                // Move to next exercise
                isResting = false
                currentExerciseIndex += 1
                if currentExerciseIndex >= workout.exercises.count {
                    // Workout complete
                    isRunning = false
                    showCompletionView = true
                } else {
                    setupTimer()
                }
            } else {
                // Start rest period
                if let exercise = currentExercise {
                    isResting = true
                    timeRemaining = exercise.restTime
                }
            }
        }
    }

    private func nextExercise() {
        if currentExerciseIndex < workout.exercises.count - 1 {
            currentExerciseIndex += 1
            isResting = false
            setupTimer()
        } else {
            showCompletionView = true
        }
    }

    private func previousExercise() {
        if currentExerciseIndex > 0 {
            currentExerciseIndex -= 1
            isResting = false
            setupTimer()
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Workout Completion View
struct WorkoutCompletionView: View {
    let workout: Workout
    let totalTime: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Celebration Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: "D4FF00").opacity(0.2))
                        .frame(width: 150, height: 150)

                    Circle()
                        .fill(Color(hex: "D4FF00"))
                        .frame(width: 100, height: 100)

                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                }

                Text("Workout Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text("Great job finishing \(workout.name)!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)

                // Stats
                HStack(spacing: 30) {
                    CompletionStat(icon: "clock", value: formatTime(totalTime), label: "Duration")
                    CompletionStat(icon: "flame", value: "\(workout.caloriesBurned)", label: "Calories")
                    CompletionStat(icon: "figure.walk", value: "\(workout.exercises.count)", label: "Exercises")
                }
                .padding(.vertical, 20)

                Spacer()

                // Buttons
                VStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "D4FF00"))
                            )
                    }

                    Button(action: {}) {
                        Text("Share")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct CompletionStat: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "D4FF00"))

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    WorkoutTimerView(workout: FitnessManager.generateSampleWorkouts()[0])
}
