import { Helmet } from 'react-helmet-async'
import { motion } from 'framer-motion'
import { Dumbbell, Brain, Heart, Utensils, Trophy, Activity } from 'lucide-react'
import { Container } from '@components/common/Container'
import { workoutTypes, meditationTypes } from '@constants/features'

export function FeaturesPage() {
  return (
    <>
      <Helmet>
        <title>功能介绍 | Pump-Up</title>
        <meta
          name="description"
          content="了解 Pump-Up 的全部功能：锻炼追踪、冥想放松、健康数据同步、营养记录和成就系统。"
        />
      </Helmet>

      {/* Hero */}
      <section className="py-20">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center max-w-3xl mx-auto"
          >
            <h1 className="section-title mb-6">
              强大功能，<span className="text-gradient">简单体验</span>
            </h1>
            <p className="section-subtitle mx-auto">
              Pump-Up 为你提供全面的健康管理工具，让你轻松达成健身目标
            </p>
          </motion.div>
        </Container>
      </section>

      {/* Workout Section */}
      <section className="py-16 bg-dark-100/50">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="grid lg:grid-cols-2 gap-12 items-center"
          >
            <div>
              <div className="inline-flex items-center gap-2 bg-purple-500/10 text-purple-400 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Dumbbell className="w-4 h-4" />
                锻炼追踪
              </div>
              <h2 className="text-3xl md:text-4xl font-bold font-heading mb-4">
                记录每一次训练
              </h2>
              <p className="text-gray-400 mb-6">
                支持多种训练类型，从力量训练到瑜伽，从高强度间歇到户外运动，全面记录你的健身历程。
              </p>
              <div className="grid grid-cols-2 gap-3">
                {workoutTypes.map((type) => (
                  <div
                    key={type.id}
                    className="flex items-center gap-3 bg-dark-100 rounded-xl p-3"
                  >
                    <div className={`w-10 h-10 rounded-lg bg-gradient-to-br ${type.color} flex items-center justify-center`}>
                      <Activity className="w-5 h-5 text-white" />
                    </div>
                    <span className="font-medium text-sm">{type.name}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="flex justify-center">
              <div className="bg-dark-100 rounded-3xl p-8 w-full max-w-sm">
                <div className="text-center text-gray-500">锻炼界面截图</div>
              </div>
            </div>
          </motion.div>
        </Container>
      </section>

      {/* Meditation Section */}
      <section className="py-16">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="grid lg:grid-cols-2 gap-12 items-center"
          >
            <div className="flex justify-center order-2 lg:order-1">
              <div className="bg-dark-100 rounded-3xl p-8 w-full max-w-sm">
                <div className="text-center text-gray-500">冥想界面截图</div>
              </div>
            </div>
            <div className="order-1 lg:order-2">
              <div className="inline-flex items-center gap-2 bg-blue-500/10 text-blue-400 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Brain className="w-4 h-4" />
                冥想放松
              </div>
              <h2 className="text-3xl md:text-4xl font-bold font-heading mb-4">
                让心灵得到休息
              </h2>
              <p className="text-gray-400 mb-6">
                丰富的冥想课程，帮助你减压放松、改善睡眠、提升专注力，找到内心的平静。
              </p>
              <div className="grid grid-cols-2 gap-3">
                {meditationTypes.map((type) => (
                  <div
                    key={type.id}
                    className="flex items-center gap-3 bg-dark-100 rounded-xl p-3"
                  >
                    <div className={`w-10 h-10 rounded-lg bg-gradient-to-br ${type.color} flex items-center justify-center`}>
                      <Brain className="w-5 h-5 text-white" />
                    </div>
                    <span className="font-medium text-sm">{type.name}</span>
                  </div>
                ))}
              </div>
            </div>
          </motion.div>
        </Container>
      </section>

      {/* Health Section */}
      <section className="py-16 bg-dark-100/50">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="grid lg:grid-cols-2 gap-12 items-center"
          >
            <div>
              <div className="inline-flex items-center gap-2 bg-red-500/10 text-red-400 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Heart className="w-4 h-4" />
                健康数据
              </div>
              <h2 className="text-3xl md:text-4xl font-bold font-heading mb-4">
                与 HealthKit 无缝集成
              </h2>
              <p className="text-gray-400 mb-6">
                自动同步 Apple Watch 和 iPhone 的健康数据，包括心率、睡眠、步数等，让你全面了解自己的身体状况。
              </p>
              <ul className="space-y-3">
                {['心率监测', '睡眠追踪', '步数统计', '卡路里消耗'].map((item) => (
                  <li key={item} className="flex items-center gap-3 text-gray-300">
                    <div className="w-2 h-2 bg-primary rounded-full" />
                    {item}
                  </li>
                ))}
              </ul>
            </div>
            <div className="flex justify-center">
              <div className="bg-dark-100 rounded-3xl p-8 w-full max-w-sm">
                <div className="text-center text-gray-500">健康数据界面截图</div>
              </div>
            </div>
          </motion.div>
        </Container>
      </section>

      {/* Nutrition & Achievement */}
      <section className="py-16">
        <Container>
          <div className="grid md:grid-cols-2 gap-8">
            {/* Nutrition */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              className="bg-dark-100 rounded-3xl p-8"
            >
              <div className="inline-flex items-center gap-2 bg-green-500/10 text-green-400 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Utensils className="w-4 h-4" />
                营养记录
              </div>
              <h3 className="text-2xl font-bold font-heading mb-3">
                轻松记录每餐
              </h3>
              <p className="text-gray-400 mb-4">
                记录早餐、午餐、晚餐和零食，追踪卡路里、蛋白质、碳水化合物和脂肪摄入。
              </p>
              <div className="grid grid-cols-2 gap-3 text-sm">
                {['卡路里', '蛋白质', '碳水化合物', '脂肪'].map((item) => (
                  <div key={item} className="bg-dark/50 rounded-lg p-3 text-center">
                    {item}
                  </div>
                ))}
              </div>
            </motion.div>

            {/* Achievement */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.1 }}
              className="bg-dark-100 rounded-3xl p-8"
            >
              <div className="inline-flex items-center gap-2 bg-yellow-500/10 text-yellow-400 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Trophy className="w-4 h-4" />
                成就系统
              </div>
              <h3 className="text-2xl font-bold font-heading mb-3">
                激励你不断进步
              </h3>
              <p className="text-gray-400 mb-4">
                完成目标解锁成就徽章，从新手到大师，见证你的每一步成长。
              </p>
              <div className="flex gap-3">
                {['steps', 'workout', 'meditation', 'streak'].map((type) => (
                  <div
                    key={type}
                    className="w-12 h-12 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-xl flex items-center justify-center"
                  >
                    <Trophy className="w-6 h-6 text-white" />
                  </div>
                ))}
              </div>
            </motion.div>
          </div>
        </Container>
      </section>
    </>
  )
}
