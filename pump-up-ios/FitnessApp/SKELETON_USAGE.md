# 骨架屏使用指南

## 概述

本项目现在包含高级加载动效和骨架屏组件，用于改善用户体验，特别是在 API 请求期间。

## 主要改进

### 1. 增强的加载视图 (LoadingView)

新的加载视图包含以下高级动效：
- ✨ 动态渐变背景
- 🌟 粒子效果动画
- 💫 多层光晕脉冲效果
- ⚡️ 循环进度条
- 🎭 流畅的文字和图标动画

### 2. 页面过渡动效

优化了应用状态之间的过渡：
- 使用 `ZStack` 和 `zIndex` 确保流畅切换
- 结合缩放、模糊和移动效果
- 弹簧动画提供自然的物理感

### 3. 骨架屏组件

提供三种可复用的骨架屏组件：

#### SkeletonView
基础骨架条，带有流光效果
```swift
SkeletonView()
    .frame(height: 20)
    .frame(width: 200)
```

#### SkeletonCard
完整的卡片骨架，适合内容卡片加载
```swift
SkeletonCard()
```

#### SkeletonList
列表项骨架，适合列表加载
```swift
SkeletonList(count: 5)
```

## 使用示例

### 在 HomeView 中使用

```swift
struct HomeView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    
    var body: some View {
        ScrollView {
            if fitnessManager.isLoading {
                // 显示骨架屏
                VStack(spacing: 16) {
                    SkeletonCard()
                    SkeletonCard()
                    SkeletonList(count: 3)
                }
                .padding()
            } else {
                // 显示实际内容
                VStack {
                    // 你的内容...
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: fitnessManager.isLoading)
    }
}
```

### 在 WorkoutView 中使用

```swift
struct WorkoutView: View {
    @EnvironmentObject var fitnessManager: FitnessManager
    
    var body: some View {
        VStack {
            if fitnessManager.workouts.isEmpty && fitnessManager.isLoading {
                // 加载中 - 显示骨架屏
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0..<3) { _ in
                            SkeletonCard()
                        }
                    }
                    .padding()
                }
            } else {
                // 显示实际训练列表
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(fitnessManager.workouts) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding()
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: fitnessManager.isLoading)
    }
}
```

### 自定义骨架屏

你也可以创建自定义的骨架布局：

```swift
struct CustomSkeletonView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                SkeletonView()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
                    SkeletonView()
                        .frame(height: 20)
                    SkeletonView()
                        .frame(height: 16)
                        .frame(width: 150)
                    SkeletonView()
                        .frame(height: 16)
                        .frame(width: 100)
                }
            }
            
            SkeletonView()
                .frame(height: 200)
        }
        .padding()
    }
}
```

## 最佳实践

1. **始终使用动画过渡**：在骨架屏和实际内容之间切换时使用 `.transition()` 和 `.animation()`

2. **匹配实际布局**：骨架屏的布局应该与实际内容相似，这样用户能预期内容的结构

3. **适当的加载数量**：不要显示太多骨架项，3-5 个通常就足够

4. **检查加载状态**：使用 `fitnessManager.isLoading` 来控制显示骨架屏还是实际内容

5. **考虑空状态**：除了加载状态，也要处理空数据状态

## 性能优化

- 使用 `LazyVStack` 和 `LazyHStack` 进行列表渲染
- 骨架屏动画使用 GPU 加速的属性（位移、缩放、透明度）
- 避免在骨架屏中使用过于复杂的视图层次

## 动画参数调优

当前使用的动画参数：
- **响应时间 (response)**: 0.5-0.55s - 快速但不突兀
- **阻尼系数 (dampingFraction)**: 0.75-0.8 - 轻微回弹效果
- **流光动画**: 1.5s 线性循环 - 流畅的加载指示

你可以根据实际需求调整这些参数。

## 视觉一致性

所有动效使用应用主题色：
- **暗背景**: `#1A1A2E`
- **霓虹黄**: `#D4FF00`
- **背景元素**: `#16213E`

保持与品牌视觉的一致性。
