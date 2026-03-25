import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import GroupSizeSelector from '../components/preferences/GroupSizeSelector';
import PreferenceSlider from '../components/preferences/PreferenceSlider';
import SkillLevelOption from '../components/preferences/SkillLevelOption';
import './BuddyMatchPreferencesPage.scss';

const skillOptions = [
  {
    value: 'same',
    icon: 'equal',
    label: 'Same as me',
    description: 'Learn together at the same pace',
  },
  {
    value: 'complementary',
    icon: 'handshake',
    label: 'Complementary',
    description: 'Mentor/Mentee dynamic',
  },
];

const BuddyMatchPreferencesPage: React.FC = () => {
  const navigate = useNavigate();

  // state for each preference
  const [groupSize, setGroupSize] = useState('one-on-one');
  const [matchPercent, setMatchPercent] = useState(80);
  const [hoursOverlap, setHoursOverlap] = useState(3);
  const [skillLevel, setSkillLevel] = useState('same');

  const handleReset = () => {
    setGroupSize('one-on-one');
    setMatchPercent(80);
    setHoursOverlap(3);
    setSkillLevel('same');
  };

  const handleSave = () => {
    console.log('Saved:', { groupSize, matchPercent, hoursOverlap, skillLevel });
    navigate(-1);
  };

  return (
    <div className="preferences-page">

      {/* Header */}
      <div className="preferences-page__header">
        <h3 className="preferences-page__title">Discovery Preferences</h3>
        <button className="preferences-page__reset" onClick={handleReset}>
          Reset
        </button>
      </div>

      {/* Scrollable content */}
      <div className="preferences-page__content">

        {/* Group Size */}
        <div className="preferences-page__section">
          <p className="preferences-page__section-category">Looking for</p>
          <p className="preferences-page__section-label">Group size preference</p>
          <GroupSizeSelector selected={groupSize} onChange={setGroupSize} />
        </div>

        {/* Match Percentage Slider */}
        <div className="preferences-page__section">
          <PreferenceSlider
            category="Compatibility"
            label="Minimum match percentage"
            value={matchPercent}
            min={60}
            max={100}
            unit="%"
            minLabel="60%"
            maxLabel="100%"
            onChange={setMatchPercent}
          />
        </div>

        {/* Hours Overlap Slider */}
        <div className="preferences-page__section">
          <PreferenceSlider
            category="Availability"
            label="Min hours overlap/week"
            value={hoursOverlap}
            min={1}
            max={10}
            unit="h"
            minLabel="1h"
            maxLabel="10h+"
            onChange={setHoursOverlap}
          />
        </div>

        {/* Skill Level */}
        <div className="preferences-page__section preferences-page__section--last">
          <p className="preferences-page__section-category">Skill Level</p>
          <p className="preferences-page__section-label">Partner expertise</p>
          <div className="preferences-page__skill-options">
            {skillOptions.map((option) => (
              <SkillLevelOption
                key={option.value}
                {...option}
                selected={skillLevel === option.value}
                onChange={setSkillLevel}
              />
            ))}
          </div>
        </div>

      </div>

      {/* Sticky Save Button */}
      <div className="preferences-page__footer">
        <button className="preferences-page__save-btn" onClick={handleSave}>
          Save Preferences
        </button>
      </div>

    </div>
  );
};

export default BuddyMatchPreferencesPage;