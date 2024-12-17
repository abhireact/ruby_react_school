// import React, { useState, useMemo, useEffect } from "react";
// import { Formik, Form, Field } from "formik";
// import { Table } from "react-bootstrap";
// import { format, parse } from "date-fns";
// import { message } from 'antd';

// const ExamReportReleases = ({ userData }) => {
//   console.log(userData, "user data");
//   const [academicYearData] = useState(userData.academic_year_data || []);
//   const [wingData] = useState(userData.wings_data || []);
//   const [sectionClassData] = useState(userData.section_class || []);
//   const [examTableData, setExamTableData] = useState(userData.exam_report_data || []);

//   const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
//   const [selectedWing, setSelectedWing] = useState("");

//   const [bulkDates, setBulkDates] = useState({
//     report_date: "",
//     guardian_date: "",
//     school_reopen_date: "",
//   });

//   const [errors, setErrors] = useState({}); // Validation errors for Paid Fee %

//   const filteredExamData = useMemo(() => {
//     return examTableData.filter(
//       (exam) =>
//         (!selectedAcademicYear || exam.mg_time_table_id == selectedAcademicYear) &&
//         (!selectedWing ||
//           sectionClassData
//             .filter((section) => section.mg_wing_id == selectedWing)
//             .some((section) => section.mg_batch_id == exam.mg_batch_id))
//     );
//   }, [selectedAcademicYear, selectedWing, examTableData, sectionClassData]);
//   useEffect(() => {
//     // Reset examTableData to the initial state based on the selected filters
//     setExamTableData(
//       userData.exam_report_data.filter((exam) =>
//         (!selectedAcademicYear || exam.mg_time_table_id == selectedAcademicYear) &&
//         (!selectedWing ||
//           sectionClassData
//             .filter((section) => section.mg_wing_id == selectedWing)
//             .some((section) => section.mg_batch_id == exam.mg_batch_id))
//       )
//     );
//   }, [selectedAcademicYear, selectedWing, userData.exam_report_data, sectionClassData]);
  
//   useEffect(() => {
//     setExamTableData((prevData) =>
//       prevData.map((exam) =>
//         (!selectedAcademicYear || exam.mg_time_table_id === parseInt(selectedAcademicYear)) &&
//         (!selectedWing ||
//           sectionClassData
//             .filter((section) => section.mg_wing_id === parseInt(selectedWing))
//             .some((section) => section.mg_batch_id === exam.mg_batch_id))
//           ? {
//               ...exam,
//               release_date: bulkDates.report_date || exam.release_date,
//               due_date: bulkDates.report_date || exam.due_date,
//               guardian_release_date: bulkDates.guardian_date || exam.guardian_release_date,
//               school_reopen_date: bulkDates.school_reopen_date || exam.school_reopen_date,
//             }
//           : exam
//       )
//     );
//   }, [bulkDates, selectedAcademicYear, selectedWing, sectionClassData]);

//   const handleFieldChange = (examId, field, value) => {
//     setExamTableData((prevData) =>
//       prevData.map((exam) => (exam.id === examId ? { ...exam, [field]: value } : exam))
//     );

//     if (field === "paid_fee_amount_percentage") {
//       // Validate Paid Fee %
//       if (value < 1 || value > 100) {
//         setErrors((prev) => ({ ...prev, [examId]: "Paid Fee % must be between 1 and 100" }));
//       } else {
//         setErrors((prev) => {
//           const { [examId]: removed, ...rest } = prev; // Remove the error for this ID
//           return rest;
//         });
//       }
//     }
//   };
//   const handleBulkDateChange = (field, value) => {
//     setBulkDates((prev) => ({ ...prev, [field]: value }));
//   };

//   const handleSubmit = async () => {
//     if (Object.keys(errors).length > 0) {
//       message.error("Please fix the errors before submitting.");
//       return;
//     }
//     const token = document
//     .querySelector('meta[name="csrf-token"]')
//     .getAttribute("content");
//     try {
//       let payload = {
//         mg_time_table_id: Number(selectedAcademicYear),
//         reportData: filteredExamData.map((exam) => ({
//           batch_release_date: exam.release_date,
//           selected_batch: exam.mg_batch_id,
//           batch_guardian_release_date: exam.guardian_release_date,
//           batch_school_reopen_date: exam.school_reopen_date,
//           batch_due_date: exam.due_date,
//           batch_paid_fee_amount_percentage: exam.paid_fee_amount_percentage || "0",
//         })),
//       };

