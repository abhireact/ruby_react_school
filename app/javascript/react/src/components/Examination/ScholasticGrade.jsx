import React, { useState, useEffect, useMemo } from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { message, Popconfirm } from 'antd';

import {
  Table,
  Button,
  Form as BootstrapForm,
  InputGroup,
  Pagination,
  Offcanvas,
} from "react-bootstrap";
import { Eye, Edit, Trash, Search, List, Plus } from "lucide-react";

const validationSchema = Yup.object().shape({
  name: Yup.string().required("Grade name is required"),
  scoring_type: Yup.string().required("Scoring type is required"),
  min_score: Yup.lazy((value, context) => {
    const scoringType = context.parent.scoring_type;

    if (scoringType === "Marks Entry") {
      return Yup.number()
        .required("Minimum score is required for Marks Entry")
        .positive("Minimum score must be a positive number")
        .typeError("Minimum score must be a number");
    }

    return Yup.number()
      .nullable()
      .transform((value, originalValue) =>
        originalValue === '' ? null : value
      );
  }),
  credit_points: Yup.number().nullable(),
});

const editValidationSchema = validationSchema;

const ScholasticGrade = ({ userData }) => {
  const [classes, setClasses] = useState([]);
  const [sections, setSections] = useState(userData.batches_data || []);
  const [academicYears, setAcademicYears] = useState(userData.academic_year_data || []);

  // State for filtering
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedSection, setSelectedSection] = useState("");

  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingClass, setEditingClass] = useState(null);

  const fetchGrades = () => {
    axios.get(`scholastic_grade/show_scholastic_grades`)
      .then(response => {
        setClasses(response.data);
      })
      .catch(error => {
        console.error("Error while fetching grades", error);
      });
  };

  useEffect(() => {
    fetchGrades();

    // Set default academic year to the last one if available
    if (academicYears.length) {
      setSelectedAcademicYear(academicYears[academicYears.length - 1].id);
    }
  }, []);

  // Filtered sections based on selected academic year
  const filteredSections = useMemo(() => {
    return selectedAcademicYear
      ? sections.filter(
        (section) => section.mg_time_table_id === Number(selectedAcademicYear)
      )
      : [];
  }, [selectedAcademicYear, sections]);


  // Filtering logic for classes with improved null/undefined handling
  const filteredClasses = useMemo(() => {
    return classes.filter((classItem) => {
      const matchesAcademicYear =
        !selectedAcademicYear ||
        (classItem.mg_time_table_id !== null &&
          classItem.mg_time_table_id === Number(selectedAcademicYear));

      const matchesSection =
        selectedSection === ""
          ? (classItem.mg_batch_id === null || classItem.mg_batch_id === undefined)
          : classItem.mg_batch_id === Number(selectedSection);

      const matchesSearch = searchTerm === "" ||
        Object.values(classItem).some(value =>
          value &&
          value.toString().toLowerCase().includes(searchTerm.toLowerCase())
        );

      return matchesAcademicYear && matchesSection && matchesSearch;
    });
  }, [classes, selectedAcademicYear, selectedSection, searchTerm]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredClasses.slice(indexOfFirstEntry, indexOfLastEntry);
  const totalPages = Math.ceil(filteredClasses.length / entriesPerPage);

  const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

  const handleSubmit = (values, { setSubmitting }) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch("scholastic_grade/create_scholastic_grade", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        grades: {
          name: values.name,
          scoring_type: values.scoring_type,
          description: values.description,
          min_score: values.min_score,
          credit_points: values.credit_points,
          mg_time_table_id: Number(selectedAcademicYear),
          mg_batch_id: selectedSection ? Number(selectedSection) : null,
        }
      }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then((data) => {
        setClasses([...classes, data]);
        setShowCreateForm(false);
        fetchGrades();
        message.success('Scholastic Grade created successfully!');
      })
      .catch((error) => {
        console.error("Error:", error);
        message.error('Failed to create Scholastic Grade.');
      })
      .finally(() => setSubmitting(false));
  };

  const handleDelete = (id) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    axios.delete(`/scholastic_grade/delete_scholastic_grade/${id}`, {
      headers: {
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => {
        if (response.status !== 200) {
          throw new Error('Deletion failed');
        }
        setClasses(classes.filter((gradeItem) => gradeItem.id !== id));
        fetchGrades();
        message.success('Scholastic Grade deleted successfully!');
      })
      .catch((error) => {
        console.error("Error deleting grade:", error);
        message.error(error.response?.data?.error || 'Failed to delete Scholastic Grade.');
      });
  };

  const handleEditClick = (gradeItem) => {
    // Store the current academic year and section to prevent data loss
    setEditingClass(gradeItem);

    // Preserve the academic year, or set it to the specific grade's academic year if not set
    setSelectedAcademicYear(gradeItem.mg_time_table_id);

    // Preserve the section, or set it to the specific grade's section if not set
    setSelectedSection(gradeItem.mg_batch_id || "");

    setShowEditForm(true);
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch(`/scholastic_grade/update_scholastic_grade/${editingClass.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        grades: {
          name: values.name,
          scoring_type: values.scoring_type,
          description: values.description,
          min_score: values.scoring_type === 'Marks Entry' ? values.min_score : null,
          credit_points: values.credit_points,
          mg_time_table_id: Number(selectedAcademicYear),
          mg_batch_id: selectedSection ? Number(selectedSection) : null,
        },
      }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then((data) => {
        // Update the specific item in the classes array
        setClasses(prevClasses =>
          prevClasses.map((c) => (c.id === editingClass.id ? data : c))
        );
        setShowEditForm(false);
        fetchGrades();
        message.success('Scholastic Grade updated successfully!');
      })
      .catch((error) => {
        console.error("Error:", error);
        message.error('Failed to update Scholastic Grade.');
      })
      .finally(() => setSubmitting(false));
  };

  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Scholastic Grade</h5>
            <Button
              variant="info"
              size="sm"
              onClick={() => setShowCreateForm(true)}
            >
              + New Scholastic Grade
            </Button>
          </div>
        </div>

        {/* Filtering Section */}
        <div className="card-body px-3 pb-2">
          <div className="row mb-3">
            <div className="col-md-4">
              <label>Academic Year</label>
              <BootstrapForm.Select
                value={selectedAcademicYear}
                onChange={(e) => {
                  setSelectedAcademicYear(e.target.value);
                  setSelectedSection(""); // Reset section when academic year changes
                }}
                className="form-control"
              >
                {academicYears.map((year) => (
                  <option key={year.id} value={year.id}>
                    {year.name}
                  </option>
                ))}
              </BootstrapForm.Select>
               </div>
            <div className="col-md-4">
              <label>Class & Section</label>
              <BootstrapForm.Select
                value={selectedSection}
                onChange={(e) => setSelectedSection(e.target.value)}
                className="form-control"
                disabled={!selectedAcademicYear}
              >

                <option value="">Common</option>
                {filteredSections.map((section) => (
                  <option key={section.mg_batch_id} value={section.mg_batch_id}>
                    {section.name}
                  </option>
                ))}
              </BootstrapForm.Select>
            </div>
            <div className="col-md-4">
              <label>Search</label>
              <InputGroup>
                <InputGroup.Text><Search size={18} /></InputGroup.Text>
                <BootstrapForm.Control
                  type="text"
                  placeholder="Search..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </div>
          </div>

        </div>

        <Table responsive bordered hover striped>
          <thead>
            <tr>
              <th style={{ width: "15%" }}>Name</th>
              <th style={{ width: "15%" }}>Scoring Type</th>
              <th style={{ width: "15%" }}>Description</th>
              <th style={{ width: "15%" }}>Minimum Score</th>
              <th style={{ width: "15%" }}>Credit Points</th>
              <th style={{ width: "15%" }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {currentEntries.map((gradeItem) => (
              <tr key={gradeItem.id}>
                <td>{gradeItem.name}</td>
                <td>{gradeItem.scoring_type}</td>
                <td>{gradeItem.description}</td>
                <td>{gradeItem.min_score}</td>
                <td>{gradeItem.credit_points}</td>
                <td>
                  <Button
                    variant="link"
                    className="text-primary p-0 me-2"
                    onClick={() => handleEditClick(gradeItem)}
                  >
                    <Edit size={18} />
                  </Button>
                  <Popconfirm
                    title="Are you sure you want to delete this grade?"
                    description="This action cannot be undone"
                    onConfirm={() => handleDelete(gradeItem.id)}
                    okText="Yes"
                    cancelText="No"
                  >
                    <Button variant="link" className="text-danger p-0">
                      <Trash size={18} />
                    </Button>
                  </Popconfirm>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>

        <div className="d-flex justify-content-between align-items-center px-3 mt-3">
          <span>
            Showing {indexOfFirstEntry + 1} to
            {Math.min(indexOfLastEntry, filteredClasses.length)} of
            {filteredClasses.length} entries
          </span>
          <Pagination>
            <Pagination.Prev
              onClick={() => handlePageChange(currentPage - 1)}
              disabled={currentPage === 1}
            />
            {[...Array(totalPages)].map((_, index) => (
              <Pagination.Item
                key={index + 1}
                active={index + 1 === currentPage}
                onClick={() => handlePageChange(index + 1)}
              >
                {index + 1}
              </Pagination.Item>
            ))}
            <Pagination.Next
              onClick={() => handlePageChange(currentPage + 1)}
              disabled={currentPage === totalPages}
            />
          </Pagination>
        </div>
      </div>
      <Offcanvas
        show={showCreateForm}
        onHide={() => setShowCreateForm(false)}
        placement="end"
        style={{ width: "60%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Create New Grade</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              name: "",
              scoring_type: "Marks Entry",
              description: "",
              min_score: null,
              credit_points: null,
            }}
            onSubmit={handleSubmit}
            validationSchema={validationSchema}
          >
            {({ errors, touched, isSubmitting, values, setFieldValue }) => (
              <Form>
                <div className="row">
                  <div className="col-md-6">
                    <label>Grade</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="name"
                        className={`form-control ${touched.name && errors.name ? "is-invalid" : ""
                          }`}
                      />
                      <ErrorMessage
                        name="name"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <label>Scoring Type</label>
                    <div className="input-group input-group-outline">
                      <Field
                        as="select"
                        name="scoring_type"
                        className="form-select"
                        onChange={(e) => {
                          // Reset min_score when scoring type changes
                          const scoringType = e.target.value;
                          setFieldValue('scoring_type', scoringType);
                          if (scoringType === 'Grading') {
                            setFieldValue('min_score', null);
                          }
                        }}
                      >
                        <option value="Marks Entry">Marks Entry</option>
                        <option value="Grading">Grading</option>
                      </Field>
                    </div>
                  </div>
                </div>
                <div className="row">
                  <div className="col-md-6">
                    <label>Minimum Score</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="min_score"
                        className={`form-control ${touched.min_score && errors.min_score ? "is-invalid" : ""
                          }`}
                        type="number"
                        disabled={values.scoring_type === "Grading"}
                        placeholder={values.scoring_type === "Grading" ? "Not applicable" : "Enter minimum score"}
                      />
                      <ErrorMessage
                        name="min_score"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <label>Credit Points</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="credit_points"
                        className={`form-control ${touched.credit_points && errors.credit_points ? "is-invalid" : ""
                          }`}
                        type="number"
                      />
                      <ErrorMessage
                        name="credit_points"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                </div>
                <div className="row">
                  <div className="col-md-6">
                    <label>Description</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="description"
                        className="form-control"
                        as="textarea"
                      />
                    </div>
                  </div>
                </div>

                <div className="row">
                  <div className="col-md-12 d-flex justify-content-end">
                    <button
                      type="submit"
                      className="btn btn-info my-4"
                      disabled={isSubmitting}
                    >
                      {isSubmitting ? "Submitting..." : "Submit"}
                    </button>
                  </div>
                </div>
              </Form>
            )}
          </Formik>
        </Offcanvas.Body>
      </Offcanvas>
      <Offcanvas
        show={showEditForm}
        onHide={() => setShowEditForm(false)}
        placement="end"
        style={{ width: "60%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Edit Grade</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingClass && (
            <Formik
              initialValues={{
                name: editingClass.name,
                scoring_type: editingClass.scoring_type,
                description: editingClass.description || "",
                min_score: editingClass.min_score,
                credit_points: editingClass.credit_points,
              }}
              validationSchema={editValidationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting, values, setFieldValue }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Grade</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="name"
                          className={`form-control ${touched.name && errors.name ? "is-invalid" : ""
                            }`}
                        />
                        <ErrorMessage
                          name="name"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                    <div className="col-md-6">
                      <label>Scoring Type</label>
                      <div className="input-group input-group-outline">
                        <Field
                          as="select"
                          name="scoring_type"
                          className="form-select"
                          onChange={(e) => {
                            // Reset min_score when scoring type changes
                            const scoringType = e.target.value;
                            setFieldValue('scoring_type', scoringType);
                            if (scoringType === 'Grading') {
                              setFieldValue('min_score', null);
                            }
                          }}
                        >
                          <option value="Marks Entry">Marks Entry</option>
                          <option value="Grading">Grading</option>
                        </Field>
                      </div>
                    </div>

                  </div>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Description</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="description"
                          className="form-control"
                          as="textarea"
                        />
                      </div>
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Minimum Score</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="min_score"
                          type="number"
                          className={`form-control ${touched.min_score && errors.min_score ? "is-invalid" : ""
                            }`}
                          disabled={values.scoring_type === "Grading"}
                          placeholder={values.scoring_type === "Grading" ? "Not applicable" : "Enter minimum score"}
                        />
                        <ErrorMessage
                          name="min_score"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                    <div className="col-md-6">
                      <label>Credit Points</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="credit_points"
                          type="number"
                          className={`form-control ${touched.credit_points && errors.credit_points ? "is-invalid" : ""
                            }`}
                        />
                        <ErrorMessage
                          name="credit_points"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 d-flex justify-content-end">
                      <button
                        type="submit"
                        className="btn btn-info my-4"
                        disabled={isSubmitting}
                      >
                        {isSubmitting ? "Updating..." : "Update Grade"}
                      </button>
                    </div>
                  </div>
                </Form>
              )}
            </Formik>
          )}
        </Offcanvas.Body>
      </Offcanvas>
    </div>
  );
};

export default ScholasticGrade;
