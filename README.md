# Pump-Up

A comprehensive fitness tracking application with workout logging, meditation sessions, and HealthKit integration.

一款功能全面的健身追踪应用，支持运动记录、冥想课程和 HealthKit 集成。

[English](#english) | [中文](#中文)

---

## English

### About

Pump-Up is a monorepo fitness application designed to help users track their workouts, practice meditation, and monitor their health metrics. The project consists of a Go backend API, a native iOS app built with SwiftUI, and an official website.

### Features

- **Workout Tracking** - 6 preset workout templates with session recording
- **Meditation Courses** - 6 guided meditation sessions
- **HealthKit Integration** - Sync steps, heart rate, sleep, and weight data
- **Achievement System** - Earn badges and track milestones
- **Push Notifications** - Workout reminders and encouragements
- **Multi-language Support** - English and Chinese

### Tech Stack

| Component | Technology |
|-----------|------------|
| Backend | Go 1.23, Gin, GORM, JWT, MongoDB (optional) |
| iOS | Swift, SwiftUI, HealthKit, UserNotifications |
| Website | React 19, TypeScript, Vite, Tailwind CSS |
| Database | MySQL / SQLite |

### Project Structure

```
pump-up/
├── pump-up-api/      # Go backend API
├── pump-up-ios/      # Native iOS app
├── official-web/     # Official website
├── doc/              # Documentation
├── ROADMAP.md        # Feature roadmap
└── CLAUDE.md         # Development guide
```

### Quick Start

#### Prerequisites

- Go 1.23+
- Node.js 18+
- Xcode 15+ (for iOS)

#### Backend

```bash
cd pump-up-api
cp env.example .env
go mod download
go run main.go
# Server runs on http://localhost:8080
```

#### Website

```bash
cd official-web
npm install
npm run dev
# Dev server runs on http://localhost:5173
```

#### iOS

1. Open `pump-up-ios/FitnessApp.xcodeproj` in Xcode
2. Configure your development team
3. Build and run on simulator or device

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | User registration |
| POST | `/api/auth/login` | User login |
| GET | `/api/workout/templates` | Get workout templates |
| POST | `/api/workout/session` | Record workout session |
| GET | `/api/meditation/courses` | Get meditation courses |
| GET | `/api/achievement/list` | Get user achievements |

### Roadmap

See [ROADMAP.md](ROADMAP.md) for detailed feature planning including:
- AI workout plan generator
- AI chat coach
- Diet tracking and nutrition analysis
- Social features

### Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## 中文

### 关于

Pump-Up 是一个 Monorepo 健身应用，旨在帮助用户追踪运动、练习冥想并监控健康指标。项目包含 Go 后端 API、SwiftUI 原生 iOS 应用和官方网站。

### 功能特性

- **运动追踪** - 6 种预设运动模板，支持会话记录
- **冥想课程** - 6 节引导式冥想课程
- **HealthKit 集成** - 同步步数、心率、睡眠和体重数据
- **成就系统** - 获取勋章，追踪里程碑
- **推送通知** - 运动提醒和激励消息
- **多语言支持** - 中文和英文

### 技术栈

| 组件 | 技术 |
|------|------|
| 后端 | Go 1.23, Gin, GORM, JWT, MongoDB（可选） |
| iOS | Swift, SwiftUI, HealthKit, UserNotifications |
| 网站 | React 19, TypeScript, Vite, Tailwind CSS |
| 数据库 | MySQL / SQLite |

### 项目结构

```
pump-up/
├── pump-up-api/      # Go 后端 API
├── pump-up-ios/      # 原生 iOS 应用
├── official-web/     # 官方网站
├── doc/              # 文档
├── ROADMAP.md        # 功能路线图
└── CLAUDE.md         # 开发指南
```

### 快速开始

#### 环境要求

- Go 1.23+
- Node.js 18+
- Xcode 15+（iOS 开发）

#### 后端

```bash
cd pump-up-api
cp env.example .env
go mod download
go run main.go
# 服务运行在 http://localhost:8080
```

#### 网站

```bash
cd official-web
npm install
npm run dev
# 开发服务器运行在 http://localhost:5173
```

#### iOS

1. 用 Xcode 打开 `pump-up-ios/FitnessApp.xcodeproj`
2. 配置开发团队
3. 在模拟器或真机上构建运行

### API 接口

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/api/auth/register` | 用户注册 |
| POST | `/api/auth/login` | 用户登录 |
| GET | `/api/workout/templates` | 获取运动模板 |
| POST | `/api/workout/session` | 记录运动会话 |
| GET | `/api/meditation/courses` | 获取冥想课程 |
| GET | `/api/achievement/list` | 获取用户成就 |

### 路线图

详细功能规划请查看 [ROADMAP.md](ROADMAP.md)，包括：
- AI 运动计划生成器
- AI 聊天教练
- 饮食追踪和营养分析
- 社交功能

### 贡献指南

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 许可证

本项目采用 Apache License 2.0 许可证 - 详情请查看 [LICENSE](LICENSE) 文件。
