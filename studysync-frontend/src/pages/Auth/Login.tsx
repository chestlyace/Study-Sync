import { useState } from 'react';
import './Auth.css';
import { authAPI } from '../../utils/api';

export function LoginPage() {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await authAPI.login(formData.email, formData.password);
      console.log('Login successful:', response);

      // Store tokens (in a real app, use secure storage)
      localStorage.setItem('accessToken', response.accessToken);
      localStorage.setItem('refreshToken', response.refreshToken);

      // Redirect to dashboard or home
      window.location.href = '/dashboard';
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setLoading(false);
    }
  };

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
        <form className="auth-form" onSubmit={handleSubmit}>
          <label className="field">
            <span>Email</span>
            <input
              type="email"
              name="email"
              placeholder="you@example.edu"
              value={formData.email}
              onChange={handleInputChange}
              required
            />
          </label>
          <label className="field">
            <span>Password</span>
            <input
              type="password"
              name="password"
              placeholder="••••••••"
              value={formData.password}
              onChange={handleInputChange}
              required
            />
          </label>
          {error && <p className="error-message">{error}</p>}
          <button className="primary-cta" type="submit" disabled={loading}>
            <span>{loading ? 'Logging in...' : 'Log in'}</span>
          </button>
          <p className="muted-link">
            New here? <a href="/register">Create an account</a>
          </p>
        </form>
      </div>
    </div>
  );
}

