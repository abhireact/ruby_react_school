import * as React from "react";
import * as ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import store from "./store";
import { I18nextProvider } from "react-i18next";
import i18n from "./i18n";
// Import components
import Home from "./components/Home";
import Wing from "./components/WingsIndex";
import Employees from "./components/Employee/EmployeesIndex";

import StudentDetails from "./components/Students/About_Student/Student_Details";
import CreateStudent from "./components/Students/About_Student/create_student";
import CasteDetails from "./components/Students/About_Student/caste";
import CreateCaste from "./components/Students/About_Student/create_caste";
// Mapping of element IDs to components
const componentMapping = {
  reactRender: Home,
  WingIndex: Wing,
<<<<<<< HEAD
  StudentDetails: StudentDetails,
  CreateStudent: CreateStudent,
  CasteDetails: CasteDetails,
  CreateCaste: CreateCaste,
=======
  EmployeesIndex: Employees,
>>>>>>> 9e8fe308f183679aadf9027721734cdbecbf418a
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
        <I18nextProvider i18n={i18n}>
          <Component {...(userData ? { userData } : {})} />
        </I18nextProvider>
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
