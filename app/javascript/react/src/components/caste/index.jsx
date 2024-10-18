import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const CasteManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [{ key: "name", label: "Caste Name" }];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "name", label: "Caste Name", type: "text", fieldType: "input" },
    {
      name: "description",
      label: "Description",
      type: "text",
      fieldType: "input",
    },
  ];

  return (
    <GenericCRUD
      title="Caste Management"
      description="Manage Caste ."
      initialData={userData}
      columns={columns}
      apiEndpoint="castes"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};
export default CasteManagement;
