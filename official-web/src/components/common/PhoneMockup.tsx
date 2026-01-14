import { motion } from 'framer-motion'
import { cn } from '@lib/utils'

interface PhoneMockupProps {
  screenshot: string
  alt: string
  className?: string
  glowColor?: string
  animate?: boolean
}

export function PhoneMockup({
  screenshot,
  alt,
  className,
  glowColor = 'primary',
  animate = true
}: PhoneMockupProps) {
  const glowColorClass = {
    primary: 'bg-primary/20',
    purple: 'bg-purple-500/20',
    blue: 'bg-blue-500/20',
    green: 'bg-green-500/20',
    orange: 'bg-orange-500/20',
  }[glowColor] || 'bg-primary/20'

  const content = (
    <div className={cn('relative', className)}>
      {/* Glow effect */}
      <div className={cn('absolute -inset-16 blur-[80px] rounded-full transition-opacity duration-500', glowColorClass)} />

      {/* Phone frame */}
      <div className="relative bg-dark-100 rounded-[3rem] p-3 shadow-2xl border border-white/10">
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-7 bg-dark rounded-b-2xl z-10" />

        {/* Screen */}
        <div className="bg-dark rounded-[2.5rem] overflow-hidden">
          <img
            src={screenshot}
            alt={alt}
            className="w-full h-auto object-cover"
            loading="lazy"
          />
        </div>
      </div>
    </div>
  )

  if (animate) {
    return (
      <motion.div
        whileHover={{ y: -8, scale: 1.02 }}
        transition={{ type: 'spring', stiffness: 300, damping: 20 }}
      >
        {content}
      </motion.div>
    )
  }

  return content
}
