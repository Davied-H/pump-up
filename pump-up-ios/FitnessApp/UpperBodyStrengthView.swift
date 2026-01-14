//
//  UpperBodyStrengthView.swift
//  FitnessApp
//

import SwiftUI

// MARK: - 上肢力量训练主视图
struct UpperBodyStrengthView: View {
    @StateObject private var viewModel = UpperBodyStrengthViewModel()
    @Environment(\.dismiss) private var dismiss

    let neonYellow = Color(hex: "D4FF00")
    let darkBackground = Color(hex: "1A1A2E")

    var body: some View {
        ZStack {
            // 动态背景
            dynamicBackground

            VStack(spacing: 0) {
                // 1. 简洁顶部导航栏
                simpleHeader

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 2. 线性进度条
                        linearProgressBar
                            .padding(.top, 8)

                        // 3. 胶囊Tab动作切换器
                        exercisePillTabs

                        // 4. 中央大圆环
                        centralRing
                            .padding(.vertical, 8)

                        // 5. 并排调节器
                        compactAdjusterRow

                        // 6. LOG SET 主按钮
                        logSetButton

                        // 7. 简化历史记录
                        sessionHistory
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - 动态背景
    private var dynamicBackground: some View {
        ZStack {
            // 基础渐变
            LinearGradient(
                colors: [
                    Color(hex: "0F0F1E"),
                    Color(hex: "1A1A2E"),
                    Color(hex: "0F0F1E")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // 动态光效
            GeometryReader { geometry in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                neonYellow.opacity(0.08),
                                neonYellow.opacity(0.02),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 300
                        )
                    )
                    .frame(width: 600, height: 600)
                    .position(x: geometry.size.width * 0.5, y: -100)
                    .blur(radius: 60)
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - 1. 简洁顶部导航栏
    private var simpleHeader: some View {
        HStack {
            // 返回按钮
            Button {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            // 标题 + 时长
            VStack(spacing: 2) {
                Text("Strength Circuit")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Text(viewModel.sessionDuration)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(neonYellow)
                    .monospacedDigit()
            }

            Spacer()

            // 完成按钮
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                viewModel.completeWorkout()
                dismiss()
            } label: {
                Text("FINISH")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(neonYellow)
                    .tracking(0.5)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
    }

    // MARK: - 2. 线性进度条
    private var linearProgressBar: some View {
        VStack(spacing: 8) {
            // 进度条
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景
                    Capsule()
                        .fill(Color.white.opacity(0.1))

                    // 进度
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [neonYellow, neonYellow.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * viewModel.overallProgress))
                        .shadow(color: neonYellow.opacity(0.4), radius: 8, x: 0, y: 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.overallProgress)
                }
            }
            .frame(height: 4)

            // 文字说明
            HStack {
                Text("Exercise \(viewModel.currentExerciseIndex + 1) of \(viewModel.exercises.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))

                Spacer()

                Text("\(Int(viewModel.overallProgress * 100))% Complete")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(neonYellow)
            }
        }
    }

    // MARK: - 3. 胶囊Tab动作切换器
    private var exercisePillTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(viewModel.exercises.enumerated()), id: \.offset) { index, exercise in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.selectExercise(at: index)
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    } label: {
                        Text(exercise.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(viewModel.currentExerciseIndex == index ? .black : .white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(viewModel.currentExerciseIndex == index ? neonYellow : Color.white.opacity(0.08))
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
    }

    // MARK: - 4. 中央大圆环
    @State private var isPulsing = false

    private var centralRing: some View {
        ZStack {
            // 外部光晕
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            neonYellow.opacity(viewModel.isTimerRunning ? 0.2 : 0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 80,
                        endRadius: 160
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 30)
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.isTimerRunning)

            // 背景圆环
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 12)
                .frame(width: 220, height: 220)

            // 进度圆环
            Circle()
                .trim(from: 0, to: viewModel.timerProgress)
                .stroke(
                    AngularGradient(
                        colors: [neonYellow, neonYellow.opacity(0.6), neonYellow],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
                .shadow(color: neonYellow.opacity(0.5), radius: 12, x: 0, y: 0)
                .animation(.spring(response: 0.3, dampingFraction: 1), value: viewModel.timerProgress)

            // 中心内容
            VStack(spacing: 8) {
                // 图标
                Image(systemName: viewModel.currentExercise.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(neonYellow.opacity(0.8))
                    .scaleEffect(viewModel.isTimerRunning ? 0.8 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isTimerRunning)

                // 主文字
                if viewModel.isTimerRunning {
                    Text(viewModel.timerDisplay)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                } else {
                    Text("READY")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                // 副文字
                Text(viewModel.isTimerRunning ? "REST" : "START SET")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(neonYellow)
                    .tracking(1)
            }
        }
        .frame(width: 260, height: 260)
        .contentShape(Circle())
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.toggleTimer()
            }

            // 脉动动画
            withAnimation(.easeInOut(duration: 0.3)) {
                isPulsing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    isPulsing = false
                }
            }

            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }

    // MARK: - 5. 并排调节器
    private var compactAdjusterRow: some View {
        HStack(spacing: 16) {
            // 重量调节器
            compactAdjuster(
                label: "WEIGHT (KG)",
                value: String(format: "%.1f", viewModel.currentWeight),
                onDecrease: { viewModel.adjustWeight(-2.5) },
                onIncrease: { viewModel.adjustWeight(2.5) }
            )

            // 次数调节器
            compactAdjuster(
                label: "REPS",
                value: "\(Int(viewModel.currentReps))",
                onDecrease: { viewModel.adjustReps(-1) },
                onIncrease: { viewModel.adjustReps(1) }
            )
        }
    }

    private func compactAdjuster(
        label: String,
        value: String,
        onDecrease: @escaping () -> Void,
        onIncrease: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 12) {
            // 标签
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1)

            // 数值
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()

            // 按钮
            HStack(spacing: 16) {
                adjustButton(icon: "minus", action: onDecrease)
                adjustButton(icon: "plus", action: onIncrease)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func adjustButton(icon: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.1))
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }

    // MARK: - 6. LOG SET 主按钮
    private var logSetButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.logSet()
            }

            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22, weight: .semibold))

                Text("LOG SET")
                    .font(.system(size: 18, weight: .bold))
                    .tracking(0.5)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.95)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: neonYellow.opacity(0.4), radius: 20, x: 0, y: 10)
            )
        }
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - 7. 简化历史记录
    private var sessionHistory: some View {
        VStack(spacing: 16) {
            // 标题行
            HStack {
                Text("Session History")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Text("Volume: \(Int(viewModel.totalVolume))kg")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(neonYellow)
            }

            // 记录列表
            if viewModel.trainingHistory.isEmpty {
                emptyHistoryState
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(viewModel.trainingHistory.prefix(5).enumerated()), id: \.offset) { index, record in
                        recordRow(record: record, index: viewModel.trainingHistory.count - index)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.9).combined(with: .opacity),
                                removal: .scale(scale: 0.9).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private var emptyHistoryState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.white.opacity(0.2))
                .padding(.top, 20)

            Text("No sets logged yet")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.4))

            Text("Complete your first set to start tracking")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.3))
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }

    private func recordRow(record: TrainingRecord, index: Int) -> some View {
        let setTypeInfo = getSetTypeInfo(record.setType)

        return HStack(spacing: 14) {
            // 序号圆圈
            Text("\(index)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(setTypeInfo.color)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(setTypeInfo.color.opacity(0.15))
                )

            // 数据
            Text("\(Int(record.weight)) kg \u{00D7} \(Int(record.reps)) reps")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            // 状态标签
            Text(setTypeInfo.text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(setTypeInfo.color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(setTypeInfo.color.opacity(0.15))
                )

            // 勾选图标
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.green)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.03))
        )
    }

    private func getSetTypeInfo(_ type: SetType) -> (text: String, color: Color) {
        switch type {
        case .warmup: return ("Warm up", .orange)
        case .target: return ("Target hit", neonYellow)
        case .working: return ("Working Set", .green)
        }
    }
}

// MARK: - 按钮样式
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
