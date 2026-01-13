//
//  AuthView.swift
//  FitnessApp
//

import SwiftUI

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
                    
                    Text("FitLife", bundle: .main, comment: "App name")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(isLogin ? LocalizedStringKey("auth.welcome_back") : LocalizedStringKey("auth.start_journey"))
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
                        Text(isLogin ? LocalizedStringKey("auth.no_account") : LocalizedStringKey("auth.have_account"))
                            .foregroundColor(.gray)
                        Text(isLogin ? LocalizedStringKey("auth.register") : LocalizedStringKey("auth.login"))
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

// MARK: - Login Form
struct LoginForm: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var email = ""
    @State private var password = ""
    
    let neonYellow = Color(hex: "D4FF00")
    let darkGray = Color(hex: "2D2D3A")
    
    var body: some View {
        VStack(spacing: 20) {
            // Email Field
            CustomTextField(
                icon: "envelope.fill",
                placeholder: "auth.email",
                text: $email,
                isSecure: false
            )
            
            // Password Field
            CustomTextField(
                icon: "lock.fill",
                placeholder: "auth.password",
                text: $password,
                isSecure: true
            )
            
            // Error Message
            if let error = fitnessManager.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Login Button
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
                        Text("auth.login", bundle: .main, comment: "Login button")
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
            
            // Demo Login Button
            Button {
                email = "demo@fitlife.com"
                password = "demo123"
                Task {
                    await fitnessManager.login(email: email, password: password)
                }
            } label: {
                Text("auth.demo_login", bundle: .main, comment: "Demo login button")
                    .font(.system(size: 16))
                    .foregroundColor(neonYellow)
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Register Form
struct RegisterForm: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordMismatch = false
    
    let neonYellow = Color(hex: "D4FF00")
    let darkGray = Color(hex: "2D2D3A")
    
    var body: some View {
        VStack(spacing: 20) {
            // Name Field
            CustomTextField(
                icon: "person.fill",
                placeholder: "auth.name",
                text: $name,
                isSecure: false
            )
            
            // Email Field
            CustomTextField(
                icon: "envelope.fill",
                placeholder: "auth.email",
                text: $email,
                isSecure: false
            )
            
            // Password Field
            CustomTextField(
                icon: "lock.fill",
                placeholder: "auth.password",
                text: $password,
                isSecure: true
            )
            
            // Confirm Password Field
            CustomTextField(
                icon: "lock.fill",
                placeholder: "auth.confirm_password",
                text: $confirmPassword,
                isSecure: true
            )
            
            // Error Messages
            if showPasswordMismatch {
                Text("auth.password_mismatch", bundle: .main, comment: "Password mismatch error")
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
            
            // Register Button
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
                        Text("auth.register", bundle: .main, comment: "Register button")
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

// MARK: - Custom Text Field
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    let darkGray = Color(hex: "2D2D3A")
    let neonYellow = Color(hex: "D4FF00")
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .frame(width: 24)
            
            if isSecure {
                SecureField(LocalizedStringKey(placeholder), text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .textContentType(.password)
            } else {
                TextField(LocalizedStringKey(placeholder), text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .keyboardType(placeholder.contains("email") ? .emailAddress : .default)
                    .textContentType(placeholder.contains("email") ? .emailAddress : .none)
            }
        }
        .padding()
        .background(darkGray)
        .cornerRadius(12)
    }
}

#Preview {
    AuthView()
        .environmentObject(FitnessManager())
}
