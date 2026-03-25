import React from 'react';
import './PreferenceSlider.scss';

interface PreferenceSliderProps {
  category: string;
  label: string;
  value: number;
  min: number;
  max: number;
  unit?: string;
  minLabel: string;
  maxLabel: string;
  onChange: (value: number) => void;
}

const PreferenceSlider: React.FC<PreferenceSliderProps> = ({
  category,
  label,
  value,
  min,
  max,
  unit = '',
  minLabel,
  maxLabel,
  onChange,
}) => {
  // calculate percentage for the filled track
  const percentage = ((value - min) / (max - min)) * 100;

  return (
    <div className="preference-slider">
      <div className="preference-slider__header">
        <div>
          <p className="preference-slider__category">{category}</p>
          <p className="preference-slider__label">{label}</p>
        </div>
        <span className="preference-slider__value">{value}{unit}</span>
      </div>

      <div className="preference-slider__track-wrapper">
        {/* grey background track */}
        <div className="preference-slider__track-bg" />

        {/* purple filled track — width driven by percentage */}
        <div
          className="preference-slider__track-fill"
          style={{ width: `${percentage}%` }}
        />

        {/* the actual range input — invisible but handles interaction */}
        <input
          type="range"
          min={min}
          max={max}
          value={value}
          onChange={(e) => onChange(Number(e.target.value))}
          className="preference-slider__input"
        />
      </div>

      <div className="preference-slider__labels">
        <span>{minLabel}</span>
        <span>{maxLabel}</span>
      </div>
    </div>
  );
};

export default PreferenceSlider;