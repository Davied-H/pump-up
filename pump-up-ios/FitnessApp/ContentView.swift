//
//  ContentView.swift
//  FitnessApp
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fitnessManager: FitnessManager

    var body: some View {
        ZStack {
            switch fitnessManager.appState {
            case .loading:
                LoadingView()
                    .transition(loadingTransition)
                    .zIndex(3)
            case .unauthenticated:
                AuthView()
                    .transition(authTransition)
                    .zIndex(2)
            case .authenticated:
                MainTabView()
                    .transition(mainTransition)
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.55, dampingFraction: 0.75, blendDuration: 0.3), value: fitnessManager.appState)
    }
    
    // MARK: - Transitions
    private var loadingTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.95)),
            removal: .opacity.combined(with: .scale(scale: 1.1))
        )
    }
    
    private var authTransition: AnyTransition {
        let insertion = AnyTransition.opacity.combined(with: .move(edge: .bottom)).combined(with: .scale(scale: 0.9))
        let removal = AnyTransition.opacity.combined(with: .scale(scale: 0.85))
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    private var mainTransition: AnyTransition {
        let insertion = AnyTransition.opacity.combined(with: .scale(scale: 0.95)).combined(with: .move(edge: .bottom))
        let removal = AnyTransition.opacity.combined(with: .move(edge: .leading)).combined(with: .scale(scale: 0.9))
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    let darkBackground = Color(hex: "1A1A2E")
    let neonYellow = Color(hex: "D4FF00")
    
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotation = 0.0
    @State private var shimmerOffset: CGFloat = -1
    @State private var dots = 0
    
    var body: some View {
        ZStack {
            // 背景渐变动画
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // 粒子效果（可选）
            ParticleEffect()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo 动画
                ZStack {
                    // 外圈光晕
                    Circle()
                        .fill(neonYellow.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                        .opacity(pulseAnimation ? 0 : 0.6)
                    
                    // 中圈光晕
                    Circle()
                        .fill(neonYellow.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.15 : 1.0)
                        .opacity(pulseAnimation ? 0 : 0.4)
                    
                    // 图标背景
                    Circle()
                        .fill(LinearGradient(
                            colors: [neonYellow.opacity(0.3), neonYellow.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                    
                    // 主图标
                    Image(systemName: "figure.run")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [neonYellow, neonYellow.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(rotation))
                        .shadow(color: neonYellow.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                
                // 标题
                VStack(spacing: 8) {
                    Text(L10n.App.name)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color.white.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .offset(y: isAnimating ? -3 : 3)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                    // 加载提示文字
                    HStack(spacing: 4) {
                        Text(L10n.Common.loading)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        // 动态点点
                        Text(String(repeating: ".", count: dots))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 20, alignment: .leading)
                    }
                }
                
                // 进度条
                LoadingProgressBar()
                    .frame(height: 4)
                    .padding(.horizontal, 60)
                
                // 提示文字
                Text("正在准备您的健身之旅", bundle: .main, comment: "Loading subtitle")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 10)
            }
        }
        .onAppear {
            // 启动所有动画
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
            
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            // 点点动画
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                dots = (dots + 1) % 4
            }
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    let darkBackground = Color(hex: "1A1A2E")
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        LinearGradient(
            colors: [
                darkBackground,
                darkBackground.opacity(0.95),
                Color(hex: "16213E"),
                darkBackground
            ],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
    }
}

// MARK: - Particle Effect
struct ParticleEffect: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var opacity: Double
        var scale: CGFloat
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color(hex: "D4FF00"))
                        .frame(width: 4, height: 4)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .position(particle.position)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
                
                // 定期更新粒子
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    updateParticles(in: geometry.size)
                }
            }
        }
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                opacity: Double.random(in: 0.1...0.3),
                scale: CGFloat.random(in: 0.5...1.5)
            )
        }
    }
    
    private func updateParticles(in size: CGSize) {
        withAnimation(.easeInOut(duration: 2.0)) {
            particles = particles.map { particle in
                var updated = particle
                updated.position.y -= 2
                if updated.position.y < 0 {
                    updated.position.y = size.height
                    updated.position.x = CGFloat.random(in: 0...size.width)
                }
                updated.opacity = Double.random(in: 0.05...0.3)
                return updated
            }
        }
    }
}

