import React from 'react';
import './SettingsListItem.scss';

interface SettingsListItemProps {
  label: string;
  sublabel?: string;
  rightText?: string;
  onClick?: () => void;
}

const SettingsListItem: React.FC<SettingsListItemProps> = ({
  label,
  sublabel,
  rightText,
  onClick,
}) => {
  return (
    <div className="settings-list-item" onClick={onClick}>
      <div className="settings-list-item__content">
        <p className="settings-list-item__label">{label}</p>
        {sublabel && (
          <p className="settings-list-item__sublabel">{sublabel}</p>
        )}
      </div>
      <div className="settings-list-item__right">
        {rightText && (
          <span className="settings-list-item__right-text">{rightText}</span>
        )}
        <span className="material-symbols-outlined">chevron_right</span>
      </div>
    </div>
  );
};

export default SettingsListItem;