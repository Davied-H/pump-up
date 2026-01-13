//
//  MeditationView.swift
//  FitnessApp
//

import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var selectedCategory: MeditationSession.MeditationCategory?
    @State private var selectedSession: MeditationSession?
    @State private var showMeditationPlayer = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    // Header
                    MeditationHeaderView()

                    // Featured Session
                    FeaturedMeditationCard()

                    // Category Pills
                    MeditationCategoryView(selectedCategory: $selectedCategory)

                    // Today's Recommendation
                    TodayRecommendationSection(
                        sessions: filteredSessions,
                        selectedSession: $selectedSession,
                        showPlayer: $showMeditationPlayer
                    )

                    // Quick Sessions
                    QuickSessionsSection(
                        sessions: fitnessManager.meditations.filter { $0.duration <= 10 },
                        selectedSession: $selectedSession,
                        showPlayer: $showMeditationPlayer
                    )

                    // Stats
                    MeditationStatsView(totalMinutes: fitnessManager.statistics.totalMeditationMinutes)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .sheet(isPresented: $showMeditationPlayer) {
                if let session = selectedSession {
                    MeditationPlayerView(session: session)
                }
            }
        }
    }

    private var filteredSessions: [MeditationSession] {
        if let category = selectedCategory {
            return fitnessManager.meditations.filter { $0.category == category }
        }
        return fitnessManager.meditations
    }
}

// MARK: - Header
struct MeditationHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Meditation.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text(L10n.Meditation.findPeace)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Circle().fill(Color(hex: "1C1C1E")))
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Featured Card
struct FeaturedMeditationCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "4A3F8A"), Color(hex: "1C1C1E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
                .overlay(
                    // Decorative circles
                    GeometryReader { geo in
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 150, height: 150)
                            .offset(x: geo.size.width - 80, y: -30)

                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 100, height: 100)
                            .offset(x: geo.size.width - 60, y: 80)
                    }
                    .clipped()
                )

            // Content
            VStack(alignment: .leading, spacing: 10) {
                Text(L10n.Meditation.dailyCalm)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "D4FF00"))
                    .tracking(2)

                Text("Evening\nRelaxation")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .lineSpacing(4)

                HStack(spacing: 15) {
                    Label("15 min", systemImage: "clock")
                    Label("Beginner", systemImage: "star")
                }
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(24)
        }
    }
}

// MARK: - Category View
struct MeditationCategoryView: View {
    @Binding var selectedCategory: MeditationSession.MeditationCategory?

    let categories: [(MeditationSession.MeditationCategory?, String, String)] = [
        (nil, "All", "sparkles"),
        (.sleep, "Sleep", "moon.fill"),
        (.stress, "Stress", "heart.fill"),
        (.focus, "Focus", "target"),
        (.breathing, "Breathe", "wind"),
        (.morning, "Morning", "sun.max.fill")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.1) { category, name, icon in
                    MeditationCategoryPill(
                        name: name,
                        icon: icon,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
}

struct MeditationCategoryPill: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(name)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "D4FF00") : Color(hex: "1C1C1E"))
            )
        }
    }
}

// MARK: - Today's Recommendation
struct TodayRecommendationSection: View {
    let sessions: [MeditationSession]
    @Binding var selectedSession: MeditationSession?
    @Binding var showPlayer: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(L10n.Meditation.forYou)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {}) {
                    Text(L10n.Common.seeAll)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "D4FF00"))
                }
            }

            VStack(spacing: 12) {
                ForEach(sessions) { session in
                    MeditationSessionCard(session: session) {
                        selectedSession = session
                        showPlayer = true
                    }
                }
            }
        }
    }
}

