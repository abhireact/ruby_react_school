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

const validationSchema = Yup.object().shape({
  exam_type_name: Yup.string().required("Exam type name is required"),
  description: Yup.string(),
  index: Yup.string(),
});

const ExamType = ({ userData }) => {
  console.log(userData, "ruby controller data");
  const [examTypes, setExamTypes] = useState(userData.examtype_data || []);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingExamType, setEditingExamType] = useState(null);

  const filteredExamTypes = useMemo(() => {
    return examTypes.filter((examType) =>
      Object.entries(examType).some(([key, value]) => {
        if (typeof value === "string") {
          return value.toLowerCase().includes(searchTerm.toLowerCase());
        }
        return false;
      })
    );
  }, [examTypes, searchTerm]);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, entriesPerPage]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredExamTypes.slice(
    indexOfFirstEntry,
    indexOfLastEntry
  );

  const totalPages = Math.ceil(filteredExamTypes.length / entriesPerPage);

  const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

  const handleSubmit = (values, { setSubmitting }) => {
    const formattedData = selectedClass.map((item) => {
      const selectedItem = userData.class_section.find((c) => c[1] === item);
      return selectedItem ? selectedItem[1] : null;
    });

    // Filter out any null values (if they exist)
    const cleanedData = formattedData.filter((item) => item !== null);

    // Output or send data in the desired format
    console.log("Selected Class:", cleanedData);

    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch("/cbsc_examinations/create", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_exam_type: {
          ...values,
        },
        selected_class: cleanedData,
      }),
    })
      .then((response) => response.json())
      .then(() => {
        setShowCreateForm(false);
        resetForm(); // Reset the form fields
        setSelectedClass([]); // Reset the selected classes

        window.location.reload();
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const handleDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this exam type?")) {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      axios
        .delete(`/cbsc_examinations/${id}`, {
          headers: {
            "X-CSRF-Token": csrfToken,
          },
        })
        .then(() => {
          window.location.reload();
          setExamTypes(examTypes.filter((et) => et.id !== id));
        })
        .catch((error) => {
          console.error("Error deleting exam type:", error);
        });
    }
  };

  const handleEditClick = (examType) => {
    setEditingExamType(examType);
    setShowEditForm(true);
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    const formattedData = selectedClass.map((item) => {
      const selectedItem = userData.class_section.find((c) => c[1] === item);
      return selectedItem ? selectedItem[1] : null;
    });

    const cleanedData = formattedData.filter((item) => item !== null);

    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch(`/cbsc_examinations/${editingExamType.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_exam_type: {
          ...values,
        },
        selected_class: cleanedData,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setExamTypes(
          examTypes.map((et) => (et.id === editingExamType.id ? data : et))
        );
        setShowEditForm(false);
        window.location.reload();
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const [selectedClass, setSelectedClass] = useState([]);
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
              onClick={() => setShowCreateForm(true)}
            >
              + New Exam Type
            </Button>
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
                    <Button
                      variant="link"
                      className="text-danger p-0"
                      onClick={() => handleDelete(item.id)}
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
              {Math.min(indexOfLastEntry, filteredExamTypes.length)} of{" "}
              {filteredExamTypes.length} entries
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
              index: "",
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting }) => (
              <Form>
                <div className="row">
                  <div className="col-md-6">
                    <label>Index</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="index"
                        className={`form-control ${
                          touched.index && errors.index ? "is-invalid" : ""
                        }`}
                      />
                      <ErrorMessage
                        name="index"
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
                          touched.exam_type_name && errors.exam_type_name
                            ? "is-invalid"
                            : ""
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
                          touched.description && errors.description
                            ? "is-invalid"
                            : ""
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
                <div className="row">
                  <h3>Select Classes and Sections</h3>
                  <div
                    style={{
                      maxHeight: "300px",
                      overflowY: "scroll",
                      border: "1px solid #ccc",
                      padding: "10px",
                    }}
                  >
                    <div
                      style={{ display: "flex", flexWrap: "wrap", gap: "10px" }}
                    >
                      {userData.class_section.map(([name, id], index) => (
                        <div key={index} style={{ flex: "0 0 48%" }}>
                          {" "}
                          {/* Set width to 48% for two items per row */}
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
                <div className="row">
                  <div className="col-md-12 d-flex justify-content-end">
                    <button
                      type="submit"
                      className="btn btn-info my-4"
                      disabled={isSubmitting}
                    >
                      {isSubmitting ? "Creating..." : "Submit"}
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
                index: editingExamType.index,
              }}
              validationSchema={validationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Index</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="index"
                          className={`form-control ${
                            touched.index && errors.index ? "is-invalid" : ""
                          }`}
                        />
                        <ErrorMessage
                          name="index"
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
                            touched.exam_type_name && errors.exam_type_name
                              ? "is-invalid"
                              : ""
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
                            touched.description && errors.description
                              ? "is-invalid"
                              : ""
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
                  <div className="row">
                    <h3>Select Classes and Sections</h3>
                    <div
                      style={{
                        maxHeight: "300px",
                        overflowY: "scroll",
                        border: "1px solid #ccc",
                        padding: "10px",
                      }}
                    >
                      <div
                        style={{
                          display: "flex",
                          flexWrap: "wrap",
                          gap: "10px",
                        }}
                      >
                        {userData.class_section.map(([name, id], index) => (
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
                  <div className="row">
                    <div className="col-md-12 d-flex justify-content-end">
                      <button
                        type="submit"
                        className="btn btn-info my-4"
                        disabled={isSubmitting}
                      >
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
