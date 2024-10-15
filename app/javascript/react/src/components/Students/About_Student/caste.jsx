import React, { useState, useEffect, useMemo, useCallback } from "react";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import * as XLSX from "xlsx";
import axios from "axios";

import {
  Table,
  Button,
  Form as BootstrapForm,
  InputGroup,
  Pagination,
} from "react-bootstrap";
import { Eye, Edit, Trash, Search } from "lucide-react";

// Custom hook for search functionality
const useSearch = (items, searchKeys) => {
  const [searchTerm, setSearchTerm] = useState("");

  const filteredItems = useMemo(() => {
    if (!searchTerm) return items;
    return items.filter((item) =>
      searchKeys.some((key) =>
        item[key].toString().toLowerCase().includes(searchTerm.toLowerCase())
      )
    );
  }, [items, searchTerm, searchKeys]);

  return { searchTerm, setSearchTerm, filteredItems };
};

// Custom hook for pagination
const usePagination = (items, itemsPerPage) => {
  const [currentPage, setCurrentPage] = useState(1);
  const [pageRange, setPageRange] = useState({ start: 1, end: 3 });

  const totalPages = Math.ceil(items.length / itemsPerPage);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

  const paginate = useCallback(
    (pageNumber) => {
      setCurrentPage(pageNumber);
      const rangeSize = 3;
      if (pageNumber > pageRange.end) {
        setPageRange((prev) => ({
          start: prev.start + 1,
          end: prev.end + 1,
        }));
      } else if (pageNumber < pageRange.start) {
        setPageRange((prev) => ({
          start: prev.start - 1,
          end: prev.end - 1,
        }));
      }
    },
    [pageRange]
  );

  return {
    currentItems,
    currentPage,
    totalPages,
    paginate,
    pageRange,
  };
};

