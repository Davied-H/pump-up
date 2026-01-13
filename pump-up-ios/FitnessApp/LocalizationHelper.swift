//
//  LocalizationHelper.swift
//  FitnessApp
//
//  本地化辅助工具
//

import Foundation
import SwiftUI

/// 本地化字符串命名空间
enum L10n {
    
    // MARK: - 应用核心
    enum App {
        static let name = LocalizedStringKey("FitLife")
    }
    
    // MARK: - Tab 标签
    enum Tab {
        static let home = LocalizedStringKey("Home")
        static let workout = LocalizedStringKey("Workout")
        static let meditation = LocalizedStringKey("Meditation")
        static let profile = LocalizedStringKey("Profile")
    }
    
    // MARK: - 认证
    enum Auth {
        static let welcomeBack = LocalizedStringKey("auth.welcome_back")
        static let startJourney = LocalizedStringKey("auth.start_journey")
        static let login = LocalizedStringKey("auth.login")
        static let register = LocalizedStringKey("auth.register")
        static let email = LocalizedStringKey("auth.email")
        static let password = LocalizedStringKey("auth.password")
        static let name = LocalizedStringKey("auth.name")
        static let confirmPassword = LocalizedStringKey("auth.confirm_password")
        static let passwordMismatch = LocalizedStringKey("auth.password_mismatch")
        static let noAccount = LocalizedStringKey("auth.no_account")
        static let haveAccount = LocalizedStringKey("auth.have_account")
        static let demoLogin = LocalizedStringKey("auth.demo_login")
    }
    
    // MARK: - 辅助方法：获取字符串值（非 SwiftUI）
    static func string(_ key: String, comment: String = "") -> String {
        NSLocalizedString(key, comment: comment)
    }
}

// MARK: - String Extension for Localization
extension String {
    /// 将字符串转换为本地化字符串
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// 带参数的本地化字符串
    func localized(with arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}

// MARK: - 使用示例
/*
 
 在 SwiftUI 视图中使用：
 
 ```swift
 // 方法 1: 使用 L10n 枚举（推荐，类型安全）
 Text(L10n.Auth.login)
 
 // 方法 2: 直接使用 LocalizedStringKey
 Text(LocalizedStringKey("auth.login"))
 
 // 方法 3: 使用 String extension（在非 SwiftUI 代码中）
 let loginText = "auth.login".localized
 ```
 
 带参数的本地化：
 
 ```swift
 // 在 Localizable.xcstrings 中定义：
 // "workout.completed" : "完成了 %d 次锻炼"
 
 let message = "workout.completed".localized(with: 5)
 // 输出: "完成了 5 次锻炼"
 ```
 
 */
