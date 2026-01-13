# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pump-Up is a fitness tracking application monorepo with three components:
- **pump-up-api**: Go backend API (Gin framework) with React web frontend
- **pump-up-ios**: Native iOS app (SwiftUI)

## Common Commands

### Backend (pump-up-api)

```bash
# Development
go run main.go                              # Start dev server on :8080

# Build
go build -o bin/my-api main.go              # Local build
./script/shell/build.sh linux               # Linux cross-compile
./script/shell/build.sh darwin              # macOS build

# Testing
go test ./...                               # Run all tests
go test ./internal/util/codeUtil -v -run TestFunctionName  # Single test

# Dependencies
go mod download
go mod tidy
```

### Frontend (pump-up-api/frontend/my-web)

```bash
cd frontend/my-web
npm run dev      # Start Vite dev server on :5173
npm run build    # Production build
npm run lint     # ESLint
```

### iOS (pump-up-ios)

Open `FitnessApp.xcodeproj` in Xcode, or:
```bash
xcodebuild -scheme FitnessApp -configuration Release
```

## Architecture

### Backend Structure

```
pump-up-api/
├── cmd/cmd.go                    # Service startup & module registration
├── config/app_dev.yml            # Configuration (supports MySQL/SQLite)
├── internal/
│   ├── com/                      # Global singletons (DB, Logger, Config)
│   ├── model/                    # GORM models (auto-migrated)
│   ├── service/                  # Business logic by domain
│   │   ├── service.go            # Router & HTTP wrapper
│   │   ├── middleware.go         # Auth, CORS
│   │   └── {module}/{module}Impl/  # Handler implementations
│   └── util/                     # Utilities (token, password, etc.)
├── script/shell/                 # Build & deployment scripts
└── frontend/my-web/              # React frontend
```

### Global Components (internal/com)

- `com.DB` - GORM database instance
- `com.L` - Logrus logger
- `com.Conf` - Viper configuration
- `com.GetMongoCollection()` - MongoDB accessor (optional)

### Request Processing Flow

1. Route defined in `service/{module}/service.go`
2. Wrapped by `GinHandlerWrapWithVo(&{Action}Req{})`
3. Auto-binds JSON to `{Action}Req` struct
4. Executes `Request(ctx, resp)` method
5. Returns `HttpBaseRespVo{Code, Msg, Data}`

### Creating New API Endpoint

```go
// internal/service/{module}/{module}Impl/{action}.go
type CreateReq struct {
    Name string `json:"name" binding:"required"`
    US   tokenUtil.UserStd `json:"-"`  // Injected for authenticated routes
}

type CreateResp struct {
    ID string `json:"id"`
}

func (req *CreateReq) Request(ctx *gin.Context, resp *service.HttpBaseRespVo) error {
    return req.Do(resp)
}

func (req *CreateReq) Do(resp *service.HttpBaseRespVo) *com.CustomError {
    // Business logic here
    resp.Data = CreateResp{ID: "..."}
    return nil  // or com.NewError("message")
}
```

### Route Registration

```go
// internal/service/{module}/service.go
func NewService() service.Option {
    return func(s *service.Service) {
        s.ApiGroup.POST("/public/endpoint", service.GinHandlerWrapWithVo(&impl.PublicReq{}))

        auth := s.ApiGroup.Group("/protected", service.AuthMid())
        auth.POST("/action", service.GinHandlerWrapWithVo(&impl.ActionReq{}))
    }
}
```

Register module in `cmd/cmd.go`:
```go
service.NewService(
    yourmodule.NewService(),
    // ...
).Run()
```

### iOS App Structure

```
pump-up-ios/FitnessApp/
├── FitnessApp.swift           # Entry point
├── APIService.swift           # Backend communication
├── HealthKitManager.swift     # HealthKit integration
├── Models/                    # Data models
├── ViewModels/                # State management
└── Views/                     # SwiftUI views
```

## Configuration

Backend configuration is in `config/app_dev.yml`. Sensitive values use environment variables:

```bash
JWT_SECRET=...
MYSQL_PASS=...
MAIL_PASSWORD=...
```

Default development uses SQLite (`my-api.sqlite`). Switch to MySQL by changing `orm.use` in config.

## API Testing

HTTP test files are in `script/http_request/`. Use VS Code REST Client or similar.

## Key Technologies

- **Backend**: Go 1.23, Gin, GORM, JWT, MongoDB (optional)
- **Frontend**: React 18, TypeScript, Vite, Ant Design
- **iOS**: SwiftUI, HealthKit, UserNotifications