const CasteDetails = ({ userData }) => {
  const [academicYears, setAcademicYears] = useState([]);
  const [showDrawer, setShowDrawer] = useState(false);
  const [editData, setEditData] = useState(null);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    const parsedYears =git 
      typeof userData === "string" ? JSON.parse(userData) : userData;
    setAcademicYears(parsedYears);
  }, [userData]);

  const {
    searchTerm,
    setSearchTerm,
    filteredItems: filteredYears,
  } = useSearch(academicYears, ["name", "start_date", "end_date"]);

  const {
    currentItems: currentEntries,
    currentPage,
    totalPages,
    paginate,
    pageRange,
  } = usePagination(filteredYears, entriesPerPage);

  const handleShowDrawer = useCallback((year = null) => {
    if (year) {
      setEditData(year);
    } else {
      setEditData(null);
    }
    setShowDrawer(true);
  }, []);

  const handleCloseDrawer = useCallback(() => {
    setShowDrawer(false);
    setEditData(null);
    setErrorMessage("");
  }, []);

  const handleFormSubmit = useCallback(
    async (values, { setSubmitting, setErrors }) => {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      try {
        let response;
        const headers = {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        };

        const payload = { academic: values };

        if (editData) {
          response = await axios.patch(
            `/academic_years/${editData.id}`,
            payload,
            { headers }
          );
        } else {
          response = await axios.post("/academic_years", payload, { headers });
        }

        if (response.status === 200) {
          const updatedAcademicYear = response.data;
          setAcademicYears((prevYears) => {
            if (editData) {
              return prevYears.map((year) =>
                year.id === editData.id ? updatedAcademicYear : year
              );
            } else {
              return [...prevYears, updatedAcademicYear];
            }
          });
          handleCloseDrawer();
          setErrorMessage("");
        }
      } catch (error) {
        console.error("There was an error submitting the form!", error);
        if (error.response) {
          if (error.response.status === 404) {
            setErrorMessage("Academic Year not found.");
          } else if (error.response.status === 422) {
            setErrors(error.response.data.errors);
          } else {
            setErrorMessage("An error occurred while processing your request.");
          }
        } else {
          setErrorMessage("An unexpected error occurred. Please try again.");
        }
      } finally {
        setSubmitting(false);
      }
    },
    [editData, handleCloseDrawer]
  );

  const handleDelete = useCallback(async (id) => {
    if (window.confirm("Are you sure you want to delete this academic year?")) {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      try {
        // Make the API call to delete the academic year
        await axios.delete(`/academic_years/${id}`, {
          headers: { "X-CSRF-Token": token },
        });

        console.log("Academic year deleted successfully");

        // Update the local state to remove the deleted academic year
        setAcademicYears((prevYears) =>
          prevYears.filter((year) => year.id !== id)
        );
      } catch (error) {
        console.error("Error deleting academic year", error);
        // Handle errors, maybe show an alert to the user
        alert(
          "There was an error deleting the academic year. Please try again."
        );
      }
    }
  }, []);

  const handleExport = useCallback(() => {
    const ws = XLSX.utils.json_to_sheet(academicYears);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Academic Years");
    XLSX.writeFile(wb, "academic_years.xlsx");
  }, [academicYears]);

  const handleImport = useCallback((e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = (event) => {
      const data = new Uint8Array(event.target.result);
      const workbook = XLSX.read(data, { type: "array" });
      const firstSheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[firstSheetName];
      const json = XLSX.utils.sheet_to_json(worksheet);
      setAcademicYears(json);
    };
    reader.readAsArrayBuffer(file);
  }, []);

  return (
    <div className="container-fluid py-4">
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="card-header pb-0">
              <div className="d-lg-flex">
                <div>
                  <h5 className="mb-0">Academic Year Management</h5>
                  <p className="text-sm mb-0">
                    Manage academic years, their start dates, and end dates.
                  </p>
                </div>
                <div className="ms-auto my-auto mt-lg-0 mt-4">
                  <div className="ms-auto my-auto">
                    <Button
                      variant="info"
                      size="sm"
                      className="mb-0"
                      onClick={() => handleShowDrawer()}
                    >
                      + New Academic Year
                    </Button>
                    <Button
                      variant="outline-info"
                      size="sm"
                      className="mb-0 ms-2"
                      onClick={() =>
                        document.getElementById("fileInput").click()
                      }
                    >
                      Import
                    </Button>
                    <Button
                      variant="outline-info"
                      size="sm"
                      className="export mb-0 ms-2"
                      onClick={handleExport}
                    >
                      Export
                    </Button>
                    <input
                      type="file"
                      id="fileInput"
                      style={{ display: "none" }}
                      accept=".xlsx"
                      onChange={handleImport}
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className="card-body px-0 pb-0">
              <div className="table-responsive p-0">
                <div className="d-flex justify-content-between align-items-center px-3 py-3">
                  <div className="d-flex align-items-center">
                    <span>Show</span>
                    <BootstrapForm.Select
                      size="sm"
                      className="mx-2"
                      value={entriesPerPage}
                      onChange={(e) =>
                        setEntriesPerPage(Number(e.target.value))
                      }
                    >
                      <option value={10}>10</option>
                      <option value={25}>25</option>
                      <option value={50}>50</option>
                      <option value={100}>100</option>
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
                <Table id="academic-years-list" className="table table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th>Academic Year</th>
                      <th>Start Date</th>
                      <th>End Date</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {currentEntries.map((year) => (
                      <tr key={year.id}>
                        <td>{year.name}</td>
                        <td>{year.start_date}</td>
                        <td>{year.end_date}</td>
                        <td>
                          <Button
                            variant="link"
                            className="text-secondary p-0 me-2"
                          >
                            <Eye size={18} />
                          </Button>
                          <Button
                            variant="link"
                            className="text-secondary p-0 me-2"
                            onClick={() => handleShowDrawer(year)}
                          >
                            <Edit size={18} />
                          </Button>
                          <Button
                            variant="link"
                            className="text-secondary p-0"
                            onClick={() => handleDelete(year.id)}
                          >
                            <Trash size={18} />
                          </Button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              </div>
              <div className="d-flex justify-content-end align-items-center mt-3">
                <span className="me-3">
                  Page {currentPage} of {totalPages}
                </span>
                <Pagination className="custom-pagination">
                  <Pagination.Prev
                    className="prev"
                    disabled={currentPage === 1}
                    onClick={() => paginate(currentPage - 1)}
                  >
                    &lt;
                  </Pagination.Prev>
                  {Array.from({ length: totalPages })
                    .map((_, index) => index + 1)
                    .filter(
                      (number) =>
                        number === 1 ||
                        number === totalPages ||
                        (number >= currentPage - 1 && number <= currentPage + 1)
                    )
                    .map((number, index, array) => (
                      <React.Fragment key={number}>
                        {index > 0 && array[index - 1] !== number - 1 && (
                          <Pagination.Ellipsis />
                        )}
                        <Pagination.Item
                          active={number === currentPage}
                          onClick={() => paginate(number)}
                        >
                          {number}
                        </Pagination.Item>
                      </React.Fragment>
                    ))}
                  <Pagination.Next
                    className="next"
                    disabled={currentPage === totalPages}
                    onClick={() => paginate(currentPage + 1)}
                  >
                    &gt;
                  </Pagination.Next>
                </Pagination>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Offcanvas for Editing */}
      <div
        className={`offcanvas offcanvas-end ${showDrawer ? "show" : ""}`}
        tabIndex="-1"
        id="editDrawer"
        aria-labelledby="editDrawerLabel"
        style={{ width: "40%", visibility: showDrawer ? "visible" : "hidden" }}
      >
        <div className="offcanvas-header">
          <h5 className="offcanvas-title" id="editDrawerLabel">
            {editData ? "Update Academic Year" : "New Academic Year"}
          </h5>
          <button
            type="button"
            style={{
              backgroundColor: "transparent",
              border: "none",
              color: "#000",
              fontSize: "1.5rem",
              cursor: "pointer",
            }}
            aria-label="Close"
            onClick={handleCloseDrawer}
          >
            &times;
          </button>
        </div>
        <div className="offcanvas-body">
          <div className="card">
            <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
              <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
                <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
                  Fill the Academic Year Info below
                </h4>
              </div>
            </div>
            <div className="card-body">
              {errorMessage && (
                <div className="alert alert-danger" role="alert">
                  {errorMessage}
                </div>
              )}
              <Formik
                initialValues={{
                  name: editData ? editData.name : "",
                  start_date: editData ? editData.start_date : "",
                  end_date: editData ? editData.end_date : "",
                }}
                enableReinitialize={true}
                validationSchema={Yup.object({
                  name: Yup.string().required("Required"),
                  start_date: Yup.date().required("Required"),
                  end_date: Yup.date()
                    .required("Required")
                    .min(
                      Yup.ref("start_date"),
                      "End date must be after start date"
                    ),
                })}
                onSubmit={handleFormSubmit}
              >
                {({ errors, touched, isSubmitting }) => (
                  <Form>
                    <div className="row">
                      <div className="col-md-12">
                        <label htmlFor="name">Academic Year</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="name"
                            className={`form-control ${
                              touched.name && errors.name ? "is-invalid" : ""
                            }`}
                            placeholder="Academic Year"
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
                      <div className="col-md-6">
                        <label htmlFor="start_date">Start Date</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="start_date"
                            type="date"
                            className={`form-control ${
                              touched.start_date && errors.start_date
                                ? "is-invalid"
                                : ""
                            }`}
                          />
                          <ErrorMessage
                            name="start_date"
                            component="div"
                            className="invalid-feedback"
                          />
                        </div>
                      </div>

                      <div className="col-md-6">
                        <label htmlFor="end_date">End Date</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            name="end_date"
                            type="date"
                            className={`form-control ${
                              touched.end_date && errors.end_date
                                ? "is-invalid"
                                : ""
                            }`}
                          />
                          <ErrorMessage
                            name="end_date"
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
                          {isSubmitting
                            ? "Updating..."
                            : editData
                            ? "Update"
                            : "Create"}
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

export default CasteDetails;
