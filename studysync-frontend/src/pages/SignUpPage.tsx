import React, { useState } from 'react';
import TopAppBar from '../components/auth/TopAppBar';
import InputField from '../components/auth/InputField';
import SocialButton from '../components/auth/SocialButton';
import './SignUpPage.scss';

const GoogleIcon = () => (
  <img
    src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzfkvZoFvWZE5i5Nabgtbxby03NkyvRn1izTheSPNda76ZCC2yVjxQ0Ouf8LoYNWQtnMape7QqjTS1RU8jYWAy-V3hv7Vyqvregp8ZMYUr_vxg_G0HO5zfwx3pE2xcrdeDa-imxpB7yRfP92j9QY6fvgED93teLASd2e4yoMwXEDvWpVKM2KnOuWwZ9oBj4K5BAVpRpx7vsIU7iz05lUhX6wvIRonF9U7qB2AH0XXMg9hBE5NNgBFCUX46r98U2OEvx2ajG0WBd_M"
    alt="Google"
    width={20}
    height={20}
  />
);

const MicrosoftIcon = () => (
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 23 23" width="20" height="20">
    <path d="M0 0h23v23H0z" fill="#f3f3f3" />
    <path d="M1 1h10v10H1z" fill="#f35325" />
    <path d="M12 1h10v10H12z" fill="#81bc06" />
    <path d="M1 12h10v10H1z" fill="#05a6f0" />
    <path d="M12 12h10v10H12z" fill="#ffba08" />
  </svg>
);

const SignUpPage: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <div className="signup-page">
      <TopAppBar title="Sign Up" onBack={() => window.history.back()} />

      <div className="signup-page__content">
        <h1 className="signup-page__headline">Join StudySync</h1>
        <p className="signup-page__subtext">Find and join study groups with ease.</p>

        <div className="signup-page__form">
          <InputField
            label="Institutional Email"
            type="email"
            placeholder="yourname@university.edu"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />

          <InputField
            label="Password"
            type="password"
            placeholder="Create a password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            showToggle={true}
          />

          <div className="signup-page__submit">
            <button className="signup-page__btn-primary">Create Account</button>
          </div>

          <div className="signup-page__divider">
            <div className="signup-page__divider-line" />
            <span className="signup-page__divider-text">or continue with</span>
            <div className="signup-page__divider-line" />
          </div>

          <div className="signup-page__social">
            <SocialButton label="Institutional Google Login" icon={<GoogleIcon />} />
            <SocialButton label="Microsoft Office 365" icon={<MicrosoftIcon />} />
          </div>

          <div className="signup-page__signin-link">
            <p>
              Already have an account?{' '}
              <a href="/signin" className="signup-page__link">Sign In</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SignUpPage;