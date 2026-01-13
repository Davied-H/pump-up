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
            // 背景渐变
            LinearGradient(
                colors: [
                    darkBackground,
                    Color(hex: "16213E"),
                    darkBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部导航栏
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 训练进度卡片
                        progressCard
                        
                        // 动作切换器
                        exerciseSwitcher
                        
                        // 主计时器和记录区域
                        mainTimerSection
                        
                        // 训练历史
                        trainingHistorySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - 顶部导航栏
    private var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("返回")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(neonYellow)
            }
            
            Spacer()
            
            Text("上肢力量训练")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // 占位符保持标题居中
            Button {
                // 更多选项
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(darkBackground.opacity(0.8))
    }
    
    // MARK: - 训练进度卡片
    private var progressCard: some View {
        VStack(spacing: 16) {
            // 标题
            HStack {
                Text("训练进度")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(viewModel.currentExerciseIndex + 1)/\(viewModel.exercises.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(neonYellow)
            }
            
            // 进度条
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                    
                    // 进度
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [neonYellow, neonYellow.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * viewModel.overallProgress)
                        .shadow(color: neonYellow.opacity(0.4), radius: 8, x: 0, y: 0)
                    
                    // 百分比文字
                    Text("\(Int(viewModel.overallProgress * 100))%")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(height: 32)
            
            // 完成信息
            HStack(spacing: 12) {
                progressInfoItem(icon: "flame.fill", value: "\(viewModel.totalSets)", label: "已完成组数")
                
                Divider()
                    .frame(height: 30)
                    .background(Color.white.opacity(0.2))
                
                progressInfoItem(icon: "calendar", value: viewModel.sessionDuration, label: "训练时长")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(neonYellow.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func progressInfoItem(icon: String, value: String, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(neonYellow)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - 动作切换器
    private var exerciseSwitcher: some View {
        VStack(spacing: 12) {
            Text("当前动作")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(viewModel.exercises.enumerated()), id: \.offset) { index, exercise in
                        exerciseCard(exercise: exercise, isSelected: index == viewModel.currentExerciseIndex)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    viewModel.selectExercise(at: index)
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func exerciseCard(exercise: Exercise, isSelected: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 图标
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isSelected ? 
                                [neonYellow.opacity(0.25), neonYellow.opacity(0.15)] :
                                [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName: exercise.icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(isSelected ? neonYellow : .white.opacity(0.6))
            }
            
            // 动作名称
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(exercise.nameEnglish)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // 目标组数
            HStack(spacing: 6) {
                Image(systemName: "target")
                    .font(.system(size: 11))
                Text("\(exercise.completedSets)/\(exercise.targetSets) 组")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(isSelected ? neonYellow : .white.opacity(0.6))
        }
        .padding(16)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(isSelected ? Color.white.opacity(0.08) : Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(
                            isSelected ? neonYellow.opacity(0.3) : Color.clear,
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: isSelected ? neonYellow.opacity(0.2) : .clear,
                    radius: 20,
                    x: 0,
                    y: 8
                )
        )
        .scaleEffect(isSelected ? 1.0 : 0.96)
    }
    
    // MARK: - 主计时器区域
    private var mainTimerSection: some View {
        VStack(spacing: 20) {
            // 计时器圆圈
            timerCircle
            
            // 重量和次数调节
            HStack(spacing: 16) {
                // 重量调节
                adjustmentCard(
                    title: "重量",
                    value: viewModel.currentWeight,
                    unit: "kg",
                    icon: "scalemass.fill",
                    onDecrease: { viewModel.adjustWeight(-2.5) },
                    onIncrease: { viewModel.adjustWeight(2.5) }
                )
                
                // 次数调节
                adjustmentCard(
                    title: "次数",
                    value: viewModel.currentReps,
                    unit: "次",
                    icon: "repeat",
                    onDecrease: { viewModel.adjustReps(-1) },
                    onIncrease: { viewModel.adjustReps(1) }
                )
            }
            
            // 记录按钮
            logSetButton
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - 计时器圆圈
    private var timerCircle: some View {
        ZStack {
            // 外圈光晕
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            viewModel.isTimerRunning ? neonYellow.opacity(0.3) : neonYellow.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 80,
                        endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)
                .blur(radius: 20)
            
            // 进度圆环
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 12)
                    .frame(width: 220, height: 220)
                
                Circle()
                    .trim(from: 0, to: viewModel.timerProgress)
                    .stroke(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: neonYellow.opacity(0.4), radius: 10, x: 0, y: 0)
            }
            
            // 中心内容
            VStack(spacing: 8) {
                if viewModel.isTimerRunning {
                    Text(viewModel.timerDisplay)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                    
                    Text("休息中")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    Text("READY")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(neonYellow)
                    
                    Text("点击开始")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .frame(width: 280, height: 280)
        .contentShape(Circle())
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                viewModel.toggleTimer()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
    
    // MARK: - 调节卡片
    private func adjustmentCard(
        title: String,
        value: Double,
        unit: String,
        icon: String,
        onDecrease: @escaping () -> Void,
        onIncrease: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 12) {
            // 标题
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.white.opacity(0.6))
            
            // 数值显示
            Text(String(format: "%.1f", value))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()
            
            Text(unit)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .offset(y: -8)
            
            // 加减按钮
            HStack(spacing: 12) {
                Button {
                    onDecrease()
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
                
                Button {
                    onIncrease()
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.03))
        )
    }
    
    // MARK: - 记录按钮
    private var logSetButton: some View {
        Button {
            viewModel.logSet()
            
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .bold))
                
                Text("LOG SET")
                    .font(.system(size: 17, weight: .bold))
                    .tracking(1.2)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: neonYellow.opacity(0.4), radius: 20, x: 0, y: 8)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    // MARK: - 训练历史区域
    private var trainingHistorySection: some View {
        VStack(spacing: 16) {
            // 标题栏
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("训练历史")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("本次训练")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                // 总容量
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(viewModel.totalVolume)) kg")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(neonYellow)
                    
                    Text("总容量")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            // 训练记录列表
            if viewModel.trainingHistory.isEmpty {
                emptyHistoryView
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(viewModel.trainingHistory.enumerated()), id: \.offset) { index, record in
                        trainingRecordRow(record: record, index: index)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.2))
            
            Text("还没有训练记录")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
            
            Text("完成第一组训练开始记录")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func trainingRecordRow(record: TrainingRecord, index: Int) -> some View {
        HStack(spacing: 16) {
            // 左侧标记
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(setTypeColor(record.setType).opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Text("\(index + 1)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(setTypeColor(record.setType))
                }
                
                Text(setTypeName(record.setType))
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // 训练数据
            VStack(alignment: .leading, spacing: 6) {
                Text(record.exerciseName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    dataItem(icon: "scalemass.fill", value: "\(String(format: "%.1f", record.weight)) kg")
                    dataItem(icon: "repeat", value: "\(Int(record.reps)) 次")
                    dataItem(icon: "flame.fill", value: "\(Int(record.volume)) kg", color: neonYellow)
                }
            }
            
            Spacer()
            
            // 时间
            Text(record.timestamp, style: .time)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(setTypeColor(record.setType).opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func dataItem(icon: String, value: String, color: Color = .white.opacity(0.6)) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(value)
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundColor(color)
    }
    
    private func setTypeColor(_ type: SetType) -> Color {
        switch type {
        case .warmup:
            return .orange
        case .target:
            return neonYellow
        case .working:
            return .green
        }
    }
    
    private func setTypeName(_ type: SetType) -> String {
        switch type {
        case .warmup:
            return "热身"
        case .target:
            return "目标"
        case .working:
            return "工作"
        }
    }
}

// MARK: - Models
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let nameEnglish: String
    let icon: String
    let targetSets: Int
    var completedSets: Int = 0
}

enum SetType {
    case warmup   // 热身组
    case target   // 目标组
    case working  // 工作组
}

struct TrainingRecord: Identifiable {
    let id = UUID()
    let exerciseName: String
    let weight: Double
    let reps: Double
    let volume: Double
    let setType: SetType
    let timestamp: Date
}

// MARK: - ViewModel
class UpperBodyStrengthViewModel: ObservableObject {
    @Published var exercises: [Exercise] = [
        Exercise(name: "卧推", nameEnglish: "Bench Press", icon: "figure.strengthtraining.traditional", targetSets: 4),
        Exercise(name: "哑铃划船", nameEnglish: "Dumbbell Rows", icon: "figure.rowing", targetSets: 4)
    ]
    
    @Published var currentExerciseIndex: Int = 0
    @Published var currentWeight: Double = 20.0
    @Published var currentReps: Double = 8.0
    @Published var trainingHistory: [TrainingRecord] = []
    
    @Published var isTimerRunning = false
    @Published var timerProgress: Double = 0
    @Published var timerDisplay = "90"
    
    private var timer: Timer?
    private var restDuration: Double = 90
    private var currentTime: Double = 90
    private var sessionStartTime = Date()
    
    var currentExercise: Exercise {
        exercises[currentExerciseIndex]
    }
    
    var overallProgress: Double {
        let totalSets = exercises.reduce(0) { $0 + $1.targetSets }
        let completedSets = exercises.reduce(0) { $0 + $1.completedSets }
        return totalSets > 0 ? Double(completedSets) / Double(totalSets) : 0
    }
    
    var totalSets: Int {
        trainingHistory.count
    }
    
    var totalVolume: Double {
        trainingHistory.reduce(0) { $0 + $1.volume }
    }
    
    var sessionDuration: String {
        let duration = Date().timeIntervalSince(sessionStartTime)
        let minutes = Int(duration) / 60
        return "\(minutes) 分钟"
    }
    
    init() {
        // 添加示例数据
        addSampleData()
    }
    
    func selectExercise(at index: Int) {
        currentExerciseIndex = index
    }
    
    func adjustWeight(_ delta: Double) {
        currentWeight = max(0, currentWeight + delta)
    }
    
    func adjustReps(_ delta: Double) {
        currentReps = max(1, currentReps + delta)
    }
    
    func logSet() {
        let volume = currentWeight * currentReps
        
        // 根据组数判断类型
        let setType: SetType
        if trainingHistory.isEmpty {
            setType = .warmup
        } else if trainingHistory.count == 1 {
            setType = .target
        } else {
            setType = .working
        }
        
        let record = TrainingRecord(
            exerciseName: currentExercise.name,
            weight: currentWeight,
            reps: currentReps,
            volume: volume,
            setType: setType,
            timestamp: Date()
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            trainingHistory.insert(record, at: 0)
            exercises[currentExerciseIndex].completedSets += 1
        }
        
        // 自动开始休息计时
        startTimer()
    }
    
    func toggleTimer() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        currentTime = restDuration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentTime -= 1
            self.timerDisplay = String(format: "%.0f", self.currentTime)
            self.timerProgress = 1 - (self.currentTime / self.restDuration)
            
            if self.currentTime <= 0 {
                self.stopTimer()
                
                // 播放完成音效
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        currentTime = restDuration
        timerDisplay = String(format: "%.0f", restDuration)
        timerProgress = 0
    }
    
    private func addSampleData() {
        // 添加示例训练数据
        let sampleRecords = [
            TrainingRecord(
                exerciseName: "卧推",
                weight: 20.0,
                reps: 8,
                volume: 160,
                setType: .working,
                timestamp: Date().addingTimeInterval(-180)
            ),
            TrainingRecord(
                exerciseName: "卧推",
                weight: 20.0,
                reps: 8,
                volume: 160,
                setType: .working,
                timestamp: Date().addingTimeInterval(-360)
            ),
            TrainingRecord(
                exerciseName: "卧推",
                weight: 20.0,
                reps: 8,
                volume: 160,
                setType: .target,
                timestamp: Date().addingTimeInterval(-540)
            ),
            TrainingRecord(
                exerciseName: "卧推",
                weight: 17.5,
                reps: 10,
                volume: 175,
                setType: .warmup,
                timestamp: Date().addingTimeInterval(-720)
            )
        ]
        
        trainingHistory = sampleRecords
        exercises[0].completedSets = 4
        sessionStartTime = Date().addingTimeInterval(-720)
    }
    
    deinit {
        timer?.invalidate()
    }
}

#Preview {
    UpperBodyStrengthView()
}
