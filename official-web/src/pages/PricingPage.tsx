import { useState } from 'react'
import { Helmet } from 'react-helmet-async'
import { motion } from 'framer-motion'
import { Check, Apple } from 'lucide-react'
import { Container } from '@components/common/Container'
import { Button } from '@components/common/Button'
import { cn } from '@lib/utils'

const plans = [
  {
    name: '免费版',
    description: '开始你的健身之旅',
    price: { monthly: 0, yearly: 0 },
    features: [
      '基础锻炼追踪',
      '5 种冥想课程',
      '基础健康数据同步',
      '简单营养记录',
      '3 个成就徽章',
    ],
    cta: '免费开始',
    popular: false,
  },
  {
    name: '专业版',
    description: '解锁全部功能',
    price: { monthly: 28, yearly: 198 },
    features: [
      '全部锻炼类型',
      '50+ 冥想课程',
      '完整 HealthKit 集成',
      '详细营养分析',
      '全部成就徽章',
      '个性化训练计划',
      '数据导出功能',
      '优先客服支持',
    ],
    cta: '升级专业版',
    popular: true,
  },
]

export function PricingPage() {
  const [yearly, setYearly] = useState(true)

  return (
    <>
      <Helmet>
        <title>定价 | Pump-Up</title>
        <meta
          name="description"
          content="选择适合你的 Pump-Up 订阅计划。免费版开始，专业版解锁全部功能。"
        />
      </Helmet>

      <section className="py-20">
        <Container>
          {/* Header */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center max-w-3xl mx-auto mb-12"
          >
            <h1 className="section-title mb-6">
              简单透明的<span className="text-gradient">定价</span>
            </h1>
            <p className="section-subtitle mx-auto">
              选择适合你的计划，免费版即可开始使用
            </p>
          </motion.div>

          {/* Toggle */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="flex justify-center mb-12"
          >
            <div className="bg-dark-100 rounded-xl p-1 flex">
              <button
                onClick={() => setYearly(false)}
                className={cn(
                  'px-6 py-2 rounded-lg text-sm font-medium transition-all',
                  !yearly ? 'bg-primary text-black' : 'text-gray-400 hover:text-white'
                )}
              >
                月付
              </button>
              <button
                onClick={() => setYearly(true)}
                className={cn(
                  'px-6 py-2 rounded-lg text-sm font-medium transition-all',
                  yearly ? 'bg-primary text-black' : 'text-gray-400 hover:text-white'
                )}
              >
                年付
                <span className="ml-2 text-xs bg-green-500/20 text-green-400 px-2 py-0.5 rounded-full">
                  省 40%
                </span>
              </button>
            </div>
          </motion.div>

          {/* Plans */}
          <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {plans.map((plan, index) => (
              <motion.div
                key={plan.name}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 + index * 0.1 }}
                className={cn(
                  'relative bg-dark-100 rounded-3xl p-8',
                  plan.popular && 'border-2 border-primary'
                )}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-primary text-black text-sm font-semibold px-4 py-1 rounded-full">
                    最受欢迎
                  </div>
                )}

                <h3 className="text-2xl font-bold font-heading mb-2">{plan.name}</h3>
                <p className="text-gray-400 mb-6">{plan.description}</p>

                <div className="mb-6">
                  <span className="text-5xl font-bold font-heading">
                    ¥{yearly ? plan.price.yearly : plan.price.monthly}
                  </span>
                  <span className="text-gray-400 ml-2">
                    /{yearly ? '年' : '月'}
                  </span>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex items-center gap-3">
                      <Check className="w-5 h-5 text-primary flex-shrink-0" />
                      <span className="text-gray-300">{feature}</span>
                    </li>
                  ))}
                </ul>

                <a
                  href="https://apps.apple.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="block"
                >
                  <Button
                    variant={plan.popular ? 'primary' : 'secondary'}
                    className="w-full gap-2"
                  >
                    <Apple className="w-5 h-5" />
                    {plan.cta}
                  </Button>
                </a>
              </motion.div>
            ))}
          </div>

          {/* FAQ */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="mt-24 max-w-2xl mx-auto"
          >
            <h2 className="text-3xl font-bold font-heading text-center mb-8">
              常见问题
            </h2>
            <div className="space-y-4">
              {[
                {
                  q: '可以随时取消订阅吗？',
                  a: '是的，你可以随时在 App Store 中取消订阅，取消后将在当前计费周期结束后生效。',
                },
                {
                  q: '免费版和专业版有什么区别？',
                  a: '专业版提供完整的锻炼和冥想内容、详细的数据分析、个性化训练计划等高级功能。',
                },
                {
                  q: '支持哪些设备？',
                  a: 'Pump-Up 支持 iPhone 和 iPad，需要 iOS 15.0 或更高版本。同时支持 Apple Watch 数据同步。',
                },
              ].map((faq) => (
                <div key={faq.q} className="bg-dark-100 rounded-2xl p-6">
                  <h3 className="font-semibold mb-2">{faq.q}</h3>
                  <p className="text-gray-400 text-sm">{faq.a}</p>
                </div>
              ))}
            </div>
          </motion.div>
        </Container>
      </section>
    </>
  )
}
