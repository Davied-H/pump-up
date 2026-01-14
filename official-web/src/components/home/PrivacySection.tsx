import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Shield, Lock, EyeOff, Smartphone } from 'lucide-react'
import { Container } from '@components/common/Container'

const privacyFeatures = [
  {
    icon: Shield,
    title: '本地优先存储',
    description: '所有健身数据存储在你的设备上，不强制上传云端',
    gradient: 'from-green-500 to-emerald-500'
  },
  {
    icon: Lock,
    title: '端到端加密',
    description: '敏感数据传输采用行业标准加密协议保护',
    gradient: 'from-blue-500 to-cyan-500'
  },
  {
    icon: EyeOff,
    title: '零广告追踪',
    description: '不收集用于广告投放的用户行为数据',
    gradient: 'from-purple-500 to-pink-500'
  }
]

export function PrivacySection() {
  const { ref, inView } = useInView({
    triggerOnce: true,
    threshold: 0.1
  })

  return (
    <section className="py-24 relative overflow-hidden" id="privacy">
      {/* Background decoration */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-1/2 left-1/4 w-96 h-96 bg-primary/5 rounded-full blur-3xl" />
        <div className="absolute bottom-1/4 right-1/4 w-80 h-80 bg-blue-500/5 rounded-full blur-3xl" />
      </div>

      <Container>
        <motion.div
          ref={ref}
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <div className="inline-flex items-center gap-2 bg-green-500/10 text-green-400 px-4 py-2 rounded-full text-sm font-medium mb-6">
            <Shield className="w-4 h-4" />
            隐私保护
          </div>
          <h2 className="text-4xl md:text-5xl font-bold font-heading mb-6">
            隐私安全，
            <span className="text-gradient">从设计开始</span>
          </h2>
          <p className="text-gray-400 text-xl max-w-2xl mx-auto">
            我们相信你的健康数据是最私密的信息之一，
            因此从产品设计之初就将隐私保护作为核心原则
          </p>
        </motion.div>

        <div className="grid md:grid-cols-3 gap-8 mb-16">
          {privacyFeatures.map((feature, index) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="group relative"
            >
              <div className="relative bg-dark-100 rounded-3xl p-8 border border-white/5 hover:border-white/10 transition-all duration-300 h-full">
                {/* Hover glow */}
                <div className={`absolute inset-0 rounded-3xl bg-gradient-to-br ${feature.gradient} opacity-0 group-hover:opacity-5 transition-opacity duration-300`} />

                {/* Icon */}
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${feature.gradient} flex items-center justify-center mb-6`}>
                  <feature.icon className="w-8 h-8 text-white" />
                </div>

                {/* Content */}
                <h3 className="text-xl font-bold font-heading mb-3">
                  {feature.title}
                </h3>
                <p className="text-gray-400">
                  {feature.description}
                </p>
              </div>
            </motion.div>
          ))}
        </div>

        {/* HealthKit notice */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="relative"
        >
          <div className="bg-dark-100/50 backdrop-blur-sm rounded-2xl p-6 md:p-8 border border-white/5 flex flex-col md:flex-row items-center gap-6">
            <div className="flex-shrink-0 w-16 h-16 bg-gradient-to-br from-red-500 to-pink-500 rounded-2xl flex items-center justify-center">
              <Smartphone className="w-8 h-8 text-white" />
            </div>
            <div className="text-center md:text-left">
              <h4 className="text-lg font-semibold mb-2">Apple HealthKit 集成</h4>
              <p className="text-gray-400">
                HealthKit 数据完全由 iOS 系统管理，我们仅读取你明确授权的数据类型，
                且不会将这些数据上传至任何服务器
              </p>
            </div>
          </div>
        </motion.div>
      </Container>
    </section>
  )
}
