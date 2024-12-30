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
import { message } from 'antd';
import { Popconfirm } from 'antd';


const validationSchema = Yup.object().shape({
    mg_employee_category_id: Yup.string().required("Employee Category is required"),
    position_name: Yup.string().required("Position Name is required"),
});
const editValidationSchema = Yup.object().shape({
    mg_employee_category_id: Yup.string().required("Employee Category is required"),
    position_name: Yup.string().required("Position Name is required"),
});



const EmployeeProfile = ({ userData }) => {
    console.log(userData, "user data");
    
  
    const convertedData = userData.categoryData.map(([category_name, category_id]) => ({ category_id, category_name }));


    const categoryMap = {};
    convertedData?.forEach(item => {
        categoryMap[item.category_id] = item.category_name;
    });

    const [categoryData,SetCategoryData] = useState(convertedData|| []);
    console.log(categoryData,"category data")
    const [profileData, setProfileData] = useState([]);
    const fetchData = () => {
        axios.get(`mg_employee_positions/show_positions`)
          .then(response => {
             console.log(response.data,"response data")// userData.positionData
             setProfileData(response.data.map(item => {
                return {
                    ...item,
                    mg_employee_category_id: categoryMap[item.mg_employee_category_id] || "Unknown"
                };
            })
            || []);
          })
          .catch(error => {
            console.error("Error while fetching data", error);
          });
      };
      useEffect(()=>{fetchData();},[])

    const [showCreateForm, setShowCreateForm] = useState(false);
    const [searchTerm, setSearchTerm] = useState("");
    const [currentPage, setCurrentPage] = useState(1);
    const [entriesPerPage, setEntriesPerPage] = useState(10);

    const filteredProfile = useMemo(() => {
        return profileData.filter((profileItem) =>
            Object.entries(profileItem).some(([key, value]) => {
                if (typeof value === "string") {
                    return value.toLowerCase().includes(searchTerm.toLowerCase());
                }
                return false;
            })
        );
    }, [profileData, searchTerm]);

    useEffect(() => {
        setCurrentPage(1);
    }, [searchTerm, entriesPerPage]);

    const indexOfLastEntry = currentPage * entriesPerPage;
    const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
    const currentEntries = filteredProfile.slice(
        indexOfFirstEntry,
        indexOfLastEntry
    );

    const totalPages = Math.ceil(filteredProfile.length / entriesPerPage);

    const handlePageChange = (pageNumber) => setCurrentPage(pageNumber);

    const handleSubmit = (values, { setSubmitting }) => {

        const token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

        fetch("/mg_employee_positions/create", {
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
                fetchData();
                message.success("Created Successfully")
            })
            .catch((error) => console.error("Error:", error))
            .finally(() => setSubmitting(false));
    };

    const handleDelete = (id) => {
      
            const csrfToken = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content");

            axios
                .delete(`/mg_employee_positions/${id}`, {
                    headers: {
                        "X-CSRF-Token": csrfToken,
                    },
                })
                .then(() => {
                    fetchData();
                      message.success("Deleted Successfully")
                    // Optionally, you can add a success message here
                })
                .catch((error) => {
                    console.error("Error Deleting Department:", error);

                });
      
    };



 

    const [showEditForm, setShowEditForm] = useState(false);
    const [editingProfile, setEditingProfile] = useState(null);

    // ... (keep existing functions)

    const handleEditClick = (profileItem) => {
        setEditingProfile({
            ...profileItem,
            mg_employee_category_id: Object.keys(categoryMap).find(
                key => categoryMap[key] === profileItem.mg_employee_category_id
            )
        });
        setShowEditForm(true);
    };
    

    const handleEditSubmit = (values, { setSubmitting }) => {
        const token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

        fetch(`/mg_employee_positions/${editingProfile.id}`, {
            method: "PATCH",
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

                setShowEditForm(false);
                message.success("Updated Successfully")
                fetchData();
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
                        <h5 className="mb-0">Profile List</h5>
                        <div>
                            <Button
                                variant="info"
                                size="sm"
                                className="me-2"
                                onClick={() => setShowCreateForm(true)}
                            >
                                + New Profile
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
                                <th style={{ width: "20%" }}>Employee Category Name</th>
                                <th style={{ width: "20%" }}>Profile Name</th>
                                <th style={{ width: "20%" }}>Status</th>
                                <th style={{ width: "20%" }}>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {currentEntries.map((profileItem) => (
                                <tr key={profileItem.id}>
                                    <td>{profileItem.mg_employee_category_id}</td>
                                    <td>{profileItem.position_name}</td>
                                    <td>{profileItem.status ? "Active" : "Inactive"}</td>

                                    <td>
                                        <Button
                                            variant="link"
                                            className="text-primary p-0 me-2"
                                            onClick={() => handleEditClick(profileItem)}
                                        >
                                            <Edit size={18} />
                                        </Button>
                       
                                                      <Popconfirm
                                          title="Are you sure you want to delete this Position?"
                                          description="This action cannot be undone"
                                          onConfirm={() => handleDelete(profileItem.id)}
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
                            {Math.min(indexOfLastEntry, filteredProfile.length)} of{" "}
                            {filteredProfile.length} entries
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
                    <Offcanvas.Title>Create New Profile</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    <Formik
                        initialValues={{
                            mg_employee_category_id: "",
                            position_name: "",
                            status: false
                        }}
                        validationSchema={validationSchema}
                        onSubmit={handleSubmit}
                    >
                        {({ errors, touched, isSubmitting,values ,setFieldValue}) => (
                            <Form>
                                <div className="row">
                                <div className="col-md-6">
            <label>Employee Category</label>
            <div className="input-group input-group-outline my-1">
              <Field
                as="select"
                name="mg_employee_category_id"
                className={`form-control ${
                  touched.mg_employee_category_id && errors.mg_employee_category_id ? "is-invalid" : ""
                }`}
                onChange={(e) => {
           
                  setFieldValue("mg_employee_category_id", e.target.value);
                }}
              >
                <option value="">Select Employee Category</option>
                {categoryData?.map((categoryItem) => (
                  <option key={categoryItem.category_id} value={categoryItem.category_id}>
                    {categoryItem.category_name}
                  </option>
                ))}
              </Field>
              <ErrorMessage
                name="mg_employee_category_id"
                component="div"
                className="invalid-feedback"
              />
            </div>
          </div>
                                    <div className="col-md-6">
                                        <label>Position Name</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="position_name"
                                                className={`form-control ${touched.position_name && errors.position_name ? "is-invalid" : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="position_name"
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
                    <Offcanvas.Title>Edit Profile</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    {editingProfile && (
                        <Formik
                            initialValues={{
                                mg_employee_category_id: editingProfile.mg_employee_category_id,
                                position_name: editingProfile.position_name,
                                status: editingProfile.status,
                               
                            }}
                            validationSchema={editValidationSchema}
                            onSubmit={handleEditSubmit}
                        >
                            {({ errors, touched, isSubmitting,values ,setFieldValue}) => (
                                <Form>
                                  <div className="row">
                                  <div className="col-md-6">
            <label>Employee Category</label>
            <div className="input-group input-group-outline my-1">
              <Field
                as="select"
                name="mg_employee_category_id"
                className={`form-control ${
                  touched.mg_employee_category_id && errors.mg_employee_category_id ? "is-invalid" : ""
                }`}
                onChange={(e) => {
           
                  setFieldValue("mg_employee_category_id", e.target.value);
                }}
              >
                <option value="">Select Employee Category</option>
                {categoryData?.map((categoryItem) => (
                  <option key={categoryItem.category_id} value={categoryItem.category_id}>
                    {categoryItem.category_name}
                  </option>
                ))}
              </Field>
              <ErrorMessage
                name="mg_employee_category_id"
                component="div"
                className="invalid-feedback"
              />
            </div>
          </div>
                  
                                    <div className="col-md-6">
                                        <label>Department Code</label>
                                        <div className="input-group input-group-outline my-1">
                                            <Field
                                                name="position_name"
                                                className={`form-control ${touched.position_name && errors.position_name ? "is-invalid" : ""
                                                    }`}
                                            />
                                            <ErrorMessage
                                                name="position_name"
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

export default EmployeeProfile;
