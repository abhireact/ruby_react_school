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
  Modal,
} from "react-bootstrap";
import { Eye, Edit, Trash, Search, List,Plus } from "lucide-react";



const validationSchema = Yup.object().shape({
  name: Yup.string().required("Absent Reason Name  is required"),
 

    
  code: Yup.string()
    .max(3, "Code cannot be more than 3 characters")
    .required("Code is required"),
  
});
const editValidationSchema = Yup.object().shape({
  name: Yup.string().required("Absent Reason Name  is required"),

   
  code: Yup.string()
    .max(3, "Code cannot be more than 3 characters")
    .required("Code is required"),
});



const AbsentReason = ({ userData }) => {
  console.log(userData, "user data");


  const [classes, setClasses] = useState([]);


  const fetchGrades = () => {
    axios.get(`absent_reason/show_absent_reasons`)
      .then(response => {
        setClasses(response.data);
        console.log(response.data, "other grades ")
      })
      .catch(error => {
        console.error("Error while fetching grades", error);
      });
  };
  useEffect(() => {fetchGrades()},[])
  const [sections, setSections] = useState(userData.batches_data || []);
  const [academicYears, setAcademicYears] = useState(
    userData.academic_year_data || []
  );
  const [filteredSections, setFilteredSections] = useState([]);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  useEffect(() => {
    // Filter sections whenever the selected academic year changes
    if (selectedAcademicYear) {
      setFilteredSections(
        sections.filter(
          (section) => section.mg_time_table_id === Number(selectedAcademicYear)
        )
      );
    } else {
      setFilteredSections([]);
    }
  }, [selectedAcademicYear, sections]);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);

  const filteredClasses = useMemo(() => {
    return classes.filter((classItem) =>
      Object.entries(classItem).some(([key, value]) => {
        if (typeof value === "string") {
          return value.toLowerCase().includes(searchTerm.toLowerCase());
        }
        return false;
      })
    );
  }, [classes, searchTerm]);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, entriesPerPage]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredClasses.slice(
    indexOfFirstEntry,
    indexOfLastEntry
  );

  const totalPages = Math.ceil(filteredClasses.length / entriesPerPage);

  const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);
  const token = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");
  const handleSubmit = (values, { setSubmitting }) => {
    values.mg_time_table_id = Number(values.mg_time_table_id);
  // In handleSubmit method
   fetch("absent_reason/create_absent_reason", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "X-CSRF-Token": token,
  },
  body: JSON.stringify({
    mg_examination_absent_reason: {
      name: values.name,
      code: values.code,
      is_applicable:values.is_applicable
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
  message.success('Absent Reason created successfully!');
})
.catch((error) => {
  console.error("Error:", error);
  message.error('Failed to create Absent Reason.');
})
.finally(() => setSubmitting(false));
  };
  
  const handleDelete = (id) => {
    const csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
  
    axios
      .delete(`/absent_reason/delete_absent_reason/${id}`, {
        headers: {
          "X-CSRF-Token": csrfToken,
        },
      })
      .then((response) => {
        if (response.status !== 200) {
          throw new Error('Deletion failed');
        }
        // Remove the grade from the state after successful deletion
        setClasses(classes.filter((gradeItem) => gradeItem.id !== id));
        fetchGrades();
        message.success('Absent Reason deleted successfully!');
      })
      .catch((error) => {
        console.error("Error deleting grade:", error);
        message.error(
          error.response?.data?.error || 'Failed to delete Absent Reason.'
        );
      });
  };
  
const [showEditForm, setShowEditForm] = useState(false);
  const [editingClass, setEditingClass] = useState(null);

  // ... (keep existing functions)

  const handleEditClick = (gradeItem) => {
    setEditingClass(gradeItem);
    setShowEditForm(true);
  };
  const handleEditSubmit = (values, { setSubmitting }) => {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
  
    fetch(`/absent_reason/update_absent_reason/${editingClass.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_examination_absent_reason: {
          name: values.name,
          code: values.code,
          is_applicable: values.is_applicable ? 1 : 0, // Convert true/false to 1/0
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
        message.success('Absent Reason updated successfully!');
      })
      .catch((error) => {
        console.error("Error:", error);
        message.error('Failed to update Absent Reason.');
      })
      .finally(() => setSubmitting(false));
  };
  
  
  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Absent Reason</h5>
            <div>
              <Button
                variant="info"
                size="sm"
                className="me-2"
                onClick={() => setShowCreateForm(true)}
              >
                + New Absent Reason
              </Button>
       
            </div>
          </div>
        </div>
        <div className="card-body px-0 pb-2">
          <div className="d-flex justify-content-between align-items-center px-3 mb-3">
            <div className="d-flex align-items-center">
              <span>Show</span>
              <BootstrapForm.Select
                size="sm"
                className="mx-2"
                value={entriesPerPage}
                onChange={(e) => setEntriesPerPage(Number(e.target.value))}
              >
                <option value={5}>5</option>
                <option value={10}>10</option>
                <option value={25}>25</option>
                <option value={50}>50</option>
              </BootstrapForm.Select>
              <span>entries</span>
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
                <th style={{ width: "15%" }}>Name</th>
               
                <th style={{ width: "15%" }}>Code</th>
    
                <th style={{ width: "15%" }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((gradeItem) => (
                <tr key={gradeItem.id}>
                  <td>{gradeItem.name}</td>
                 
                  <td>{gradeItem.code}</td>
              
                  <td>
                    <Button
                      variant="link"
                      className="text-primary p-0 me-2"
                      onClick={() => handleEditClick(gradeItem)}
                    >
                      <Edit size={18} />
                    </Button>
                    <Popconfirm
  title="Are you sure you want to delete this absent reason?"
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
      </div>

      <Offcanvas
        show={showCreateForm}
        onHide={() => setShowCreateForm(false)}
        placement="end"
        style={{ width: "60%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Create New Absent Reason</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              name: "",
         
              code: "",
              is_applicable:0
            
            }}
            onSubmit={handleSubmit}
            validationSchema={validationSchema}
          >
            {({ errors, touched, isSubmitting, values, setFieldValue }) => (
              <Form>
                <div className="row">
                  <div className="col-md-4">
                    <label>Absent Reason</label>
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
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>Code</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="code"
                        className={`form-control ${
                          touched.code && errors.code ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="code"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>Marks Calculation</label>
                    <div className="input-group input-group-outline my-1">
                    <Field
              type="checkbox"
              name="is_applicable"
              checked={values.is_applicable === 1}
              onChange={(e) => {
                setFieldValue("is_applicable", e.target.checked ? 1 : 0);
              }}
            />
             &nbsp;&nbsp;Is Applicable
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
          <Offcanvas.Title>Edit Absent Reason</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingClass && (
            <Formik
            initialValues={{
              name: editingClass.name,
              code: editingClass.code || "",
              is_applicable:editingClass.is_applicable,
            }}
            validationSchema={editValidationSchema}
            onSubmit={handleEditSubmit}
          >
            {({ errors, touched, isSubmitting, values, setFieldValue }) => (
              <Form>
                <div className="row">
                  <div className="col-md-4">
                    <label>Grade</label>
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
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>Code</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="code"
                        className={`form-control ${
                          touched.code && errors.code ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="code"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>Marks Calculation</label>
                    <div className="input-group input-group-outline my-1">
                    <Field
  type="checkbox"
  name="is_applicable"
  checked={values.is_applicable} // Boolean value true/false
  onChange={(e) => setFieldValue("is_applicable", e.target.checked)} // Keep it boolean
/>

            &nbsp;&nbsp;Is Applicable
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

export default AbsentReason;