//       const response = await fetch("/exam_report_releases/exam_report_releases_data", {
//         method: "POST",
//         headers: {
//           "Content-Type": "application/json",
//           "X-CSRF-Token": token,
//         },
//         body: JSON.stringify(payload),
//       });
//       console.log(response,"repsonse")

//       if (response.status == 200) {
//         console.log("Table data successfully submitted.");
//        message.success("Table data successfully submitted");
//       } else {
//         console.error("Failed to submit data", response);
//         message.error("Failed to save changes. Please try again.");
//       }
//     } catch (error) {
//       console.error("An error occurred while saving changes. Please try again.");
//     }
//   };

//   const convertDateFormat = (dateString) => {
//     if (!dateString) return "";
//     // Parse the date and format it as dd/mm/yyyy
//     const parsedDate = parse(dateString, 'yyyy-MM-dd', new Date());
//     return format(parsedDate, 'dd/MM/yyyy');
//   };

//   const formatDateForInput = (dateString) => {
//     if (!dateString) return "";
//     return format(new Date(dateString), "yyyy-MM-dd");
//   };

//   return (
//     <div className="container mt-4">
//       <div className="card mb-4">
//         <div className="card-header pb-0">
//           <h5 className="my-2">Report Date</h5>
//           <Formik
//             initialValues={{
//               mg_time_table_id: "",
//               mg_wing_id: "",
//               report_date: "",
//               guardian_date: "",
//               school_reopen_date: "",
//             }}
//             onSubmit={(values) => {
//               setSelectedAcademicYear(values.mg_time_table_id);
//               setSelectedWing(values.mg_wing_id);
//               setBulkDates({
//                 report_date: values.report_date,
//                 guardian_date: values.guardian_date,
//                 school_reopen_date: values.school_reopen_date,
//               });
//             }}
//           >
//             {({ setFieldValue, values }) => (
//               <Form>
//                 <div className="row">
//                   <div className="col-md-4">
//                     <label>Academic Year</label>
//                     <div className="input-group input-group-outline my-3">
//                     <Field
//   as="select"
//   name="mg_time_table_id"
//   className="form-control"
//   onChange={(e) => {
//     setFieldValue("mg_time_table_id", e.target.value);
//     setFieldValue("mg_wing_id", "");
//     setSelectedAcademicYear(e.target.value);
//     setSelectedWing(""); // Clear selected wing
//     setBulkDates({
//       report_date: "",
//       guardian_date: "",
//       school_reopen_date: "",
//     }); // Clear bulk dates
//   }}
// >
//   <option value="">Select Academic Year</option>
//   {academicYearData.map((year) => (
//     <option key={year.id} value={year.id}>
//       {year.name}
//     </option>
//   ))}
// </Field>
//                     </div>
//                   </div>

//                   <div className="col-md-4">
//                     <label>Wing Name</label>
//                     <div className="input-group input-group-outline my-3">
//                     <Field
//   as="select"
//   name="mg_wing_id"
//   className="form-control"
//   onChange={(e) => {
//     setFieldValue("mg_wing_id", e.target.value);
//     setSelectedWing(e.target.value);
//     setBulkDates({
//       report_date: "",
//       guardian_date: "",
//       school_reopen_date: "",
//     }); // Clear bulk dates
//   }}
//   disabled={!values.mg_time_table_id}
// >
//   <option value="">Select Wing</option>
//   {wingData.map((item) => (
//     <option key={item.id} value={item.id}>
//       {item.wing_name}
//     </option>
//   ))}
// </Field>
//                     </div>
//                   </div>

