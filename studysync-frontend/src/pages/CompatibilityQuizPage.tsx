import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import QuizProgressBar from '../components/quiz/QuizProgressBar';
import HeroIllustration from '../components/quiz/HeroIllustration';
import FeatureCard from '../components/quiz/FeatureCard';
import './CompatibilityQuizPage.scss';

const CompatibilityQuizPage: React.FC = () => {
  const navigate = useNavigate();

 
  const [current] = useState(0);
  const total = 10;

  
  const [btnActive, setBtnActive] = useState(false);

  const handleStartQuiz = () => {
    setBtnActive(true);
    setTimeout(() => {
      setBtnActive(false);
      
      console.log('Starting quiz...');
    }, 200);
  };

  return (
    <div className="compat-quiz-page">

      {/* ── Header ── */}
      <div className="compat-quiz-page__header">
        <button
          className="compat-quiz-page__back"
          onClick={() => navigate(-1)}
          aria-label="Go back"
        >
          <span className="material-symbols-outlined">arrow_back</span>
        </button>
        <h2 className="compat-quiz-page__header-title">Compatibility Quiz</h2>
        {/* spacer to keep title centered */}
        <div className="compat-quiz-page__header-spacer" />
      </div>

      {/* ── Progress Bar ── */}
      <div className="compat-quiz-page__progress">
        <QuizProgressBar current={current} total={total} />
      </div>

      {/* ── Scrollable Body ── */}
      <div className="compat-quiz-page__body">

        {/* Hero image */}
        <div className="compat-quiz-page__hero">
          <HeroIllustration />
        </div>

        {/* Headline text */}
        <div className="compat-quiz-page__text">
          <h1 className="compat-quiz-page__headline">
            Find Your Perfect{' '}
            <br />
            <span className="compat-quiz-page__headline-accent">
              Study Partner
            </span>
          </h1>
          <p className="compat-quiz-page__subtext">
            Take this quick 2-minute quiz to help us understand your learning
            style and goals. We'll match you with the best groups.
          </p>
        </div>

        {/* Feature cards */}
        <div className="compat-quiz-page__features">
          <FeatureCard
            icon="timer"
            title="Quick & Easy"
            description="Only takes 2 minutes to complete"
            color="blue"
            animationDelay="0.1s"
          />
          <FeatureCard
            icon="psychology"
            title="Smart Matching"
            description="AI-driven compatibility scores"
            color="purple"
            animationDelay="0.2s"
          />
        </div>

      </div>

      {/* ── Sticky Start Button ── */}
      <div className="compat-quiz-page__footer">
        <button
          className={`compat-quiz-page__start-btn ${btnActive ? 'compat-quiz-page__start-btn--active' : ''}`}
          onClick={handleStartQuiz}
        >
          <span>Start Quiz</span>
          <span className="material-symbols-outlined">arrow_forward</span>
        </button>
      </div>

    </div>
  );
};

export default CompatibilityQuizPage;