import { type ReactNode } from 'react'
import { Link, NavLink } from 'react-router-dom'
import './RootLayout.css'

type RootLayoutProps = {
  children: ReactNode
}

export function RootLayout({ children }: RootLayoutProps) {
  return (
    <div className="app-shell">
      <header className="app-header">
        <Link to="/" className="brand">
          <span className="brand-mark">SS</span>
          <span className="brand-text">StudySync</span>
        </Link>
        <nav className="nav-links">
          <NavLink to="/" end>
            Home
          </NavLink>
          <NavLink to="/dashboard">Dashboard</NavLink>
        </nav>
        <div className="nav-auth">
          <NavLink to="/login" className="btn ghost">
            Log in
          </NavLink>
          <NavLink to="/register" className="btn primary">
            Get started
          </NavLink>
        </div>
      </header>

      <main className="app-main">{children}</main>

      <footer className="app-footer">
        <span>© {new Date().getFullYear()} StudySync</span>
        <span className="footer-secondary">Study smarter, not harder.</span>
      </footer>
    </div>
  )
}

