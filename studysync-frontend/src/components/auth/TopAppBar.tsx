import React from 'react';
import './TopAppBar.scss';

interface TopAppBarProps {
  title: string;
  onBack?: () => void;
}

const TopAppBar: React.FC<TopAppBarProps> = ({ title, onBack }) => {
  return (
    <div className="top-app-bar">
      <div className="top-app-bar__back" onClick={onBack}>
        <span className="material-symbols-outlined">arrow_back_ios</span>
      </div>
      <h2 className="top-app-bar__title">{title}</h2>
    </div>
  );
};

export default TopAppBar;