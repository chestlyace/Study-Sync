import React from 'react';
import './ToggleSwitch.scss';

interface ToggleSwitchProps {
  label: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
}

const ToggleSwitch: React.FC<ToggleSwitchProps> = ({ label, checked, onChange }) => {
  return (
    <div className="toggle-switch">
      <p className="toggle-switch__label">{label}</p>
      <label className="toggle-switch__track">
        <input
          type="checkbox"
          checked={checked}
          onChange={(e) => onChange(e.target.checked)}
        />
        <span className="toggle-switch__slider" />
      </label>
    </div>
  );
};

export default ToggleSwitch;