//                   <div className="col-md-4">
//                     <label>Report Date</label>
//                     <div className="input-group input-group-outline my-3">
//                       <Field
//                         type="date"
//                         name="report_date"
//                         className="form-control"
//                         onChange={(e) => {
//                           setFieldValue("report_date", e.target.value);
//                           handleBulkDateChange("report_date", e.target.value);
//                         }}
//                       />
//                     </div>
//                   </div>
//                 </div>

//                 <div className="row">
//                   <div className="col-md-4">
//                     <label>Guardian Date</label>
//                     <div className="input-group input-group-outline my-3">
//                       <Field
//                         type="date"
//                         name="guardian_date"
//                         className="form-control"
//                         onChange={(e) => {
//                           setFieldValue("guardian_date", e.target.value);
//                           handleBulkDateChange("guardian_date", e.target.value);
//                         }}
//                       />
//                     </div>
//                   </div>
//                   <div className="col-md-4">
//                     <label>School Reopen Date</label>
//                     <div className="input-group input-group-outline my-3">
//                       <Field
//                         type="date"
//                         name="school_reopen_date"
//                         className="form-control"
//                         onChange={(e) => {
//                           setFieldValue("school_reopen_date", e.target.value);
//                           handleBulkDateChange("school_reopen_date", e.target.value);
//                         }}
//                       />
//                     </div>
//                   </div>
//                 </div>
//               </Form>
//             )}
//           </Formik>
//         </div>

//         <div className="card-body">
//           {filteredExamData.length > 0 && selectedWing && selectedAcademicYear && (
//             <div className="m-4">
//               <Table striped bordered hover responsive>
//                 <thead>
//                   <tr>
//                     <th>Class & Section</th>
//                     <th>Report Date</th>
//                     <th>School Reopen Date</th>
//                     <th>Due Date</th>
//                     <th>Guardian Release Date</th>
//                     <th>Paid Fee %</th>
//                   </tr>
//                 </thead>
//                 <tbody>
//   {filteredExamData.map((exam) => {
//     const matchedSection = sectionClassData.find(
//       (section) => section.mg_batch_id === exam.mg_batch_id
//     );

//     return (
//       <tr key={exam.id}>
//         <td>{matchedSection ? matchedSection.name : "N/A"}</td>
//         <td>
//           <input
//             type="date"
//             className="form-control"
//             style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
//             placeholder="Enter Report Date"
//             value={exam.release_date ? formatDateForInput(exam.release_date) : ""}
//             onChange={(e) => handleFieldChange(exam.id, "release_date", e.target.value)}
//           />
//         </td>
//         <td>
//           <input
//             type="date"
//             className="form-control"
//             style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
//             placeholder="Enter School Reopen Date"
//             value={exam.school_reopen_date ? formatDateForInput(exam.school_reopen_date) : ""}
//             onChange={(e) => handleFieldChange(exam.id, "school_reopen_date", e.target.value)}
//           />
//         </td>
//         <td>
//           <input
//             type="date"
//             className="form-control"
//             style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
//             placeholder="Enter Due Date"
//             value={exam.due_date ? formatDateForInput(exam.due_date) : ""}
//             onChange={(e) => handleFieldChange(exam.id, "due_date", e.target.value)}
//           />
//         </td>
//         <td>
//           <input
//             type="date"
//             className="form-control"
//             style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
//             placeholder="Enter Guardian Release Date"
//             value={exam.guardian_release_date ? formatDateForInput(exam.guardian_release_date) : ""}
//             onChange={(e) => handleFieldChange(exam.id, "guardian_release_date", e.target.value)}
//           />
//         </td>
//         <td>
//           <input
//             type="number"
//             className="form-control"
//             min="1" // Minimum value
//             max="100" // Maximum value
//             style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
//             placeholder="Enter Paid Fee %"
//             value={exam.paid_fee_amount_percentage || ""}
//             onChange={(e) => handleFieldChange(exam.id, "paid_fee_amount_percentage", e.target.value)}
//           />
//                {errors[exam.id] && <span className="text-danger">
//                             {errors[exam.id]}
//                           </span>}
//         </td>
//       </tr>
//     );
//   })}
// </tbody>

//               </Table>
//             </div>
//           )}

//           {filteredExamData.length === 0 && selectedWing && (
//             <div className="alert alert-info text-center">
//               No exam reports found for the selected wing and academic year.
//             </div>
//           )}

