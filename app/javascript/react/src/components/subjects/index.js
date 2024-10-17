import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const SubjectsManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [
    { key: "subject_name", label: "Subject Name" },
    { key: "subject_code", label: "Subject Code" },
    { key: "max_weekly_class", label: "Max Weekly Class" },
  ];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "subject_name", label: "Subject Name", type: "text" },
    { name: "subject_code", label: "Subject Code", type: "text" },
    { name: "max_weekly_class", label: "Max Weekly Class", type: "text" },
    { name: "is_core", label: "Is Core", type: "text" },
    { name: "is_lab", label: "Is Lab", type: "text" },
    { name: "is_extra_curricular", label: "Is Extra Curricular", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Subject Management"
      description="Subject Sports ."
      initialData={userData}
      columns={columns}
      apiEndpoint="subjects"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};
export default SubjectsManagement;
