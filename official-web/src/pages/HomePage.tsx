import { Helmet } from 'react-helmet-async'
import { HeroSection } from '@components/home/HeroSection'
import { PrivacySection } from '@components/home/PrivacySection'
import { FeaturesSection } from '@components/home/FeaturesSection'
import { CTASection } from '@components/home/CTASection'

export function HomePage() {
  return (
    <>
      <Helmet>
        <title>Pump-Up - 隐私优先的智能健身追踪 | 你的数据只属于你</title>
        <meta
          name="description"
          content="Pump-Up 是一款隐私优先的智能健身应用，所有数据本地存储。提供专业锻炼计划、冥想放松、HealthKit 健康数据同步等功能，帮助您建立健康生活方式。"
        />
      </Helmet>

      <HeroSection />
      <PrivacySection />
      <FeaturesSection />
      <CTASection />
    </>
  )
}
