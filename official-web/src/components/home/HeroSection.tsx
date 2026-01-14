import { motion } from 'framer-motion'
import { ArrowRight, Apple, Shield } from 'lucide-react'
import { Container } from '@components/common/Container'
import { Button } from '@components/common/Button'
import { PhoneMockup } from '@components/common/PhoneMockup'

export function HeroSection() {
  return (
    <section className="min-h-[90vh] flex items-center py-20" id="hero">
      <Container>
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          {/* Left: Content */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
          >
            <div className="inline-flex items-center gap-2 bg-primary/10 text-primary px-4 py-2 rounded-full text-sm font-medium mb-6">
              <span className="w-2 h-2 bg-primary rounded-full animate-pulse" />
              隐私优先设计
            </div>

            <h1 className="text-5xl md:text-6xl lg:text-7xl font-bold font-heading leading-tight mb-6">
              你的健身数据
              <br />
              <span className="text-gradient">只属于你</span>
            </h1>

            <p className="text-gray-400 text-xl md:text-2xl mb-6 max-w-lg">
              Pump-Up 帮助你追踪锻炼、冥想放松、记录营养，
              所有数据本地存储，绝不上传云端
            </p>

            {/* Privacy badges */}
            <div className="flex flex-wrap items-center gap-3 mb-8">
              <div className="inline-flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-full text-sm text-gray-300 border border-white/10">
                <Shield className="w-4 h-4 text-primary" />
                本地存储
              </div>
              <div className="inline-flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-full text-sm text-gray-300 border border-white/10">
                <Shield className="w-4 h-4 text-primary" />
                隐私优先
              </div>
              <div className="inline-flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-full text-sm text-gray-300 border border-white/10">
                <Shield className="w-4 h-4 text-primary" />
                无广告追踪
              </div>
            </div>

            <div className="flex flex-col sm:flex-row gap-4">
              <a
                href="https://apps.apple.com"
                target="_blank"
                rel="noopener noreferrer"
              >
                <Button size="lg" className="w-full sm:w-auto gap-2">
                  <Apple className="w-5 h-5" />
                  App Store 下载
                </Button>
              </a>
              <a href="#features">
                <Button variant="secondary" size="lg" className="w-full sm:w-auto gap-2">
                  了解更多
                  <ArrowRight className="w-5 h-5" />
                </Button>
              </a>
            </div>

            {/* Stats */}
            <div className="flex gap-8 mt-12 pt-8 border-t border-white/10">
              <div>
                <div className="text-3xl font-bold font-heading text-primary">10K+</div>
                <div className="text-gray-500 text-sm">活跃用户</div>
              </div>
              <div>
                <div className="text-3xl font-bold font-heading text-primary">50K+</div>
                <div className="text-gray-500 text-sm">完成训练</div>
              </div>
              <div>
                <div className="text-3xl font-bold font-heading text-primary">4.9</div>
                <div className="text-gray-500 text-sm">App 评分</div>
              </div>
            </div>
          </motion.div>

          {/* Right: App Preview */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="relative flex justify-center"
          >
            <div className="relative max-w-[300px]">
              <PhoneMockup
                screenshot="/images/screenshots/home.png"
                alt="Pump-Up App 首页"
                animate={false}
              />
            </div>
          </motion.div>
        </div>
      </Container>
    </section>
  )
}
