import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const SportsManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [
    { key: "name", label: "Sport Name" },
    { key: "description", label: "Description" },
  ];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "name", label: "Sport Name", type: "text" },
    { name: "description", label: "Description", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Sports Management"
      description="Manage Sports"
      initialData={userData}
      columns={columns}
      apiEndpoint="category/sports"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="sports"
    />
  );
};
export default SportsManagement;
