import { motion } from 'framer-motion'
import { useInView } from 'react-intersection-observer'
import { PhoneMockup } from './PhoneMockup'
import { cn } from '@lib/utils'
import type { LucideIcon } from 'lucide-react'

interface ScreenshotCardProps {
  title: string
  description: string
  screenshot: string
  features: string[]
  gradient: string
  icon: LucideIcon
  reverse?: boolean
  index: number
}

export function ScreenshotCard({
  title,
  description,
  screenshot,
  features,
  gradient,
  icon: Icon,
  reverse = false,
  index
}: ScreenshotCardProps) {
  const { ref, inView } = useInView({
    triggerOnce: true,
    threshold: 0.2
  })

  return (
    <motion.div
      ref={ref}
      initial={{ opacity: 0, y: 40 }}
      animate={inView ? { opacity: 1, y: 0 } : {}}
      transition={{ duration: 0.6, delay: index * 0.15 }}
      className={cn(
        'grid md:grid-cols-2 gap-8 md:gap-12 items-center',
        reverse && 'md:[direction:rtl]'
      )}
    >
      {/* Screenshot */}
      <div className={cn('relative flex justify-center', reverse && 'md:[direction:ltr]')}>
        <div className="relative max-w-[280px]">
          <PhoneMockup
            screenshot={screenshot}
            alt={title}
            glowColor={gradient.includes('purple') ? 'purple' : gradient.includes('blue') ? 'blue' : gradient.includes('orange') ? 'orange' : 'primary'}
          />
        </div>
      </div>

      {/* Content */}
      <div className={cn('space-y-6', reverse && 'md:[direction:ltr]')}>
        {/* Icon */}
        <div className={cn(
          'w-14 h-14 rounded-2xl flex items-center justify-center',
          `bg-gradient-to-br ${gradient}`
        )}>
          <Icon className="w-7 h-7 text-white" />
        </div>

        {/* Title & Description */}
        <div>
          <h3 className="text-3xl md:text-4xl font-bold font-heading mb-3">
            {title}
          </h3>
          <p className="text-gray-400 text-lg">
            {description}
          </p>
        </div>

        {/* Feature tags */}
        <div className="flex flex-wrap gap-2">
          {features.map((feature, i) => (
            <span
              key={i}
              className="px-4 py-2 bg-white/5 rounded-full text-sm text-gray-300 border border-white/10"
            >
              {feature}
            </span>
          ))}
        </div>
      </div>
    </motion.div>
  )
}
