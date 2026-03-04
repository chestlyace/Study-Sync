import './Dashboard.css'

export function DashboardPage() {
  return (
    <div className="page dashboard-page">
      <header className="page-header">
        <p className="page-eyebrow">Dashboard</p>
        <h1 className="page-title">Overview of your study week.</h1>
        <p className="page-subtitle">
          This is where your upcoming sessions, recently completed work, and focus stats will live.
          Hook this up to your backend when you&apos;re ready.
        </p>
      </header>

      <div className="dashboard-grid">
        <section className="panel">
          <div className="panel-header">
            <h2 className="panel-title">Upcoming sessions</h2>
            <span className="panel-tag">Demo data</span>
          </div>
          <ul className="dashboard-list">
            <li>
              <span>Algorithms problem set</span>
              <span className="badge">Today · 7:00–8:00 PM</span>
            </li>
            <li>
              <span>Linear algebra review</span>
              <span className="badge">Tomorrow · 4:30–5:15 PM</span>
            </li>
            <li>
              <span>Study group sync</span>
              <span className="badge">Fri · 6:00–7:00 PM</span>
            </li>
          </ul>
        </section>

        <section className="panel dashboard-secondary">
          <div className="panel-header">
            <h2 className="panel-title">Focus streak</h2>
          </div>
          <p className="panel-body">
            You&apos;ve completed <strong>8 focused sessions</strong> in the last 7 days. Keep your
            streak going by planning tomorrow&apos;s first block now.
          </p>
        </section>
      </div>
    </div>
  )
}

