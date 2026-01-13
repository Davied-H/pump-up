import { Dumbbell, Brain, Heart, Utensils, Trophy, Activity } from 'lucide-react'

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
    id: 'workout',
    title: '锻炼追踪',
    description: '记录每一次训练，涵盖力量、有氧、HIIT、瑜伽等多种类型',
    icon: Dumbbell,
    gradient: 'from-purple-500 to-pink-500',
  },
  {
    id: 'meditation',
    title: '冥想放松',
    description: '多种冥想课程，帮助你减压、助眠、提升专注力',
    icon: Brain,
    gradient: 'from-blue-500 to-cyan-500',
  },
  {
    id: 'health',
    title: '健康数据',
    description: '与 Apple HealthKit 无缝集成，实时追踪心率、睡眠等数据',
    icon: Heart,
    gradient: 'from-red-500 to-orange-500',
  },
  {
    id: 'nutrition',
    title: '营养记录',
    description: '轻松记录每餐摄入，追踪卡路里和营养成分',
    icon: Utensils,
    gradient: 'from-green-500 to-emerald-500',
  },
  {
    id: 'achievement',
    title: '成就系统',
    description: '解锁成就徽章，让健身之路更有动力',
    icon: Trophy,
    gradient: 'from-yellow-500 to-amber-500',
  },
]
