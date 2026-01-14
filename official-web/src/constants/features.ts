import { Dumbbell, Brain, Trophy, Activity } from 'lucide-react'

export const workoutTypes = [
  { id: 'strength', name: '力量训练', icon: Dumbbell, color: 'from-purple-500 to-purple-700' },
  { id: 'cardio', name: '有氧运动', icon: Activity, color: 'from-green-500 to-green-700' },
  { id: 'hiit', name: 'HIIT 高强度', icon: Activity, color: 'from-orange-500 to-orange-700' },
  { id: 'yoga', name: '瑜伽', icon: Brain, color: 'from-cyan-500 to-cyan-700' },
  { id: 'flexibility', name: '柔韧性', icon: Activity, color: 'from-pink-500 to-pink-700' },
  { id: 'outdoor', name: '户外运动', icon: Activity, color: 'from-yellow-500 to-yellow-700' },
]

export const meditationTypes = [
  { id: 'sleep', name: '助眠', color: 'from-indigo-500 to-indigo-700' },
  { id: 'stress', name: '减压', color: 'from-pink-500 to-pink-700' },
  { id: 'focus', name: '专注', color: 'from-blue-500 to-blue-700' },
  { id: 'breathing', name: '呼吸', color: 'from-teal-500 to-teal-700' },
  { id: 'morning', name: '晨间', color: 'from-orange-500 to-orange-700' },
  { id: 'gratitude', name: '感恩', color: 'from-purple-500 to-purple-700' },
]

export const mainFeatures = [
  {
    id: 'tracking',
    title: '智能追踪',
    description: '实时同步步数、卡路里、运动时长，与 Apple HealthKit 深度集成',
    screenshot: '/images/screenshots/home.png',
    gradient: 'from-primary to-green-500',
    icon: Activity,
    features: ['步数统计', '卡路里消耗', '运动时长', 'HealthKit 同步']
  },
  {
    id: 'workout',
    title: '锻炼计划',
    description: '丰富的训练课程，从力量到有氧，满足不同健身需求',
    screenshot: '/images/screenshots/workout.png',
    gradient: 'from-purple-500 to-pink-500',
    icon: Dumbbell,
    features: ['力量训练', '有氧运动', 'HIIT', '自定义计时']
  },
  {
    id: 'meditation',
    title: '冥想放松',
    description: '多种冥想课程，帮助你助眠、减压、提升专注力',
    screenshot: '/images/screenshots/meditation.png',
    gradient: 'from-blue-500 to-cyan-500',
    icon: Brain,
    features: ['助眠冥想', '减压放松', '专注呼吸', '晨间能量']
  },
  {
    id: 'profile',
    title: '个人成就',
    description: '追踪你的健身进度，解锁成就徽章，保持动力',
    screenshot: '/images/screenshots/profile.png',
    gradient: 'from-yellow-500 to-orange-500',
    icon: Trophy,
    features: ['身体数据', '运动统计', '成就徽章', '历史记录']
  }
]

// Privacy features for the new PrivacySection
export const privacyFeatures = [
  {
    id: 'local',
    title: '本地优先存储',
    description: '所有健身数据存储在你的设备上，不强制上传云端',
    icon: 'shield'
  },
  {
    id: 'encrypted',
    title: '端到端加密',
    description: '敏感数据传输采用行业标准加密协议保护',
    icon: 'lock'
  },
  {
    id: 'noTracking',
    title: '零广告追踪',
    description: '不收集用于广告投放的用户行为数据',
    icon: 'eye-off'
  }
]
