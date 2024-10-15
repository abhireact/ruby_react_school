import React, { useState, useEffect } from "react";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import axios from "axios";
import { Search, Eye, Edit, Trash } from "lucide-react";
import { useTranslation } from "react-i18next";

const validationSchema = Yup.object().shape({
  first_name: Yup.string().required("First name is required"),
  last_name: Yup.string().required("Last name is required"),
  // employee_number: Yup.string().required("Employee number is required"),
  // job_title: Yup.string().required("Job title is required"),
  // department: Yup.string().required("Department is required"),
  // joining_date: Yup.date().required("Joining date is required"),
  // email: Yup.string().email("Invalid email").required("Email is required"),
  // mobile_number: Yup.string().required("Mobile number is required"),
});

const EmployeeList = ({ userData }) => {
  const [employees, setEmployees] = useState([]);
  const [filteredEmployees, setFilteredEmployees] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [selectedEmployee, setSelectedEmployee] = useState(null);
  const [isAddingEmployee, setIsAddingEmployee] = useState(false);

  useEffect(() => {
    const parsedEmployees = Array.isArray(userData)
      ? userData
      : JSON.parse(userData);
    setEmployees(parsedEmployees);
    setFilteredEmployees(parsedEmployees);
  }, [userData]);

  useEffect(() => {
    const results = employees.filter((employee) =>
      Object.values(employee).some((value) =>
        value.toString().toLowerCase().includes(searchTerm.toLowerCase())
      )
    );
    setFilteredEmployees(results);
    setCurrentPage(1);
  }, [searchTerm, employees]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredEmployees.slice(
    indexOfFirstEntry,
    indexOfLastEntry
  );

  const totalPages = Math.ceil(filteredEmployees.length / entriesPerPage);

  const handleEditClick = (employee) => {
    setSelectedEmployee(employee);
    setIsAddingEmployee(false);
    const offcanvasElement = document.getElementById("employeeFormDrawer");
    const offcanvas = new bootstrap.Offcanvas(offcanvasElement);
    offcanvas.show();
  };

  const handleAddClick = () => {
    setSelectedEmployee(null);
    setIsAddingEmployee(true);
    const offcanvasElement = document.getElementById("employeeFormDrawer");
    const offcanvas = new bootstrap.Offcanvas(offcanvasElement);
    offcanvas.show();
  };

  const handleSubmit = async (values, { setSubmitting, resetForm }) => {
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const url = isAddingEmployee
        ? "/employees"
        : `/employees/${selectedEmployee.id}`;
      const method = isAddingEmployee ? "post" : "patch";

      const response = await axios({
        method: method,
        url: url,
        data: { employee: values },
        headers: { "X-CSRF-Token": token },
      });

      console.log(
        isAddingEmployee
          ? "Employee added successfully"
          : "Employee info updated successfully"
      );

      if (isAddingEmployee) {
        setEmployees([...employees, response.data]);
      } else {
        setEmployees(
          employees.map((emp) =>
            emp.id === selectedEmployee.id ? response.data : emp
          )
        );
      }

      const offcanvasElement = document.getElementById("employeeFormDrawer");
      const offcanvas = bootstrap.Offcanvas.getInstance(offcanvasElement);
      offcanvas.hide();
      resetForm();
    } catch (error) {
      console.error(
        isAddingEmployee
          ? "Error adding employee"
          : "Error updating employee info",
        error
      );
    } finally {
      setSubmitting(false);
    }
  };
 const { t, i18n } = useTranslation("common");

 const changeEng = () => {
   i18n.changeLanguage("en");
 };

 const changeHin = () => {
   i18n.changeLanguage("hindi");
 };

 const changeArab = () => {
   i18n.changeLanguage("arabic");
 };
  return (
    <div className="container-fluid py-4">
       <>
      HOME: {t("HOME")} Greetings: {t('Hi')}
      <button onClick={changeEng}>Translate English</button>
      <button onClick={changeHin}>Translate Hindi</button>
      <button onClick={changeArab}>Translate Arabic</button>
    </>
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="card-header pb-0">
              <div className="d-lg-flex">
                <div>
                  <h5 className="mb-0">Employee List</h5>
                </div>
                <div className="ms-auto my-auto mt-lg-0 mt-4">
                  <div className="ms-auto my-auto">
                    <button
                      className="btn btn-info btn-sm mb-0"
                      onClick={handleAddClick}
                    >
                      + New Employee
                    </button>
                    <button
                      className="btn btn-outline-info btn-sm export mb-0 ms-2"
                      data-type="csv"
                    >
                      Export
                    </button>
                  </div>
                </div>
              </div>
            </div>
            <div className="card-body px-0 pb-0">
              <div className="table-responsive p-0">
                <div className="d-flex justify-content-between align-items-center px-3 py-3">
                  <div className="d-flex align-items-center">
                    <span>Show</span>
                    <select
                      className="form-select form-select-sm mx-2"
                      value={entriesPerPage}
                      onChange={(e) =>
                        setEntriesPerPage(Number(e.target.value))
                      }
                    >
                      <option value={10}>10</option>
                      <option value={25}>25</option>
                      <option value={50}>50</option>
                      <option value={100}>100</option>
                    </select>
                    <span>entries</span>
                  </div>
                  <div className="input-group input-group-outline w-auto">
                    <Search size={18} className="input-group-text" />
                    <input
                      type="text"
                      className="form-control"
                      placeholder="Search..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                  </div>
                </div>
                <table className="table table-flush" id="employees-list">
                  <thead className="thead-light">
                    <tr>
                      <th>Employee Number</th>
                      <th>Name</th>
                      <th>Job Title</th>
                      <th>Department</th>
                      <th>Joining Date</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {currentEntries.map((employee) => (
                      <tr key={employee.id}>
                        <td>{employee.employee_number}</td>
                        <td>{`${employee.first_name} ${employee.last_name}`}</td>
                        <td>{employee.job_title}</td>
                        <td>{employee.department}</td>
                        <td>{employee.joining_date}</td>
                        <td>{employee.status}</td>
                        <td>
                          <button className="btn btn-link text-secondary p-0 me-2">
                            <Eye size={18} />
                          </button>
                          <button
                            className="btn btn-link text-secondary p-0 me-2"
                            onClick={() => handleEditClick(employee)}
                          >
                            <Edit size={18} />
                          </button>
                          <button className="btn btn-link text-secondary p-0">
                            <Trash size={18} />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <div className="d-flex justify-content-end mt-3">
                <nav aria-label="Page navigation">
                  <ul className="pagination">
                    <li
                      className={`page-item ${
                        currentPage === 1 ? "disabled" : ""
                      }`}
                    >
                      <button
                        className="page-link"
                        onClick={() => setCurrentPage(currentPage - 1)}
                      >
                        &lt;
                      </button>
                    </li>
                    {[...Array(totalPages)].map((_, i) => (
                      <li
                        key={i}
                        className={`page-item ${
                          currentPage === i + 1 ? "active" : ""
                        }`}
                      >
                        <button
                          className="page-link"
                          onClick={() => setCurrentPage(i + 1)}
                        >
                          {i + 1}
                        </button>
                      </li>
                    ))}
                    <li
                      className={`page-item ${
                        currentPage === totalPages ? "disabled" : ""
                      }`}
                    >
                      <button
                        className="page-link"
                        onClick={() => setCurrentPage(currentPage + 1)}
                      >
                        &gt;
                      </button>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Offcanvas for Editing */}
      <div
        className="offcanvas offcanvas-end"
        tabIndex="-1"
        id="employeeFormDrawer"
        aria-labelledby="employeeFormDrawerLabel"
        style={{ width: "60%" }}
      >
        <div className="offcanvas-header">
          <button
            type="button"
            className="btn-close"
            data-bs-dismiss="offcanvas"
            aria-label="Close"
          ></button>
        </div>
        <div className="offcanvas-body">
          <div className="card">
            <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
              <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
                <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
                  {isAddingEmployee
                    ? "Add New Employee"
                    : "Edit Employee Information"}
                </h4>
              </div>
            </div>
            <div className="card-body">
              <Formik
                initialValues={{
                  first_name: selectedEmployee?.first_name || "",
                  last_name: selectedEmployee?.last_name || "",
                  employee_number: selectedEmployee?.employee_number || "",
                  job_title: selectedEmployee?.job_title || "",
                  department: selectedEmployee?.department || "",
                  joining_date: selectedEmployee?.joining_date || "",
                  email: selectedEmployee?.email || "",
                  mobile_number: selectedEmployee?.mobile_number || "",
                }}
                validationSchema={validationSchema}
                onSubmit={handleSubmit}
                enableReinitialize
              >
                {({ errors, touched, isSubmitting }) => (
                  <Form>
                    <div className="row">
                      <div className="col-md-6">
                        <label htmlFor="first_name">First Name</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="first_name"
                            className={`form-control ${
                              touched.first_name && errors.first_name
                                ? "is-invalid"
                                : ""
                            }`}
                            placeholder="First Name"
                          />
                          <ErrorMessage
                            name="first_name"
                            component="div"
                            className="invalid-feedback"
                          />
                        </div>
                      </div>
                      <div className="col-md-6">
                        <label htmlFor="last_name">Last Name</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="last_name"
                            className={`form-control ${
                              touched.last_name && errors.last_name
                                ? "is-invalid"
                                : ""
                            }`}
                            placeholder="Last Name"
                          />
                          <ErrorMessage
                            name="last_name"
                            component="div"
                            className="invalid-feedback"
                          />
                        </div>
                      </div>
                    </div>

                    {/* Add more fields here following the same pattern */}

                    <div className="row">
                      <div className="col-md-12 d-flex justify-content-end">
                        <button
                          type="submit"
                          className="btn btn-info my-4"
                          disabled={isSubmitting}
                        >
                          {isSubmitting
                            ? isAddingEmployee
                              ? "Adding..."
                              : "Updating..."
                            : isAddingEmployee
                            ? "Add Employee"
                            : "Update Employee"}
                        </button>
                      </div>
                    </div>
                  </Form>
                )}
              </Formik>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmployeeList;
