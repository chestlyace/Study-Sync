import React from 'react';
import './GroupSizeSelector.scss';

interface GroupOption {
    label: string;
    icon: string;
    value: string;
}

const options: GroupOption[] = [
    { label: '1-on-1', icon: 'person', value: 'small-groups' },
    { label: 'Small groups', icon: 'groups', value: 'small-groups' },
];

interface GroupSizeSelectorProps {
  selected: string;
  onChange: (value: string) => void;
}

const GroupSizeSelector: React.FC<GroupSizeSelectorProps> = ({ selected, onChange }) => {
  return (
    <div className="group-size-selector">
      {options.map((option) => (
        <button
          key={option.value}
          className={`group-size-selector__chip ${selected === option.value ? 'group-size-selector__chip--active' : ''}`}
          onClick={() => onChange(option.value)}
        >
          <span className="material-symbols-outlined">{option.icon}</span>
          <span>{option.label}</span>
        </button>
      ))}
    </div>
  );
};

export default GroupSizeSelector;