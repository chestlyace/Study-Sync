import './Auth.css'

export function LoginPage() {
  return (
    <div className="page auth-page">
      <header className="page-header">
        <p className="page-eyebrow">Welcome back</p>
        <h1 className="page-title">Log in to StudySync</h1>
        <p className="page-subtitle">
          Continue where you left off, pick up an in‑progress session, or review your latest notes.
        </p>
      </header>

      <div className="auth-card">
        <form className="auth-form">
          <label className="field">
            <span>Email</span>
            <input type="email" placeholder="you@example.edu" />
          </label>
          <label className="field">
            <span>Password</span>
            <input type="password" placeholder="••••••••" />
          </label>
          <button className="primary-cta" type="submit">
            <span>Log in</span>
          </button>
          <p className="muted-link">
            New here? <a href="/register">Create an account</a>
          </p>
        </form>
      </div>
    </div>
  )
}

