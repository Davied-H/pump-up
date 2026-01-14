import { NavLink } from 'react-router-dom'
import { cn } from '@lib/utils'
import { BookOpen, HelpCircle, Smartphone, Settings } from 'lucide-react'

interface DocItem {
  title: string
  href: string
  icon?: typeof BookOpen
}

interface DocSection {
  title: string
  items: DocItem[]
}

const docsSections: DocSection[] = [
  {
    title: '快速开始',
    items: [
      { title: '介绍', href: '/docs/getting-started', icon: BookOpen },
      { title: '安装指南', href: '/docs/installation', icon: Smartphone },
    ]
  },
  {
    title: '功能指南',
    items: [
      { title: 'HealthKit 设置', href: '/docs/healthkit-setup', icon: Settings },
      { title: '常见问题', href: '/docs/faq', icon: HelpCircle },
    ]
  }
]

export function DocsSidebar() {
  return (
    <aside className="w-64 flex-shrink-0 hidden lg:block">
      <nav className="sticky top-24 space-y-8">
        {docsSections.map((section) => (
          <div key={section.title}>
            <h4 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3">
              {section.title}
            </h4>
            <ul className="space-y-1">
              {section.items.map((item) => (
                <li key={item.href}>
                  <NavLink
                    to={item.href}
                    className={({ isActive }) =>
                      cn(
                        'flex items-center gap-2 px-3 py-2 rounded-lg text-sm transition-colors',
                        isActive
                          ? 'bg-primary/10 text-primary'
                          : 'text-gray-400 hover:text-white hover:bg-white/5'
                      )
                    }
                  >
                    {item.icon && <item.icon className="w-4 h-4" />}
                    {item.title}
                  </NavLink>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </nav>
    </aside>
  )
}
