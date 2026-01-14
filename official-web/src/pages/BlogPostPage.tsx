import { Suspense, lazy } from 'react'
import { useParams, Navigate, Link } from 'react-router-dom'
import { Helmet } from 'react-helmet-async'
import { motion } from 'framer-motion'
import { Container } from '@components/common/Container'
import { MDXProvider } from '@components/mdx/MDXProvider'
import { ArrowLeft } from 'lucide-react'

// Lazy load MDX content
const blogModules = import.meta.glob('../../content/blog/*.mdx')

// Map slug to module path
const getBlogModule = (slug: string) => {
  const path = `../../content/blog/${slug}.mdx`
  return blogModules[path]
}

// Loading component
function BlogLoading() {
  return (
    <div className="animate-pulse space-y-4">
      <div className="h-12 bg-dark-100 rounded w-3/4" />
      <div className="h-4 bg-dark-100 rounded w-1/4" />
      <div className="h-px bg-dark-100 my-8" />
      <div className="h-4 bg-dark-100 rounded w-full" />
      <div className="h-4 bg-dark-100 rounded w-5/6" />
      <div className="h-4 bg-dark-100 rounded w-4/5" />
    </div>
  )
}

// Blog content component
function BlogContent({ slug }: { slug: string }) {
  const moduleLoader = getBlogModule(slug)

  if (!moduleLoader) {
    return <Navigate to="/blog" replace />
  }

  const MDXContent = lazy(moduleLoader as () => Promise<{ default: React.ComponentType }>)

  return (
    <Suspense fallback={<BlogLoading />}>
      <MDXContent />
    </Suspense>
  )
}

export function BlogPostPage() {
  const { slug } = useParams()

  if (!slug) {
    return <Navigate to="/blog" replace />
  }

  return (
    <>
      <Helmet>
        <title>博客 - Pump-Up</title>
        <meta name="description" content="Pump-Up 博客文章" />
      </Helmet>

      <div className="min-h-screen pt-32 pb-16">
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="max-w-3xl mx-auto"
          >
            {/* Back link */}
            <Link
              to="/blog"
              className="inline-flex items-center gap-2 text-gray-400 hover:text-white transition-colors mb-8"
            >
              <ArrowLeft className="w-4 h-4" />
              返回博客
            </Link>

            {/* Content */}
            <article className="prose prose-invert max-w-none">
              <MDXProvider>
                <BlogContent slug={slug} />
              </MDXProvider>
            </article>
          </motion.div>
        </Container>
      </div>
    </>
  )
}
