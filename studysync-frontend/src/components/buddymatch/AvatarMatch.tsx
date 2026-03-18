import React from 'react';
import './AvatarMatch.scss';

interface AvatarMatchProps {
  avatarOne: string;
  avatarTwo: string;
}

const AvatarMatch: React.FC<AvatarMatchProps> = ({ avatarOne, avatarTwo }) => {
  return (
    <div className="avatar-match">

      {/* Left avatar sits on top (z-index higher) */}
      <div className="avatar-match__item avatar-match__item--left">
        <div className="avatar-match__ring">
          <div
            className="avatar-match__image"
            style={{ backgroundImage: `url(${avatarOne})` }}
          />
        </div>
        {/* Heart badge on the left avatar */}
        <div className="avatar-match__badge">
          <span
            className="material-symbols-outlined"
            style={{ fontVariationSettings: "'FILL' 1" }}
          >
            favorite
          </span>
        </div>
      </div>

      {/* Right avatar sits behind */}
      <div className="avatar-match__item avatar-match__item--right">
        <div className="avatar-match__ring">
          <div
            className="avatar-match__image"
            style={{ backgroundImage: `url(${avatarTwo})` }}
          />
        </div>
      </div>

    </div>
  );
};

export default AvatarMatch;