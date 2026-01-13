import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { Layout } from '@components/layout/Layout'
import { HomePage } from '@pages/HomePage'
import { FeaturesPage } from '@pages/FeaturesPage'
import { PricingPage } from '@pages/PricingPage'
import { AboutPage } from '@pages/AboutPage'
import { PrivacyPage } from '@pages/PrivacyPage'
import { TermsPage } from '@pages/TermsPage'
import { NotFoundPage } from '@pages/NotFoundPage'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          <Route path="/" element={<HomePage />} />
          <Route path="/features" element={<FeaturesPage />} />
          <Route path="/pricing" element={<PricingPage />} />
          <Route path="/about" element={<AboutPage />} />
          <Route path="/privacy" element={<PrivacyPage />} />
          <Route path="/terms" element={<TermsPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App
