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

import Classes from "./components/Classes/ClassesIndex";
import Dashboard from "./components/Dashboard/index";
import AddmissionDates from "./components/Addmission/dates";
import ManageAdmissionSettings from "./components/Addmission/dates/manage";
import ExamType from "./components/Examination/ExamType";
import SectionIndex from "./components/Section/SectionIndex";
import EmpListManagement from "./components/emp_subjects/list";
import EmpSybIndex from "./components/emp_subjects";
import GreetingMessageManagement from "./components/school/greetingmessage";
import SubjectArchiveManager from "./components/subject_archive";
import ListManagement from "./components/subject_archive/list";
import SubjectsManagement from "./components/subjects";
import CasteManagement from "./components/caste";
import CategoryManagement from "./components/category";
import StudentHobbyManagement from "./components/student_hobby";
import HouseManagement from "./components/house";
import SportsManagement from "./components/sports";
import ExtraCurrIndex from "./components/extra_curricular";
import StudentCategoryIndex from "./components/student_category";
import BatchSubjectsIndex from "./components/batch_subject";
import SelectSubject from "./components/batch_subject/create";
import StudentAttendance from "./components/attendance/student_attendance";
import MgEmployeeLeaveTypeIndex from "./components/attendance/employee_leave_type";
import UploadSet from "./components/Upload/UploadSet";
import OtherParticular from "./components/Examination/OtherParticular";
import OtherGrade from "./components/Examination/OtherGrade";
import ScholasticGrade from "./components/Examination/ScholasticGrade";
import AbsentReason from "./components/Examination/AbsentReason";
import SubSubject from "./components/Examination/SubSubject";
import RemarksEntry from "./components/Examination/RemarksEntry";
import OtherMarksEntry from "./components/Examination/OtherMarksEntry";
import ExamReportReleases from "./components/Examination/ExamReportReleases";
import EmployeeDepartment from "./components/EmployeeDepartment";
import EmployeeProfile from "./components/EmployeeProfile";
import BulkEmployeePhotoUpload from "./components/BulkEmployeePhotoUpload";
import AssignTeacher from "./components/AssignTeacher";
import ArchiveEmployee from "./components/ArchiveEmployee";
import ExportArchiveEmployee from "./components/ExportArchiveEmployee";
import Employee from "./components/Employee";
import ExperienceCertificate from "./components/Employee/ExperienceCertificate";



// Mapping of element IDs to components
const componentMapping = {
  reactRender: Home,
  WingsIndex: WingManagement,
  SchoolIndex: SchoolInfo,
  AcademicIndex: AcademicYearManagement,

  DashboardIndex: Dashboard,
  ClassesIndex: Classes,
  AddmissionsIndex: AddmissionDates,
  ManageAddmissionsIndex: ManageAdmissionSettings,
  ExamType: ExamType,
  EmpListManagement: EmpListManagement,
  EmpSybIndex: EmpSybIndex,
  SectionIndex: SectionIndex,
  GreetingMessageIndex: GreetingMessageManagement,
  SubjectArchiveIndex: SubjectArchiveManager,
  ListManagement: ListManagement,
  SubjectsIndex: SubjectsManagement,
  CasteIndex: CasteManagement,
  CategoryIndex: CategoryManagement,
  StudentHobbyIndex: StudentHobbyManagement,
  HouseIndex: HouseManagement,
  SportsIndex: SportsManagement,
  ExtraCurrIndex: ExtraCurrIndex,
  StudentCategoryIndex: StudentCategoryIndex,
  BatchSubjectsIndex: BatchSubjectsIndex,
  SelectSubject: SelectSubject,
  StudentAttendance: StudentAttendance,
  MgEmployeeLeaveTypeIndex: MgEmployeeLeaveTypeIndex,
  UploadSet:UploadSet,
  OtherParticular:OtherParticular,
  OtherGrade,
  ScholasticGrade,
  AbsentReason,
  SubSubject,
  RemarksEntry,
  OtherMarksEntry,
  ExamReportReleases,
  EmployeeDepartment,
  EmployeeProfile,
  BulkEmployeePhotoUpload,
  AssignTeacher,
  ArchiveEmployee,
  ExportArchiveEmployee,
  ExperienceCertificate,
  Employee
  
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
