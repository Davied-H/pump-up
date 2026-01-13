import { motion } from 'framer-motion'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@lib/utils'

interface FeatureCardProps {
  icon: LucideIcon
  title: string
  description: string
  gradient: string
  index?: number
}

export function FeatureCard({
  icon: Icon,
  title,
  description,
  gradient,
  index = 0,
}: FeatureCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
      className="group relative card cursor-pointer"
    >
      {/* Icon container */}
      <div
        className={cn(
          'w-14 h-14 rounded-2xl flex items-center justify-center mb-4',
          'bg-gradient-to-br',
          gradient
        )}
      >
        <Icon className="w-7 h-7 text-white" />
      </div>

      {/* Title */}
      <h3 className="text-xl font-bold font-heading mb-2">{title}</h3>

      {/* Description */}
      <p className="text-gray-400 text-sm leading-relaxed">{description}</p>

      {/* Hover glow effect */}
      <div
        className="absolute inset-0 rounded-3xl opacity-0
                   group-hover:opacity-100 transition-opacity duration-300
                   pointer-events-none"
        style={{
          background: `linear-gradient(135deg, rgba(212, 255, 0, 0.1) 0%, transparent 50%)`,
        }}
      />
    </motion.div>
  )
}
