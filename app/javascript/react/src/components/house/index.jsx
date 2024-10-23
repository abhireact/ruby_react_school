import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const HouseManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [
    { key: "Name", label: "Name" },
    { key: "Description", label: "Description" },
  ];

  const validationSchema = Yup.object({
    Name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "Name", label: "Name", type: "text" },
    { name: "Description", label: "Description", type: "text" },
  ];

  return (
    <GenericCRUD
      title="House Management"
      description="Manage House ."
      initialData={userData}
      columns={columns}
      apiEndpoint="category/house_details"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="house"
    />
  );
};
export default HouseManagement;
