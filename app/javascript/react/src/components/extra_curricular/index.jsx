import React from "react";
import * as Yup from "yup";
import GenericCRUD from "../genericCrud";
const ExtraCurrIndex = ({ userData }) => {
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
      title="Extra Curricular Management"
      description="Manage Extra Curricular ."
      initialData={userData}
      columns={columns}
      apiEndpoint="category/extra_curricular_index"
      validationSchema={validationSchema}
      formFields={formFields}
      payloadKey="mg_extra_curricular"
      needinbuilticon={true}
    />
  );
};
export default ExtraCurrIndex;
