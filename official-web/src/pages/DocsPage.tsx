import { Suspense, lazy } from 'react'
import { useParams, Navigate } from 'react-router-dom'
import { Helmet } from 'react-helmet-async'
import { Container } from '@components/common/Container'
import { DocsSidebar } from '@components/mdx/DocsSidebar'
import { MDXProvider } from '@components/mdx/MDXProvider'

// Lazy load MDX content
const docsModules = import.meta.glob('../../content/docs/*.mdx')

// Map slug to module path
const getDocModule = (slug: string) => {
  const path = `../../content/docs/${slug}.mdx`
  return docsModules[path]
}

// Loading component
function DocLoading() {
  return (
    <div className="animate-pulse space-y-4">
      <div className="h-10 bg-dark-100 rounded w-3/4" />
      <div className="h-4 bg-dark-100 rounded w-full" />
      <div className="h-4 bg-dark-100 rounded w-5/6" />
      <div className="h-4 bg-dark-100 rounded w-4/5" />
    </div>
  )
}

// Document content component
function DocContent({ slug }: { slug: string }) {
  const moduleLoader = getDocModule(slug)

  if (!moduleLoader) {
    return <Navigate to="/docs/getting-started" replace />
  }

  const MDXContent = lazy(moduleLoader as () => Promise<{ default: React.ComponentType }>)

  return (
    <Suspense fallback={<DocLoading />}>
      <MDXContent />
    </Suspense>
  )
}

export function DocsPage() {
  const { slug = 'getting-started' } = useParams()

  return (
    <>
      <Helmet>
        <title>文档 - Pump-Up</title>
        <meta name="description" content="Pump-Up 帮助文档，了解如何使用 App 的各项功能" />
      </Helmet>

      <div className="min-h-screen pt-32 pb-16">
        <Container>
          <div className="flex gap-12">
            <DocsSidebar />
            <main className="flex-1 min-w-0">
              <article className="prose prose-invert max-w-none">
                <MDXProvider>
                  <DocContent slug={slug} />
                </MDXProvider>
              </article>
            </main>
          </div>
        </Container>
      </div>
    </>
  )
}
