import React, { useState } from 'react';
import TopAppBar from '../components/auth/TopAppBar';
import SettingsListItem from '../components/settings/SettingsListItem';
import ToggleSwitch from '../components/settings/ToggleSwitch';
import BottomNavBar from '../components/settings/BottomNavBar';
import './AccountPrivacyPage.scss';

const AccountPrivacyPage: React.FC = () => {
  // tracks which visibility button is selected
  const [visibility, setVisibility] = useState<'Public' | 'Institution' | 'Private'>('Public');

  // tracks the two toggle states
  const [hideLastName, setHideLastName] = useState(true);
  const [disableDMs, setDisableDMs] = useState(false);

  return (
    <div className="account-privacy-page">

      {/* Reusing the TopAppBar we built for SignUp — just different title */}
      <TopAppBar title="Account & Privacy" onBack={() => window.history.back()} />

      <div className="account-privacy-page__content">

        {/* ── ACCOUNT SECTION ── */}
        <h3 className="account-privacy-page__section-title">Account</h3>
        <div className="account-privacy-page__card">
          <SettingsListItem
            label="Email"
            sublabel="student@university.edu"
            onClick={() => console.log('Email clicked')}
          />
          <SettingsListItem
            label="Change Password"
            onClick={() => console.log('Password clicked')}
          />
          <SettingsListItem
            label="Linked Accounts"
            onClick={() => console.log('Linked clicked')}
          />
        </div>

        {/* ── PRIVACY SECTION ── */}
        <h3 className="account-privacy-page__section-title">Privacy</h3>
        <div className="account-privacy-page__card">

          {/* Profile Visibility Segmented Control */}
          <div className="account-privacy-page__visibility">
            <p className="account-privacy-page__visibility-label">Profile Visibility</p>
            <div className="account-privacy-page__visibility-tabs">
              {(['Public', 'Institution', 'Private'] as const).map((option) => (
                <button
                  key={option}
                  className={`account-privacy-page__visibility-tab ${visibility === option ? 'account-privacy-page__visibility-tab--active' : ''}`}
                  onClick={() => setVisibility(option)}
                >
                  {option}
                </button>
              ))}
            </div>
          </div>

          {/* Toggle switches — pass state and setter as props */}
          <ToggleSwitch
            label="Hide Last Name"
            checked={hideLastName}
            onChange={setHideLastName}
          />
          <ToggleSwitch
            label="Disable Direct Messages"
            checked={disableDMs}
            onChange={setDisableDMs}
          />
        </div>

        {/* ── NOTIFICATIONS SECTION ── */}
        <h3 className="account-privacy-page__section-title">Notifications</h3>
        <div className="account-privacy-page__card">
          <SettingsListItem
            label="Push Notifications"
            rightText="Enabled"
            onClick={() => console.log('Push clicked')}
          />
          <SettingsListItem
            label="Email Preferences"
            onClick={() => console.log('Email prefs clicked')}
          />
          <SettingsListItem
            label="SMS Alerts"
            rightText="Off"
            onClick={() => console.log('SMS clicked')}
          />
        </div>

        {/* ── ACADEMIC VERIFICATION SECTION ── */}
        <h3 className="account-privacy-page__section-title">Academic Verification</h3>
        <div className="account-privacy-page__card">
          <div className="account-privacy-page__verify-row">
            <div>
              <p className="account-privacy-page__verify-title">Verify .edu Email</p>
              <p className="account-privacy-page__verify-subtitle">Last verified: Sept 2023</p>
            </div>
            <button className="account-privacy-page__verify-btn">Re-verify</button>
          </div>
        </div>

        {/* ── DANGER ZONE ── */}
        <h3 className="account-privacy-page__section-title account-privacy-page__section-title--danger">
          Danger Zone
        </h3>
        <div className="account-privacy-page__card">
          <button className="account-privacy-page__danger-btn">
            <span className="material-symbols-outlined">no_accounts</span>
            <span>Deactivate Account</span>
          </button>
        </div>

        {/* Footer */}
        <div className="account-privacy-page__footer">
          <p>StudySync Version 2.4.0</p>
          <p>Made for students, by students.</p>
        </div>

      </div>

      {/* Bottom nav stays fixed at the bottom */}
      <BottomNavBar />
    </div>
  );
};

export default AccountPrivacyPage;