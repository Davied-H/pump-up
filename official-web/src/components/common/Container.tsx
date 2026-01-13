import type { ReactNode } from 'react'
import { cn } from '@lib/utils'

interface ContainerProps {
  children: ReactNode
  className?: string
}

export function Container({ children, className }: ContainerProps) {
  return (
    <div className={cn('container-main', className)}>
      {children}
    </div>
  )
}
