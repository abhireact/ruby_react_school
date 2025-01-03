import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const CategoryManagement = ({ userData }) => {
  console.log(userData, "userrdata in wings");
  const columns = [
    { key: "name", label: "Category Name" },
    { key: "description", label: "Description" },
  ];

  const validationSchema = Yup.object({
    name: Yup.string().required("Required"),
  });

  const formFields = [
    { name: "name", label: "Category Name", type: "text" },
    { name: "description", label: "Description", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Category Management"
      description="Manage Category ."
      initialData={userData}
      columns={columns}
      apiEndpoint="category/castecategory"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="category"
      needinbuilticon={true}
    />
  );
};
export default CategoryManagement;
