import { useState } from 'react';
import './Auth.css';
import { authAPI } from '../../utils/api';

export function RegisterPage() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    phone: '',
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
      const response = await authAPI.register({
        name: formData.name,
        email: formData.email,
        password: formData.password,
        phone: formData.phone,
      });
      console.log('Registration successful:', response);

      // Store tokens (in a real app, use secure storage)
      localStorage.setItem('accessToken', response.accessToken || '');
      localStorage.setItem('refreshToken', response.refreshToken || '');

      // Redirect to dashboard or home
      window.location.href = '/dashboard';
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Registration failed');
    } finally {
      setLoading(false);
    }
  };

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
        <form className="auth-form" onSubmit={handleSubmit}>
          <label className="field">
            <span>Name</span>
            <input
              type="text"
              name="name"
              placeholder="Alex Johnson"
              value={formData.name}
              onChange={handleInputChange}
              required
            />
          </label>
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
              placeholder="Create a password"
              value={formData.password}
              onChange={handleInputChange}
              required
            />
          </label>
          <label className="field">
            <span>Phone</span>
            <input
              type="tel"
              name="phone"
              placeholder="+1 (555) 000-0000"
              value={formData.phone}
              onChange={handleInputChange}
              required
            />
          </label>
          {error && <p className="error-message">{error}</p>}
          <button className="primary-cta" type="submit" disabled={loading}>
            <span>{loading ? 'Creating account...' : 'Create account'}</span>
          </button>
          <p className="muted-link">
            Already have an account? <a href="/login">Log in</a>
          </p>
        </form>
      </div>
    </div>
  );
}

