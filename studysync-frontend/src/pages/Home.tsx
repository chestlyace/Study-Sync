import './Home.css'

export function HomePage() {
  return (
    <div className="page home-page">
      <header className="page-header">
        <p className="page-eyebrow">StudySync</p>
        <h1 className="page-title">Your study sessions, in sync.</h1>
        <p className="page-subtitle">
          Plan focused blocks, track your progress, and keep every resource for class, exams, and
          side projects in one calm workspace.
        </p>
      </header>

      <div className="page-grid">
        <section className="home-hero-left">
          <div className="pill-row">
            <span className="pill">Smart session planning</span>
            <span className="pill">Shared study spaces</span>
            <span className="pill">Progress analytics</span>
          </div>

          <button className="primary-cta" type="button">
            <span>Start a 25‑minute focus session</span>
          </button>

          <div className="stat-row">
            <div className="stat">
              <strong>1200+</strong> focused sessions logged
            </div>
            <div className="stat">
              <strong>14hr / week</strong> average deep work
            </div>
            <div className="stat">
              <strong>3x</strong> higher completion rate
            </div>
          </div>
        </section>

        <section className="panel home-board">
          <div className="panel-header">
            <h2 className="panel-title">Today&apos;s study plan</h2>
            <span className="panel-tag">Sample board</span>
          </div>
          <div className="home-board-grid">
            <div className="home-column">
              <p className="home-column-title">Now</p>
              <div className="home-card">
                <p className="home-chip">Focus • 25 min</p>
                <h3>Review lecture notes</h3>
                <p>Summarise today&apos;s CS lecture and flag unclear concepts.</p>
              </div>
              <div className="home-card secondary">
                <p className="home-chip">Break • 5 min</p>
                <h3>Reset</h3>
                <p>Stretch, hydrate, and log how the session went.</p>
              </div>
            </div>
            <div className="home-column">
              <p className="home-column-title">Next</p>
              <div className="home-card">
                <p className="home-chip">Focus • 50 min</p>
                <h3>Problem set</h3>
                <p>Work through 3–4 practice problems, then mark blockers.</p>
              </div>
              <div className="home-card">
                <p className="home-chip">Collab</p>
                <h3>Group review</h3>
                <p>Sync with your study group and compare solutions.</p>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  )
}

