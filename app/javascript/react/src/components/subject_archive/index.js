import React, { useState, useEffect, useCallback } from "react";
import { Formik, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Button, Form as BootstrapForm, InputGroup } from "react-bootstrap";

const SubjectArchiveManager = () => {
  const [items, setItems] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [loading, setLoading] = useState(false);

  // Hard-coded academic year and class section values
  const academicYearId = "1"; // example hardcoded academic year ID
  const classSectionId = "2"; // example hardcoded class section ID

  const fetchItems = useCallback(async () => {
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
          academic_year_id: academicYearId,
          class_section: classSectionId,
          request_type: "subjects",
        },
      });
      setItems(response.data);
    } catch (error) {
      setErrorMessage("Failed to fetch subjects");
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [academicYearId, classSectionId]);

  useEffect(() => {
    fetchItems();
  }, [fetchItems]);

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
                      <input
                        className="form-control"
                        value="2023-2024" // hardcoded value
                        disabled
                      />
                    </div>
                  </div>

                  <div className="col-md-6">
                    <div className="input-group input-group-outline">
                      <label className="form-label">Class & Section</label>
                      <input
                        className="form-control"
                        value="Class 10 - Section A" // hardcoded value
                        disabled
                      />
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
                      {touched.selectedSubjects && errors.selectedSubjects && (
                        <div className="text-danger mt-1">
                          {errors.selectedSubjects}
                        </div>
                      )}
                    </div>
                  )
                )}

                <div className="d-flex justify-content-end">
                  <Button
                    type="submit"
                    variant="default"
                    disabled={loading || items.length === 0}
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