// MARK: - Loading Progress Bar
struct LoadingProgressBar: View {
    @State private var progress: CGFloat = 0
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.1))
                
                // 进度条
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.7), neonYellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
                    .shadow(color: neonYellow.opacity(0.5), radius: 4, x: 0, y: 0)
            }
        }
        .onAppear {
            // 循环进度动画
            animateProgress()
        }
    }
    
    private func animateProgress() {
        withAnimation(.easeInOut(duration: 2.0)) {
            progress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            progress = 0
            animateProgress()
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    let neonYellow = Color(hex: "D4FF00")

    enum Tab: String, CaseIterable {
        case home = "Home"
        case workout = "Workout"
        case meditation = "Meditation"
        case profile = "Profile"
        
        var localizedName: LocalizedStringKey {
            LocalizedStringKey(self.rawValue)
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .workout: return "dumbbell.fill"
            case .meditation: return "heart.circle.fill"
            case .profile: return "person.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab.home.view
                .tabItem {
                    Label(Tab.home.localizedName, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
            
            Tab.workout.view
                .tabItem {
                    Label(Tab.workout.localizedName, systemImage: Tab.workout.icon)
                }
                .tag(Tab.workout)
            
            Tab.meditation.view
                .tabItem {
                    Label(Tab.meditation.localizedName, systemImage: Tab.meditation.icon)
                }
                .tag(Tab.meditation)
            
            Tab.profile.view
                .tabItem {
                    Label(Tab.profile.localizedName, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
        .tint(neonYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.2)
        
        let normalItemAppearance = UITabBarItemAppearance()
        normalItemAppearance.normal.iconColor = .systemGray
        normalItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        normalItemAppearance.selected.iconColor = UIColor(neonYellow)
        normalItemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(neonYellow),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance = normalItemAppearance
        appearance.inlineLayoutAppearance = normalItemAppearance
        appearance.compactInlineLayoutAppearance = normalItemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - 嵌入式搜索按钮
struct EmbeddedSearchButton: View {
    @Binding var showSearch: Bool
    @State private var isPressed = false
    
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        Button {
            // 触感反馈
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showSearch = true
            }
        } label: {
            ZStack {
                // 背景光晕
                Circle()
                    .fill(neonYellow.opacity(0.15))
                    .frame(width: 70, height: 70)
                    .blur(radius: 8)
                
                // 主按钮
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                neonYellow,
                                neonYellow.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: neonYellow.opacity(0.4), radius: 12, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                
                // 搜索图标
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - 全屏搜索界面
struct SearchOverlayView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var opacity: Double = 0
    @FocusState private var searchFieldFocus: Bool
    
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        ZStack {
            // 全屏背景 - 深色渐变
            ZStack {
                // 基础深色背景
                LinearGradient(
                    colors: [
                        Color(hex: "0A0A0F"),
                        Color(hex: "1A1A2E"),
                        Color(hex: "16213E")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // 顶部霓虹光晕
                RadialGradient(
                    colors: [
                        neonYellow.opacity(0.08),
                        Color.clear
                    ],
                    center: .top,
                    startRadius: 0,
                    endRadius: 400
                )
                
                // 底部微光
                LinearGradient(
                    colors: [
                        Color.clear,
                        neonYellow.opacity(0.03)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            .opacity(opacity)
            
            // 主内容区域
            VStack(spacing: 0) {
                // 顶部导航栏
                HStack(spacing: 16) {
                    // 返回按钮
                    Button {
                        dismissSearch()
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .opacity(opacity)
                
                // 搜索框
                HStack(spacing: 14) {
                    // 搜索图标
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        neonYellow.opacity(searchText.isEmpty ? 0.15 : 0.22),
                                        neonYellow.opacity(searchText.isEmpty ? 0.08 : 0.12)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(neonYellow)
                    }
                    .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
                    
                    // 输入框
                    TextField("搜索训练、课程、冥想...", text: $searchText)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.white)
                        .tint(neonYellow)
                        .focused($searchFieldFocus)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                    
                    // 清除按钮
                    if !searchText.isEmpty {
                        Button {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                searchText = ""
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            neonYellow.opacity(searchFieldFocus ? 0.35 : 0.12),
                                            neonYellow.opacity(searchFieldFocus ? 0.15 : 0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(
                            color: neonYellow.opacity(searchFieldFocus ? 0.2 : 0),
                            radius: 25,
                            x: 0,
                            y: 10
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .animation(.easeInOut(duration: 0.3), value: searchFieldFocus)
                .opacity(opacity)
                
                // 搜索结果区域
                SearchResultsView(searchText: searchText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // 淡入动画
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 1
            }
            
            // 延迟聚焦
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                searchFieldFocus = true
            }
        }
    }
    
    private func dismissSearch() {
        searchFieldFocus = false
        
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
        
        // 淡出动画
        withAnimation(.easeIn(duration: 0.25)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
            searchText = ""
        }
    }
    
    private func performSearch() {
        print("搜索：\(searchText)")
        searchFieldFocus = false
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

// MARK: - 搜索结果视图（精简版）
struct SearchResultsView: View {
    let searchText: String
    
    let neonYellow = Color(hex: "D4FF00")
    
    // 模拟数据
    let quickActions = [
        ("有氧训练", "figure.run", "30+ 课程"),
        ("力量训练", "dumbbell.fill", "25+ 课程"),
        ("瑜伽拉伸", "figure.flexibility", "20+ 课程")
    ]
    
    let recentSearches = ["HIIT训练", "晨间瑜伽", "睡前冥想"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                if searchText.isEmpty {
                    // 空状态 - 快速操作
                    VStack(alignment: .leading, spacing: 18) {
                        Text("快速开始")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(quickActions.enumerated()), id: \.offset) { index, action in
                                QuickActionCard(
                                    title: action.0,
                                    icon: action.1,
                                    subtitle: action.2,
                                    delay: Double(index) * 0.05
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 最近搜索
                    if !recentSearches.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("最近搜索")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                                
                                Spacer()
                                
                                Button("清除") {
                                    // 清除历史
                                }
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(neonYellow.opacity(0.7))
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                ForEach(Array(recentSearches.enumerated()), id: \.offset) { index, search in
                                    RecentSearchRow(
                                        searchText: search,
                                        isLast: index == recentSearches.count - 1
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                } else {
                    // 搜索结果
                    VStack(alignment: .leading, spacing: 16) {
                        Text("找到 5 个结果")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { index in
                                SearchResultCard(
                                    title: "HIIT 高强度间歇训练 \(index + 1)",
                                    duration: "\(15 + index * 5) 分钟",
                                    difficulty: index % 3 == 0 ? "初级" : (index % 3 == 1 ? "中级" : "高级"),
                                    delay: Double(index) * 0.04
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 120)
        }
    }
}

// MARK: - 快速操作卡片
struct QuickActionCard: View {
    let title: String
    let icon: String
    let subtitle: String
    let delay: Double
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 16) {
                // 图标容器
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    neonYellow.opacity(0.15),
                                    neonYellow.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(neonYellow)
                }
                
                // 文本信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .buttonStyle(ScaleButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                appeared = true
            }
        }
    }
}

// MARK: - 最近搜索行（精简版）
struct RecentSearchRow: View {
    let searchText: String
    let isLast: Bool
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Image(systemName: "clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text(searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(neonYellow.opacity(0.6))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                
                if !isLast {
                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.leading, 46)
                }
            }
            .background(Color.white.opacity(0.02))
            .opacity(appeared ? 1 : 0)
            .offset(x: appeared ? 0 : -20)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }
}

// MARK: - 搜索结果卡片
struct SearchResultCard: View {
    let title: String
    let duration: String
    let difficulty: String
    let delay: Double
    
    @State private var appeared = false
    let neonYellow = Color(hex: "D4FF00")
    
    var difficultyColor: Color {
        switch difficulty {
        case "初级": return .green
        case "中级": return .orange
        case "高级": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 14) {
                // 左侧渐变条
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [neonYellow, neonYellow.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 12) {
                        // 时长标签
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 11))
                            Text(duration)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.6))
                        
                        // 难度标签
                        HStack(spacing: 4) {
                            Circle()
                                .fill(difficultyColor)
                                .frame(width: 6, height: 6)
                            Text(difficulty)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .buttonStyle(ScaleButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                appeared = true
            }
        }
    }
}

// MARK: - Tab View Extension
extension MainTabView.Tab {
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeView()
        case .workout:
            WorkoutView()
        case .meditation:
            MeditationView()
        case .profile:
            ProfileView()
        }
    }
}


// MARK: - Skeleton Loading Components
/// 骨架屏 - 用于数据加载时的占位符
struct SkeletonView: View {
    @State private var shimmerOffset: CGFloat = -1
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset * geometry.size.width)
                        .onAppear {
                            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                shimmerOffset = 2
                            }
                        }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

/// 卡片骨架屏
struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonView()
                .frame(height: 150)
            
            SkeletonView()
                .frame(height: 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SkeletonView()
                .frame(height: 16)
                .frame(width: 200, alignment: .leading)
            
            HStack {
                SkeletonView()
                    .frame(width: 60, height: 16)
                SkeletonView()
                    .frame(width: 60, height: 16)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

/// 列表骨架屏
struct SkeletonList: View {
    let count: Int
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<count, id: \.self) { _ in
                HStack(spacing: 12) {
                    SkeletonView()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonView()
                            .frame(height: 16)
                            .frame(maxWidth: .infinity)
                        
                        SkeletonView()
                            .frame(height: 14)
                            .frame(width: 150)
                    }
                }
            }
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(FitnessManager())
}