//           {filteredExamData.length > 0 && selectedAcademicYear && selectedWing && (
//             <div className="m-4 text-start">
//               <button className="btn btn-info" onClick={handleSubmit}>
//                 Submit
//               </button>
//             </div>
//           )}
//         </div>
//       </div>
//     </div>
//   );
// };

// export default ExamReportReleases;
import React, { useState, useMemo, useEffect } from "react";
import { Formik, Form, Field } from "formik";
import { Table } from "react-bootstrap";
import { DatePicker, message } from 'antd';
import dayjs from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat';

dayjs.extend(customParseFormat);

const dateFormatList = ['DD/MM/YYYY', 'DD/MM/YY', 'DD-MM-YYYY', 'DD-MM-YY'];

const ExamReportReleases = ({ userData }) => {
  console.log(userData, "user data");
  const [academicYearData] = useState(userData.academic_year_data || []);
  const [wingData] = useState(userData.wings_data || []);
  const [sectionClassData] = useState(userData.section_class || []);
  const [examTableData, setExamTableData] = useState(userData.exam_report_data || []);

  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedWing, setSelectedWing] = useState("");

  const [bulkDates, setBulkDates] = useState({
    report_date: null,
    guardian_date: null,
    school_reopen_date: null,
  });

  const [errors, setErrors] = useState({});

  const filteredExamData = useMemo(() => {
    return examTableData.filter(
      (exam) =>
        (!selectedAcademicYear || exam.mg_time_table_id == selectedAcademicYear) &&
        (!selectedWing ||
          sectionClassData
            .filter((section) => section.mg_wing_id == selectedWing)
            .some((section) => section.mg_batch_id == exam.mg_batch_id))
    );
  }, [selectedAcademicYear, selectedWing, examTableData, sectionClassData]);

  useEffect(() => {
    setExamTableData(
      userData.exam_report_data.filter((exam) =>
        (!selectedAcademicYear || exam.mg_time_table_id == selectedAcademicYear) &&
        (!selectedWing ||
          sectionClassData
            .filter((section) => section.mg_wing_id == selectedWing)
            .some((section) => section.mg_batch_id == exam.mg_batch_id))
      )
    );
  }, [selectedAcademicYear, selectedWing, userData.exam_report_data, sectionClassData]);
  
  useEffect(() => {
    setExamTableData((prevData) =>
      prevData.map((exam) =>
        (!selectedAcademicYear || exam.mg_time_table_id === parseInt(selectedAcademicYear)) &&
        (!selectedWing ||
          sectionClassData
            .filter((section) => section.mg_wing_id === parseInt(selectedWing))
            .some((section) => section.mg_batch_id === exam.mg_batch_id))
          ? {
              ...exam,
              release_date: bulkDates.report_date ? bulkDates.report_date.format('YYYY-MM-DD') : exam.release_date,
              due_date: bulkDates.report_date ? bulkDates.report_date.format('YYYY-MM-DD') : exam.due_date,
              guardian_release_date: bulkDates.guardian_date ? bulkDates.guardian_date.format('YYYY-MM-DD') : exam.guardian_release_date,
              school_reopen_date: bulkDates.school_reopen_date ? bulkDates.school_reopen_date.format('YYYY-MM-DD') : exam.school_reopen_date,
            }
          : exam
      )
    );
  }, [bulkDates, selectedAcademicYear, selectedWing, sectionClassData]);

  const handleFieldChange = (examId, field, value) => {
    // Check if the value is a date (only apply format for dates)
    if (field === "release_date" || field === "due_date" || field === "guardian_release_date" || field === "school_reopen_date") {
      value = value ? value.format('YYYY-MM-DD') : null; // Ensure value is in the correct format
    }
  
    setExamTableData((prevData) =>
      prevData.map((exam) => (exam.id === examId ? { ...exam, [field]: value } : exam))
    );
  
    // Special handling for the "paid_fee_amount_percentage" field
    if (field === "paid_fee_amount_percentage") {
      const numericValue = parseInt(value);
      if (isNaN(numericValue) || numericValue < 1 || numericValue > 100) {
        setErrors((prev) => ({ ...prev, [examId]: "Paid Fee % must be between 1 and 100" }));
      } else {
        setErrors((prev) => {
          const { [examId]: removed, ...rest } = prev;
          return rest;
        });
      }
    }
  };
  

  const handleBulkDateChange = (field, value) => {
    setBulkDates((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async () => {
    if (Object.keys(errors).length > 0) {
      message.error("Please fix the errors before submitting.");
      return;
    }
    const token = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");
    try {
      let payload = {
        mg_time_table_id: Number(selectedAcademicYear),
        reportData: filteredExamData.map((exam) => ({
          batch_release_date: exam.release_date,
          selected_batch: exam.mg_batch_id,
          batch_guardian_release_date: exam.guardian_release_date,
          batch_school_reopen_date: exam.school_reopen_date,
          batch_due_date: exam.due_date,
          batch_paid_fee_amount_percentage: exam.paid_fee_amount_percentage || "0",
        })),
      };

      const response = await fetch("/exam_report_releases/exam_report_releases_data", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify(payload),
      });
      console.log(response,"repsonse")

      if (response.status == 200) {
        console.log("Table data successfully submitted.");
       message.success("Table data successfully submitted");
      } else {
        console.error("Failed to submit data", response);
        message.error("Failed to save changes. Please try again.");
      }
    } catch (error) {
      console.error("An error occurred while saving changes. Please try again.");
    }
  };

  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <h5 className="my-2">Report Date</h5>
          <Formik
            initialValues={{
              mg_time_table_id: "",
              mg_wing_id: "",
              report_date: null,
              guardian_date: null,
              school_reopen_date: null,
            }}
            onSubmit={(values) => {
              setSelectedAcademicYear(values.mg_time_table_id);
              setSelectedWing(values.mg_wing_id);
              setBulkDates({
                report_date: values.report_date,
                guardian_date: values.guardian_date,
                school_reopen_date: values.school_reopen_date,
              });
            }}
          >
            {({ setFieldValue, values }) => (
              <Form>
                <div className="row">
                  <div className="col-md-4">
                    <label>Academic Year</label>
                    <div className="input-group input-group-outline my-3">
                      <Field
                        as="select"
                        name="mg_time_table_id"
                        className="form-control"
                        onChange={(e) => {
                          setFieldValue("mg_time_table_id", e.target.value);
                          setFieldValue("mg_wing_id", "");
                          setSelectedAcademicYear(e.target.value);
                          setSelectedWing("");
                          setBulkDates({
                            report_date: null,
                            guardian_date: null,
                            school_reopen_date: null,
                          });
                        }}
                      >
                        <option value="">Select Academic Year</option>
                        {academicYearData.map((year) => (
                          <option key={year.id} value={year.id}>
                            {year.name}
                          </option>
                        ))}
                      </Field>
                    </div>
                  </div>

                  <div className="col-md-4">
                    <label>Wing Name</label>
                    <div className="input-group input-group-outline my-3">
                      <Field
                        as="select"
                        name="mg_wing_id"
                        className="form-control"
                        onChange={(e) => {
                          setFieldValue("mg_wing_id", e.target.value);
                          setSelectedWing(e.target.value);
                          setBulkDates({
                            report_date: null,
                            guardian_date: null,
                            school_reopen_date: null,
                          });
                        }}
                        disabled={!values.mg_time_table_id}
                      >
                        <option value="">Select Wing</option>
                        {wingData.map((item) => (
                          <option key={item.id} value={item.id}>
                            {item.wing_name}
                          </option>
                        ))}
                      </Field>
                    </div>
                  </div>

                  <div className="col-md-4">
                    <label>Report Date</label>
                    <div className="input-group input-group-outline my-3">
                      <DatePicker
                        name="report_date"
                        format={dateFormatList}
                        onChange={(date) => {
                          setFieldValue("report_date", date);
                          handleBulkDateChange("report_date", date);
                        }}
                        style={{ width: '100%' }}
                      />
                    </div>
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4">
                    <label>Guardian Release Date</label>
                    <div className="input-group input-group-outline my-3">
                      <DatePicker
                        name="guardian_date"
                        format={dateFormatList}
                        onChange={(date) => {
                          setFieldValue("guardian_date", date);
                          handleBulkDateChange("guardian_date", date);
                        }}
                        style={{ width: '100%' }}
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>School Reopen Date</label>
                    <div className="input-group input-group-outline my-3">
                      <DatePicker
                        name="school_reopen_date"
                        format={dateFormatList}
                        onChange={(date) => {
                          setFieldValue("school_reopen_date", date);
                          handleBulkDateChange("school_reopen_date", date);
                        }}
                        style={{ width: '100%' }}
                      />
                    </div>
                  </div>
                </div>
              </Form>
            )}
          </Formik>
        </div>

        <div className="card-body">
          {filteredExamData.length > 0 && selectedWing && selectedAcademicYear && (
            <div className="m-4">
              <Table striped bordered hover responsive>
                <thead>
                <tr>
      <th style={{ fontSize: "12px", padding: "8px" }}>Class & Section</th>
      <th style={{ fontSize: "12px", padding: "8px" }}>Report Date</th>
      <th style={{ fontSize: "12px", padding: "8px" }}>School Reopen Date</th>
      <th style={{ fontSize: "12px", padding: "8px" }}>Due Date</th>
      <th style={{ fontSize: "12px", padding: "8px" }}>Guardian Release Date</th>
      <th style={{ fontSize: "12px", padding: "8px" }}>Paid Fee %</th>
    </tr>
                </thead>
                <tbody>
                  {filteredExamData.map((exam) => {
                    const matchedSection = sectionClassData.find(
                      (section) => section.mg_batch_id === exam.mg_batch_id
                    );

                    return (
                      <tr key={exam.id}>
                        <td>{matchedSection ? matchedSection.name : "N/A"}</td>
                        <td>
                          <DatePicker
                            style={{ width: '100%' }}
                            value={exam.release_date ? dayjs(exam.release_date, 'YYYY-MM-DD') : null}
                            format={dateFormatList}
                            onChange={(date) => handleFieldChange(exam.id, "release_date", date)}
                          />
                        </td>
                        <td>
                          <DatePicker
                            style={{ width: '100%' }}
                            value={exam.school_reopen_date ? dayjs(exam.school_reopen_date, 'YYYY-MM-DD') : null}
                            format={dateFormatList}
                            onChange={(date) => handleFieldChange(exam.id, "school_reopen_date", date)}
                          />
                        </td>
                        <td>
                          <DatePicker
                            style={{ width: '100%' }}
                            value={exam.due_date ? dayjs(exam.due_date, 'YYYY-MM-DD') : null}
                            format={dateFormatList}
                            onChange={(date) => handleFieldChange(exam.id, "due_date", date)}
                          />
                        </td>
                        <td>
                          <DatePicker
                            style={{ width: '100%' }}
                            value={exam.guardian_release_date ? dayjs(exam.guardian_release_date, 'YYYY-MM-DD') : null}
                            format={dateFormatList}
                            onChange={(date) => handleFieldChange(exam.id, "guardian_release_date", date)}
                          />
                        </td>
                        <td>
                        <input
  type="number"
  className="form-control"
  min="1"
  max="100"
  style={{ border: "1px solid #ccc", padding: "5px", background: "#f9f9f9" }}
  placeholder="Enter Paid Fee %"
  value={exam.paid_fee_amount_percentage || ""}
  onChange={(e) => handleFieldChange(exam.id, "paid_fee_amount_percentage", e.target.value)}
/>

                          {errors[exam.id] && <span className="text-danger">
                            {errors[exam.id]}
                          </span>}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </Table>
            </div>
          )}

          {filteredExamData.length === 0 && selectedWing && (
            <div className="alert alert-info text-center">
              No exam reports found for the selected wing and academic year.
            </div>
          )}

          {filteredExamData.length > 0 && selectedAcademicYear && selectedWing && (
            <div className="mx-4 mt-2 text-start">
              <button className="btn btn-info" onClick={handleSubmit}>
                Submit
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ExamReportReleases;