import React from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";
const WingManagement = ({ userData }) => {
  console.log(typeof userData,"userrdata in wings");
  const columns = [
    { key: "wing_name", label: "Wing Name" },
  ];

  const validationSchema = Yup.object({
    wing_name : Yup.string().required("Required"),
    
  });

  const formFields = [
    { name : "wing_name", label: "Wing Name", type: "text" },
    
  ];

  return (
    <GenericCRUD
      title="Wings Management"
      description="Manage Wings ."
      initialData={userData}
      columns={columns}
      apiEndpoint="wings"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};
export default WingManagement;
