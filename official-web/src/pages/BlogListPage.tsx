import { Link } from 'react-router-dom'
import { Helmet } from 'react-helmet-async'
import { motion } from 'framer-motion'
import { Container } from '@components/common/Container'
import { Calendar, ArrowRight } from 'lucide-react'

// Blog post metadata - in a real app this would come from MDX frontmatter
const blogPosts = [
  {
    slug: 'welcome',
    title: '欢迎来到 Pump-Up',
    description: '了解我们为什么创建 Pump-Up，以及我们的隐私优先设计理念',
    date: '2024-01-15',
    tags: ['公告', '隐私']
  },
  {
    slug: 'privacy-first',
    title: '隐私优先：我们如何保护你的数据',
    description: '深入了解 Pump-Up 的数据保护机制和隐私设计原则',
    date: '2024-01-10',
    tags: ['隐私', '技术']
  }
]

export function BlogListPage() {
  return (
    <>
      <Helmet>
        <title>博客 - Pump-Up</title>
        <meta name="description" content="Pump-Up 博客，了解最新产品动态和健身知识" />
      </Helmet>

      <div className="min-h-screen pt-32 pb-16">
        <Container>
          {/* Header */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center mb-16"
          >
            <h1 className="text-4xl md:text-5xl font-bold font-heading mb-4">
              博客
            </h1>
            <p className="text-gray-400 text-xl max-w-2xl mx-auto">
              产品动态、健身知识、隐私保护理念
            </p>
          </motion.div>

          {/* Blog posts grid */}
          <div className="grid md:grid-cols-2 gap-8">
            {blogPosts.map((post, index) => (
              <motion.article
                key={post.slug}
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
              >
                <Link
                  to={`/blog/${post.slug}`}
                  className="block group"
                >
                  <div className="bg-dark-100 rounded-2xl p-6 border border-white/5 hover:border-white/10 transition-all duration-300 h-full">
                    {/* Tags */}
                    <div className="flex flex-wrap gap-2 mb-4">
                      {post.tags.map((tag) => (
                        <span
                          key={tag}
                          className="px-3 py-1 bg-primary/10 text-primary text-xs rounded-full"
                        >
                          {tag}
                        </span>
                      ))}
                    </div>

                    {/* Title */}
                    <h2 className="text-xl font-bold font-heading mb-2 group-hover:text-primary transition-colors">
                      {post.title}
                    </h2>

                    {/* Description */}
                    <p className="text-gray-400 mb-4">
                      {post.description}
                    </p>

                    {/* Footer */}
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2 text-gray-500 text-sm">
                        <Calendar className="w-4 h-4" />
                        {post.date}
                      </div>
                      <span className="text-primary flex items-center gap-1 text-sm group-hover:gap-2 transition-all">
                        阅读更多
                        <ArrowRight className="w-4 h-4" />
                      </span>
                    </div>
                  </div>
                </Link>
              </motion.article>
            ))}
          </div>
        </Container>
      </div>
    </>
  )
}
