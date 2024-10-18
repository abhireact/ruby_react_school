// import React from "react";
// import GenericCRUD from "../../genericCrud";
// import * as Yup from "yup";
// const WingManagement = ({ userData }) => {
//   console.log(typeof userData,"userrdata in wings");
//   const columns = [
//     { key: "wing_name", label: "Wing Name" },
//   ];

//   const validationSchema = Yup.object({
//     wing_name : Yup.string().required("Required"),

//   });

//   const formFields = [
//     { name : "wing_name", label: "Wing Name", type: "text" },

//   ];

//   return (
//     <GenericCRUD
//       title="Wings Management"
//       description="Manage Wings ."
//       initialData={userData}
//       columns={columns}
//       apiEndpoint="wings"
//       validationSchema={validationSchema}
//       formFields={formFields}
//     />
//   );
// };
// export default WingManagement;

import React from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";

const WingManagement = ({ userData }) => {
  const columns = [
    { key: "wing_name", label: "Wing Name" },
    { key: "wing_type", label: "Wing Type" },
    { key: "is_active", label: "Status" },
  ];

  const validationSchema = Yup.object({
    wing_name: Yup.string().required("Required"),
    wing_type: Yup.string().required("Required"),
    is_active: Yup.boolean(),
    preferred_location: Yup.string().required("Required"),
  });

  const formFields = [
    {
      name: "wing_name",
      label: "Wing Name",
      type: "text",
      fieldType: "input",
    },
    {
      name: "wing_type",
      label: "Wing Type",
      fieldType: "select",
      options: [
        { value: "academic", label: "Academic" },
        { value: "administrative", label: "Administrative" },
      ],
    },
    {
      name: "wing_type",
      label: "Wing Type",
      fieldType: "radio",
      options: [
        { value: "academic", label: "Academic" },
        { value: "administrative", label: "Administrative" },
      ],
    },
    {
      name: "is_active",
      label: "Active Status",
      fieldType: "checkbox",
    },
    {
      name: "preferred_location",
      label: "Preferred Location",
      fieldType: "autocomplete",
      options: [
        { value: "building_a", label: "Building A" },
        { value: "building_b", label: "Building B" },
        { value: "building_c", label: "Building C" },
      ],
    },
  ];

  return (
    <GenericCRUD
      title="Wings Management"
      description="Manage Wings"
      initialData={userData}
      columns={columns}
      apiEndpoint="wings"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};

export default WingManagement;
