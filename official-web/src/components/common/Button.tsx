import type { ButtonHTMLAttributes, ReactNode } from 'react'
import { cn } from '@lib/utils'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  children: ReactNode
}

export function Button({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center font-semibold',
        'transition-all duration-200 ease-out cursor-pointer',
        'focus:outline-none focus:ring-2 focus:ring-primary/50',
        'disabled:opacity-50 disabled:cursor-not-allowed',
        // Variant styles
        {
          primary: 'bg-primary text-black hover:bg-primary/90 active:scale-95',
          secondary: 'bg-transparent text-white border border-white/20 hover:bg-white/10',
          ghost: 'bg-transparent text-white hover:bg-white/10',
        }[variant],
        // Size styles
        {
          sm: 'px-4 py-2 text-sm rounded-lg',
          md: 'px-6 py-3 text-base rounded-xl',
          lg: 'px-8 py-4 text-lg rounded-2xl',
        }[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  )
}
