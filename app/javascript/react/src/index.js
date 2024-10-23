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
import Classes from "./components/Classes/ClassesIndex";
import Dashboard from "./components/Dashboard/index";
import AddmissionDates from "./components/Addmission/dates";
import ManageAdmissionSettings from "./components/Addmission/dates/manage";
import ExamType from "./components/Examination/ExamType";
import SectionIndex from "./components/Section/SectionIndex";

import EmpListManagement from "./components/emp_subjects/list";
import EmpSybIndex from "./components/emp_subjects";
import BatchSubjectManagement from "./components/subjects/batch";
import CategoryManagement from "./components/category";
import SubjectsManagement from "./components/subjects";
import CasteManagement from "./components/caste";
import SportsManagement from "./components/sports";
import StudentHobbyManagement from "./components/student_hobby";
import HouseManagement from "./components/house";
import ExtraCurrIndex from "./components/extra_curricular";
import StudentCategoryIndex from "./components/student_category";
// Mapping of element IDs to components
const componentMapping = {
  reactRender: Home,
  WingsIndex: WingManagement,
  SchoolIndex: SchoolInfo,
  AcademicIndex: AcademicYearManagement,
  EmployeesIndex: Employees,
  DashboardIndex: Dashboard,
  ClassesIndex: Classes,
  AddmissionsIndex: AddmissionDates,
  ManageAddmissionsIndex: ManageAdmissionSettings,
  ExamType: ExamType,
  EmpListManagement: EmpListManagement,
  EmpSybIndex: EmpSybIndex,
  BatchSubjectManagement: BatchSubjectManagement,
  SectionIndex: SectionIndex,
  CategoryIndex: CategoryManagement,
  CasteIndex: CasteManagement,
  SubjectsIndex: SubjectsManagement,
  SportsIndex: SportsManagement,
  StudentHobbyIndex: StudentHobbyManagement,
  HouseIndex: HouseManagement,
  ExtraCurrIndex: ExtraCurrIndex,
  StudentCategoryIndex: StudentCategoryIndex,
};

// Function to render a component
const renderComponent = (elementId, Component) => {
  const rootElement = document.getElementById(elementId);

  if (rootElement) {
    console.log(`Rendering component in ${elementId}`);

    let userData;
    try {
      userData = JSON.parse(rootElement.dataset.user || "{}");
      // console.log(userData, "efsdfasdjkl");
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
