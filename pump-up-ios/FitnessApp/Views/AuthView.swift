//
//  AuthView.swift
//  FitnessApp
//
//  Login and Registration views
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""

    // Theme colors
    let darkBackground = Color(hex: "1A1A2E")
    let cardBackground = Color(hex: "252542")
    let neonYellow = Color(hex: "D4FF00")
    let textPrimary = Color.white
    let textSecondary = Color.gray

    var body: some View {
        ZStack {
            darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 60)

                    // Logo
                    VStack(spacing: 10) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 60))
                            .foregroundColor(neonYellow)

                        Text("FitLife")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(textPrimary)

                        Text("开启你的健身之旅")
                            .font(.subheadline)
                            .foregroundColor(textSecondary)
                    }

                    // Tab Selector
                    HStack(spacing: 0) {
                        TabButton(title: "登录", isSelected: isLogin) {
                            withAnimation { isLogin = true }
                        }
                        TabButton(title: "注册", isSelected: !isLogin) {
                            withAnimation { isLogin = false }
                        }
                    }
                    .background(cardBackground)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)

                    // Form
                    VStack(spacing: 20) {
                        if !isLogin {
                            CustomTextField(
                                icon: "person.fill",
                                placeholder: "姓名",
                                text: $name
                            )
                        }

                        CustomTextField(
                            icon: "envelope.fill",
                            placeholder: "邮箱",
                            text: $email,
                            keyboardType: .emailAddress
                        )

                        CustomSecureField(
                            icon: "lock.fill",
                            placeholder: "密码",
                            text: $password
                        )

                        if !isLogin {
                            CustomSecureField(
                                icon: "lock.fill",
                                placeholder: "确认密码",
                                text: $confirmPassword
                            )
                        }

                        // Error Message
                        if let error = fitnessManager.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        // Submit Button
                        Button(action: submit) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(neonYellow)
                                    .frame(height: 55)

                                if fitnessManager.isLoading {
                                    ProgressView()
                                        .tint(darkBackground)
                                } else {
                                    Text(isLogin ? "登录" : "注册")
                                        .font(.headline)
                                        .foregroundColor(darkBackground)
                                }
                            }
                        }
                        .disabled(fitnessManager.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1 : 0.6)
                        .padding(.top, 10)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(textSecondary.opacity(0.3))
                                .frame(height: 1)
                            Text("或")
                                .font(.caption)
                                .foregroundColor(textSecondary)
                            Rectangle()
                                .fill(textSecondary.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical)

                        // Social Login Buttons
                        VStack(spacing: 12) {
                            SocialLoginButton(
                                icon: "apple.logo",
                                title: "使用 Apple 登录",
                                backgroundColor: .white,
                                foregroundColor: .black
                            ) {
                                // Apple sign in
                            }

                            SocialLoginButton(
                                icon: "g.circle.fill",
                                title: "使用 Google 登录",
                                backgroundColor: cardBackground,
                                foregroundColor: textPrimary
                            ) {
                                // Google sign in
                            }
                        }
                    }
                    .padding(.horizontal, 30)

                    // Terms
                    if !isLogin {
                        Text("注册即表示您同意我们的服务条款和隐私政策")
                            .font(.caption)
                            .foregroundColor(textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    Spacer().frame(height: 50)
                }
            }
        }
    }

    var isFormValid: Bool {
        if isLogin {
            return !email.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty && !name.isEmpty && password == confirmPassword
        }
    }

    func submit() {
        Task {
            if isLogin {
                await fitnessManager.login(email: email, password: password)
            } else {
                await fitnessManager.register(email: email, password: password, name: name)
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    let neonYellow = Color(hex: "D4FF00")
    let darkBackground = Color(hex: "1A1A2E")

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isSelected ? darkBackground : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? neonYellow : Color.clear)
                .cornerRadius(25)
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    let cardBackground = Color(hex: "252542")
    let textPrimary = Color.white

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .foregroundColor(textPrimary)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(15)
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure = true

    let cardBackground = Color(hex: "252542")
    let textPrimary = Color.white

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(textPrimary)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(textPrimary)
            }

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(15)
    }
}

struct SocialLoginButton: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.subheadline)
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .cornerRadius(15)
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(FitnessManager())
}
