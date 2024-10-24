import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";

const SubjectsManagement = ({ userData }) => {
  const columns = [
    { key: "subject_name", label: "Subject Name" },
    { key: "subject_code", label: "Subject Code" },
    { key: "max_weekly_class", label: "Max Weekly Class" },
    { key: "index", label: "Index" },
  ];

  const validationSchema = Yup.object({
    // name: Yup.string().required("Required"),
  });

  const formFields = [
    {
      name: "subject_name",
      label: "Subject Name",
      type: "text",
      fieldType: "input",
    },
    {
      name: "subject_code",
      label: "Subject Code",
      type: "text",
      fieldType: "input",
    },
    {
      name: "mg_course_id",
      label: "Course Id",
      type: "number",
      fieldType: "input",
    },
    {
      name: "max_weekly_class",
      label: "Max Weekly Class",
      type: "text",
      fieldType: "input",
    },
    {
      name: "index",
      label: "Index",
      type: "text",
      fieldType: "input",
    },
    {
      name: "is_lab",
      label: "Is Lab",
      fieldType: "checkbox",
    },
    {
      name: "is_core",
      label: "Is Core",
      fieldType: "checkbox",
    },
    {
      name: "is_extra_curricular",
      label: "Is Extra Curricular",
      fieldType: "checkbox",
    },
  ];

  return (
    <div className="container-fluid py-4">
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="card-body px-0 pb-0">
              <GenericCRUD
                title="Subjects Management"
                description="Manage Subjects"
                initialData={userData}
                columns={columns}
                apiEndpoint="subjects"
                validationSchema={validationSchema}
                formFields={formFields}
                needinbuilticon={true}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SubjectsManagement;
