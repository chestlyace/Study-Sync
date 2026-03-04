import './Auth.css'

export function RegisterPage() {
  return (
    <div className="page auth-page">
      <header className="page-header">
        <p className="page-eyebrow">Get started</p>
        <h1 className="page-title">Create your StudySync workspace.</h1>
        <p className="page-subtitle">
          We&apos;ll keep you organised with sessions, tasks, and shared boards that match how you
          actually study.
        </p>
      </header>

      <div className="auth-card">
        <form className="auth-form">
          <label className="field">
            <span>Name</span>
            <input type="text" placeholder="Alex Johnson" />
          </label>
          <label className="field">
            <span>Email</span>
            <input type="email" placeholder="you@example.edu" />
          </label>
          <label className="field">
            <span>Password</span>
            <input type="password" placeholder="Create a password" />
          </label>
          <button className="primary-cta" type="submit">
            <span>Create account</span>
          </button>
          <p className="muted-link">
            Already have an account? <a href="/login">Log in</a>
          </p>
        </form>
      </div>
    </div>
  )
}

