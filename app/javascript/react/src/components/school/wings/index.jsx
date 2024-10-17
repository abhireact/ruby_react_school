import React, { useEffect } from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";
import { useSelector } from "react-redux";
const WingManagement = ({ userData }) => {
  const { academicYear, classData, sectionData, wingsData } = useSelector((state) => ({
    academicYear: state.academicYear,
    classData: state.classData,
    sectionData: state.sectionData,
    wingsData: state.wingsData,
  }));
  useEffect(() => {
    console.log("Redux state updated:", { academicYear, classData, sectionData, wingsData });
  }, [academicYear, classData, sectionData, wingsData]);
  console.log(typeof userData, "userrdata in wings");
  console.log(academicYear, classData, sectionData, wingsData, "redux-data");

  const columns = [{ key: "wing_name", label: "Wing Name" }];

  const validationSchema = Yup.object({
    wing_name: Yup.string().required("Required"),
  });

  const formFields = [{ name: "wing_name", label: "Wing Name", type: "text" }];

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
