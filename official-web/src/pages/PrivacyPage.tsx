import { Helmet } from 'react-helmet-async'
import { Container } from '@components/common/Container'

export function PrivacyPage() {
  return (
    <>
      <Helmet>
        <title>隐私政策 | Pump-Up</title>
        <meta name="description" content="Pump-Up 隐私政策" />
      </Helmet>

      <section className="py-20">
        <Container>
          <div className="max-w-3xl mx-auto">
            <h1 className="section-title mb-8">隐私政策</h1>
            <div className="prose prose-invert max-w-none space-y-6 text-gray-300">
              <p className="text-gray-400">最后更新：2024 年 1 月</p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                1. 信息收集
              </h2>
              <p>
                我们收集的信息包括但不限于：您的账户信息、健身数据、健康数据（如您授权我们访问 HealthKit）、
                设备信息和使用数据。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                2. 信息使用
              </h2>
              <p>我们使用收集的信息来：</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>提供和改进我们的服务</li>
                <li>个性化您的体验</li>
                <li>分析使用趋势</li>
                <li>与您沟通有关服务更新</li>
              </ul>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                3. 数据安全
              </h2>
              <p>
                我们采取行业标准的安全措施来保护您的个人信息。您的健康数据存储在您的设备上，
                只有在您明确授权的情况下才会与我们的服务器同步。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                4. HealthKit 数据
              </h2>
              <p>
                如果您选择连接 Apple HealthKit，我们将仅读取您明确授权的数据类型。
                我们不会将 HealthKit 数据用于广告或与第三方共享。
              </p>

              <h2 className="text-2xl font-bold font-heading text-white mt-8 mb-4">
                5. 联系我们
              </h2>
              <p>
                如果您对隐私政策有任何问题，请通过 contact@pump-up.app 联系我们。
              </p>
            </div>
          </div>
        </Container>
      </section>
    </>
  )
}
