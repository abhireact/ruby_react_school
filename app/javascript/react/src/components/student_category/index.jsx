import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const StudentCategoryIndex = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [{ key: "name", label: "Name" }];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [{ name: "name", label: "Name", type: "text" }];

  return (
    <GenericCRUD
      title="Student Category Management"
      description="Manage Student Category ."
      initialData={userData}
      columns={columns}
      apiEndpoint="student_categories"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="student_category"
      needinbuilticon={true}
    />
  );
};
export default StudentCategoryIndex;
