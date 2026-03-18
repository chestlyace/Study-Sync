import React from 'react';
import './BottomNavBar.scss';

interface NavItem {
  icon: string;
  label: string;
  path: string;
  active?: boolean;
  filled?: boolean;
}

const navItems: NavItem[] = [
  { icon: 'home', label: 'Home', path: '/' },
  { icon: 'group', label: 'Groups', path: '/groups' },
  { icon: 'chat_bubble', label: 'Chats', path: '/chats' },
  { icon: 'settings', label: 'Settings', path: '/settings', active: true, filled: true },
];

const BottomNavBar: React.FC = () => {
  return (
    <div className="bottom-nav-bar">
      {navItems.map((item) => (
        <a key={item.label} href={item.path} className={`bottom-nav-bar__item ${item.active ? 'bottom-nav-bar__item--active' : ''}`}>
          <span
            className="material-symbols-outlined"
            style={item.filled ? { fontVariationSettings: "'FILL' 1" } : {}}
          >
            {item.icon}
          </span>
          <span className="bottom-nav-bar__item-label">{item.label}</span>
        </a>
      ))}
    </div>
  );
};

export default BottomNavBar;
