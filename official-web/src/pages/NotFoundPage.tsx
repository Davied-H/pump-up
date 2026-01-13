import { Link } from 'react-router-dom'
import { Helmet } from 'react-helmet-async'
import { Home, ArrowLeft } from 'lucide-react'
import { Container } from '@components/common/Container'
import { Button } from '@components/common/Button'

export function NotFoundPage() {
  return (
    <>
      <Helmet>
        <title>页面未找到 | Pump-Up</title>
      </Helmet>

      <section className="min-h-[70vh] flex items-center">
        <Container>
          <div className="text-center max-w-md mx-auto">
            <div className="text-8xl font-bold font-heading text-primary mb-4">
              404
            </div>
            <h1 className="text-2xl font-bold font-heading mb-4">
              页面未找到
            </h1>
            <p className="text-gray-400 mb-8">
              抱歉，您访问的页面不存在或已被移除。
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link to="/">
                <Button className="gap-2">
                  <Home className="w-5 h-5" />
                  返回首页
                </Button>
              </Link>
              <Button
                variant="secondary"
                onClick={() => window.history.back()}
                className="gap-2"
              >
                <ArrowLeft className="w-5 h-5" />
                返回上页
              </Button>
            </div>
          </div>
        </Container>
      </section>
    </>
  )
}
