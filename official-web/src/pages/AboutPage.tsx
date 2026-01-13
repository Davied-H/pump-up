import { Helmet } from 'react-helmet-async'
import { motion } from 'framer-motion'
import { Heart, Target, Users, Zap } from 'lucide-react'
import { Container } from '@components/common/Container'

const values = [
  {
    icon: Heart,
    title: '用户至上',
    description: '我们把用户的健康和体验放在首位，持续优化产品。',
  },
  {
    icon: Target,
    title: '专注目标',
    description: '帮助每一位用户达成他们的健身目标，无论大小。',
  },
  {
    icon: Users,
    title: '社区驱动',
    description: '倾听用户反馈，与社区共同成长，不断改进产品。',
  },
  {
    icon: Zap,
    title: '简单高效',
    description: '追求简洁的设计和流畅的体验，让健康管理变得简单。',
  },
]

export function AboutPage() {
  return (
    <>
      <Helmet>
        <title>关于我们 | Pump-Up</title>
        <meta
          name="description"
          content="了解 Pump-Up 的故事、使命和愿景。我们致力于帮助每个人建立健康的生活方式。"
        />
      </Helmet>

      {/* Hero */}
      <section className="py-20">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center max-w-3xl mx-auto"
          >
            <h1 className="section-title mb-6">
              让健康变得<span className="text-gradient">简单</span>
            </h1>
            <p className="section-subtitle mx-auto">
              Pump-Up 诞生于一个简单的信念：每个人都值得拥有健康的生活方式，
              而科技应该让这一切变得更加简单。
            </p>
          </motion.div>
        </Container>
      </section>

      {/* Story */}
      <section className="py-16 bg-dark-100/50">
        <Container>
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
            >
              <h2 className="text-3xl md:text-4xl font-bold font-heading mb-6">
                我们的故事
              </h2>
              <div className="space-y-4 text-gray-400">
                <p>
                  Pump-Up 始于 2024 年，当时我们发现市场上的健身应用要么功能过于复杂，
                  要么缺乏真正有用的功能。我们决定创建一款真正以用户为中心的健康管理应用。
                </p>
                <p>
                  我们相信，健康不应该是一件复杂的事情。通过结合智能追踪、冥想放松和
                  营养管理，Pump-Up 为用户提供了一个全面而简单的健康解决方案。
                </p>
                <p>
                  今天，成千上万的用户每天使用 Pump-Up 来追踪他们的健身进度，
                  我们也在不断努力，让这款应用变得更好。
                </p>
              </div>
            </motion.div>
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              className="flex justify-center"
            >
              <div className="bg-dark-100 rounded-3xl p-12 text-center">
                <div className="w-32 h-32 bg-primary rounded-3xl flex items-center justify-center mx-auto mb-6">
                  <span className="text-black font-bold text-6xl">P</span>
                </div>
                <p className="text-gray-400">Pump-Up 团队</p>
              </div>
            </motion.div>
          </div>
        </Container>
      </section>

      {/* Values */}
      <section className="py-16">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-12"
          >
            <h2 className="text-3xl md:text-4xl font-bold font-heading mb-4">
              我们的价值观
            </h2>
            <p className="text-gray-400 max-w-2xl mx-auto">
              这些核心价值观指导着我们的每一个决定
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {values.map((value, index) => (
              <motion.div
                key={value.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1 }}
                className="bg-dark-100 rounded-2xl p-6 text-center"
              >
                <div className="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <value.icon className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-bold font-heading mb-2">{value.title}</h3>
                <p className="text-gray-400 text-sm">{value.description}</p>
              </motion.div>
            ))}
          </div>
        </Container>
      </section>

      {/* Contact */}
      <section className="py-16 bg-dark-100/50">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center max-w-2xl mx-auto"
          >
            <h2 className="text-3xl md:text-4xl font-bold font-heading mb-4">
              联系我们
            </h2>
            <p className="text-gray-400 mb-8">
              有问题或建议？我们很乐意听取你的意见
            </p>
            <a
              href="mailto:contact@pump-up.app"
              className="inline-flex items-center gap-2 btn-primary"
            >
              发送邮件
            </a>
          </motion.div>
        </Container>
      </section>
    </>
  )
}
