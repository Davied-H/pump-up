import { Helmet } from 'react-helmet-async'
import { HeroSection } from '@components/home/HeroSection'
import { FeaturesSection } from '@components/home/FeaturesSection'
import { CTASection } from '@components/home/CTASection'

export function HomePage() {
  return (
    <>
      <Helmet>
        <title>Pump-Up - 智能健身追踪 | 锻炼、冥想、营养一站式管理</title>
        <meta
          name="description"
          content="Pump-Up 是一款智能健身追踪应用，提供专业锻炼计划、冥想放松、HealthKit 健康数据同步、营养记录等功能，帮助您建立健康生活方式。"
        />
      </Helmet>

      <HeroSection />
      <FeaturesSection />
      <CTASection />
    </>
  )
}
