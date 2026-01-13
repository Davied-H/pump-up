//
//  ProfileView.swift
//  FitnessApp
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var showEditProfile = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    // Profile Header
                    ProfileHeaderView(
                        user: fitnessManager.currentUser,
                        onEditTap: { showEditProfile = true }
                    )

                    // Stats Overview
                    StatsOverviewSection(statistics: fitnessManager.statistics)

                    // Achievements
                    AchievementsSection(achievements: fitnessManager.achievements)

                    // Goals Section
                    GoalsSection(user: fitnessManager.currentUser)

                    // Menu Items
                    ProfileMenuSection(showSettings: $showSettings)

                    // App Info
                    AppInfoView()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(user: $fitnessManager.currentUser)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Profile Header
struct ProfileHeaderView: View {
    let user: User
    let onEditTap: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "D4FF00"), Color(hex: "8BC34A")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(user.name.prefix(1)))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)
                    )

                Button(action: onEditTap) {
                    Circle()
                        .fill(Color(hex: "1C1C1E"))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        )
                }
            }

            // Name & Email
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            // Quick Stats
            HStack(spacing: 30) {
                ProfileQuickStat(value: "\(Int(user.height))", label: "Height", unit: "cm")
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.3))
                ProfileQuickStat(value: "\(Int(user.weight))", label: "Weight", unit: "kg")
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.3))
                ProfileQuickStat(value: "\(user.age)", label: "Age", unit: "yrs")
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
        .padding(.top, 20)
    }
}

struct ProfileQuickStat: View {
    let value: String
    let label: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text(unit)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Stats Overview
struct StatsOverviewSection: View {
    let statistics: FitnessStatistics

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatOverviewCard(
                    icon: "flame.fill",
                    value: "\(statistics.totalCaloriesBurned)",
                    label: "Calories Burned",
                    color: .orange
                )
                StatOverviewCard(
                    icon: "figure.run",
                    value: "\(statistics.totalWorkouts)",
                    label: "Workouts",
                    color: .green
                )
                StatOverviewCard(
                    icon: "clock.fill",
                    value: "\(statistics.totalActiveMinutes)",
                    label: "Active Minutes",
                    color: .blue
                )
                StatOverviewCard(
                    icon: "brain.head.profile",
                    value: "\(statistics.totalMeditationMinutes)",
                    label: "Meditation",
                    color: .purple
                )
            }
        }
    }
}

struct StatOverviewCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - Achievements Section
struct AchievementsSection: View {
    let achievements: [Achievement]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {}) {
                    Text("View All")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "D4FF00"))
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color(hex: "D4FF00") : Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)

                Image(systemName: achievement.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.isUnlocked ? .black : .gray)

                if !achievement.isUnlocked {
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                }
            }

            VStack(spacing: 2) {
                Text(achievement.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(achievement.description)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 100)
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - Goals Section
struct GoalsSection: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Goals")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                GoalProgressRow(
                    icon: "shoeprints.fill",
                    title: "Steps",
                    current: 3246,
                    goal: user.dailyStepGoal,
                    color: Color(hex: "D4FF00")
                )

                GoalProgressRow(
                    icon: "flame.fill",
                    title: "Calories",
                    current: 124,
                    goal: user.dailyCalorieGoal,
                    color: .orange
                )

                GoalProgressRow(
                    icon: "clock.fill",
                    title: "Active Time",
                    current: 45,
                    goal: 60,
                    color: .blue,
                    unit: "min"
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1C1C1E"))
            )
        }
    }
}

struct GoalProgressRow: View {
    let icon: String
    let title: String
    let current: Int
    let goal: Int
    let color: Color
    var unit: String = ""

    var progress: Double {
        min(Double(current) / Double(goal), 1.0)
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)

                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Text("\(current)\(unit) / \(goal)\(unit)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Profile Menu
struct ProfileMenuSection: View {
    @Binding var showSettings: Bool

    let menuItems: [(String, String, Color)] = [
        ("gearshape.fill", "Settings", .gray),
        ("bell.fill", "Notifications", .orange),
        ("shield.fill", "Privacy", .blue),
        ("questionmark.circle.fill", "Help & Support", .green),
        ("star.fill", "Rate Us", .yellow)
    ]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.0) { icon, title, color in
                Button(action: {
                    if title == "Settings" {
                        showSettings = true
                    }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(color)
                            .frame(width: 24)

                        Text(title)
                            .font(.system(size: 16))
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 15)
                }

                if title != "Rate Us" {
                    Divider()
                        .background(Color.gray.opacity(0.2))
                }
            }
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
        )
    }
}

// MARK: - App Info
struct AppInfoView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("FitLife")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            Text("Version 1.0.0")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Text("Made with ❤️ by Your Team")
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var selectedGoal: User.FitnessGoal = .stayFit

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "D4FF00"), Color(hex: "8BC34A")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(String(name.prefix(1)))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                        )
                        .overlay(
                            Button(action: {}) {
                                Circle()
                                    .fill(Color(hex: "D4FF00"))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)
                                    )
                            }
                            .offset(x: 35, y: 35)
                        )
                        .padding(.top, 20)

                    // Form Fields
                    VStack(spacing: 16) {
                        EditField(title: "Name", text: $name, placeholder: "Enter your name")
                        EditField(title: "Height (cm)", text: $height, placeholder: "165", keyboardType: .numberPad)
                        EditField(title: "Weight (kg)", text: $weight, placeholder: "58", keyboardType: .decimalPad)
                        EditField(title: "Age", text: $age, placeholder: "28", keyboardType: .numberPad)

                        // Fitness Goal Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fitness Goal")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)

                            ForEach(User.FitnessGoal.allCases, id: \.self) { goal in
                                Button(action: { selectedGoal = goal }) {
                                    HStack {
                                        Text(goal.rawValue)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        Spacer()
                                        if selectedGoal == goal {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color(hex: "D4FF00"))
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedGoal == goal ? Color(hex: "D4FF00").opacity(0.1) : Color(hex: "2C2C2E"))
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.black)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveProfile() }
                        .foregroundColor(Color(hex: "D4FF00"))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            name = user.name
            height = "\(Int(user.height))"
            weight = "\(Int(user.weight))"
            age = "\(user.age)"
            selectedGoal = user.fitnessGoal
        }
    }

    private func saveProfile() {
        user.name = name
        user.height = Double(height) ?? user.height
        user.weight = Double(weight) ?? user.weight
        user.age = Int(age) ?? user.age
        user.fitnessGoal = selectedGoal
        dismiss()
    }
}

struct EditField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "1C1C1E"))
                )
                .keyboardType(keyboardType)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationsEnabled = true
    @State private var darkMode = true
    @State private var units = "Metric"

    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkMode)

                    Picker("Units", selection: $units) {
                        Text("Metric").tag("Metric")
                        Text("Imperial").tag("Imperial")
                    }
                }

                Section("Account") {
                    Button("Change Password") {}
                    Button("Connected Devices") {}
                    Button("Export Data") {}
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    Button("Terms of Service") {}
                    Button("Privacy Policy") {}
                }

                Section {
                    Button("Sign Out") {}
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "D4FF00"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProfileView()
        .environmentObject(FitnessManager())
        .preferredColorScheme(.dark)
}
