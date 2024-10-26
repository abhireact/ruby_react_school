import React, { useState, useEffect, useCallback } from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Button } from "react-bootstrap";
import { useSelector } from "react-redux";
import CustomAutocomplete from "../Autocomplete";

const SubjectArchiveManager = ({ onBack }) => {
  const [items, setItems] = useState([]);
  const [classes, setClasses] = useState([]);
  const [sections, setSections] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const { academicYear, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear,
    sectionData: state.sectionData,
  }));

  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedClass, setSelectedClass] = useState("");

  // Convert academicYear array to options format for autocomplete
  const academicYearOptions = academicYear.map((year) => ({
    value: year.id,
    label: year.name,
  }));

  const fetchCoursesAndSections = useCallback(async () => {
    if (!selectedAcademicYear) return;

    try {
      setLoading(true);
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const response = await axios.get("/application/get_course", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          mg_time_table_id: selectedAcademicYear,
        },
      });

      if (response.data.courses_batches) {
        setClasses(
          response.data.courses_batches.map((batch) => ({
            value: batch[1],
            label: batch[0],
          }))
        );
      } else {
        setClasses([]);
      }
      setSections([]);
    } catch (error) {
      setErrorMessage("Failed to fetch classes and sections");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [selectedAcademicYear]);

  const fetchSubjects = useCallback(async () => {
    if (!selectedClass) return;

    try {
      setLoading(true);
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const response = await axios.get("/subjects/get_subject", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          department_id: selectedClass,
          api_request: true,
        },
      });

      if (Array.isArray(response.data)) {
        const flattenedSubjects = response.data
          .filter((item) => Array.isArray(item) && item.length > 0)
          .map((item) => item[0])
          .map((subject) => ({
            name: subject[0],
            id: subject[1],
          }));

        setSubjects(flattenedSubjects);
      } else {
        setSubjects([]);
      }
    } catch (error) {
      setErrorMessage("Failed to fetch subjects");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [selectedClass]);

  useEffect(() => {
    if (selectedAcademicYear) {
      fetchCoursesAndSections();
    }
  }, [selectedAcademicYear, fetchCoursesAndSections]);

  useEffect(() => {
    fetchSubjects();
  }, [selectedClass, fetchSubjects]);

  const handleFormSubmit = useCallback(async (values, { setSubmitting }) => {
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      await axios.post(
        "/subjects/subject_archive_create",
        {
          selectedemployees: values.selectedSubjects,
        },
        {
          headers: {
            "X-CSRF-Token": token,
            "Content-Type": "application/json",
          },
        }
      );

      window.location.href = "/subjects/archived_subject_list";
    } catch (error) {
      setErrorMessage("Failed to archive subjects");
      console.error(error);
    } finally {
      setSubmitting(false);
    }
  }, []);

  const validationSchema = Yup.object().shape({
    selectedSubjects: Yup.array().min(1, "Select at least one subject"),
  });

  return (
    <div className="container-fluid py-4">
      <div className="card">
        <div className="card-header pb-0">
          <h5 className="mb-0">Subject Archive Manager</h5>
          {/* <p className="text-sm mb-0">
            Archive subjects by academic year and class section
          </p> */}
        </div>
        <div className="card-body px-0 pb-0">
          {errorMessage && (
            <div className="alert alert-danger mx-4" role="alert">
              {errorMessage}
            </div>
          )}

          <Formik
            initialValues={{
              selectedSubjects: [],
              academicYear: "",
              class: "",
            }}
            validationSchema={validationSchema}
            onSubmit={handleFormSubmit}
          >
            {({ values, setFieldValue, errors, touched }) => (
              <Form className="mx-4">
                <div className="row mb-4">
                  <div className="col-md-6">
                    <label className="ms-0">Academic Year</label>
                    <CustomAutocomplete
                      field={{
                        name: "academicYear",
                        value: selectedAcademicYear,
                        onChange: () => {},
                      }}
                      form={{
                        setFieldValue: (name, value) => {
                          setSelectedAcademicYear(value);
                          setFieldValue(name, value);
                        },
                      }}
                      options={academicYearOptions}
                      label="Select Academic Year"
                      width="100%"
                      showClearButton={true}
                    />
                  </div>

                  <div className="col-md-6">
                    <label className="ms-0">Class</label>
                    <CustomAutocomplete
                      field={{
                        name: "class",
                        value: selectedClass,
                        onChange: () => {},
                      }}
                      form={{
                        setFieldValue: (name, value) => {
                          setSelectedClass(value);
                          setFieldValue(name, value);
                        },
                      }}
                      options={classes}
                      label="Select Class"
                      width="100%"
                      showClearButton={true}
                      disabled={!selectedAcademicYear}
                    />
                  </div>
                </div>

                {loading ? (
                  <div className="text-center py-4">Loading subjects...</div>
                ) : (
                  subjects.length > 0 && (
                    <div className="mb-4">
                      <div className="card">
                        <div className="card-header p-3">
                          <label className="inline-flex items-center">
                            <input
                              type="checkbox"
                              className="form-check-input"
                              onChange={(e) => {
                                const allItemIds = subjects.map(
                                  (subject) => subject.id
                                );
                                setFieldValue(
                                  "selectedSubjects",
                                  e.target.checked ? allItemIds : []
                                );
                              }}
                              checked={
                                values.selectedSubjects.length ===
                                subjects.length
                              }
                            />
                            <span className="ml-2">Select All Subjects</span>
                          </label>
                        </div>
                        <div className="card-body">
                          {subjects.map((subject) => (
                            <div key={subject.id} className="form-check">
                              <input
                                className="form-check-input"
                                type="checkbox"
                                id={`subject-${subject.id}`}
                                checked={values.selectedSubjects.includes(
                                  subject.id
                                )}
                                onChange={(e) => {
                                  const updatedSubjects = e.target.checked
                                    ? [...values.selectedSubjects, subject.id]
                                    : values.selectedSubjects.filter(
                                        (id) => id !== subject.id
                                      );
                                  setFieldValue(
                                    "selectedSubjects",
                                    updatedSubjects
                                  );
                                }}
                              />
                              <label
                                className="form-check-label"
                                htmlFor={`subject-${subject.id}`}
                              >
                                {subject.name}
                              </label>
                            </div>
                          ))}
                        </div>
                      </div>
                    </div>
                  )
                )}

                {errors.selectedSubjects && touched.selectedSubjects && (
                  <div className="text-danger">{errors.selectedSubjects}</div>
                )}

                <div className="text-center d-flex justify-content-between gap-3">
                  <Button
                    variant="secondary"
                    onClick={onBack}
                    className="btn btn-dark mt-2 mb-2"
                  >
                    Back
                  </Button>
                  <Button
                    type="submit"
                    className="btn btn-info mt-2 mb-2"
                    disabled={loading}
                  >
                    Archive Selected Subjects
                  </Button>
                </div>
              </Form>
            )}
          </Formik>
        </div>
      </div>
    </div>
  );
};

export default SubjectArchiveManager;
