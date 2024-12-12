import React, { useState, useEffect, useMemo } from "react";
import { Formik, Form, Field, ErrorMessage ,FieldArray} from "formik";
import * as Yup from "yup";
import axios from "axios";
import { message } from 'antd';
import { Popconfirm, Select } from 'antd';

import {
  Table,
  Button,
  Form as BootstrapForm,
  InputGroup,
  Pagination,
  Offcanvas,
} from "react-bootstrap";
import { Edit, Trash, Search, PlusCircle, X } from "lucide-react";

const validationSchema = Yup.object().shape({
  academicYear: Yup.string().required("Academic Year is required"),
  section: Yup.string().required("Class and Section is required"),
  subject: Yup.string().required("Subject is required"),
  subject_components: Yup.array().of(
    Yup.object().shape({
      name: Yup.string()
        .required("Subject Component Name is required")
        .min(2, "Subject Component Name must be at least 2 characters")
    })
  ).min(1, "At least one subject component is required")
});

const SubSubject = ({ userData }) => {
  console.log(userData,"user data")
  const [classes, setClasses] = useState(userData.subject_component_data);
  const [sections, setSections] = useState(userData.batches_data || []);
  const [academicYears, setAcademicYears] = useState(
    userData.academic_year_data || []
  );
  const [subjects, setSubjects] = useState(userData.subjects_data||[])

  // State for filtering
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [searchTerm, setSearchTerm] = useState("");

  const fetchGrades = () => {
    axios.get(`sub_subject/show_sub_subjects`)
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
  useEffect(() => {
    if (academicYears.length) {
      const defaultAcademicYear = String(academicYears[academicYears.length - 1].id);
      setSelectedAcademicYear(defaultAcademicYear);
    }
  }, [academicYears]);
  

  // Filtering logic for classes
  const filteredClasses = useMemo(() => {
    return classes.filter((classItem) => {
      const matchesAcademicYear = 
        !selectedAcademicYear || 
        classItem.mg_time_table_id === Number(selectedAcademicYear);

      const matchesSearch = searchTerm === "" || 
        Object.values(classItem).some(value => 
          value && 
          value.toString().toLowerCase().includes(searchTerm.toLowerCase())
        );

      return matchesAcademicYear && matchesSearch;
    });
  }, [classes, selectedAcademicYear, searchTerm]);

  // Pagination logic
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredClasses.slice(
    indexOfFirstEntry,
    indexOfLastEntry
  );

  const totalPages = Math.ceil(filteredClasses.length / entriesPerPage);

  const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

  // Create/Edit form handling
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingClass, setEditingClass] = useState(null);

  const token = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");

  const handleDelete = (id) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  
    axios.delete(`/sub_subject/delete_sub_subject/${id}`, {
      headers: {
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => {
        if (response.status !== 200) {
          throw new Error('Deletion failed');
        }
     
        fetchGrades();
        message.success('Subject Component deleted successfully!');
      })
      .catch((error) => {
        console.error("Error deleting grade:", error);
        message.error(error.response?.data?.error || 'Failed to delete Subject Component.');
      });
  };

  const handleSubmit = (values, { setSubmitting, resetForm }) => {
    // Prepare the payload with subject components
    const payload = {
      mg_time_table_id: Number(values.academicYear),
      mg_batch_id: Number(values.section),
      mg_subject_id: Number(values.subject),
      subject_components: values.subject_components.map(component => ({
        name: component.name
      }))
    };

    fetch("sub_subject/create_sub_subject", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({ mg_subject_component: payload }),
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
      message.success('Subject Components created successfully!');
      resetForm(); // Reset the form after successful submission
    })
    .catch((error) => {
      console.error("Error:", error);
      message.error('Failed to create Subject Components.');
    })
    .finally(() => setSubmitting(false));
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    fetch(`/sub_subject/update_sub_subject/${editingClass.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_subject_component: {
          subject_component_name: values.subject_component_name,
        
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
      setClasses(classes.map((c) => (c.id === editingClass.id ? data : c)));
      setShowEditForm(false);
      fetchGrades();
      message.success('Subject Component updated successfully!');
    })
    .catch((error) => {
      console.error("Error:", error);
      message.error('Failed to update Subject Component.');
    })
    .finally(() => setSubmitting(false));
  };

  const handleEditClick = (gradeItem) => {
    setEditingClass(gradeItem);
    setSelectedAcademicYear(gradeItem.mg_time_table_id);
    setShowEditForm(true);
  };

  // Filter sections based on selected academic year for autocomplete
  const filterSectionsForYear = (academicYearId) => {
    return sections.filter(
      (section) => section.mg_time_table_id === Number(academicYearId)
    );
  };
  const filterSubjectsForYearAndSection = (academicYearId, sectionId) => {
    // Implement your logic to filter subjects based on academic year and section
    // This might require additional backend support or filtering logic
    return subjects.filter(subject => 
      // Example filtering - adjust based on your exact requirements
      subject.mg_course_id === filterSectionsForYear(academicYearId).find(s => s.mg_batch_id === Number(sectionId))?.mg_course_id
    );
  };
  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Subject Components</h5>
            <Button
              variant="info"
              size="sm"
              onClick={() => setShowCreateForm(true)}
            >
               + New Subject Components
            </Button>
          </div>
        </div>
        
        {/* Search Section */}
        <div className="card-body px-3 pb-2">
          <div className="row mb-3">
            <div className="col-md-6">
              <label>Academic Year</label>
              <BootstrapForm.Select
                value={selectedAcademicYear}
                onChange={(e) => setSelectedAcademicYear(e.target.value)}
                className="form-control"
              >
                
                {academicYears.map((year) => (
                  <option key={year.id} value={year.id}>
                    {year.name}
                  </option>
                ))}
              </BootstrapForm.Select>
            </div>
            <div className="col-md-6">
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
                <th style={{ width: "15%" }}>Subject Name</th>
                <th style={{ width: "15%" }}>Class</th>
                <th style={{ width: "15%" }}>Section</th>
                <th style={{ width: "15%" }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((gradeItem) => (
                <tr key={gradeItem.id}>
                  <td>{gradeItem.subject_component_name}</td>
                  <td>{gradeItem.subject_name}</td>
                  <td>{gradeItem.course_name}</td>
                  <td>{gradeItem.batch_name}</td>
              
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
                      <Button
                        variant="link"
                        className="text-danger p-0"
                      >
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
              Showing {indexOfFirstEntry + 1} to{" "}
              {Math.min(indexOfLastEntry, filteredClasses.length)} of{" "}
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

      {/* Create Form */}
      <Offcanvas
        show={showCreateForm}
        onHide={() => setShowCreateForm(false)}
        placement="end"
        style={{ width: "40%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Create Subject Components</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              academicYear: academicYears.length ? String(academicYears[academicYears.length - 1].id) : "",

              section: "",
              subject: "",
              subject_components: [{ name: "" }]
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting, values, setFieldValue }) => (
              <Form>
                {/* Academic Year Dropdown */}
                <div className="row mb-3">
                  <div className="col-md-12">
                    <label>Academic Year</label>
                    <Select
                      style={{ width: '100%' }}
                      placeholder="Select Academic Year"
                      value={values.academicYear}
                      onChange={(value) => {
                        setFieldValue('academicYear', value);
                        setFieldValue('section', ''); // Reset section
                        setFieldValue('subject', ''); // Reset subject
                      }}
                      options={academicYears.map(year => ({
                        value: year.id.toString(),
                        label: year.name
                      }))}
                      status={touched.academicYear && errors.academicYear ? 'error' : ''}
                    />
                    {touched.academicYear && errors.academicYear && (
                      <div className="text-danger">{errors.academicYear}</div>
                    )}
                  </div>
                </div>

                {/* Section Dropdown */}
                <div className="row mb-3">
                  <div className="col-md-12">
                    <label>Class & Section</label>
                    <Select
                      style={{ width: '100%' }}
                      placeholder="Select Class & Section"
                      value={values.section}
                      onChange={(value) => {
                        setFieldValue('section', value);
                        setFieldValue('subject', ''); // Reset subject
                      }}
                      disabled={!values.academicYear}
                      options={
                        values.academicYear 
                          ? filterSectionsForYear(values.academicYear).map(section => ({
                              value: section.mg_batch_id.toString(),
                              label: section.name
                            }))
                          : []
                      }
                      status={touched.section && errors.section ? 'error' : ''}
                    />
                    {touched.section && errors.section && (
                      <div className="text-danger">{errors.section}</div>
                    )}
                  </div>
                </div>

                {/* Subject Dropdown */}
                <div className="row mb-3">
                  <div className="col-md-12">
                    <label>Subject</label>
                    <Select
                      style={{ width: '100%' }}
                      placeholder="Select Subject"
                      value={values.subject}
                      onChange={(value) => setFieldValue('subject', value)}
                      disabled={!values.academicYear || !values.section}
                      options={
                        values.academicYear && values.section
                          ? filterSubjectsForYearAndSection(values.academicYear, values.section).map(subject => ({
                              value: subject.id.toString(),
                              label: subject.subject_name
                            }))
                          : []
                      }
                      status={touched.subject && errors.subject ? 'error' : ''}
                    />
                    {touched.subject && errors.subject && (
                      <div className="text-danger">{errors.subject}</div>
                    )}
                  </div>
                </div>

             {/* Dynamic Subject Components */}
             <FieldArray
  name="subject_components"
  render={(arrayHelpers) => (
    <div className="p-3 mb-2">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h5>Components</h5>
        <button
          type="button"
          className="btn btn-info btn-sm"
          onClick={() => arrayHelpers.push({ name: "" })} // Push a new object with an empty name
        >
          + Add Component
        </button>
      </div>

      {values.subject_components.map((component, index) => (
        <div key={index} className="row mb-2 align-items-center">
          <div className="col-md-10">
          <div className="input-group input-group-outline my-1">
            <Field
              name={`subject_components.${index}.name`}
              className={`form-control ${
                touched.subject_components?.[index]?.name &&
                errors.subject_components?.[index]?.name
                  ? "is-invalid"
                  : ""
              }`}
              placeholder="Enter Component Name"
            />
         
            <ErrorMessage
              name={`subject_components.${index}.name`}
              component="div"
              className="invalid-feedback"
            />
               </div>
          </div>
          {values.subject_components.length > 1 && (
            <div className="col-md-2">
              <button
                type="button"
                className="btn btn-dark btn-sm w-100"
                onClick={() => arrayHelpers.remove(index)}
              >
                X
              </button>
            </div>
          )}
        </div>
      ))}

      {/* Display error if no subject components */}
      {errors.subject_components && (
        <div className="text-danger mt-2">
          {typeof errors.subject_components === "string"
            ? errors.subject_components
            : null}
        </div>
      )}
    </div>
  )}
/>


                {/* Submit Button */}
                <div className="row mt-3">
                  <div className="col-md-12 d-flex justify-content-end">
                    <button
                      type="submit"
                      className="btn btn-info"
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

      {/* Edit Form */}
      <Offcanvas
        show={showEditForm}
        onHide={() => setShowEditForm(false)}
        placement="end"
        style={{ width: "40%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Update Component</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingClass && (
            <Formik
              initialValues={{
                subject_component_name: editingClass.subject_component_name,
                
              }}
              // validationSchema={validationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-12">
                      <label>Subject Component</label>
                      <div className="input-group input-group-outline my-1">
                      <Field
                        name="subject_component_name"
                        className={`form-control ${
                          touched.subject_component_name && errors.subject_component_name ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="subject_component_name"
                        component="div"
                        className="invalid-feedback"
                      /></div>
                    </div>
                    </div>
                
                  <div className="row mt-3">
                    <div className="col-md-12 d-flex justify-content-end">
                      <button
                        type="submit"
                        className="btn btn-info"
                        disabled={isSubmitting}
                      >
                        {isSubmitting ? "Updating..." : "Update"}
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

export default SubSubject;