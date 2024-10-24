import React, { useState, useEffect, useCallback } from "react";
import { Formik, Form } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Button } from "react-bootstrap";
import { useSelector } from "react-redux";
const SubjectArchiveManager = () => {
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
  const [selectedSection, setSelectedSection] = useState("");

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

      // Update class data based on response
      if (response.data.courses_batches) {
        setClasses(
          response.data.courses_batches.map((batch) => ({
            id: batch[1], // Course ID
            name: batch[0], // Course name
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

      // Only extract arrays that actually contain subjects
      if (Array.isArray(response.data)) {
        const flattenedSubjects = response.data
          .filter((item) => Array.isArray(item) && item.length > 0) // Filter out empty arrays
          .map((item) => item[0]) // Extract subject info from each array
          .map((subject) => ({
            name: subject[0], // Subject name
            id: subject[1], // Subject ID
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

      // Ensure you're sending the correct request structure
      await axios.post(
        "/subjects/subject_archive_create",
        {
          selectedemployees: values.selectedSubjects,
          // api_request: true, // Ensure this is included if backend expects it in body
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
          <p className="text-sm mb-0">
            Archive subjects by academic year and class section
          </p>
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
            }}
            validationSchema={validationSchema}
            onSubmit={handleFormSubmit}
          >
            {({ values, setFieldValue, errors, touched }) => (
              <Form className="mx-4">
                <div className="row mb-4">
                  <div className="col-md-6">
                    <div className="input-group input-group-outline">
                      <label className="form-label">Academic Year</label>
                      <select
                        className="form-control"
                        value={selectedAcademicYear}
                        onChange={(e) => {
                          setSelectedAcademicYear(e.target.value);
                          setSelectedClass("");
                          setSections([]);
                          setSubjects([]); // Clear subjects when academic year changes
                        }}
                      >
                        <option value="">Select Academic Year</option>
                        {academicYear.map((year) => (
                          <option key={year.id} value={year.id}>
                            {year.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="col-md-6">
                    <div className="input-group input-group-outline">
                      <label className="form-label">Class</label>
                      <select
                        className="form-control"
                        value={selectedClass}
                        onChange={(e) => {
                          setSelectedClass(e.target.value);
                          setSelectedSection("");
                          setSubjects([]); // Clear subjects when class changes
                        }}
                      >
                        <option value="">Select Class</option>
                        {classes.map((cls) => (
                          <option key={cls.id} value={cls.id}>
                            {cls.name}
                          </option>
                        ))}
                      </select>
                    </div>
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
                                ); // Map to get all subject IDs
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
                                {subject.name} {/* Display subject name */}
                              </label>
                            </div>
                          ))}
                          {errors.selectedSubjects &&
                            touched.selectedSubjects && (
                              <div className="text-danger">
                                {errors.selectedSubjects}
                              </div>
                            )}
                        </div>
                      </div>
                    </div>
                  )
                )}

                <div className="text-center">
                  <Button type="submit" variant="primary">
                    Archive Subjects
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
