import React from 'react';
import './SkillLevelOption.scss';

interface SkillLevelOptionProps {
  value: string;
  icon: string;
  label: string;
  description: string;
  selected: boolean;
  onChange: (value: string) => void;
}

const SkillLevelOption: React.FC<SkillLevelOptionProps> = ({
  value,
  icon,
  label,
  description,
  selected,
  onChange,
}) => {
  return (
    <label className={`skill-level-option ${selected ? 'skill-level-option--selected' : ''}`}>
      <div className="skill-level-option__left">
        <div className={`skill-level-option__icon ${selected ? 'skill-level-option__icon--active' : ''}`}>
          <span className="material-symbols-outlined">{icon}</span>
        </div>
        <div className="skill-level-option__text">
          <span className="skill-level-option__label">{label}</span>
          <span className="skill-level-option__desc">{description}</span>
        </div>
      </div>
      <input
        type="radio"
        name="skill_level"
        value={value}
        checked={selected}
        onChange={() => onChange(value)}
        className="skill-level-option__radio"
      />
    </label>
  );
};

export default SkillLevelOption;