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
    Modal,
} from "react-bootstrap";
import {Edit, Trash, Search} from "lucide-react";


const validationSchema = Yup.object().shape({
    department_name: Yup.string().required("Department name is required"),
    department_code: Yup.string().required("Department code is required"),
});
const editValidationSchema = Yup.object().shape({
    department_name: Yup.string().required("Department name is required"),
    department_code: Yup.string().required("Department code is required"),
});



const DepartmentIndex = ({ userData }) => {
    console.log(userData, "user data");

    const [departmentData, setDepartmentData] = useState(userData || []);


    const [showCreateForm, setShowCreateForm] = useState(false);
    const [searchTerm, setSearchTerm] = useState("");
    const [currentPage, setCurrentPage] = useState(1);
    const [entriesPerPage, setEntriesPerPage] = useState(10);

    const filteredDepartment = useMemo(() => {
        return departmentData.filter((departmentItem) =>
            Object.entries(departmentItem).some(([key, value]) => {
                if (typeof value === "string") {
                    return value.toLowerCase().includes(searchTerm.toLowerCase());
                }
                return false;
            })
        );
    }, [departmentData, searchTerm]);

    useEffect(() => {
        setCurrentPage(1);
    }, [searchTerm, entriesPerPage]);

    const indexOfLastEntry = currentPage * entriesPerPage;
    const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
    const currentEntries = filteredDepartment.slice(
        indexOfFirstEntry,
        indexOfLastEntry
    );

    const totalPages = Math.ceil(filteredDepartment.length / entriesPerPage);

    const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

    const handleSubmit = (values, { setSubmitting }) => {

        const token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

        fetch("/mg_employee_position/create", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": token,
            },
            body: JSON.stringify({
                mg_employee_position: {
                    mg_employee_category_id: values.mg_employee_category_id,
                    position_name: values.position_name,
                    status: values.status
                }
            }),
        })
            .then((response) => response.json())
            .then((data) => {
                setShowCreateForm(false);
                window.location.reload();
            })
            .catch((error) => console.error("Error:", error))
            .finally(() => setSubmitting(false));
    };

    const handleDelete = (id) => {
        if (window.confirm("Are you sure you want to delete this Department?")) {
            const csrfToken = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content");

            axios
                .delete(`/mg_employee_departments/${id}`, {
                    headers: {
                        "X-CSRF-Token": csrfToken,
                    },
                })
                .then(() => {
                    window.location.reload();
                    // Optionally, you can add a success message here
                })
                .catch((error) => {
                    console.error("Error Deleting Department:", error);

                });
        }
    };



 

    const [showEditForm, setShowEditForm] = useState(false);
    const [editingDepartment, setEditingDepartment] = useState(null);

    // ... (keep existing functions)

    const handleEditClick = (departmentItem) => {
        setEditingDepartment(departmentItem);
        setShowEditForm(true);
    };

    const handleEditSubmit = (values, { setSubmitting }) => {
        const token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

        fetch(`/mg_employee_departments/${editingDepartment.id}`, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": token,
            },
            body: JSON.stringify({
                mg_employee_department: {
                    department_name: values.department_name,
                    department_code: values.department_code,
                    status: values.status
                }
            }),
        })
            .then((response) => response.json())
            .then((data) => {

                setShowEditForm(false);
                window.location.reload();
            })
            .catch((error) => console.error("Error:", error))
            .finally(() => setSubmitting(false));
    };
