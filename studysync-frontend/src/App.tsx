import { BrowserRouter, Routes, Route } from 'react-router-dom'
import './App.css'
import { RootLayout } from './layouts/RootLayout'
import { HomePage } from './pages/Home'
import { DashboardPage } from './pages/Dashboard'
import { LoginPage } from './pages/Auth/Login'
import { RegisterPage } from './pages/Auth/Register'
import SignUpPage from './pages/SignUpPage'
import AccountPrivacyPage from './pages/AccountPrivacyPage'
import BuddyMatchPage from './pages/BuddyMatchPage'
import BuddyMatchPreferencesPage from './pages/BuddyMatchPreferencesPage'
import CompatibilityQuizPage from './pages/CompatibilityQuizPage'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Pages WITH navbar — RootLayout wraps each one directly */}
        <Route path="/" element={<RootLayout><HomePage /></RootLayout>} />
        <Route path="/dashboard" element={<RootLayout><DashboardPage /></RootLayout>} />
        <Route path="/login" element={<RootLayout><LoginPage /></RootLayout>} />
        <Route path="/register" element={<RootLayout><RegisterPage /></RootLayout>} />

        {/* SignUp — completely standalone, no navbar */}
        <Route path="/signup" element={<SignUpPage />} />
        <Route path="/settings/account" element={<AccountPrivacyPage />} />
        <Route path="/buddy-match" element={<BuddyMatchPage />} />
        <Route path="/buddy-preferences" element={<BuddyMatchPreferencesPage />} />
        <Route path="/quiz" element={<CompatibilityQuizPage />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App