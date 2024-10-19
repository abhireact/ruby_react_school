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
let dummyData = {
  academic_year_data: [175],
  examtype_data: [
    {
      id: 189,
      exam_type_name: "Term-1",
      description: "",
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      is_deleted: false,
      created_at: "2024-05-20T04:37:15.000Z",
      updated_at: "2024-05-20T04:37:15.000Z",
      index: 1,
      mg_time_table_id: 175,
    },
    {
      id: 190,
      exam_type_name: "Term-2",
      description: "",
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      is_deleted: false,
      created_at: "2024-05-20T04:37:15.000Z",
      updated_at: "2024-05-20T04:37:15.000Z",
      index: 2,
      mg_time_table_id: 175,
    },
    {
      id: 191,
      exam_type_name: "Academic Year",
      description: "",
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      is_deleted: false,
      created_at: "2024-05-20T04:37:15.000Z",
      updated_at: "2024-05-20T04:37:15.000Z",
      index: 3,
      mg_time_table_id: 175,
    },
  ],
  classes: [
    {
      id: 1868,
      course_name: "NURSERYdtest",
      code: "NUR",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-10-18T07:15:21.000Z",
      mg_time_table_id: 175,
      index: 1,
    },
    {
      id: 1869,
      course_name: "LKG",
      code: "LKG",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 250,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:20:49.000Z",
      mg_time_table_id: 175,
      index: 2,
    },
    {
      id: 1870,
      course_name: "UKG",
      code: "UKG",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 250,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:20:58.000Z",
      mg_time_table_id: 175,
      index: 3,
    },
    {
      id: 1871,
      course_name: "I",
      code: "I",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 251,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:21:07.000Z",
      mg_time_table_id: 175,
      index: 4,
    },
    {
      id: 1872,
      course_name: "II",
      code: "II",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 251,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:21:20.000Z",
      mg_time_table_id: 175,
      index: 5,
    },
    {
      id: 1873,
      course_name: "III",
      code: "III",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 251,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:21:30.000Z",
      mg_time_table_id: 175,
      index: 6,
    },
    {
      id: 1874,
      course_name: "IV",
      code: "IV",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 251,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:21:55.000Z",
      mg_time_table_id: 175,
      index: 7,
    },
    {
      id: 1875,
      course_name: "V",
      code: "V",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 251,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:22:01.000Z",
      mg_time_table_id: 175,
      index: 8,
    },
    {
      id: 1876,
      course_name: "VI",
      code: "VI",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:22:21.000Z",
      mg_time_table_id: 175,
      index: 9,
    },
    {
      id: 1877,
      course_name: "VII",
      code: "VII",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:22:25.000Z",
      mg_time_table_id: 175,
      index: 10,
    },
    {
      id: 1878,
      course_name: "VIII",
      code: "VIII",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:22:37.000Z",
      mg_time_table_id: 175,
      index: 11,
    },
    {
      id: 1879,
      course_name: "IX",
      code: "IX",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:22:55.000Z",
      mg_time_table_id: 175,
      index: 12,
    },
    {
      id: 1880,
      course_name: "X",
      code: "X",
      section_name: null,
      grading_type: "4",
      mg_wing_id: 252,
      is_deleted: false,
      mg_school_id: 71,
      created_by: 160098,
      updated_by: 160098,
      created_at: "2024-03-15T07:04:54.000Z",
      updated_at: "2024-03-15T07:23:05.000Z",
      mg_time_table_id: 175,
      index: 13,
    },
  ],
  userData: [
    {
      id: 1,
      name: "Alice Smith",
      email: "alice.smith@example.com",
      class_id: 1868,
    },
    {
      id: 2,
      name: "Bob Johnson",
      email: "bob.johnson@example.com",
      class_id: 1869,
    },
    {
      id: 3,
      name: "Charlie Brown",
      email: "charlie.brown@example.com",
      class_id: 1870,
    },
    {
      id: 4,
      name: "David Wilson",
      email: "david.wilson@example.com",
      class_id: 1871,
    },
    {
      id: 5,
      name: "Eva Davis",
      email: "eva.davis@example.com",
      class_id: 1872,
    },
    {
      id: 6,
      name: "Fiona Clark",
      email: "fiona.clark@example.com",
      class_id: 1873,
    },
    {
      id: 7,
      name: "George Martin",
      email: "george.martin@example.com",
      class_id: 1874,
    },
    {
      id: 8,
      name: "Hannah Lee",
      email: "hannah.lee@example.com",
      class_id: 1875,
    },
    {
      id: 9,
      name: "Ian Wright",
      email: "ian.wright@example.com",
      class_id: 1876,
    },
    {
      id: 10,
      name: "Julia Roberts",
      email: "julia.roberts@example.com",
      class_id: 1877,
    },
    {
      id: 11,
      name: "Kevin Brown",
      email: "kevin.brown@example.com",
      class_id: 1878,
    },
    {
      id: 12,
      name: "Lily Adams",
      email: "lily.adams@example.com",
      class_id: 1879,
    },
    {
      id: 13,
      name: "Michael Green",
      email: "michael.green@example.com",
      class_id: 1880,
    },
  ],
};
const validationSchema = Yup.object().shape({
  exam_type_name: Yup.string().required("Exam type name is required"),
  description: Yup.string(),
  index: Yup.string(),
});
function createCombinedCourseBatchData(data) {
  // Array to hold the combined course-batch data
  const combinedData = [];

  // Iterate through each user to get class and related course data
  data.userData?.forEach((user) => {
    // Find the class corresponding to the user's class_id
    const course = data.classes.find((course) => course.id === user.class_id);

    if (course) {
      // Create a combined object with the required fields
      const combinedEntry = {
        courseId: course.id,
        courseName: course.course_name,
        batchId: user.class_id,
        batchName: course.course_name, // Assuming batch name is the same as course name
      };

      // Add the combined entry to the combined data array
      combinedData.push(combinedEntry);
    }
  });

  return combinedData;
}
const ExamType = ({ userData }) => {
  const combinedCourseBatchData = createCombinedCourseBatchData(dummyData);
  console.log(combinedCourseBatchData, "combined course and batch ");
  console.log(userData, "ruby controller data");
  const [examTypes, setExamTypes] = useState(userData.examtype_data || []);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingExamType, setEditingExamType] = useState(null);
  const [selectedClasses, setSelectedClasses] = useState([]);

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
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch("/cbsc_examinations", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_exam_type: {
          ...values,
        },
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setExamTypes([...examTypes, data]);
        setShowCreateForm(false);
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

        selected_class: selectedClasses,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setExamTypes(
          examTypes.map((et) => (et.id === editingExamType.id ? data : et))
        );
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
              }}
              validationSchema={validationSchema}
              onSubmit={handleEditSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                <Form>
                  <div className="row">
                    <div className="col-md-12">
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
                    <div className="col-md-12">
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
                    <div className="col-md-12">
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
