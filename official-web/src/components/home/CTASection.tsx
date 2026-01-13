import { motion } from 'framer-motion'
import { Apple, ArrowRight } from 'lucide-react'
import { Container } from '@components/common/Container'
import { Button } from '@components/common/Button'

export function CTASection() {
  return (
    <section className="py-24" id="download">
      <Container>
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="relative bg-dark-100 rounded-[2rem] p-12 md:p-16 overflow-hidden"
        >
          {/* Background glow */}
          <div className="absolute top-0 right-0 w-96 h-96 bg-primary/20 blur-[120px] rounded-full" />
          <div className="absolute bottom-0 left-0 w-64 h-64 bg-blue-500/20 blur-[100px] rounded-full" />

          <div className="relative z-10 max-w-2xl mx-auto text-center">
            <h2 className="section-title mb-6">
              准备好开始你的
              <br />
              <span className="text-gradient">健康之旅</span>了吗？
            </h2>

            <p className="section-subtitle mx-auto mb-8">
              现在下载 Pump-Up，免费开始使用。升级专业版解锁更多高级功能。
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="https://apps.apple.com"
                target="_blank"
                rel="noopener noreferrer"
              >
                <Button size="lg" className="w-full sm:w-auto gap-2">
                  <Apple className="w-5 h-5" />
                  免费下载
                </Button>
              </a>
              <a href="/pricing">
                <Button variant="secondary" size="lg" className="w-full sm:w-auto gap-2">
                  查看定价
                  <ArrowRight className="w-5 h-5" />
                </Button>
              </a>
            </div>

            <p className="text-gray-500 text-sm mt-6">
              需要 iOS 15.0 或更高版本
            </p>
          </div>
        </motion.div>
      </Container>
    </section>
  )
}
