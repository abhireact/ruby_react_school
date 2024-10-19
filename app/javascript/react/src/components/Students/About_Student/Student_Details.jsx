import React from "react";
import { useSelector, useDispatch } from "react-redux";

const StudentDetails = ({ userData }) => {
  const dispatch = useDispatch();
  const { academicYear, classData, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear,
    classData: state.classData,
    sectionData: state.sectionData,
  }));

  // Parse userData if it's a string, otherwise use it as is
  const user = typeof userData === "string" ? JSON.parse(userData) : userData;
  console.log(user, "user");

  console.log(academicYear, "academic"); // Logs academic year data
  console.log(classData, "class"); // Logs class data
  console.log(sectionData, "section"); // Logs section data

  // Assuming wingData is part of classData or a separate state
  const wingData = classData
    ? [...new Set(classData.map((cls) => cls.wing))]
    : [];

  return (
    <div className="card mb-4">
      <div className="card-body">
        <form id="sectionChangeForm">
          <div className="row">
            <div className="col-md-3 mb-3">
              <label htmlFor="academicYear" className="form-label">
                Academic Year
              </label>
              <select
                className="form-select"
                id="academicYear"
                name="academic_year"
                required
              >
                <option value="">Select Academic Year</option>
                {academicYear.map((year, index) => (
                  <option key={index} value={year}>
                    {year}
                  </option>
                ))}
              </select>
              <div className="invalid-feedback" id="error-academic_year"></div>
            </div>
            <div className="col-md-3 mb-3">
              <label htmlFor="wingName" className="form-label">
                Wing Name
              </label>
              <select
                className="form-select"
                id="wingName"
                name="wing_name"
                required
              >
                <option value="">Select Wing</option>

                {wingData.map((wing, index) => (
                  <option key={index} value={wing}>
                    {wing}
                  </option>
                ))}
              </select>
              <div className="invalid-feedback" id="error-wing_name"></div>
            </div>
            <div className="col-md-3 mb-3">
              <label htmlFor="className" className="form-label">
                Class
              </label>
              <select
                className="form-select"
                id="className"
                name="class_name"
                required
              >
                <option value="">Select Class</option>
                {classData.map((cls, index) => (
                  <option key={index} value={cls}>
                    {cls}
                  </option>
                ))}
              </select>
              <div className="invalid-feedback" id="error-class_name"></div>
            </div>
            <div className="col-md-3 mb-3">
              <label htmlFor="section" className="form-label">
                Section
              </label>
              <select
                className="form-select"
                id="section"
                name="section"
                required
              >
                <option value="">Select Section</option>
                {sectionData.map((section, index) => (
                  <option key={index} value={section}>
                    {section}
                  </option>
                ))}
              </select>
              <div className="invalid-feedback" id="error-section"></div>
            </div>

            <div className="col-12 mt-3">
              <button type="submit" className="btn btn-info">
                Submit
              </button>
            </div>

            <div className="col-12 mt-3">
              <a href="students/create" className="btn btn-info">
                Create New Student
              </a>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default StudentDetails;
