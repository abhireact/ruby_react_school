import React from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";
const GreetingMessageManagement = ({ userData }) => {
  console.log( userData,"userrdata in AcM");
  const columns = [
      { key: "start_time", label: "Start Time" },
      { key: "end_time", label: "End Time" },
      { key: "message", label: "Message" },
  ];

  const validationSchema = Yup.object({
    message: Yup.string().required("Required"),
    start_time: Yup.date().required("Required"),
    end_time: Yup.date()
      .required("Required")
      .min(Yup.ref("start_time"), "End date must be after start date"),
  });

  const formFields = [
      { name: "start_time", label: "Start Date", type: "date" },
      { name: "end_time", label: "End Date", type: "date" },
      { name: "message", label: "Message", type: "text" },
  ];

  return (
    <GenericCRUD
      title="Greeting Message"
      description="Manage Greeting Message, their start time, and end time."
      initialData={userData}
      columns={columns}
      apiEndpoint="greeting"
      validationSchema={validationSchema}
      formFields={formFields}
    />
  );
};
export default GreetingMessageManagement;
