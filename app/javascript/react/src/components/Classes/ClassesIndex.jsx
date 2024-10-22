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
import { Eye, Edit, Trash, Search, List } from "lucide-react";

function convertDateFormat(dateString) {
  // Split the date string into an array
  const [year, month, day] = dateString.split("-");

  // Return the formatted date
  return `${day}/${month}/${year}`;
}

const validationSchema = Yup.object().shape({
  course_name: Yup.string().required("Class name is required"),
  code: Yup.string().required("Class code is required"),
  mg_time_table_id: Yup.string().required("Academic Year is required"),
  mg_wing_id: Yup.string().required("Wing is required"),
  batch: Yup.object().shape({
    name: Yup.string().required("Batch name is required"),
    start_date: Yup.date().required("Start date is required"),
    end_date: Yup.date().required("End date is required"),
  }),
});
const editValidationSchema = Yup.object().shape({
  course_name: Yup.string().required("Class name is required"),
  code: Yup.string().required("Class code is required"),
  mg_wing_id: Yup.string().required("Wing is required"),
  mg_time_table_id: Yup.string().required("Academic Year is required"),
});

const ClassesIndex = ({ userData }) => {
  console.log(userData, "user data");

  const [classes, setClasses] = useState(userData.classes || []);
  const [wings, setWings] = useState(userData.wings_data || []);
  const [academicYears, setAcademicYears] = useState(
    userData.academic_year_data || []
  );
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

  const handleSubmit = (values, { setSubmitting }) => {
    values.mg_time_table_id = Number(values.mg_time_table_id);
    values.mg_wing_id = Number(values.mg_wing_id);
    values.batch.end_date = convertDateFormat(values.batch.end_date);
    values.batch.start_date = convertDateFormat(values.batch.start_date);
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch("/classes", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_course: {
          course_name: values.course_name,
          code: values.code,
          mg_wing_id: values.mg_wing_id,
          mg_time_table_id: values.mg_time_table_id,
          section_name: values.batch.name,
        },
        batch: values.batch,
        mg_time_table_id: userData.current_academic_year_id,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setClasses([...classes, data]);
        setShowCreateForm(false);
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const handleDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this class?")) {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      axios
        .delete(`/classes/${id}`, {
          headers: {
            "X-CSRF-Token": csrfToken,
          },
        })
        .then(() => {
          setClasses(classes.filter((c) => c.id !== id));
          // Optionally, you can add a success message here
        })
        .catch((error) => {
          console.error("Error deleting class:", error);
          // Optionally, you can add an error message here
        });
    }
  };

  const [showSectionsModal, setShowSectionsModal] = useState(false);
  const [sections, setSections] = useState([]);
  const [selectedClass, setSelectedClass] = useState(null);
  // New function to fetch and show sections
  const handleSections = (id) => {
    axios
      .get(`/classes/${id}/batchList`)
      .then((response) => {
        setSections(response.data);
        setShowSectionsModal(true);
        setSelectedClass(classes.find((c) => c.id === id));
      })
      .catch((error) => {
        console.error("Error fetching sections:", error);
      });
  };

  const [showEditForm, setShowEditForm] = useState(false);
  const [editingClass, setEditingClass] = useState(null);

  // ... (keep existing functions)

  const handleEditClick = (classItem) => {
    setEditingClass(classItem);
    setShowEditForm(true);
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch(`/classes/${editingClass.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        course: {
          course_name: values.course_name,
          code: values.code,
          mg_wing_id: values.mg_wing_id,
          mg_time_table_id: values.mg_time_table_id,
        },
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setClasses(classes.map((c) => (c.id === editingClass.id ? data : c)));
        setShowEditForm(false);
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Classes</h5>
            <div>
              <Button
                variant="info"
                size="sm"
                className="me-2"
                onClick={() => setShowCreateForm(true)}
              >
                + New Class
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
                <th style={{ width: "20%" }}>Class Name</th>
                <th style={{ width: "20%" }}>Section</th>
                <th style={{ width: "20%" }}>Code</th>
                <th style={{ width: "20%" }}>Wing</th>
                <th style={{ width: "20%" }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((classItem) => (
                <tr key={classItem.id}>
                  <td>{classItem.course_name}</td>
                  <td>{classItem.section_name}</td>
                  <td>{classItem.code}</td>
                  <td>{classItem.mg_wing_id}</td>
                  <td>
                    <Button
                      variant="link"
                      className="text-primary p-0 me-2"
                      onClick={() => handleEditClick(classItem)}
                    >
                      <Edit size={18} />
                    </Button>
                    <Button
                      variant="link"
                      className="text-danger p-0"
                      onClick={() => handleDelete(classItem.id)}
                    >
                      <Trash size={18} />
                    </Button>
                    <Button
                      variant="link"
                      className="text-info p-0"
                      onClick={() => handleSections(classItem.id)}
                    >
                      <List size={18} />
                    </Button>
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
          <Offcanvas.Title>Create New Class</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              course_name: "",
              code: "",
              mg_wing_id: "",
              mg_time_table_id: "",
              mg_school_id: userData.school_id,

              batch: {
                name: "",
                start_date: "",
                end_date: "",
                mg_school_id: userData.school_id,
              },
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting }) => (
              <Form>
                <div className="row">
                  <div className="col-md-6">
                    <label>Class Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="course_name"
                        className={`form-control ${
                          touched.course_name && errors.course_name
                            ? "is-invalid"
                            : ""
                        }`}
                      />
                      <ErrorMessage
                        name="course_name"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <label>Class Code</label>
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
                </div>

                <div className="row">
                  <div className="col-md-6">
                    <label>Wing</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        as="select"
                        name="mg_wing_id"
                        className={`form-control ${
                          touched.mg_wing_id && errors.mg_wing_id
                            ? "is-invalid"
                            : touched.mg_wing_id
                            ? "is-valid"
                            : ""
                        }`}
                      >
                        <option value="" label="Select wing" />
                        {wings.map((wing) => (
                          <option key={wing.id} value={wing.id}>
                            {wing.wing_name}
                          </option>
                        ))}
                      </Field>
                      <ErrorMessage
                        name="mg_wing_id"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <label>Academic Year</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        as="select"
                        name="mg_time_table_id"
                        className={`form-control ${
                          touched.mg_time_table_id && errors.mg_time_table_id
                            ? "is-invalid"
                            : touched.mg_time_table_id
                            ? "is-valid"
                            : ""
                        }`}
                      >
                        <option value="" label="Select academic year" />
                        {academicYears.map((year) => (
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
                </div>

                <div className="row mt-4">
                  <div className="col-md-12">
                    <h5>Batch Details</h5>
                  </div>
                  <div className="col-md-4">
                    <label>Section Name</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="batch.name"
                        className={`form-control ${
                          touched.batch?.name && errors.batch?.name
                            ? "is-invalid"
                            : ""
                        }`}
                      />
                      <ErrorMessage
                        name="batch.name"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>Start Date</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="date"
                        name="batch.start_date"
                        className={`form-control ${
                          touched.batch?.start_date && errors.batch?.start_date
                            ? "is-invalid"
                            : ""
                        }`}
                      />
                      <ErrorMessage
                        name="batch.start_date"
                        component="div"
                        className="invalid-feedback"
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <label>End Date</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        type="date"
                        name="batch.end_date"
                        className={`form-control ${
                          touched.batch?.end_date && errors.batch?.end_date
                            ? "is-invalid"
                            : ""
                        }`}
                      />
                      <ErrorMessage
                        name="batch.end_date"
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
                      {isSubmitting ? "Creating..." : "Create Class"}
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
          <Offcanvas.Title>Edit Class</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingClass && (
            <Formik
              initialValues={{
                course_name: editingClass.course_name,
                code: editingClass.code,
                mg_wing_id: editingClass.mg_wing_id,
                mg_time_table_id: editingClass.mg_time_table_id,
              }}
              validationSchema={editValidationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-6">
                      <label>Class Name</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          name="course_name"
                          className={`form-control ${
                            touched.course_name && errors.course_name
                              ? "is-invalid"
                              : ""
                          }`}
                        />
                        <ErrorMessage
                          name="course_name"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                    <div className="col-md-6">
                      <label>Class Code</label>
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
                  </div>

                  <div className="row">
                    <div className="col-md-6">
                      <label>Wing</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          as="select"
                          name="mg_wing_id"
                          className={`form-control ${
                            touched.mg_wing_id && errors.mg_wing_id
                              ? "is-invalid"
                              : ""
                          }`}
                        >
                          <option value="" label="Select wing" />
                          {wings.map((wing) => (
                            <option key={wing.id} value={wing.id}>
                              {wing.wing_name}
                            </option>
                          ))}
                        </Field>
                        <ErrorMessage
                          name="mg_wing_id"
                          component="div"
                          className="invalid-feedback"
                        />
                      </div>
                    </div>
                    <div className="col-md-6">
                      <label>Academic Year</label>
                      <div className="input-group input-group-outline my-1">
                        <Field
                          as="select"
                          name="mg_time_table_id"
                          className={`form-control ${
                            touched.mg_time_table_id && errors.mg_time_table_id
                              ? "is-invalid"
                              : ""
                          }`}
                        >
                          <option value="" label="Select academic year" />
                          {academicYears.map((year) => (
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
                  </div>

                  <div className="row">
                    <div className="col-md-12 d-flex justify-content-end">
                      <button
                        type="submit"
                        className="btn btn-info my-4"
                        disabled={isSubmitting}
                      >
                        {isSubmitting ? "Updating..." : "Update Class"}
                      </button>
                    </div>
                  </div>
                </Form>
              )}
            </Formik>
          )}
        </Offcanvas.Body>
      </Offcanvas>
      <Modal
        show={showSectionsModal}
        onHide={() => setShowSectionsModal(false)}
        size="lg"
      >
        <Modal.Header closeButton>
          <Modal.Title>Sections in {selectedClass?.course_name}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <ul>
            {sections.map((section) => (
              <li key={section.id}>{section.name}</li>
            ))}
          </ul>
        </Modal.Body>
        <Modal.Footer>
          <Button
            variant="secondary"
            onClick={() => setShowSectionsModal(false)}
          >
            Close
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default ClassesIndex;
