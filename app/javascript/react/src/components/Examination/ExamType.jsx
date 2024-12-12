import React, { useState, useEffect, useMemo } from "react";
import { Formik, Form, Field, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import {
  Table,
  Button,
  Form as BootstrapForm,
  InputGroup,
  Pagination,
  Offcanvas,
} from "react-bootstrap";
import { Edit, Trash, Search } from "lucide-react";
import { message } from 'antd';
import { Popconfirm } from 'antd';
import { selectClasses } from "@mui/material";

const validationSchema = Yup.object().shape({
  exam_type_name: Yup.string().required("Exam type name is required"),
  description: Yup.string(),
  mg_time_table_id: Yup.string().required("Academic Year is required"),
});

const ExamType = ({ userData }) => {
  const [examTypes, setExamTypes] = useState(userData.examtype_data || []);
   console.log(userData,"user Data")

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingExamType, setEditingExamType] = useState(null);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedTableAcademicYear, setSelectedTableAcademicYear] = useState(userData.academicYearsData[userData.academicYearsData.length - 1].id.toString());


  const [academicYearData, setAcademicYearData] = useState(userData.academicYearsData || []);
  const filteredExamTypes = useMemo(() => {
    let result = examTypes;

    // Filter by search term
    result = result.filter((examType) =>
      Object.entries(examType).some(([key, value]) => {
        if (typeof value === "string") {
          return value.toLowerCase().includes(searchTerm.toLowerCase());
        }
        return false;
      })
    );

    // Filter by academic year if selected
    if (selectedTableAcademicYear) {
      result = result.filter(
        (examType) => examType.mg_time_table_id.toString() === selectedTableAcademicYear
      );
    }

    return result;
  }, [examTypes, searchTerm, selectedTableAcademicYear]);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, entriesPerPage]);
  useEffect(() => {
    if (editingExamType) {
      setSelectedAcademicYear(editingExamType.mg_time_table_id.toString());
    }
  }, [editingExamType]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredExamTypes.slice(indexOfFirstEntry, indexOfLastEntry);

  const totalPages = Math.ceil(filteredExamTypes.length / entriesPerPage);

  const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

  const handleSubmit = (values, { setSubmitting }) => {
    const formattedData = selectedClass.map((item) => {
      const selectedItem = userData.class_section.find(([_, id]) => id === item);
      return selectedItem ? selectedItem[1] : null;
    });

    const cleanedData = formattedData.filter((item) => item !== null);

    // Rest of the code remains the same
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch("/cbsc_examinations/create", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_exam_type: {
          exam_type_name: values.exam_type_name,
          description: values.description,
        },
        selected_class: cleanedData,
        mg_time_table_id: values.mg_time_table_id,
      }),
    })
      .then((response) => response.json())
      .then(() => {
        setShowCreateForm(false);
        window.location.reload();
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const handleDelete = (id) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  
    // Show loading message
    const msgKey = 'deletingExamType';
    message.loading({ content: 'Deleting Exam Type...', key: msgKey });
  
    axios
      .delete(`/cbsc_examinations/${id}`, {
        headers: {
          "X-CSRF-Token": csrfToken,
        },
      })
      .then((response) => {
        if (response.data.status !== 200) {
          // Remove the deleted item from the state
          message.success({
            content: 'Exam Type deleted successfully!',
            key: msgKey,
          });
  
          // Update local state and reload
          window.location.reload();
        } else {
          throw new Error(response.data.message);
        }
      })
      .catch((error) => {
        // Handle both network errors and server-returned errors
        const errorMessage = error.response?.data?.message || error.message;
        // Error message
        message.error({
          content: `Failed to delete Exam Type: ${errorMessage}`,
          key: msgKey,
        });
      });
  };
  

  const handleEditClick = (examType) => {
    // Set the academic year first
    setSelectedAcademicYear(examType.mg_time_table_id.toString());

    // Find all exam associations for this exam type
    const examAssociations = userData.exam_associationData.filter(
      (association) => association.mg_cbsc_exam_type_id === examType.id
    );

    // Get the class-section IDs from the associations
    const associatedClassSections = examAssociations.map((association) => {
      return `${association.mg_course_id}-${association.mg_batch_id}`;
    });

    // Set the pre-selected classes
    setSelectedClass(associatedClassSections);

    // Set the exam type being edited
    setEditingExamType(examType);

    // Show the edit form
    setShowEditForm(true);
  };
  const handleEditSubmit = (values, { setSubmitting }) => {
    // Get currently selected classes
    const currentlySelectedClasses = new Set(selectedClass);

    // Find previously selected classes
    const examAssociations = userData.exam_associationData.filter(
      (association) => association.mg_cbsc_exam_type_id === editingExamType.id
    );

    // Get classes that need to be deleted
    const deletedClasses = examAssociations
      .map((association) => `${association.mg_course_id}-${association.mg_batch_id}`)
      .filter((classId) => !currentlySelectedClasses.has(classId));

    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch(`/cbsc_examinations/${editingExamType.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_exam_type: {
          exam_type_name: values.exam_type_name,
          description: values.description,
          mg_time_table_id: values.mg_time_table_id,
        },
        selected_class: Array.from(currentlySelectedClasses),
        delete_class: deletedClasses,
      }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        setShowEditForm(false);
         window.location.reload();
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Failed to update exam type. Please try again.");
      })
      .finally(() => {
        setSubmitting(false);
      });
  };
 
  const [filteredClassSections, setFilteredClassSections] = useState([]);
  const [selectedClass, setSelectedClass] = useState([]);
  useEffect(() => {
    if (selectedAcademicYear) {
      // Filter class sections based on academic year
      const filtered = userData.class_section.filter(([_, id, academicYearId]) => {
        return academicYearId === parseInt(selectedAcademicYear);
      });
      setFilteredClassSections(filtered);
    } else {
      setFilteredClassSections([]);
      setSelectedClass([]);
    }
  }, [selectedAcademicYear, userData.class_section]);
  const handleAcademicYearChange = (e) => {
    const yearId = e.target.value;
    setSelectedAcademicYear(yearId);
  };
  const handleTableAcademicYearChange = (e) => {
    const yearId = e.target.value;
    setSelectedTableAcademicYear(yearId);
  };

  const handleSelectChange = (e) => {
    const value = e.target.value;
    // If the value is already selected, remove it. Otherwise, add it.
    setSelectedClass((prevSelected) =>
      prevSelected.includes(value)
        ? prevSelected.filter((v) => v !== value)
        : [...prevSelected, value]
    );
  };
  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Exam Type List</h5>
            <Button
              variant="info"
              size="sm"
              className="me-2"
              onClick={() =>{setShowCreateForm(true)
                setSelectedClass([])}
              }
            >
              + New Exam Type
            </Button>
          </div>
        </div>
        <div className="card-body px-0 pb-2">
        <div className="d-flex justify-content-between align-items-center px-3 mb-3">
            <div className="col-md-4">
            <label>Academic Year</label>
              <BootstrapForm.Select
              
                value={selectedTableAcademicYear}
                onChange={handleTableAcademicYearChange}
                className="form-control"
              >
                <option value="">Choose Academic Years</option>
                {academicYearData.map((year) => (
                  <option key={year.id} value={year.id}>
                    {year.name}
                  </option>
                ))}
              </BootstrapForm.Select>
            </div>
            <InputGroup className="w-auto">
              <InputGroup.Text>
                <Search size={18} />
              </InputGroup.Text>
              <BootstrapForm.Control
                type="text"
                placeholder="Search..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </InputGroup>
          </div>
          <Table responsive bordered hover striped>
            <thead>
              <tr>
                <th>Exam Type Name</th>
                <th>Description</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((item) => (
                <tr key={item.id}>
                  <td>{item.exam_type_name}</td>
                  <td>{item.description}</td>
                  <td>
                    <Button
                      variant="link"
                      className="text-primary p-0 me-2"
                      onClick={() => handleEditClick(item)}
                    >
                      <Edit size={18} />
                    </Button>
                    <Popconfirm
                    title="Are you sure you want to delete this exam type?"
                    description="This action cannot be undone"
                    onConfirm={() => handleDelete(item.id)}
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
              {Math.min(indexOfLastEntry, filteredExamTypes.length)} of {filteredExamTypes.length}{" "}
              entries
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
      </div>
      <Offcanvas
        show={showCreateForm}
        onHide={() => setShowCreateForm(false)}
        placement="end"
        style={{ width: "60%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Create New Exam Type</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              exam_type_name: "",
              description: "",
              mg_time_table_id: "",
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting, setFieldValue }) => (
              <Form>
                <div className="row">
                  <div className="col-md-6">
                    <label>Academic Year</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        as="select"
                        name="mg_time_table_id"
                        className={`form-control ${
                          touched.mg_time_table_id && errors.mg_time_table_id ? "is-invalid" : ""
                        }`}
                        onChange={(e) => {
                          handleAcademicYearChange(e);
                          // Make sure to trigger Formik's onChange as well
                          const event = e;
                          setFieldValue("mg_time_table_id", e.target.value);
                        }}
                      >
                        <option value="">Select Academic Year</option>
                        {academicYearData.map((year) => (
                          <option key={year.id} value={year.id}>
                            {year.name}
                          </option>
                        ))}
                      </Field>
                      <ErrorMessage
                        name="mg_time_table_id"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>

                  <div className="col-md-6">
                    <label>Exam Type Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="exam_type_name"
                        className={`form-control ${
                          touched.exam_type_name && errors.exam_type_name ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="exam_type_name"
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
                        as="textarea"
                        className={`form-control ${
                          touched.description && errors.description ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="description"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                </div>
                {selectedAcademicYear && (
                  <div className="row">
                    <h5>Select Classes and Sections</h5>
                    <div
                      style={{
                        maxHeight: "200px",
                        overflowY: "scroll",
                        border: "1px solid #ccc",
                        padding: "10px",
                      }}
                    >
                      <div style={{ display: "flex", flexWrap: "wrap", gap: "10px" }}>
                        {filteredClassSections.map(([name, id], index) => (
                          <div key={index} style={{ flex: "0 0 48%" }}>
                            <label>
                              <input
                                type="checkbox"
                                value={id}
                                onChange={handleSelectChange}
                                checked={selectedClass.includes(id)}
                              />
                              &nbsp; &nbsp;
                              {name}
                            </label>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                )}
                <div className="row">
                  <div className="col-md-12 d-flex justify-content-end">
                    <button type="submit" className="btn btn-info my-4" disabled={isSubmitting}>
                      {isSubmitting ? "Submiting..." : "Submit"}
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
          <Offcanvas.Title>Edit Exam Type</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingExamType && (
            <Formik
              initialValues={{
                exam_type_name: editingExamType.exam_type_name,
                description: editingExamType.description,
                mg_time_table_id: editingExamType.mg_time_table_id,
              }}
              validationSchema={validationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting, setFieldValue }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Academic Year</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          as="select"
                          name="mg_time_table_id"
                          className={`form-control ${
                            touched.mg_time_table_id && errors.mg_time_table_id ? "is-invalid" : ""
                          }`}
                          onChange={(e) => {
                            handleAcademicYearChange(e);
                            setFieldValue("mg_time_table_id", e.target.value);
                          }}
                        >
                          <option value="">Select Academic Year</option>
                          {academicYearData.map((year) => (
                            <option key={year.id} value={year.id}>
                              {year.name}
                            </option>
                          ))}
                        </Field>
                        <ErrorMessage
                          name="mg_time_table_id"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                    <div className="col-md-6">
                      <label>Exam Type Name</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="exam_type_name"
                          className={`form-control ${
                            touched.exam_type_name && errors.exam_type_name ? "is-invalid" : ""
                          }`}
                        />
                        <ErrorMessage
                          name="exam_type_name"
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
                          as="textarea"
                          className={`form-control ${
                            touched.description && errors.description ? "is-invalid" : ""
                          }`}
                        />
                        <ErrorMessage
                          name="description"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                  </div>
                  {selectedAcademicYear && (
                    <div className="row">
                      <h5>Select Classes and Sections</h5>
                      <div
                        style={{
                          maxHeight: "200px",
                          overflowY: "scroll",
                          border: "1px solid #ccc",
                          padding: "10px",
                        }}
                      >
                        <div style={{ display: "flex", flexWrap: "wrap", gap: "10px" }}>
                          {filteredClassSections.map(([name, id], index) => (
                            <div key={index} style={{ flex: "0 0 48%" }}>
                              <label>
                                <input
                                  type="checkbox"
                                  value={id}
                                  onChange={handleSelectChange}
                                  checked={selectedClass.includes(id)}
                                />
                                &nbsp; &nbsp;
                                {name}
                              </label>
                            </div>
                          ))}
                        </div>
                      </div>
                    </div>
                  )}
                  <div className="row">
                    <div className="col-md-12 d-flex justify-content-end">
                      <button type="submit" className="btn btn-info my-4" disabled={isSubmitting}>
                        {isSubmitting ? "Updating..." : "Update Exam Type"}
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
export default ExamType;
