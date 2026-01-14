import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { Container } from '@components/common/Container'
import { ScreenshotCard } from '@components/common/ScreenshotCard'
import { mainFeatures } from '@constants/features'

export function FeaturesSection() {
  const { ref, inView } = useInView({
    triggerOnce: true,
    threshold: 0.1
  })

  return (
    <section className="py-24 relative overflow-hidden" id="features">
      {/* Background decoration */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-purple-500/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-blue-500/5 rounded-full blur-3xl" />
      </div>

      <Container>
        {/* Section Header */}
        <motion.div
          ref={ref}
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-20"
        >
          <h2 className="text-4xl md:text-5xl font-bold font-heading mb-6">
            全方位<span className="text-gradient">健康管理</span>
          </h2>
          <p className="text-gray-400 text-xl max-w-2xl mx-auto">
            从锻炼到冥想，从营养到睡眠，Pump-Up 为你提供完整的健康解决方案
          </p>
        </motion.div>

        {/* Features with Screenshots */}
        <div className="space-y-24 md:space-y-32">
          {mainFeatures.map((feature, index) => (
            <ScreenshotCard
              key={feature.id}
              title={feature.title}
              description={feature.description}
              screenshot={feature.screenshot}
              features={feature.features}
              gradient={feature.gradient}
              icon={feature.icon}
              reverse={index % 2 === 1}
              index={index}
            />
          ))}
        </div>
      </Container>
    </section>
  )
}