struct MeditationSessionCard: View {
    let session: MeditationSession
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Icon
                RoundedRectangle(cornerRadius: 12)
                    .fill(categoryGradient(for: session.category))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: categoryIcon(for: session.category))
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    )

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(session.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        if session.isPremium {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                        }
                    }

                    Text(session.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    Label("\(session.duration) min", systemImage: "clock")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Play Button
                Circle()
                    .fill(Color(hex: "D4FF00"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }

    private func categoryIcon(for category: MeditationSession.MeditationCategory) -> String {
        switch category {
        case .sleep: return "moon.fill"
        case .stress: return "heart.fill"
        case .focus: return "target"
        case .breathing: return "wind"
        case .morning: return "sun.max.fill"
        case .gratitude: return "hands.sparkles.fill"
        }
    }

    private func categoryGradient(for category: MeditationSession.MeditationCategory) -> LinearGradient {
        let colors: [Color]
        switch category {
        case .sleep: colors = [Color.indigo, Color.purple]
        case .stress: colors = [Color.pink, Color.red]
        case .focus: colors = [Color.blue, Color.cyan]
        case .breathing: colors = [Color.teal, Color.green]
        case .morning: colors = [Color.orange, Color.yellow]
        case .gratitude: colors = [Color.purple, Color.pink]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Quick Sessions
struct QuickSessionsSection: View {
    let sessions: [MeditationSession]
    @Binding var selectedSession: MeditationSession?
    @Binding var showPlayer: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.Meditation.quickSessions)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sessions) { session in
                        QuickSessionCard(session: session) {
                            selectedSession = session
                            showPlayer = true
                        }
                    }
                }
            }
        }
    }
}

struct QuickSessionCard: View {
    let session: MeditationSession
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: categoryIcon(for: session.category))
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        )

                    Text("\(session.duration)m")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color(hex: "D4FF00")))
                }

                Text(session.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 100)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }

    private func categoryIcon(for category: MeditationSession.MeditationCategory) -> String {
        switch category {
        case .sleep: return "moon.fill"
        case .stress: return "heart.fill"
        case .focus: return "target"
        case .breathing: return "wind"
        case .morning: return "sun.max.fill"
        case .gratitude: return "hands.sparkles.fill"
        }
    }
}

// MARK: - Stats View
struct MeditationStatsView: View {
    let totalMinutes: Int

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(L10n.Meditation.sessionsCompleted)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }

            HStack(spacing: 15) {
                StatCard(value: "\(totalMinutes)", label: L10n.string("meditation.total_minutes"), icon: "clock.fill", color: .purple)
                StatCard(value: "\(totalMinutes / 10)", label: L10n.string("meditation.sessions_completed"), icon: "checkmark.circle.fill", color: .green)
            }
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - Meditation Player View
struct MeditationPlayerView: View {
    let session: MeditationSession
    @Environment(\.dismiss) var dismiss
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var totalTime: Double

    init(session: MeditationSession) {
        self.session = session
        self._totalTime = State(initialValue: Double(session.duration * 60))
    }

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Close Button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()

                // Animation Circle
                ZStack {
                    // Outer Ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 3)
                        .frame(width: 250, height: 250)

                    // Progress Ring
                    Circle()
                        .trim(from: 0, to: currentTime / totalTime)
                        .stroke(
                            Color(hex: "D4FF00"),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))

                    // Inner Circle with Animation
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: "4A3F8A").opacity(0.5), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(
                            isPlaying ?
                            Animation.easeInOut(duration: 4).repeatForever(autoreverses: true) :
                            .default,
                            value: isPlaying
                        )

                    // Icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                }

                // Session Info
                VStack(spacing: 8) {
                    Text(session.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text(session.category.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                // Timer
                Text(formatTime(currentTime))
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .foregroundColor(.white)

                Spacer()

                // Controls
                HStack(spacing: 50) {
                    Button(action: { rewind() }) {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }

                    Button(action: { togglePlayPause() }) {
                        Circle()
                            .fill(Color(hex: "D4FF00"))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            )
                    }

                    Button(action: { forward() }) {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                // Volume & Sound Controls
                HStack(spacing: 30) {
                    Button(action: {}) {
                        VStack(spacing: 4) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 20))
                            Text("Sound")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.gray)
                    }

                    Button(action: {}) {
                        VStack(spacing: 4) {
                            Image(systemName: "music.note")
                                .font(.system(size: 20))
                            Text("Music")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.gray)
                    }

                    Button(action: {}) {
                        VStack(spacing: 4) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                            Text("Reminder")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if isPlaying && currentTime < totalTime {
                currentTime += 1
            }
        }
    }

    private func togglePlayPause() {
        isPlaying.toggle()
    }

    private func rewind() {
        currentTime = max(0, currentTime - 15)
    }

    private func forward() {
        currentTime = min(totalTime, currentTime + 15)
    }

    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    MeditationView()
        .environmentObject(FitnessManager())
        .preferredColorScheme(.dark)
}
