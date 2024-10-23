import React from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";

const validationSchema = Yup.object().shape({
  admissionDate: Yup.date().required("Admission date is required"),
  admissionNumber: Yup.string().required("Admission number is required"),
  feeCode: Yup.string().required("Fee code is required"),
  firstName: Yup.string().required("First name is required"),
  lastName: Yup.string().required("Last name is required"),
  academicYear: Yup.string().required("Academic year is required"),
  class: Yup.string().required("Class is required"),
  section: Yup.string().required("Section is required"),
  dateOfBirth: Yup.date().required("Date of birth is required"),
  gender: Yup.string().required("Gender is required"),
  mobileNumber: Yup.string().required("Mobile number is required"),
  email: Yup.string().email("Invalid email").required("Email is required"),
});

const CreateStudent = () => {
  const initialValues = {
    admissionDate: "",
    admissionNumber: "",
    feeCode: "",
    firstName: "",
    middleName: "",
    lastName: "",
    academicYear: "",
    class: "",
    section: "",
    dateOfBirth: "",
    birthPlace: "",
    bloodGroup: "",
    aadharNumber: "",
    motherTongue: "",
    hobby: "",
    religion: "",
    caste: "",
    casteCategory: "",
    studentCategory: "",
    houseDetails: "",
    penNumber: "",
    gender: "",
    studentImage: null,
    siblingName: "",
    siblingClass: "",
    siblingSection: "",
    siblingRelation: "",
    siblingRollNumber: "",
    dateOfAdmission: "",
    siblingAdmissionNumber: "",
    mobileNumber: "",
    alternateNumber: "",
    email: "",
  };

  const handleSubmit = (values, { setSubmitting }) => {
    // Handle form submission here
    console.log(values);
    setSubmitting(false);
  };

  return (
    <div className="container mt-5">
      <Formik
        initialValues={initialValues}
        validationSchema={validationSchema}
        onSubmit={handleSubmit}
      >
        {({ isSubmitting, setFieldValue }) => (
          <Form>
            <div className="card mb-4">
              <div className="card-body">
                <h4 className="mb-4">Student Details</h4>
                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="schoolCode">Admission Date</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="date"
                        name="school_code"
                        className="form-control"
                        placeholder="School Code"
                      />
                      <ErrorMessage
                        name="school_code"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="admissionNumber">Admission Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="admissionNumber"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="admissionNumber"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="feeCode">Fee Code</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="feeCode"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="feeCode"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="firstName">First Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="firstName"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="firstName"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="middleName">Middle Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="middleName"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="lastName">Last Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="lastName"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="lastName"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="academicYear">Academic Year</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="academicYear"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="academicYear"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="class">Class</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="class"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="class"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="section">Section</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="section"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="section"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="dateOfBirth">Date of Birth</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="date"
                        name="dateOfBirth"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="dateOfBirth"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="birthPlace">Birth Place</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="birthPlace"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="bloodGroup">Blood Group</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="bloodGroup"
                        className="form-control"
                      />
                    </div>
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="aadharNumber">Aadhar Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="aadharNumber"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="motherTongue">Mother Tongue</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="motherTongue"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="hobby">Hobby</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="hobby"
                        className="form-control"
                      />
                    </div>
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="religion">Religion</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="religion"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="caste">Caste</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="caste"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="casteCategory">Caste Category</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="casteCategory"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="studentCategory">Student Category</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="studentCategory"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="houseDetails">House Details</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="houseDetails"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="penNumber">PEN Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="penNumber"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="gender">Gender</label>
                    <div className="input-group input-group-outline my-1">
                      <Field as="select" name="gender" className="form-control">
                        <option value="">Select Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="other">Other</option>
                      </Field>
                    </div>
                    <ErrorMessage
                      name="gender"
                      component="div"
                      className="text-danger"
                    />
                  </div>

                  <div className="col-md-4 mb-3">
                    <label htmlFor="studentImage">Upload Student Image</label>
                    <div className="input-group input-group-outline my-1">
                      <input
                        type="file"
                        name="studentImage"
                        onChange={(event) => {
                          setFieldValue(
                            "studentImage",
                            event.currentTarget.files[0]
                          );
                        }}
                        className="form-control"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div className="card mb-4">
              <div className="card-body">
                <h4 className="mt-2 mb-3">Sibling Information</h4>
                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingName">Sibling Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingName"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingClass">Class</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingClass"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingSection">Section</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingSection"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="date_of_admission">Date of Admission</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="date"
                        name="siblingSection"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingRelation">Relation</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingRelation"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingRollNumber">Roll Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingRollNumber"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="siblingAdmissionNumber">
                      Admission Number
                    </label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="siblingAdmissionNumber"
                        className="form-control"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="card mb-4">
              <div className="card-body">
                <h4 className="mt-2 mb-3">Contact Details</h4>
                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="mobileNumber">Mobile Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="mobileNumber"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="mobileNumber"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="alternateNumber">Alternate Number</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="alternateNumber"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="email">Email ID</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="email"
                        name="email"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="email"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="card mb-4">
              <div className="card-body">
                <h4 className="mt-2 mb-3">Previous Education</h4>
                <div className="row">
                  <div className="col-md-4 mb-3">
                    <label htmlFor="mobileNumber">School Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="school_name"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="school_name"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="alternateNumber">Class</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="text"
                        name="class"
                        className="form-control"
                      />
                    </div>
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="email">Year</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="email"
                        name="year"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="year"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="email">Marks Obtained</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="email"
                        name="marks_obtained"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="marks_obtained"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="email">Total Marks</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="email"
                        name="total_marks"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="total_marks"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                  <div className="col-md-4 mb-3">
                    <label htmlFor="email">Percentage</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="email"
                        name="percentage"
                        className="form-control"
                      />
                    </div>
                    <ErrorMessage
                      name="percentage"
                      component="div"
                      className="text-danger"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-4 d-flex justify-content-between">
              <a href="/students" className="btn btn-dark me-2">
                Back
              </a>

              <button
                type="submit"
                className="btn btn-info"
                disabled={isSubmitting}
              >
                {isSubmitting ? "Submitting..." : "Save"}
              </button>
            </div>
          </Form>
        )}
      </Formik>
    </div>
  );
};

export default CreateStudent;
