import React from "react";
import GenericCRUD from "../../genericCrud";
import * as Yup from "yup";
import { Settings } from "lucide-react";

const AddmissionDates = ({ userData }) => {
  console.log(userData, "data");

  const timeTableOptions = userData?.academic_year?.map((item) => ({
    value: item.id,
    label: item.name,
  }));
  console.log(timeTableOptions, "time table ");

  const handleManage = (item) => {
    // Handle manage action
    console.log("Manage", item);

window.location.href =`/mg_admission_settings/admission_setting_detail/${item?.id}`

    // Add your custom logic here, e.g., navigate to a management page
  };

  const additionalActions = [
    {
      icon: <Settings size={18} />,
      onClick: handleManage,
    },
    
  ];

  const columns = [
    { key: "mg_time_table_id", label: "Academic Year" },
    { key: "start_date", label: "Start Date" },
    { key: "end_date", label: "End Date" },
  ];

  const validationSchema = Yup.object({
    // mg_time_table_id: Yup.string().required("Required"),
    start_date: Yup.string().required("Required"),
  });

  const formFields = [
    {
      name: "mg_time_table_id",
      label: "Academic Year",
      fieldType: "autocomplete",
      options: timeTableOptions,
    },
    { name: "start_date", label: "Start Date", type: "date" },
    { name: "end_date", label: "End Date", type: "date" },
  ];

  return (
    <GenericCRUD
      title="Addmission Dates "
      description="manage addmission dates"
      initialData={userData?.admission_array}
      columns={columns}
      apiEndpoint="addmissions"
      validationSchema={validationSchema}
      formFields={formFields}
      needinbuilticon={true}
      additionalActions={additionalActions}
    />
  );
};

export default AddmissionDates;
