import React from 'react';
import './SocialButton.scss';

interface SocialButtonProps {
  label: string;
  icon: React.ReactNode;
  onClick?: () => void;
}

const SocialButton: React.FC<SocialButtonProps> = ({ label, icon, onClick }) => {
  return (
    <button className="social-button" onClick={onClick}>
      <span className="social-button__icon">{icon}</span>
      <span>{label}</span>
    </button>
  );
};

export default SocialButton;