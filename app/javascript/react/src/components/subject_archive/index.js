import React, { useState, useEffect, useCallback } from "react";
import { Formik, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Button } from "react-bootstrap";
import { useSelector } from "react-redux";

const SubjectArchiveManager = () => {
  const [items, setItems] = useState([]);
  const [classes, setClasses] = useState([]); // To store fetched classes
  const [sections, setSections] = useState([]); // To store fetched sections
  const [errorMessage, setErrorMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const { academicYear, classData, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear, // Array of academic year objects
    classData: state.classData, // Array of class objects
    sectionData: state.sectionData, // Array of section objects
  }));

  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedClass, setSelectedClass] = useState("");
  const [selectedSection, setSelectedSection] = useState("");

  // Fetch classes based on academic year (mg_time_table_id)
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
          mg_time_table_id: selectedAcademicYear, // Pass the academic year id
        },
      });

      // Update class and section data
      setClasses(response.data.courses); // Assuming 'courses' is the key in the response for classes
      setSections([]); // Reset sections as new classes are fetched
    } catch (error) {
      setErrorMessage("Failed to fetch classes and sections");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [selectedAcademicYear]);

  // Fetch subjects based on selected academic year and class
  const fetchItems = useCallback(async () => {
    if (!selectedAcademicYear || !selectedClass) return;

    try {
      setLoading(true);
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const response = await axios.get("/subject_archives/getdata", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          academic_year_id: selectedAcademicYear,
          class_section: selectedClass,
          request_type: "subjects",
        },
      });

      if (Array.isArray(response.data)) {
        setItems(response.data);
      } else {
        setItems([]);
      }
    } catch (error) {
      setErrorMessage("Failed to fetch subjects");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [selectedAcademicYear, selectedClass]);

  useEffect(() => {
    if (selectedAcademicYear) {
      fetchCoursesAndSections(); // Fetch classes when academic year changes
    }
  }, [selectedAcademicYear, fetchCoursesAndSections]);

  const handleFormSubmit = useCallback(async (values, { setSubmitting }) => {
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      await axios.post(
        "/subject_archives/subject_archive_create",
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

      window.location.href = "/subject_archives/archived_subject_list";
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
                          setSelectedClass(""); // Reset class selection
                          setSections([]); // Clear sections on academic year change
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
                          setSelectedSection(""); // Reset section when class changes
                        }}
                      >
                        <option value="">Select Class</option>
                        {classes.map((cls) => (
                          <option key={cls.id} value={cls.id}>
                            {cls.course_name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="col-md-6 mt-3">
                    <div className="input-group input-group-outline">
                      <label className="form-label">Section</label>
                      <select
                        className="form-control"
                        value={selectedSection}
                        onChange={(e) => setSelectedSection(e.target.value)}
                        disabled={!selectedClass} // Disable until class is selected
                      >
                        <option value="">Select Section</option>
                        {sectionData
                          .filter(
                            (section) => section.classId === selectedClass
                          )
                          .map((section) => (
                            <option key={section.id} value={section.id}>
                              {section.section_name}
                            </option>
                          ))}
                      </select>
                    </div>
                  </div>
                </div>

                {loading ? (
                  <div className="text-center py-4">Loading subjects...</div>
                ) : (
                  items.length > 0 && (
                    <div className="mb-4">
                      <div className="card">
                        <div className="card-header p-3">
                          <label className="inline-flex items-center">
                            <input
                              type="checkbox"
                              className="form-check-input"
                              onChange={(e) => {
                                const allItemIds = items.map((item) => item.id);
                                setFieldValue(
                                  "selectedSubjects",
                                  e.target.checked ? allItemIds : []
                                );
                              }}
                              checked={
                                values.selectedSubjects.length === items.length
                              }
                            />
                            <span className="ml-2">Select All Subjects</span>
                          </label>
                        </div>
                        <div className="card-body">
                          <div className="row">
                            {items.map((subject) => (
                              <div key={subject.id} className="col-md-4 mb-3">
                                <label className="d-flex items-center">
                                  <input
                                    type="checkbox"
                                    className="form-check-input me-2"
                                    value={subject.id}
                                    checked={values.selectedSubjects.includes(
                                      subject.id
                                    )}
                                    onChange={(e) => {
                                      const newSelected = e.target.checked
                                        ? [
                                            ...values.selectedSubjects,
                                            subject.id,
                                          ]
                                        : values.selectedSubjects.filter(
                                            (id) => id !== subject.id
                                          );
                                      setFieldValue(
                                        "selectedSubjects",
                                        newSelected
                                      );
                                    }}
                                  />
                                  <span>{subject.name}</span>
                                </label>
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>
                      <ErrorMessage
                        name="selectedSubjects"
                        component="div"
                        className="text-danger"
                      />
                    </div>
                  )
                )}

                <Button
                  className="btn btn-primary"
                  type="submit"
                  disabled={loading || values.selectedSubjects.length === 0}
                >
                  Archive Selected Subjects
                </Button>
              </Form>
            )}
          </Formik>
        </div>
      </div>
    </div>
  );
};

export default SubjectArchiveManager;
