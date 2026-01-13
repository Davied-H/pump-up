//
//  AuthView+Localized.swift
//  FitnessApp
//
//  这是使用 LocalizationHelper 的优化版本示例
//  你可以选择使用这个版本替换原来的 AuthView
//

import SwiftUI

// MARK: - 示例：使用 L10n 枚举的优化版本

/*

// 在 AuthView 中，你可以这样使用：

struct AuthView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var isLogin = true
    
    let darkBackground = Color(hex: "1A1A2E")
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 70))
                        .foregroundColor(neonYellow)
                    
                    Text(L10n.App.name)  // 使用 L10n
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(isLogin ? L10n.Auth.welcomeBack : L10n.Auth.startJourney)  // 使用 L10n
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 80)
                .padding(.bottom, 60)
                
                // Auth Form
                if isLogin {
                    LoginForm()
                } else {
                    RegisterForm()
                }
                
                Spacer()
                
                // Toggle Button
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isLogin.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isLogin ? L10n.Auth.noAccount : L10n.Auth.haveAccount)  // 使用 L10n
                            .foregroundColor(.gray)
                        Text(isLogin ? L10n.Auth.register : L10n.Auth.login)  // 使用 L10n
                            .foregroundColor(neonYellow)
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 16))
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Login Form 使用 L10n
struct LoginForm: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var email = ""
    @State private var password = ""
    
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                icon: "envelope.fill",
                placeholder: L10n.Auth.email,  // 使用 L10n
                text: $email,
                isSecure: false
            )
            
            CustomTextField(
                icon: "lock.fill",
                placeholder: L10n.Auth.password,  // 使用 L10n
                text: $password,
                isSecure: true
            )
            
            if let error = fitnessManager.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button {
                Task {
                    await fitnessManager.login(email: email, password: password)
                }
            } label: {
                ZStack {
                    if fitnessManager.isLoading {
                        ProgressView()
                            .tint(.black)
                    } else {
                        Text(L10n.Auth.login)  // 使用 L10n
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(neonYellow)
                .cornerRadius(16)
            }
            .disabled(fitnessManager.isLoading || email.isEmpty || password.isEmpty)
            .opacity((fitnessManager.isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1)
            .padding(.top, 10)
            
            Button {
                email = "demo@fitlife.com"
                password = "demo123"
                Task {
                    await fitnessManager.login(email: email, password: password)
                }
            } label: {
                Text(L10n.Auth.demoLogin)  // 使用 L10n
                    .font(.system(size: 16))
                    .foregroundColor(neonYellow)
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Register Form 使用 L10n
struct RegisterForm: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordMismatch = false
    
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                icon: "person.fill",
                placeholder: L10n.Auth.name,  // 使用 L10n
                text: $name,
                isSecure: false
            )
            
            CustomTextField(
                icon: "envelope.fill",
                placeholder: L10n.Auth.email,  // 使用 L10n
                text: $email,
                isSecure: false
            )
            
            CustomTextField(
                icon: "lock.fill",
                placeholder: L10n.Auth.password,  // 使用 L10n
                text: $password,
                isSecure: true
            )
            
            CustomTextField(
                icon: "lock.fill",
                placeholder: L10n.Auth.confirmPassword,  // 使用 L10n
                text: $confirmPassword,
                isSecure: true
            )
            
            if showPasswordMismatch {
                Text(L10n.Auth.passwordMismatch)  // 使用 L10n
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }
            
            if let error = fitnessManager.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button {
                if password != confirmPassword {
                    showPasswordMismatch = true
                } else {
                    showPasswordMismatch = false
                    Task {
                        await fitnessManager.register(email: email, password: password, name: name)
                    }
                }
            } label: {
                ZStack {
                    if fitnessManager.isLoading {
                        ProgressView()
                            .tint(.black)
                    } else {
                        Text(L10n.Auth.register)  // 使用 L10n
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(neonYellow)
                .cornerRadius(16)
            }
            .disabled(fitnessManager.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            .opacity((fitnessManager.isLoading || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) ? 0.6 : 1)
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - CustomTextField 使用 LocalizedStringKey
struct CustomTextField: View {
    let icon: String
    let placeholder: LocalizedStringKey  // 改为 LocalizedStringKey
    @Binding var text: String
    let isSecure: Bool
    
    let darkGray = Color(hex: "2D2D3A")
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .textContentType(.password)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .background(darkGray)
        .cornerRadius(12)
    }
}

*/
