import * as React from "react";
import * as ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import store from "./store";

// Import components
import Home from "./components/Home";
import Wing from "./components/WingsIndex";
import SchoolInfo from "./components/school/schoolinfo";
import AcademicYearManagement from "./components/school/academic";

// Mapping of element IDs to components
const componentMapping = {
  reactRender: Home,
  WingIndex: Wing,
  SchoolIndex:SchoolInfo,
 AcademicIndex:AcademicYearManagement,

};

// Function to render a component
const renderComponent = (elementId, Component) => {
  const rootElement = document.getElementById(elementId);

  if (rootElement) {
    console.log(`Rendering component in ${elementId}`);

    let userData;
    try {
      userData = JSON.parse(rootElement.dataset.user || "{}");
    } catch (error) {
      console.error(`Error parsing user data for ${elementId}:`, error);
      userData = {};
    }

    const root = ReactDOM.createRoot(rootElement);
    root.render(
      <Provider store={store}>
        <Component {...(userData ? { userData } : {})} />
      </Provider>
    );
  }
};

// Render components based on the presence of their target elements
document.addEventListener("DOMContentLoaded", () => {
  Object.entries(componentMapping).forEach(([elementId, Component]) => {
    if (document.getElementById(elementId)) {
      renderComponent(elementId, Component);
    }
  });
});

// If you need to export the components for use elsewhere
// export { Home, Wing };
