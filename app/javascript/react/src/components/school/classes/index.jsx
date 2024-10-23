import React, { useEffect, useState } from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";

const ClassManagement = ({ userData, wings, academicYear }) => {
  const [currentAcademicYear, setCurrentAcademicYear] = useState(academicYear);
  const [showWarning, setShowWarning] = useState(!academicYear);

  useEffect(() => {
    console.log("Academic Year:", currentAcademicYear);
    setShowWarning(!currentAcademicYear);
  }, [currentAcademicYear]);

  const parseUserData = () => {
    if (typeof userData === "string") {
      try {
        return JSON.parse(userData);
      } catch (e) {
        console.error("Error parsing userData:", e);
        return [];
      }
    }
    return userData || [];
  };

  const processedData = parseUserData().map((classData) => ({
    ...classData,
    wing_name: classData.mg_wing?.wing_name || "N/A",
    academic_year: currentAcademicYear,
  }));

  const columns = [
    { key: "course_name", label: "Course Name" },
    { key: "section_name", label: "Section" },
    { key: "code", label: "Code" },
    { key: "grading_type", label: "Grading Type" },
    { key: "wing_name", label: "Wing" },
  ];

  const validationSchema = Yup.object({
    course_name: Yup.string().required("Course name is required"),
    section_name: Yup.string().required("Section name is required"),
    code: Yup.string().required("Code is required"),
    grading_type: Yup.string().required("Grading type is required"),
    mg_wing_id: Yup.string().required("Wing is required"),
  });

  const formFields = [
    { name: "course_name", label: "Course Name", type: "text" },
    { name: "academic_year", label: "Academic Year", type: "text" },
    { name: "section_name", label: "Section Name", type: "text" },
    { name: "code", label: "Code", type: "text" },
    { name: "grading_type", label: "Grading Type", type: "text" },
    {
      name: "mg_wing_id",
      label: "Wing",
      type: "select",
      options:
        wings?.map((wing) => ({
          value: wing.id,
          label: wing.wing_name,
        })) || [],
    },
  ];

  return (
    <div>
      {showWarning && (
        <div
          className="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-4"
          role="alert"
        >
          <p className="font-bold">Warning</p>
          <p>
            No academic year is currently set. Some features may be limited.
          </p>
        </div>
      )}

      <GenericCRUD
        title="Class Management"
        description="Manage school classes, sections, and their configurations."
        initialData={processedData}
        columns={columns}
        apiEndpoint="classes"
        validationSchema={validationSchema}
        formFields={formFields}
      />
    </div>
  );
};

export default ClassManagement;
