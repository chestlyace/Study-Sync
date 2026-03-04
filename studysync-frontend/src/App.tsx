import { BrowserRouter, Routes, Route } from 'react-router-dom'
import './App.css'
import { RootLayout } from './layouts/RootLayout'
import { HomePage } from './pages/Home'
import { DashboardPage } from './pages/Dashboard'
import { LoginPage } from './pages/Auth/Login'
import { RegisterPage } from './pages/Auth/Register'

function App() {
  return (
    <BrowserRouter>
      <RootLayout>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
        </Routes>
      </RootLayout>
    </BrowserRouter>
  )
}

export default App
