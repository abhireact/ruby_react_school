import React from 'react';
import { Menu } from 'antd';

const SideNavigation = ({ sections }) => {
  const handleScrollToSection = (key) => {
    const element = document.getElementById(key);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div
      style={{
        width: '200px',
        height: 'auto', // Set height to auto to fit the content
        boxShadow: '2px 0 8px rgba(0,0,0,0.1)',
        borderRadius: '10px',
        overflow: 'hidden',
        position: 'fixed',
        backgroundColor: '#fff',
      }}
    >
      <Menu
        mode="vertical"
        className="h-full border-none"
        items={sections.map((section) => ({
          key: section.key,
          icon: section.icon,
          label: section.title,
          onClick: () => handleScrollToSection(section.key),
        }))}
      />
    </div>
  );
};

export default SideNavigation;
