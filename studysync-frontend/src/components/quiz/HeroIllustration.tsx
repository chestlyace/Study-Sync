import React from 'react';
import './HeroIllustration.scss';

const IMAGE_URL =
  'https://lh3.googleusercontent.com/aida-public/AB6AXuCgtH_QsCI8HWh5XEI-fpP8NHFhUhCYs8WKOgkLm0SUT2IWCpiHzHAC4C5HWnxszhSpD6GX0ZwbHM6DiRRTKz8s2TsUbUJ4kd8WxvktNo-5QY3NYfqTrPABhZYyDQTjhfYZojqdjz_JJ8tfqJs-1Av3_g8ziK4qMcjEjpUqcDU8FzPe110zPsMrZpiyTX1hGEXbGM1z_x8oqtiyssFIi8bS2huumB2IkqqcX0nQeyAII2myMnKfAzh34yfewDatBBBWWjoIYLZTV60';

const HeroIllustration: React.FC = () => {
  return (
    <div className="hero-illustration">
      {/* decorative blobs */}
      <div className="hero-illustration__blob hero-illustration__blob--top" />
      <div className="hero-illustration__blob hero-illustration__blob--bottom" />

      {/* the actual image */}
      <div
        className="hero-illustration__image"
        style={{ backgroundImage: `url(${IMAGE_URL})` }}
      />

      {/* subtle bottom gradient overlay */}
      <div className="hero-illustration__overlay" />
    </div>
  );
};

export default HeroIllustration;