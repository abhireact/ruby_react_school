import React, { useState, useEffect, useMemo } from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { message } from 'antd';
import { Popconfirm } from 'antd';

import {
  Table,
  Button,
  Form as BootstrapForm,
  InputGroup,
  Pagination,
  Offcanvas,
} from "react-bootstrap";
import { Edit, Trash, Search } from "lucide-react";

const validationSchema = Yup.object().shape({
  name: Yup.string().required("Grade name is required"),
});

const OtherGrade = ({ userData }) => {
  console.log(userData)
  const [classes, setClasses] = useState([]);
  const [sections, setSections] = useState(userData.batches_data || []);
  const [academicYears, setAcademicYears] = useState(
    userData.academic_year_data || []
  );

  // State for filtering
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedSection, setSelectedSection] = useState("");
  const [searchTerm, setSearchTerm] = useState("");

  const fetchGrades = () => {
    axios.get(`other_grade/show_other_grades`)
      .then(response => {
         console.log(response.data,"response data")
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

  // Filtering logic for classes
  const filteredClasses = useMemo(() => {
    return classes.filter((classItem) => {
      const matchesAcademicYear = 
        !selectedAcademicYear || 
        classItem.mg_time_table_id === Number(selectedAcademicYear);
      
      const matchesSection = 
        selectedSection === "" 
          ? !classItem.mg_batch_id // Match when mg_batch_id is null, undefined, or an empty string
          : classItem.mg_batch_id === Number(selectedSection);

      const matchesSearch = searchTerm === "" || 
        Object.values(classItem).some(value => 
          value && 
          value.toString().toLowerCase().includes(searchTerm.toLowerCase())
        );

      return matchesAcademicYear && matchesSection && matchesSearch;
    });
  }, [classes, selectedAcademicYear, selectedSection, searchTerm]);

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

    axios.delete(`/other_grade/delete_other_grade/${id}`, {
      headers: {
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => {
        if (response.status !== 200) {
          throw new Error('Deletion failed');
        }
     
        fetchGrades();
        message.success('Scholastic Grade deleted successfully!');
      })
      .catch((error) => {
        console.error("Error deleting grade:", error);
        message.error(error.response?.data?.error || 'Failed to delete Scholastic Grade.');
      });
  };

  const handleSubmit = (values, { setSubmitting }) => {
    fetch("other_grade/create_other_grade", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        grades: {
          name: values.name,
          description: values.description,
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
      message.success('Other Grade created successfully!');
    })
    .catch((error) => {
      console.error("Error:", error);
      message.error('Failed to create Other Grade.');
    })
    .finally(() => setSubmitting(false));
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    fetch(`/other_grade/update_other_grade/${editingClass.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        grades: {
          name: values.name,
          description: values.description,
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
      // Directly update the class in the state
      setClasses(prevClasses => 
        prevClasses.map((c) => (c.id === editingClass.id ? data : c))
      );
      setShowEditForm(false);
      fetchGrades();
      message.success('Other Grade updated successfully!');
    })
    .catch((error) => {
      console.error("Error:", error);
      message.error('Failed to update Other Grade.');
    })
    .finally(() => setSubmitting(false));
  };

  const handleEditClick = (gradeItem) => {
    // Preserve original filter settings
    const originalAcademicYear = selectedAcademicYear;
    const originalSection = selectedSection;

    // Set editing class
    setEditingClass(gradeItem);
    
    // Set academic year and section to match the selected item
    setSelectedAcademicYear(gradeItem.mg_time_table_id);
    setSelectedSection(gradeItem.mg_batch_id || "");

    // Open edit form
    setShowEditForm(true);
  };

  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Other Grade</h5>
            <Button
              variant="info"
              size="sm"
              onClick={() => setShowCreateForm(true)}
            >
              + New Grade
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
               
                <th style={{ width: "15%" }}>Description</th>
    
                <th style={{ width: "15%" }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((gradeItem) => (
                <tr key={gradeItem.id}>
                  <td>{gradeItem.name}</td>
                 
                  <td>{gradeItem.description}</td>
              
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
          <Offcanvas.Title>Create New Grade</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              name: "",
              description: "",
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting }) => (
              <Form>
                <div className="row">
                  <div className="col-md-12">
                    <label>Grade Name</label>   <div className="input-group input-group-outline my-1">
                    <Field
                      name="name"
                      className={`form-control ${
                        touched.name && errors.name ? "is-invalid" : ""
                      }`}
                    />
                    <ErrorMessage
                      name="name"
                      component="div"
                      className="invalid-feedback"
                    />
                    </div>
                  </div>
                  </div>
                  <div className="row">
                  <div className="col-md-12">
                    <label>Description</label>   <div className="input-group input-group-outline my-1">
                    <Field
                      name="description"
                      as="textarea"
                      className="form-control"
                    />
                    </div>
                  </div>
                </div>
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
          <Offcanvas.Title>Edit Grade</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingClass && (
            <Formik
              initialValues={{
                name: editingClass.name,
                description: editingClass.description || "",
              }}
              validationSchema={validationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-12">
                      <label>Grade Name</label>
                      <div className="input-group input-group-outline my-1">
                      <Field
                        name="name"
                        className={`form-control ${
                          touched.name && errors.name ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="name"
                        component="div"
                        className="invalid-feedback"
                      /></div>
                    </div>
                    </div>
                    <div className="row">
                    <div className="col-md-12">
                      <label>Description</label>
                      <div className="input-group input-group-outline my-1">
                      <Field
                        name="description"
                        as="textarea"
                        className="form-control"
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

export default OtherGrade;