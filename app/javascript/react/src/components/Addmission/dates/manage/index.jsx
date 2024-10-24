import React, { useState } from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { useParams } from "react-router-dom";

const validationSchema = Yup.object().shape({
  maximum_form_per_day: Yup.number()
    .required("Maximum forms per day is required")
    .min(1, "Must be at least 1"),
  maximum_form: Yup.number()
    .required("Maximum total forms is required")
    .min(1, "Must be at least 1"),
  start_date: Yup.string().required("Date for calculating age is required"),
  min_age_year: Yup.number()
    .required("Minimum age year is required")
    .min(0, "Must be positive"),
  max_age_year: Yup.number()
    .required("Maximum age year is required")
    .min(0, "Must be positive"),
  amount: Yup.number()
    .required("Amount is required")
    .min(0, "Must be positive"),
});

const ManageAdmissionSettings = ({ userData }) => {
  console.log(userData, "data");
  const { id } = useParams(); // This will capture '13' from the URL

  console.log(id, "idddddddddddddddd");
  const classData = userData?.setting_detail;

  const [selectedClasses, setSelectedClasses] = useState(
    classData.map((cls) => ({ ...cls, isSelected: false }))
  );
  const handleSubmit = async (values, { setSubmitting, resetForm }) => {
    try {
      // Get CSRF token from meta tag
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      // Filter only selected classes
      const selectedData = values.classes.filter(
        (_, index) => selectedClasses[index].isSelected
      );

      // If no classes are selected, show an alert
      if (selectedData.length === 0) {
        alert("Please select at least one class to update");
        setSubmitting(false);
        return;
      }

      // Transform data into required format
      const transformedData = selectedData.reduce((acc, classItem) => {
        // Add course ID to the courses array if it doesn't exist
        if (!acc.course) {
          acc.course = [];
        }
        acc.course.push(classItem.mg_course_id.toString());

        // Format date to DD/MM/YYYY if needed
        const formatDate = (dateString) => {
          if (!dateString) return "";
          const date = new Date(dateString);
          return `${date.getDate().toString().padStart(2, "0")}/${(
            date.getMonth() + 1
          )
            .toString()
            .padStart(2, "0")}/${date.getFullYear()}`;
        };

        // Add all fields with course ID suffix
        const courseId = classItem.mg_course_id.toString();

        // Add individual fields
        acc[`maximum_form_per_day-${courseId}`] =
          classItem.maximum_form_per_day.toString();
        acc[`maximum_form-${courseId}`] = classItem.maximum_form.toString();
        acc[`start_date-${courseId}`] = formatDate(classItem.start_date);
        acc[`from_year-${courseId}`] = classItem.from_year.toString();
        acc[`to_year-${courseId}`] = classItem.to_year.toString();
        acc[`from_month-${courseId}`] = classItem.from_month.toString();
        acc[`to_month-${courseId}`] = classItem.to_month.toString();
        acc[`from_day-${courseId}`] = classItem.from_day.toString();
        acc[`to_day-${courseId}`] = classItem.to_day.toString();
        acc[`amount-${courseId}`] = classItem.amount.toString();
        acc[`status-${courseId}`] = classItem.status;
        return acc;
      }, {});

      // Include mg_admission_setting_detail in transformedData
      transformedData.mg_admission_setting_detail = {
        admission_setting_id: userData.id, // Assuming userData.id is available
      };

      // Make the API request using axios
      const response = await axios({
        method: "post",
        url: "/mg_admission_settings/admission_setting_detail_create",
        data: transformedData,
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
      });

      console.log("Settings updated successfully", response.data);
      alert("Settings updated successfully");

      // Reset selection and form
      setSelectedClasses((prev) =>
        prev.map((cls) => ({ ...cls, isSelected: false }))
      );
      resetForm();
    } catch (error) {
      console.error("Error updating settings:", error);
      alert(
        "Failed to update settings: " +
          (error.response?.data?.message || error.message)
      );
    } finally {
      setSubmitting(false);
    }
  };

  const handleSelectAll = (isSelectAll) => {
    setSelectedClasses((prevClasses) =>
      prevClasses.map((cls) => ({ ...cls, isSelected: isSelectAll }))
    );
  };

  return (
    <div className="container-fluid p-4">
      <div className="card">
        <div className="card-header bg-gradient-info p-0 position-relative mt-n4 mx-3 z-index-2">
          <div className="py-3 px-3">
            <div className="d-flex justify-content-between align-items-center">
              <h5 className="text-white font-weight-bolder mb-0">
                Manage Admission Settings
              </h5>
              <div className="btn-group">
                <button
                  className="btn btn-light btn-sm me-2"
                  onClick={() => handleSelectAll(true)}
                >
                  Select All
                </button>
                <button
                  className="btn btn-light btn-sm"
                  onClick={() => handleSelectAll(false)}
                >
                  Clear Selection
                </button>
              </div>
            </div>
          </div>
        </div>

        <div className="card-body">
          <Formik
            initialValues={{
              classes: selectedClasses.map((cls) => ({
                mg_course_id: cls.mg_course_id,
                maximum_form_per_day: cls.maximum_form_per_day,
                maximum_form: cls.maximum_form,
                start_date: cls.start_date,
                from_year: cls.from_year,
                to_year: cls.to_year,
                from_month: cls.from_month,
                to_month: cls.to_month,
                from_day: cls.from_day,
                to_day: cls.to_day,
                amount: cls.amount,
                status: cls.status,
              })),
            }}
            // validationSchema={validationSchema}
            onSubmit={handleSubmit}
            enableReinitialize={true}
          >
            {({ values, handleChange, errors, touched }) => (
              <Form>
                <div className="table-responsive">
                  <table className="table table-bordered table-hover">
                    <thead className="table-light">
                      <tr>
                        <th className="text-center" style={{ width: "50px" }}>
                          Select
                        </th>
                        <th>Class Name</th>
                        {/* <th style={{ width: "200px" }}>Form Limits</th> */}
                        <th style={{ width: "200px" }}>
                          Form Limits
                          <div
                            className="d-flex justify-content-between mt-2"
                            style={{ fontSize: "0.9em" }}
                          >
                            <div
                              style={{ width: "45%" }}
                              className="text-center"
                            >
                              Daily
                            </div>
                            <div
                              style={{ width: "45%" }}
                              className="text-center"
                            >
                              Total
                            </div>
                          </div>
                        </th>
                        <th style={{ width: "200px" }}>Age Calculation Date</th>
                        <th style={{ width: "200px" }}>
                          Age Requirements for Admission
                          <div
                            className="d-flex justify-content-between mt-2"
                            style={{ fontSize: "0.9em" }}
                          >
                            <div
                              style={{ width: "45%" }}
                              className="text-center"
                            >
                              Minimum (Y-M-D)
                            </div>
                            <div
                              style={{ width: "45%" }}
                              className="text-center"
                            >
                              Maximum (Y-M-D)
                            </div>
                          </div>
                        </th>
                        <th style={{ width: "120px" }}>Amount</th>
                        <th style={{ width: "120px" }}>Status</th>
                      </tr>
                    </thead>

                    <tbody>
                      {selectedClasses.map((cls, index) => (
                        <tr key={cls.id}>
                          <td className="text-center align-middle">
                            <div className="form-check d-flex justify-content-center">
                              <input
                                type="checkbox"
                                className="form-check-input border border-info"
                                checked={cls.isSelected}
                                onChange={(e) => {
                                  const newClasses = [...selectedClasses];
                                  newClasses[index].isSelected =
                                    e.target.checked;
                                  setSelectedClasses(newClasses);
                                }}
                                style={{
                                  "&:checked": {
                                    backgroundColor: "#0dcaf0",
                                    borderColor: "#0dcaf0",
                                  },
                                }}
                              />
                            </div>
                          </td>
                          <td className="align-middle">
                            <strong>{cls.mg_course_id}</strong>
                          </td>
                          <td className="text-center align-middle">
                            <div className="d-flex gap-2  justify-content-center">
                              <input
                                type="number"
                                name={`classes[${index}].maximum_form_per_day`}
                                value={
                                  values.classes[index].maximum_form_per_day
                                }
                                onChange={handleChange}
                                className={`form-control form-control-sm border ${
                                  touched.classes?.[index]
                                    ?.maximum_form_per_day &&
                                  errors.classes?.[index]?.maximum_form_per_day
                                    ? "is-invalid border-danger"
                                    : "border-gray-300"
                                }`}
                                placeholder="Daily"
                              />
                              <input
                                type="number"
                                name={`classes[${index}].maximum_form`}
                                value={values.classes[index].maximum_form}
                                onChange={handleChange}
                                className={`form-control form-control-sm border ${
                                  touched.classes?.[index]?.maximum_form &&
                                  errors.classes?.[index]?.maximum_form
                                    ? "is-invalid border-danger"
                                    : "border-gray-300"
                                }`}
                                placeholder="Total"
                              />
                            </div>
                          </td>
                          <td className="text-center align-middle">
                            <input
                              type="date"
                              name={`classes[${index}].start_date`}
                              value={values.classes[index].start_date}
                              onChange={handleChange}
                              className={`form-control form-control-sm border ${
                                touched.classes?.[index]?.start_date &&
                                errors.classes?.[index]?.start_date
                                  ? "is-invalid border-danger"
                                  : "border-gray-300"
                              }`}
                            />
                          </td>
                          <td className="text-center align-middle">
                            {/* <div
                              className="d-flex justify-content-between"
                              style={{ gap: "20px" }}
                            >
                              <label>Minimum</label>
                              <label>Maximum</label>
                            </div> */}

                            <div className="d-flex gap-3 align-items-start">
                              {/* Minimum Age Fields */}
                              <div className="d-flex flex-row">
                                <input
                                  type="number"
                                  name={`classes[${index}].from_year`}
                                  value={values.classes[index].from_year}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.from_year &&
                                    errors.classes?.[index]?.from_year
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="Y"
                                />
                                <input
                                  type="number"
                                  name={`classes[${index}].from_month`}
                                  value={values.classes[index].from_month}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.from_month &&
                                    errors.classes?.[index]?.from_month
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="M"
                                />
                                <input
                                  type="number"
                                  name={`classes[${index}].from_day`}
                                  value={values.classes[index].from_day}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.from_day &&
                                    errors.classes?.[index]?.from_day
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="D"
                                />
                              </div>

                              {/* Vertical Divider */}
                              <div
                                className="vertical-divider"
                                style={{
                                  borderLeft: "1px solid #000",
                                  height: "100%",
                                  margin: "0 5px",
                                }}
                              ></div>

                              {/* Maximum Age Fields */}
                              <div className="d-flex flex-row">
                                <input
                                  type="number"
                                  name={`classes[${index}].to_year`}
                                  value={values.classes[index].to_year}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.to_year &&
                                    errors.classes?.[index]?.to_year
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="Y"
                                />
                                <input
                                  type="number"
                                  name={`classes[${index}].to_month`}
                                  value={values.classes[index].to_month}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.to_month &&
                                    errors.classes?.[index]?.to_month
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="M"
                                />
                                <input
                                  type="number"
                                  name={`classes[${index}].to_day`}
                                  value={values.classes[index].to_day}
                                  onChange={handleChange}
                                  className={`form-control form-control-sm border ${
                                    touched.classes?.[index]?.to_day &&
                                    errors.classes?.[index]?.to_day
                                      ? "is-invalid border-danger"
                                      : "border-gray-300"
                                  }`}
                                  placeholder="D"
                                />
                              </div>
                            </div>
                          </td>

                          <td className="text-center align-middle">
                            <input
                              type="number"
                              name={`classes[${index}].amount`}
                              value={values.classes[index].amount}
                              onChange={handleChange}
                              className={`form-control form-control-sm border ${
                                touched.classes?.[index]?.amount &&
                                errors.classes?.[index]?.amount
                                  ? "is-invalid border-danger"
                                  : "border-gray-300"
                              }`}
                              placeholder="Amount"
                            />
                          </td>
                          <td className="text-center align-middle">
                            <select
                              name={`classes[${index}].status`}
                              value={values.classes[index].status}
                              onChange={handleChange}
                              className={`form-select form-select-sm border border-gray-300 ${
                                values.classes[index].status === "Active"
                                  ? "text-success"
                                  : "text-danger"
                              }`}
                            >
                              <option value="Active">Active</option>
                              <option value="Inactive">Inactive</option>
                            </select>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                <div  className="mt-3 d-flex gap-3 align-items-end justify-content-end">
                  {" "}
                  <button type="submit" className="btn btn-dark">
                    back
                  </button>
                  <button type="submit" className="btn btn-info">
                    Save
                  </button>
                </div>
              </Form>
            )}
          </Formik>
        </div>
      </div>
    </div>
  );
};

export default ManageAdmissionSettings;
