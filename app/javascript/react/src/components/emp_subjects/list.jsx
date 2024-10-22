import React, { useState, useEffect, useCallback } from "react";
import { Formik, Form, Field } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Button } from "react-bootstrap";
import { useSelector } from "react-redux";

const EmpListManagement = () => {
  const [items, setItems] = useState([]);
  const [classes, setClasses] = useState([]);
  const [sections, setSections] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [assignedSubjects, setAssignedSubjects] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const { academicYear } = useSelector((state) => ({
    academicYear: state.academicYear,
  }));

  const [selection, setSelection] = useState({
    academicYearId: "",
    classId: "",
    sectionId: "",
    selectedSubjects: [],
  });

  const fetchCoursesAndSections = useCallback(async () => {
    const { academicYearId } = selection;
    if (!academicYearId) return;

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
          mg_time_table_id: academicYearId,
        },
      });

      if (response.data.courses) {
        setClasses(
          response.data.courses.map((batch) => ({
            id: batch[1],
            name: batch[0],
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
  }, [selection]);

  const fetchSubjects = useCallback(async () => {
    const { classId } = selection;
    if (!classId) return;

    try {
      setLoading(true);
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const response = await axios.get("/emp_subjects/get_subject_batch_id", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          mg_course_id: classId,
          employee: localStorage.getItem("selectedEmployeeId"),
        },
      });

      if (response.data) {
        const { assigned_subjects, available_subjects } = response.data;
        setAssignedSubjects(assigned_subjects.map((subject) => subject.id)); // Store assigned subject IDs
        setSubjects(
          [...assigned_subjects, ...available_subjects].map((subject) => ({
            name: subject.subject_name,
            id: subject.id,
          }))
        );
      }
    } catch (error) {
      setErrorMessage("Failed to fetch subjects");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [selection]);

  useEffect(() => {
    fetchCoursesAndSections();
  }, [selection.academicYearId, fetchCoursesAndSections]);

  useEffect(() => {
    fetchSubjects();
  }, [selection.classId, fetchSubjects]);

  const handleFormSubmit = useCallback(
    async (values, { setSubmitting }) => {
      const employeeId = localStorage.getItem("selectedEmployeeId");
      if (!employeeId) {
        setErrorMessage("Employee ID not found. Please try again.");
        return;
      }

      // Determine unassigned subjects (those that were assigned but not selected)
      const unassignedSubjects = assignedSubjects.filter(
        (subjectId) => !values.selectedSubjects.includes(subjectId)
      );

      // Determine new subjects to be assigned (those selected but not previously assigned)
      const newSubjects = values.selectedSubjects.filter(
        (subjectId) => !assignedSubjects.includes(subjectId)
      );

      try {
        const token = document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content");

        // Construct query params for new subjects to assign
        const assignedSubjectParams = newSubjects
          .map((subjectId) => `assigned_subjects[]=${subjectId}`)
          .join("&");

        // Join unassigned subjects to a string
        const batchSub = unassignedSubjects.join(",");

        // Post request
        await axios.post(
          `/emp_subjects/subject_archive_create?${assignedSubjectParams}&employee=${employeeId}&batch_sub=${batchSub}`,
          {},
          {
            headers: {
              "X-CSRF-Token": token,
              "Content-Type": "application/json",
            },
          }
        );

        setSuccessMessage("Subjects assigned successfully!");
      } catch (error) {
        setErrorMessage("Failed to assign subjects");
        console.error(error);
      } finally {
        setSubmitting(false);
      }
    },
    [assignedSubjects]
  );

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
            initialValues={{ selectedSubjects: assignedSubjects }}
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
                        value={selection.academicYearId}
                        onChange={(e) => {
                          setSelection({
                            ...selection,
                            academicYearId: e.target.value,
                            classId: "",
                            sectionId: "",
                          });
                          setSections([]);
                          setSubjects([]);
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
                        value={selection.classId}
                        onChange={(e) => {
                          setSelection({
                            ...selection,
                            classId: e.target.value,
                          });
                          setSections([]);
                          setSubjects([]);
                        }}
                      >
                        <option value="">Select Class</option>
                        {classes.map((classItem) => (
                          <option key={classItem.id} value={classItem.id}>
                            {classItem.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                </div>

                <div className="row mb-4">
                  <div className="col-md-12">
                    <h6>Select Subjects:</h6>
                    {subjects.map((subject) => (
                      <div key={subject.id}>
                        <label>
                          <Field
                            type="checkbox"
                            name="selectedSubjects"
                            value={subject.id}
                            checked={values.selectedSubjects.includes(
                              subject.id
                            )}
                            onChange={() => {
                              const selected = values.selectedSubjects.includes(
                                subject.id
                              )
                                ? values.selectedSubjects.filter(
                                    (id) => id !== subject.id
                                  )
                                : [...values.selectedSubjects, subject.id];
                              setFieldValue("selectedSubjects", selected);
                            }}
                          />
                          {subject.name}
                        </label>
                      </div>
                    ))}

                    {errors.selectedSubjects && touched.selectedSubjects && (
                      <div className="text-danger">
                        {errors.selectedSubjects}
                      </div>
                    )}
                  </div>
                </div>

                <Button type="submit" disabled={loading}>
                  {loading ? "Saving..." : "Save Changes"}
                </Button>
              </Form>
            )}
          </Formik>
        </div>
      </div>
    </div>
  );
};

export default EmpListManagement;
