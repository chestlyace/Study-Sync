import React from 'react';
import './QuizProgressBar.scss';

interface QuizProgressBarProps {
  current: number;
  total: number;
}

const QuizProgressBar: React.FC<QuizProgressBarProps> = ({ current, total }) => {
  const percentage = total > 0 ? (current / total) * 100 : 5;

  return (
    <div className="quiz-progress-bar">
      <div className="quiz-progress-bar__labels">
        <span className="quiz-progress-bar__label">Quiz Progress</span>
        <span className="quiz-progress-bar__count">{current}/{total}</span>
      </div>
      <div className="quiz-progress-bar__track">
        <div
          className="quiz-progress-bar__fill"
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
};

export default QuizProgressBar;