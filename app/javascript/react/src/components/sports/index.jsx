import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const SportsManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [{ key: "name", label: "Caste Name" }];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "name", label: "Caste Name", type: "text" },
    { name: "description", label: "Description", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Sports Management"
      description="Manage Sports ."
      initialData={userData}
      columns={columns}
      apiEndpoint="sports"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};
export default SportsManagement;