// Create a custom Switch component for Formik
const FormikSwitch = ({ field, form }) => (
    <div className="form-check form-switch">
      <input
        type="checkbox"
        className="form-check-input"
        {...field}
        checked={field.value}
        role="switch"
        style={{ cursor: 'pointer' }}
      />
    </div>
  )
    return (
        <div className="container mt-4">
            <div className="card mb-4">
                <div className="card-header pb-0">
                    <div className="d-flex justify-content-between align-items-center">
                        <h5 className="mb-0">Department List</h5>
                        <div>
                            <Button
                                variant="info"
                                size="sm"
                                className="me-2"
                                onClick={() => setShowCreateForm(true)}
                            >
                                + New Department
                            </Button>
                            <Button variant="outline-info" size="sm" className="me-2">
                                Import
                            </Button>
                            <Button variant="outline-info" size="sm">
                                Export
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
                                <th style={{ width: "20%" }}>Department Name</th>
                                <th style={{ width: "20%" }}>Department Code</th>
                                <th style={{ width: "20%" }}>Status</th>
                                <th style={{ width: "20%" }}>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {currentEntries.map((departmentItem) => (
                                <tr key={departmentItem.id}>
                                    <td>{departmentItem.department_name}</td>
                                    <td>{departmentItem.department_code}</td>
                                    <td>{departmentItem.status ? "Active" : "Inactive"}</td>

                                    <td>
                                        <Button
                                            variant="link"
                                            className="text-primary p-0 me-2"
                                            onClick={() => handleEditClick(departmentItem)}
                                        >
                                            <Edit size={18} />
                                        </Button>
                                        <Button
                                            variant="link"
                                            className="text-danger p-0"
                                            onClick={() => handleDelete(departmentItem.id)}
                                        >
                                            <Trash size={18} />
                                        </Button>


                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>

                    <div className="d-flex justify-content-between align-items-center px-3 mt-3">
                        <span>
                            Showing {indexOfFirstEntry + 1} to{" "}
                            {Math.min(indexOfLastEntry, filteredDepartment.length)} of{" "}
                            {filteredDepartment.length} entries
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
                    <Offcanvas.Title>Create New Department</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    <Formik
                        initialValues={{
                            department_name: "",
                            department_code: "",
                            status: false
                        }}
                        validationSchema={validationSchema}
                        onSubmit={handleSubmit}
                    >
                        {({ errors, touched, isSubmitting,values }) => (
                            <Form>
                                <div className="row">
                                    <div className="col-md-6">
                                        <label>Department Name</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="department_name"
                                                className={`form-control ${touched.department_name && errors.department_name
                                                    ? "is-invalid"
                                                    : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="department_name"
                                                component="div"
                                                className="invalid-feedback"
                                            />
                                        </div>
                                    </div>
                                    <div className="col-md-6">
                                        <label>Department Code</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="department_code"
                                                className={`form-control ${touched.department_code && errors.department_code ? "is-invalid" : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="department_code"
                                                component="div"
                                                className="invalid-feedback"
                                            />
                                        </div>
                                    </div>
                                </div>

                                <div className="row mt-3">
                    <div className="col-md-6">
                      <label className="d-flex align-items-center">
                        <span className="me-2">Status</span>
                        <Field name="status" component={FormikSwitch} />
                        <span className="ms-2">
                          {values.status ? "Active" : "Inactive"}
                        </span>
                      </label>
                    </div>
                  </div>

                                <div className="row">
                                    <div className="col-md-12 d-flex justify-content-end">
                                        <button
                                            type="submit"
                                            className="btn btn-info my-4"
                                            disabled={isSubmitting}
                                        >
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
                    <Offcanvas.Title>Edit Department</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    {editingDepartment && (
                        <Formik
                            initialValues={{
                                department_name: editingDepartment.department_name,
                                department_code: editingDepartment.department_code,
                                status: editingDepartment.status,
                               
                            }}
                            validationSchema={editValidationSchema}
                            onSubmit={handleEditSubmit}
                        >
                            {({ errors, touched, isSubmitting,values }) => (
                                <Form>
                                  <div className="row">
                                    <div className="col-md-6">
                                        <label>Department Name</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="department_name"
                                                className={`form-control ${touched.department_name && errors.department_name
                                                    ? "is-invalid"
                                                    : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="department_name"
                                                component="div"
                                                className="invalid-feedback"
                                            />
                                        </div>
                                    </div>
                                    <div className="col-md-6">
                                        <label>Department Code</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="department_code"
                                                className={`form-control ${touched.department_code && errors.department_code ? "is-invalid" : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="department_code"
                                                component="div"
                                                className="invalid-feedback"
                                            />
                                        </div>
                                    </div>
                                </div>
           
                                <div className="row mt-3">
                    <div className="col-md-6">
                      <label className="d-flex align-items-center">
                        <span className="me-2">Status</span>
                        <Field name="status" component={FormikSwitch} />
                        <span className="ms-2">
                          {values.status ? "Active" : "Inactive"}
                        </span>
                      </label>
                    </div>
                  </div>
                                    <div className="row">
                                        <div className="col-md-12 d-flex justify-content-end">
                                            <button
                                                type="submit"
                                                className="btn btn-info my-4"
                                                disabled={isSubmitting}
                                            >
                                                {isSubmitting ? "Updating..." : "Update Department"}
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

export default DepartmentIndex;
