import { motion } from 'framer-motion'
import { cn } from '@lib/utils'

interface PhoneMockupProps {
  screenshot: string
  alt: string
  className?: string
  glowColor?: string
  animate?: boolean
  showFrame?: boolean
}

export function PhoneMockup({
  screenshot,
  alt,
  className,
  glowColor = 'primary',
  animate = true,
  showFrame = true
}: PhoneMockupProps) {
  const glowColorClass = {
    primary: 'bg-primary/30',
    purple: 'bg-purple-500/30',
    blue: 'bg-blue-500/30',
    green: 'bg-green-500/30',
    orange: 'bg-orange-500/30',
  }[glowColor] || 'bg-primary/30'

  const content = (
    <div className={cn('relative', className)}>
      {/* Glow effect */}
      <div className={cn('absolute -inset-12 blur-[80px] rounded-full', glowColorClass)} />

      {/* iPhone frame */}
      <div className={cn(
        'relative rounded-[3rem] p-[3px]',
        showFrame && 'bg-gradient-to-b from-gray-700 via-gray-800 to-gray-900 shadow-[0_0_0_1px_rgba(255,255,255,0.1),inset_0_0_0_1px_rgba(0,0,0,0.5)]'
      )}>
        {/* Inner bezel */}
        <div className={cn(
          'relative rounded-[2.8rem] overflow-hidden',
          showFrame && 'bg-black p-[2px]'
        )}>
          {/* Screen container */}
          <div className="relative rounded-[2.6rem] overflow-hidden bg-black">
            {/* Dynamic Island */}
            {showFrame && (
              <div className="absolute top-3 left-1/2 -translate-x-1/2 z-20">
                <div className="w-[90px] h-[28px] bg-black rounded-full flex items-center justify-center">
                  {/* Camera dot */}
                  <div className="absolute right-4 w-[10px] h-[10px] rounded-full bg-[#1a1a1a] border border-[#2a2a2a]">
                    <div className="absolute inset-[2px] rounded-full bg-gradient-to-br from-[#2d3748] to-[#1a202c]" />
                    <div className="absolute top-[3px] left-[3px] w-[2px] h-[2px] rounded-full bg-blue-400/30" />
                  </div>
                </div>
              </div>
            )}

            {/* Screenshot - 放大2%填充 */}
            <img
              src={screenshot}
              alt={alt}
              className="relative w-full h-full object-cover scale-[1.10]"
              loading="lazy"
            />
          </div>
        </div>

        {/* Side buttons */}
        {showFrame && (
          <>
            {/* Power button (right) */}
            <div className="absolute right-[-3px] top-[120px] w-[3px] h-[60px] bg-gradient-to-r from-gray-700 to-gray-600 rounded-r-sm" />
            {/* Volume buttons (left) */}
            <div className="absolute left-[-3px] top-[80px] w-[3px] h-[24px] bg-gradient-to-l from-gray-700 to-gray-600 rounded-l-sm" />
            <div className="absolute left-[-3px] top-[115px] w-[3px] h-[45px] bg-gradient-to-l from-gray-700 to-gray-600 rounded-l-sm" />
            <div className="absolute left-[-3px] top-[170px] w-[3px] h-[45px] bg-gradient-to-l from-gray-700 to-gray-600 rounded-l-sm" />
          </>
        )}
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
