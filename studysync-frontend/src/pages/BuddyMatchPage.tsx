import React from 'react';
import { useNavigate } from 'react-router-dom';
import BackgroundBlobs from '../components/buddymatch/BackgroundBlobs';
import AvatarMatch from '../components/buddymatch/AvatarMatch';
import './BuddyMatchPage.scss';

const AVATAR_ONE = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLhDWQWOngReWKJroWDXEEgNOn5hTrcTCAdayiHXuvHNZWjOOhVV7MnIVKlGAF3BZv4bhCsY_fGc2jIgGlVaF0uI_3KpaU6jk_uyAdUgOVGj60HUwitF5VLtDdL9kYbIXK1dxCyWyQFU3MQtWmogFQMUEcvo6WRn5dR7DeBOQ4TPu41DXA4H2NF75Su-MZacv9T5dwT6kp-SBPgBJx_nD9JYEGsaIrULqpqnAfGWau8INad4HU2nivHU3HiUeoRwFLmMO1t8HFZ-o';

const AVATAR_TWO = 'https://lh3.googleusercontent.com/aida-public/AB6AXuD6snDufI3U3vVsz094Lwwvit5Z2Q0q4CKBfOOfLwPantbAqO4E6XySzuGOn23BSGx7xfHfOI9LedH4oxB9NsphC1QeCynZ1dz3ENX6qqsoTL3Ir__bXexM-w1b9_bhAT-lOAVbYEdv1b2Sb31qVrX2laCii6nAgIyPqxypXOaIP68yDLxCLMj6wSoU1KgP8t0-o7Khuss88bJdTNXL_1rAEt8AwWo02TI2cV3-bkmrcT728Ba754K2orqliFh90Vir07XJAjax-hk';

const BuddyMatchPage: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="buddy-match-page">

      {/* Decorative background blobs and confetti */}
      <BackgroundBlobs />

      {/* Top bar with close button */}
      <div className="buddy-match-page__topbar">
        <div className="buddy-match-page__topbar-spacer" />
        <button
          className="buddy-match-page__close"
          onClick={() => navigate(-1)}
        >
          <span className="material-symbols-outlined">close</span>
        </button>
      </div>

      {/* Main content */}
      <div className="buddy-match-page__content">

        {/* Big headline */}
        <h1 className="buddy-match-page__headline">It's a Match!</h1>

        {/* Two overlapping avatars */}
        <div className="buddy-match-page__avatars">
          <AvatarMatch avatarOne={AVATAR_ONE} avatarTwo={AVATAR_TWO} />
        </div>

        {/* Subtext */}
        <div className="buddy-match-page__text">
          <h2 className="buddy-match-page__subheadline">Time to hit the books!</h2>
          <p className="buddy-match-page__body">
            You and Precious are a match for{' '}
            <span className="buddy-match-page__highlight">Calculus II</span>.
          </p>
        </div>

        {/* Action buttons */}
        <div className="buddy-match-page__actions">
          <button
            className="buddy-match-page__btn-primary"
            onClick={() => navigate('/chats')}
          >
            <span className="material-symbols-outlined">chat_bubble</span>
            Send a Message
          </button>

          <button
            className="buddy-match-page__btn-secondary"
            onClick={() => navigate(-1)}
          >
            Keep Browsing
          </button>
        </div>

      </div>

      <div className="buddy-match-page__spacer" />
    </div>
  );
};

export default BuddyMatchPage;