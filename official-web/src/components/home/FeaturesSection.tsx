import { motion } from 'framer-motion'
import { Container } from '@components/common/Container'
import { FeatureCard } from '@components/common/FeatureCard'
import { mainFeatures } from '@constants/features'

export function FeaturesSection() {
  return (
    <section className="py-24" id="features">
      <Container>
        {/* Section Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center mb-16"
        >
          <h2 className="section-title mb-4">
            全方位<span className="text-gradient">健康管理</span>
          </h2>
          <p className="section-subtitle mx-auto">
            从锻炼到冥想，从营养到睡眠，Pump-Up 为你提供完整的健康解决方案
          </p>
        </motion.div>

        {/* Features Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {mainFeatures.map((feature, index) => (
            <FeatureCard
              key={feature.id}
              icon={feature.icon}
              title={feature.title}
              description={feature.description}
              gradient={feature.gradient}
              index={index}
            />
          ))}
        </div>
      </Container>
    </section>
  )
}
