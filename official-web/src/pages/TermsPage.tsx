import { Helmet } from 'react-helmet-async'
import { Container } from '@components/common/Container'

export function TermsPage() {
  return (
    <>
      <Helmet>
        <title>服务条款 | Pump-Up</title>
        <meta name="description" content="Pump-Up 服务条款" />
      </Helmet>

      <section className="py-20">
        <Container>
          <div className="max-w-3xl mx-auto">
            <h1 className="section-title mb-8">服务条款</h1>
            <div className="prose prose-invert max-w-none space-y-6 text-gray-300">
              <p className="text-gray-400">最后更新：2024 年 1 月</p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                1. 接受条款
              </h2>
              <p>
                使用 Pump-Up 应用即表示您同意遵守这些服务条款。如果您不同意这些条款，请勿使用我们的服务。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                2. 服务描述
              </h2>
              <p>
                Pump-Up 是一款健身追踪应用，提供锻炼记录、冥想课程、健康数据同步和营养追踪等功能。
                我们保留随时修改或终止服务的权利。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                3. 用户责任
              </h2>
              <p>您同意：</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>提供准确的账户信息</li>
                <li>保护您的账户安全</li>
                <li>不滥用或干扰服务</li>
                <li>遵守所有适用的法律法规</li>
              </ul>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                4. 健康免责声明
              </h2>
              <p>
                Pump-Up 提供的信息仅供参考，不构成医疗建议。在开始任何新的健身计划之前，
                请咨询医疗专业人员。我们不对因使用本应用而导致的任何伤害负责。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                5. 订阅和付款
              </h2>
              <p>
                专业版订阅通过 App Store 处理。订阅会自动续订，除非您在当前计费周期结束前取消。
                退款政策遵循 Apple 的相关规定。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                6. 联系我们
              </h2>
              <p>
                如果您对服务条款有任何问题，请通过 contact@pump-up.app 联系我们。
              </p>
            </div>
          </div>
        </Container>
      </section>
    </>
  )
}
