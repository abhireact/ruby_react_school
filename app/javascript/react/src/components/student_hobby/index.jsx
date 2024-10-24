import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const StudentHobbyManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [
    { key: "name", label: "Name" },
    { key: "description", label: "Description" },
  ];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "name", label: "Name", type: "text" },
    { name: "description", label: "Description", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Student Hobby Management"
      description="Manage Student Hobby ."
      initialData={userData}
      columns={columns}
      apiEndpoint="category/student_hobbies"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="student_hobbies"
      needinbuilticon={true}
    />
  );
};
export default StudentHobbyManagement;
