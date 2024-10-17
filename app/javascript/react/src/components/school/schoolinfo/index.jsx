import React, { useState } from "react";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import DataTable from "../../Datatable";

const validationSchema = Yup.object().shape({
  school_name: Yup.string().required("School name is required"),
  school_code: Yup.string().required("School code is required"),
  start_time: Yup.string().required("Start time is required"),
  end_time: Yup.string().required("End time is required"),
  // affiliated_to: Yup.string().required("Affiliated board is required"),
  reg_num: Yup.string().required("Registration number is required"),
  mobile_number: Yup.string().required("Mobile number is required"),
  email_id: Yup.string().email("Invalid email").required("Email is required"),
  address_line1: Yup.string().required("Address line 1 is required"),
  city: Yup.string().required("City is required"),
  state: Yup.string().required("State is required"),
  pin_code: Yup.string().required("Pincode is required"),
  country: Yup.string().required("Country is required"),
});

const SchoolInfo = ({ userData }) => {


  const columns = [
    { key: 'id', label: 'ID' },
    { key: 'name', label: 'Name' },
    { key: 'email', label: 'Email' },
    
  ];

  const data = [
    { id: 1, name: 'John Doe', email: 'john@example.com' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
    { id: 1, name: 'John Doe', email: 'john@example.com' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
    { id: 1, name: 'John Doe', email: 'john@example.com' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com' },

  ];
  const [schoolData, setSchoolData] = useState(userData[0]);

  const handleSubmit = (values, { setSubmitting }) => {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    console.log(token, "token");

    axios
      .patch(
        `/schools/${schoolData.id}`,
        { school: values },
        { headers: { "X-CSRF-Token": token } } // Add the CSRF token in the headers here
      )
      .then((response) => {
        console.log("School info updated successfully");
        setSchoolData(response.data);
        // Close the offcanvas after successful update
        const offcanvasElement = document.getElementById("editDrawer");
        const offcanvas = bootstrap.Offcanvas.getInstance(offcanvasElement);
        offcanvas.hide();
      })
      .catch((error) => {
        console.error("Error updating school info", error);
        // Handle errors, maybe show an alert to the user
      })

  };

  return (
    <div className="container mt-4">
      {schoolData && (
        <>
          <div className="row justify-content-between align-items-center mb-4">
            <div className="col-auto"></div>
            <div className="col-auto">
              <img
                src={
                  schoolData.logo_file_name || "https://via.placeholder.com/100"
                }
                alt="School Logo"
                className="img-fluid"
                style={{ maxWidth: "100px" }}
              />
            </div>
          </div>

          {/* School Details */}
          <div className="card mb-4">
            <div className="card-body">
              <h4 className="card-title mb-4">
                School Details{" "}
                <i
                  data-bs-toggle="offcanvas"
                  data-bs-target="#editDrawer"
                  aria-controls="editDrawer"
                  className="material-icons text-secondary position-relative text-lg mx-2"
                >
                  drive_file_rename_outline
                </i>
              </h4>

              <div className="row">
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">School Name</h6>
                  <p>{schoolData.school_name}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">School Code</h6>
                  <p>{schoolData.school_code}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Start Time</h6>
                  <p>{schoolData.start_time}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">End Time</h6>
                  <p>{schoolData.end_time}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Affiliated To</h6>
                  <p>{schoolData.affiliated_to}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Affiliated No./Reg. No.</h6>
                  <p>{schoolData.reg_num}</p>
                </div>
              </div>
            </div>
          </div>

          {/* Address Details */}
          <div className="card mb-4">
            <div className="card-body">
              <h4 className="card-title mb-4">
                Address Details{" "}
                <i
                  data-bs-toggle="offcanvas"
                  data-bs-target="#editDrawer"
                  aria-controls="editDrawer"
                  className="material-icons text-secondary position-relative text-lg mx-2"
                >
                  drive_file_rename_outline
                </i>
              </h4>
              <div className="row">
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Address Line 1</h6>
                  <p>{schoolData.address_line1}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Address Line 2</h6>
                  <p>{schoolData.address_line2}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Street</h6>
                  <p>{schoolData.street}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">City</h6>
                  <p>{schoolData.city}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">State</h6>
                  <p>{schoolData.state}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Pincode</h6>
                  <p>{schoolData.pin_code}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Landmark</h6>
                  <p>{schoolData.landmark}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Country</h6>
                  <p>{schoolData.country}</p>
                </div>
              </div>
            </div>
          </div>

          {/* Contact Details */}
          <div className="card mb-4">
            <div className="card-body">
              <h4 className="card-title mb-4">
                Contact Details{" "}
                <i
                  data-bs-toggle="offcanvas"
                  data-bs-target="#editDrawer"
                  aria-controls="editDrawer"
                  className="material-icons text-secondary position-relative text-lg mx-2"
                >
                  drive_file_rename_outline
                </i>
              </h4>
              <div className="row">
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Mobile Number</h6>
                  <p>{schoolData.mobile_number}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Email</h6>
                  <p>{schoolData.email_id}</p>
                </div>
                <div className="col-md-4 mb-3">
                  <h6 className="text-secondary">Fax Number</h6>
                  <p>{schoolData.fax_number}</p>
                </div>
              </div>
            </div>
          </div>

          {/* Offcanvas for Editing */}
          <div
            className="offcanvas offcanvas-end"
            tabIndex="-1"
            id="editDrawer"
            aria-labelledby="editDrawerLabel"
            style={{ width: "60%" }}
          >
            <div className="offcanvas-header">
              {/* <h5 className="offcanvas-title" id="editDrawerLabel">Update School Info</h5> */}
              <button
                type="button"
                className="btn-close"
                data-bs-dismiss="offcanvas"
                aria-label="Close"
              ></button>
            </div>
            <div className="offcanvas-body">
              <div className="card">
                <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                  <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
                    <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
                      Fill the School Info below
                    </h4>
                  </div>
                </div>
                <div className="card-body">
                  <Formik
                    initialValues={{
                      school_name: schoolData.school_name || "",
                      school_code: schoolData.school_code || "",
                      start_time: schoolData.start_time || "",
                      end_time: schoolData.end_time || "",
                      // affiliated_to: schoolData.affiliated_to || "",
                      reg_num: schoolData.reg_num || "",
                      mobile_number: schoolData.mobile_number || "",
                      email_id: schoolData.email_id || "",
                      address_line1: schoolData.address_line1 || "",
                      address_line2: schoolData.address_line2 || "",
                      street: schoolData.street || "",
                      city: schoolData.city || "",
                      state: schoolData.state || "",
                      pin_code: schoolData.pin_code || "",
                      landmark: schoolData.landmark || "",
                      country: schoolData.country || "",
                    }}
                    validationSchema={validationSchema}
                    onSubmit={handleSubmit}
                  >
                    {({ errors, touched, isSubmitting }) => (
                      <Form>
                        <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="schoolName">School Name</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="school_name"
                                className={`form-control ${
                                  touched.school_name && errors.school_name
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="School Name"
                              />
                              <ErrorMessage
                                name="school_name"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="schoolCode">School Code</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="school_code"
                                className={`form-control ${
                                  touched.school_code && errors.school_code
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="School Code"
                              />
                              <ErrorMessage
                                name="school_code"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div>

                        <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="startTime">Start Time</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="start_time"
                                type="time"
                                className={`form-control ${
                                  touched.start_time && errors.start_time
                                    ? "is-invalid"
                                    : ""
                                }`}
                              />
                              <ErrorMessage
                                name="start_time"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="endTime">End Time</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="end_time"
                                type="time"
                                className={`form-control ${
                                  touched.end_time && errors.end_time
                                    ? "is-invalid"
                                    : ""
                                }`}
                              />
                              <ErrorMessage
                                name="end_time"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div>
                        {/* <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="affiliatedTo">Affiliated To</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="affiliated_to"
                                className={`form-control ${
                                  touched.affiliated_to && errors.affiliated_to
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Affiliated To"
                              />
                              <ErrorMessage
                                name="affiliated_to"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="regNum">Registration Number</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="reg_num"
                                className={`form-control ${
                                  touched.reg_num && errors.reg_num
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Registration Number"
                              />
                              <ErrorMessage
                                name="reg_num"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div> */}

                        <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="mobileNumber">Mobile Number</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="mobile_number"
                                className={`form-control ${
                                  touched.mobile_number && errors.mobile_number
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Mobile Number"
                              />
                              <ErrorMessage
                                name="mobile_number"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="email">Email</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="email_id"
                                type="email"
                                className={`form-control ${
                                  touched.email_id && errors.email_id
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Email"
                              />
                              <ErrorMessage
                                name="email_id"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div>

                        <label htmlFor="addressLine1">Address Line 1</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="address_line1"
                            className={`form-control ${
                              touched.address_line1 && errors.address_line1
                                ? "is-invalid"
                                : ""
                            }`}
                            placeholder="Address Line 1"
                          />
                          <ErrorMessage
                            name="address_line1"
                            component="div"
                            className="invalid-feedback"
                          />
                        </div>

                        <label htmlFor="addressLine2">
                          Address Line 2 (Optional)
                        </label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="address_line2"
                            className="form-control"
                            placeholder="Address Line 2 (Optional)"
                          />
                        </div>

                        <label htmlFor="street">Street (Optional)</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="street"
                            className="form-control"
                            placeholder="Street (Optional)"
                          />
                        </div>

                        <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="city">City</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="city"
                                className={`form-control ${
                                  touched.city && errors.city
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="City"
                              />
                              <ErrorMessage
                                name="city"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="state">State</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="state"
                                className={`form-control ${
                                  touched.state && errors.state
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="State"
                              />
                              <ErrorMessage
                                name="state"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div>

                        <div className="row">
                          <div className="col-md-6">
                            <label htmlFor="pinCode">Pincode</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="pin_code"
                                className={`form-control ${
                                  touched.pin_code && errors.pin_code
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Pincode"
                              />
                              <ErrorMessage
                                name="pin_code"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>

                          <div className="col-md-6">
                            <label htmlFor="country">Country</label>
                            <div className="input-group input-group-outline my-1">
                              <Field
                                name="country"
                                className={`form-control ${
                                  touched.country && errors.country
                                    ? "is-invalid"
                                    : ""
                                }`}
                                placeholder="Country"
                              />
                              <ErrorMessage
                                name="country"
                                component="div"
                                className="invalid-feedback"
                              />
                            </div>
                          </div>
                        </div>

                        <label htmlFor="landmark">Landmark (Optional)</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="landmark"
                            className="form-control"
                            placeholder="Landmark (Optional)"
                          />
                        </div>
                        <div className="row">
                          <div className="col-md-12 d-flex justify-content-end">
                            <button
                              type="submit"
                              className="btn btn-info my-4"
                              disabled={isSubmitting}
                            >
                              {isSubmitting ? "Updating..." : "Update"}
                            </button>
                          </div>
                        </div>
                      </Form>
                    )}
                  </Formik>
                </div>
              </div>
            </div>
          </div>
        </>
      )}


<DataTable columns={columns} data={data} />

    </div>
  );
};

export default SchoolInfo;
