import React from 'react';
import './FeatureCard.scss';

interface FeatureCardProps {
  icon: string;
  title: string;
  description: string;
  color: 'blue' | 'purple';
  animationDelay?: string;
}

const FeatureCard: React.FC<FeatureCardProps> = ({
  icon,
  title,
  description,
  color,
  animationDelay = '0s',
}) => {
  return (
    <div
      className={`feature-card feature-card--${color}`}
      style={{ animationDelay }}
    >
      <div className={`feature-card__icon-wrap feature-card__icon-wrap--${color}`}>
        <span className="material-symbols-outlined">{icon}</span>
      </div>
      <div className="feature-card__text">
        <span className="feature-card__title">{title}</span>
        <span className="feature-card__desc">{description}</span>
      </div>
    </div>
  );
};

export default FeatureCard;