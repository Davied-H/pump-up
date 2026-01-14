import { MDXProvider as BaseMDXProvider } from '@mdx-js/react'
import type { ReactNode, ComponentProps } from 'react'
import { cn } from '@lib/utils'

// Custom MDX components
const components = {
  h1: ({ className, ...props }: ComponentProps<'h1'>) => (
    <h1
      className={cn('text-4xl font-bold font-heading mb-6 mt-8 first:mt-0', className)}
      {...props}
    />
  ),
  h2: ({ className, ...props }: ComponentProps<'h2'>) => (
    <h2
      className={cn('text-3xl font-bold font-heading mb-4 mt-8', className)}
      {...props}
    />
  ),
  h3: ({ className, ...props }: ComponentProps<'h3'>) => (
    <h3
      className={cn('text-2xl font-semibold font-heading mb-3 mt-6', className)}
      {...props}
    />
  ),
  h4: ({ className, ...props }: ComponentProps<'h4'>) => (
    <h4
      className={cn('text-xl font-semibold font-heading mb-2 mt-4', className)}
      {...props}
    />
  ),
  p: ({ className, ...props }: ComponentProps<'p'>) => (
    <p
      className={cn('text-gray-300 mb-4 leading-relaxed', className)}
      {...props}
    />
  ),
  a: ({ className, ...props }: ComponentProps<'a'>) => (
    <a
      className={cn('text-primary hover:underline transition-colors', className)}
      {...props}
    />
  ),
  ul: ({ className, ...props }: ComponentProps<'ul'>) => (
    <ul
      className={cn('list-disc list-inside mb-4 space-y-2 text-gray-300', className)}
      {...props}
    />
  ),
  ol: ({ className, ...props }: ComponentProps<'ol'>) => (
    <ol
      className={cn('list-decimal list-inside mb-4 space-y-2 text-gray-300', className)}
      {...props}
    />
  ),
  li: ({ className, ...props }: ComponentProps<'li'>) => (
    <li
      className={cn('text-gray-300', className)}
      {...props}
    />
  ),
  blockquote: ({ className, ...props }: ComponentProps<'blockquote'>) => (
    <blockquote
      className={cn('border-l-4 border-primary pl-4 my-4 italic text-gray-400', className)}
      {...props}
    />
  ),
  code: ({ className, ...props }: ComponentProps<'code'>) => (
    <code
      className={cn('bg-dark-100 px-1.5 py-0.5 rounded text-sm text-primary', className)}
      {...props}
    />
  ),
  pre: ({ className, ...props }: ComponentProps<'pre'>) => (
    <pre
      className={cn('bg-dark-100 p-4 rounded-xl overflow-x-auto mb-4 border border-white/5', className)}
      {...props}
    />
  ),
  hr: ({ className, ...props }: ComponentProps<'hr'>) => (
    <hr
      className={cn('my-8 border-white/10', className)}
      {...props}
    />
  ),
  table: ({ className, ...props }: ComponentProps<'table'>) => (
    <div className="overflow-x-auto mb-4">
      <table
        className={cn('w-full border-collapse', className)}
        {...props}
      />
    </div>
  ),
  th: ({ className, ...props }: ComponentProps<'th'>) => (
    <th
      className={cn('border border-white/10 px-4 py-2 bg-dark-100 text-left font-semibold', className)}
      {...props}
    />
  ),
  td: ({ className, ...props }: ComponentProps<'td'>) => (
    <td
      className={cn('border border-white/10 px-4 py-2 text-gray-300', className)}
      {...props}
    />
  ),
}

interface MDXProviderProps {
  children: ReactNode
}

export function MDXProvider({ children }: MDXProviderProps) {
  return (
    <BaseMDXProvider components={components}>
      {children}
    </BaseMDXProvider>
  )
}

// Callout component for MDX
interface CalloutProps {
  type?: 'info' | 'warning' | 'success' | 'error'
  title?: string
  children: ReactNode
}

export function Callout({ type = 'info', title, children }: CalloutProps) {
  const styles = {
    info: 'bg-blue-500/10 border-blue-500/30 text-blue-300',
    warning: 'bg-yellow-500/10 border-yellow-500/30 text-yellow-300',
    success: 'bg-green-500/10 border-green-500/30 text-green-300',
    error: 'bg-red-500/10 border-red-500/30 text-red-300',
  }

  return (
    <div className={cn('p-4 rounded-xl border mb-4', styles[type])}>
      {title && <p className="font-semibold mb-2">{title}</p>}
      <div className="text-sm">{children}</div>
    </div>
  )
}
