import React from 'react';
import './BackgroundBlobs.scss';

const BackgroundBlobs: React.FC = () => {
  return (
    <>
      <div className="blob blob--top-left" />
      <div className="blob blob--bottom-right" />
      <div className="confetti confetti--diamond" />
      <div className="confetti confetti--circle" />
      <div className="confetti confetti--bar" />
    </>
  );
};

export default BackgroundBlobs;