import * as React from "react";
import * as ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import store from "./store";
import { I18nextProvider } from "react-i18next";
import i18n from "./i18n";
import Home from "./components/Home";
import SchoolInfo from "./components/school/schoolinfo";
import AcademicYearManagement from "./components/school/academic";
import WingManagement from "./components/school/wings";
import Employees from "./components/Employee/EmployeesIndex";
import Classes from "./components/Classes/ClassesIndex"
import Dashboard from "./components/Dashboard/index";

import StudentDetails from "./components/Students/About_Student/Student_Details";
import CreateStudent from "./components/Students/About_Student/create_student";
import CasteDetails from "./components/Students/About_Student/caste";
import CreateCaste from "./components/Students/About_Student/create_caste";
import ClassManagement from "./components/school/classes";
import CasteManagement from "./components/caste";
import CategoryManagement from "./components/category";
import StudentHobbyManagement from "./components/student_hobby";
import HouseManagement from "./components/house";
import SportsManagement from "./components/sports";
import SubjectsManagement from "./components/subjects";
import SubjectArchiveManager from "./components/subject_archive";
// Mapping of element IDs to components
const componentMapping = {
  reactRender: Home,
  WingsIndex: WingManagement,
  SchoolIndex: SchoolInfo,
  AcademicIndex: AcademicYearManagement,
  EmployeesIndex: Employees,
  ClassIndex: ClassManagement,
  CasteIndex: CasteManagement,
  CategoryIndex: CategoryManagement,
  StudentHobbyIndex: StudentHobbyManagement,
  HouseIndex: HouseManagement,
  SportsIndex: SportsManagement,
  SubjectsIndex: SubjectsManagement,
  DashboardIndex: Dashboard,
  ClassesIndex:Classes,
  SubjectArchiveIndex: SubjectArchiveManager,
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
