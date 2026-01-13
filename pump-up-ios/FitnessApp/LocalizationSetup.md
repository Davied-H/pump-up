# 国际化 (i18n) 配置指南

## 已完成的更改

### 1. 创建了本地化字符串文件
- **文件**: `Localizable.xcstrings`
- **源语言**: 简体中文 (zh-Hans)
- **支持的语言**: 简体中文、英文

### 2. 更新了视图文件
- ✅ `ContentView.swift` - Tab 标签和应用名称已本地化
- ✅ `AuthView.swift` - 登录和注册界面已本地化

## Xcode 项目配置步骤

### 第一步：添加 Localizable.xcstrings 到项目
1. 在 Xcode 中，将 `Localizable.xcstrings` 文件拖入项目导航器
2. 确保勾选你的 App Target

### 第二步：配置项目本地化设置
1. 选择项目文件（最顶部的蓝色图标）
2. 在 **Info** 标签页中找到 **Localizations** 部分
3. 点击 **+** 按钮添加语言：
   - 简体中文 (Chinese, Simplified) - 默认语言
   - 英文 (English) - 备用语言

### 第三步：设置开发语言区域
1. 在项目设置的 **Info** 标签中
2. 找到 **Development Language** 或 **Development Region**
3. 设置为 **Chinese, Simplified (zh-Hans)**

### 第四步：配置 Info.plist (可选，但推荐)
在 Info.plist 中添加：
```xml
<key>CFBundleDevelopmentRegion</key>
<string>zh_CN</string>
```

## 测试本地化

### 在模拟器/真机上测试
1. 打开设备的 **设置** > **通用** > **语言与地区**
2. 将"首选语言"设置为"中文（简体）"查看中文界面
3. 将"首选语言"设置为"English"查看英文界面

### 在 Xcode 中测试
1. 选择 Scheme（Product > Scheme > Edit Scheme）
2. 在 **Run** 选项中，找到 **Options** 标签
3. 设置 **App Language** 为：
   - Chinese, Simplified (简体中文)
   - English (英文)

## 本地化字符串使用方法

### 在 SwiftUI Text 中使用
```swift
// 方法 1：使用 LocalizedStringKey
Text(LocalizedStringKey("auth.login"))

// 方法 2：使用 Text 的 bundle 参数（推荐，可添加注释）
Text("auth.login", bundle: .main, comment: "Login button text")

// 方法 3：直接使用字符串（如果字符串在 Localizable.xcstrings 中定义）
Text("Home")  // 会自动查找本地化
```

### 在代码中获取本地化字符串
```swift
let localizedString = NSLocalizedString("auth.login", comment: "Login button")
```

## 当前已本地化的字符串

### 应用核心
- `FitLife` - 应用名称
- `Home` - 首页
- `Workout` - 锻炼
- `Meditation` - 冥想
- `Profile` - 我的

### 认证相关
- `auth.welcome_back` - 欢迎回来
- `auth.start_journey` - 开启健康之旅
- `auth.login` - 登录
- `auth.register` - 注册
- `auth.email` - 邮箱
- `auth.password` - 密码
- `auth.name` - 姓名
- `auth.confirm_password` - 确认密码
- `auth.password_mismatch` - 密码不匹配
- `auth.no_account` - 还没有账号?
- `auth.have_account` - 已有账号?
- `auth.demo_login` - 使用演示账号登录

## 添加新的本地化字符串

编辑 `Localizable.xcstrings` 文件，添加新的字符串：

```json
"your.new.key" : {
  "extractionState" : "manual",
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Your English Text"
      }
    },
    "zh-Hans" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "你的中文文本"
      }
    }
  }
}
```

## 注意事项

1. **命名规范**: 使用点分隔的命名空间，如 `module.feature.text`
2. **注释**: 在代码中使用 `comment` 参数帮助理解上下文
3. **默认语言**: 项目默认使用简体中文，如果设备语言不支持，会回退到中文
4. **格式化字符串**: 对于需要参数的字符串，使用 `String(format:)` 或 `String(localized:)`

## 下一步工作

如果需要为其他视图添加本地化，请告诉我：
- HomeView
- WorkoutView
- MeditationView
- ProfileView

我可以帮你添加更多的本地化字符串！
