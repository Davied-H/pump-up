//
//  UpperBodyStrengthView.swift
//  FitnessApp
//

import SwiftUI

// MARK: - 上肢力量训练主视图
struct UpperBodyStrengthView: View {
    @StateObject private var viewModel = UpperBodyStrengthViewModel()
    @Environment(\.dismiss) private var dismiss
    @Namespace private var animation
    
    let neonYellow = Color(hex: "D4FF00")
    let darkBackground = Color(hex: "1A1A2E")
    
    var body: some View {
        ZStack {
            // 动态背景
            dynamicBackground
            
            VStack(spacing: 0) {
                // 简化的顶部导航栏
                minimalistHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // 精简的进度指示器
                        compactProgressIndicator
                            .padding(.top, 8)
                        
                        // 动作切换器（更大、更清晰）
                        enhancedExerciseSwitcher
                        
                        // 主计时器和控制区域（重新设计）
                        redesignedTimerSection
                        
                        // 简化的训练历史
                        minimalistHistory
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
    
    // MARK: - 极简顶部栏
    private var minimalistHeader: some View {
        HStack(spacing: 16) {
            Button {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("上肢力量")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(viewModel.sessionDuration)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(neonYellow)
                    .monospacedDigit()
            }
            
            Spacer()
            
            Button {
                // 更多选项
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // MARK: - 紧凑的进度指示器
    private var compactProgressIndicator: some View {
        VStack(spacing: 12) {
            // 进度环形指示器
            ZStack {
                // 背景圆环
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                // 进度圆环
                Circle()
                    .trim(from: 0, to: viewModel.overallProgress)
                    .stroke(
                        AngularGradient(
                            colors: [neonYellow, neonYellow.opacity(0.6), neonYellow],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.overallProgress)
                
                // 中心文字
                VStack(spacing: 2) {
                    Text("\(Int(viewModel.overallProgress * 100))")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                    
                    Text("%")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            // 统计信息
            HStack(spacing: 24) {
                statItem(value: "\(viewModel.totalSets)", label: "组", icon: "checkmark.circle.fill")
                statItem(value: "\(Int(viewModel.totalVolume))", label: "kg", icon: "flame.fill")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.15), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(neonYellow)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    // MARK: - 增强的动作切换器
    private var enhancedExerciseSwitcher: some View {
        VStack(spacing: 16) {
            HStack {
                Text("当前动作")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .textCase(.uppercase)
                    .tracking(0.8)
                
                Spacer()
            }
            
            TabView(selection: $viewModel.currentExerciseIndex) {
                ForEach(0..<viewModel.exercises.count, id: \.self) { index in
                    largeExerciseCard(exercise: viewModel.exercises[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 180)
            .animation(.spring(response: 0.5, dampingFraction: 0.75), value: viewModel.currentExerciseIndex)
            
            // 自定义页面指示器
            HStack(spacing: 8) {
                ForEach(0..<viewModel.exercises.count, id: \.self) { index in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.selectExercise(at: index)
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    } label: {
                        VStack(spacing: 6) {
                            Capsule()
                                .fill(index == viewModel.currentExerciseIndex ? neonYellow : Color.white.opacity(0.2))
                                .frame(width: index == viewModel.currentExerciseIndex ? 40 : 8, height: 4)
                            
                            if index == viewModel.currentExerciseIndex {
                                Text(viewModel.exercises[index].name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .transition(.opacity)
                            }
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentExerciseIndex)
                    }
                }
            }
        }
    }
    
    private func largeExerciseCard(exercise: StrengthExercise) -> some View {
        VStack(spacing: 20) {
            // 大图标
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                neonYellow.opacity(0.2),
                                neonYellow.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: exercise.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(neonYellow)
            }
            
            VStack(spacing: 6) {
                Text(exercise.name)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text(exercise.nameEnglish)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .textCase(.uppercase)
                    .tracking(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    // MARK: - 重新设计的计时器区域
    private var redesignedTimerSection: some View {
        VStack(spacing: 24) {
            // 计时器
            modernTimerCircle
            
            // 重量和次数调节（并排，更紧凑）
            HStack(spacing: 16) {
                compactAdjustmentCard(
                    icon: "scalemass.fill",
                    value: viewModel.currentWeight,
                    unit: "kg",
                    onDecrease: { viewModel.adjustWeight(-2.5) },
                    onIncrease: { viewModel.adjustWeight(2.5) }
                )
                
                compactAdjustmentCard(
                    icon: "repeat",
                    value: viewModel.currentReps,
                    unit: "次",
                    onDecrease: { viewModel.adjustReps(-1) },
                    onIncrease: { viewModel.adjustReps(1) }
                )
            }
            
            // 主按钮
            modernLogButton
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
        )
    }
    
    // MARK: - 现代化计时器
    private var modernTimerCircle: some View {
        ZStack {
            // 外圈光晕（更柔和）
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            viewModel.isTimerRunning ? neonYellow.opacity(0.25) : neonYellow.opacity(0.08),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 60,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .blur(radius: 20)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.isTimerRunning)
            
            // 进度环
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 8)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0, to: viewModel.timerProgress)
                    .stroke(
                        AngularGradient(
                            colors: [neonYellow, neonYellow.opacity(0.7), neonYellow],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: neonYellow.opacity(0.5), radius: 15, x: 0, y: 0)
                    .animation(.spring(response: 0.3, dampingFraction: 1), value: viewModel.timerProgress)
            }
            
            // 中心内容
            VStack(spacing: 6) {
                if viewModel.isTimerRunning {
                    Text(viewModel.timerDisplay)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                    
                    Text("休息中")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                        .textCase(.uppercase)
                        .tracking(1)
                } else {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(neonYellow)
                    
                    Text("开始")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .padding(.top, 4)
                }
            }
        }
        .frame(width: 240, height: 240)
        .contentShape(Circle())
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.toggleTimer()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
    
    // MARK: - 紧凑调节卡片
    private func compactAdjustmentCard(
        icon: String,
        value: Double,
        unit: String,
        onDecrease: @escaping () -> Void,
        onIncrease: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 16) {
            // 图标
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(neonYellow)
            
            // 数值
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", value))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                
                Text(unit)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // 加减按钮
            HStack(spacing: 10) {
                adjustButton(icon: "minus", action: onDecrease)
                adjustButton(icon: "plus", action: onIncrease)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
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
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    // MARK: - 现代化记录按钮
    private var modernLogButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.logSet()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                
                Text("记录这组")
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
    
    // MARK: - 极简历史记录
    private var minimalistHistory: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("训练记录")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                        .textCase(.uppercase)
                        .tracking(0.8)
                    
                    Text("\(viewModel.trainingHistory.count) 组完成")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(viewModel.totalVolume))")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(neonYellow)
                        .monospacedDigit()
                    
                    Text("总容量 (kg)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            if viewModel.trainingHistory.isEmpty {
                emptyState
            } else {
                VStack(spacing: 8) {
                    ForEach(0..<min(5, viewModel.trainingHistory.count), id: \.self) { index in
                        modernRecordRow(record: viewModel.trainingHistory[index], index: index)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.9).combined(with: .opacity),
                                removal: .scale(scale: 0.9).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.15), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.white.opacity(0.2))
                .padding(.top, 20)
            
            Text("还没有训练记录")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
            
            Text("完成第一组开始记录")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.3))
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func modernRecordRow(record: TrainingRecord, index: Int) -> some View {
        HStack(spacing: 16) {
            // 序号标记
            Text("\(viewModel.trainingHistory.count - index)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(setTypeColor(record.setType))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(setTypeColor(record.setType).opacity(0.15))
                )
            
            // 数据
            HStack(spacing: 20) {
                dataColumn(icon: "scalemass.fill", value: String(format: "%.1f", record.weight), unit: "kg")
                dataColumn(icon: "repeat", value: "\(Int(record.reps))", unit: "次")
                dataColumn(icon: "flame.fill", value: "\(Int(record.volume))", unit: "kg", highlight: true)
            }
            
            Spacer()
            
            // 时间
            Text(record.timestamp, style: .time)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.3))
                .monospacedDigit()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
                )
        )
    }
    
    private func dataColumn(icon: String, value: String, unit: String, highlight: Bool = false) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(highlight ? neonYellow : .white.opacity(0.4))
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(highlight ? neonYellow : .white)
                    .monospacedDigit()
                
                Text(unit)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }
    
    private func setTypeColor(_ type: SetType) -> Color {
        switch type {
        case .warmup: return .orange
        case .target: return neonYellow
        case .working: return .green
        }
    }
}

// MARK: - 按钮样式
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

