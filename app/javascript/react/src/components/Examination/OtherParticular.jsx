import React, { useState, useEffect, useMemo } from "react";
import { Formik, Form, Field, ErrorMessage,FieldArray } from "formik";
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
import { Edit, Trash, Search,List,Plus } from "lucide-react";
import { message,Popconfirm  } from 'antd';


//  validation schema
const validationSchema = Yup.object().shape({
  name: Yup.string().required("Name is required"),
  description: Yup.string(),
  mg_time_table_id: Yup.string().required("Academic Year is required"),
  index: Yup.number().nullable(),
  particulars: Yup.array().of(
    Yup.object().shape({
      name: Yup.string().required("Component Name is required"),
      scoring_type: Yup.string()
        .required("Scoring Type is required")
        .oneOf(["Marks Entry", "Grading"], "Invalid Scoring Type"),
      description: Yup.string()
    })
  ).min(1, "At least one component is required")
});
const componentValidation = 
    Yup.object().shape({
      name: Yup.string().required("Component Name is required"),
      scoring_type: Yup.string()
        .required("Scoring Type is required")
        .oneOf(["Marks Entry", "Grading"], "Invalid Scoring Type"),
      description: Yup.string()
    });
  

const editValidationSchema = Yup.object().shape({
  name: Yup.string().required("Name is required"),
  description: Yup.string(),
  mg_time_table_id: Yup.string().required("Academic Year is required"),
  index:Yup.number().nullable(),

});

const OtherParticular = ({ userData }) => {
  const [examTypes, setExamTypes] = useState(userData?.other_particular || []);

  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(10);
  const [showEditForm, setShowEditForm] = useState(false);
  const [editingExamType, setEditingExamType] = useState(null);
  const [selectedTableAcademicYear, setSelectedTableAcademicYear] = useState(userData.academicYearsData[userData.academicYearsData.length - 1].id.toString());


  console.log("user data",userData)

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
    if (selectedClass.length === 0) {
      message.error("Atleast One Class and Section must be selected")
      setSubmitting(false)
      return;
    }
    const formattedData = selectedClass.map((item) => {
      const selectedItem = userData.class_section.find(([_, id]) => id === item);
      return selectedItem ? selectedItem[1] : null;
    });

    const cleanedData = formattedData.filter((item) => item !== null);

    // Rest of the code remains the same
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch("other_particular/co_scholastic_create", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_co_scholastic_exam_components: {
          name: values.name,
          description: values.description,
          index:values.index,
          mg_time_table_id: values.mg_time_table_id,
        },
        selected_class: cleanedData,
        particulars: values.particulars
      
      }),
    })
      .then((response) => response.json())
      .then(() => {
        // setShowCreateForm(false);
        window.location.reload();
      })
      .catch((error) => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const handleDelete = (id) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    // Show loading message
    message.loading({ content: 'Deleting particular...', key: 'deletingParticular' });

    axios
      .delete(`/other_particular/delete_particular/${id}`, {
        headers: {
          "X-CSRF-Token": csrfToken,
        },
      })
      .then((response) => {
        if (response.data.status !== 200) {
          // Success message
          message.success({ 
            content: 'Particular deleted successfully!', 
            key: 'deletingParticular' 
          });

          // Update local state and reload
          window.location.reload();
          setExamTypes((prevExamTypes) => prevExamTypes.filter((examType) => examType.id !== id));
        } else {
          throw new Error(response.data.message);
        }
      })
      .catch((error) => {
        const errorMessage = error.response?.data?.message || error.message;
        
        // Error message
        message.error({ 
          content: `Failed to delete particular: ${errorMessage}`, 
          key: 'deletingParticular' 
        });

        console.error("Error deleting exam type:", error);
      });
  };

  const handleEditClick = (examType) => {
    console.log(examType,"dfsd")
    // Set the academic year first
    setSelectedAcademicYear(examType.mg_time_table_id.toString());

    // Find all exam associations for this exam type
    const examAssociations = userData.other_particular_class_section.filter(
      (association) => association.mg_co_scholastic_exam_particular_id === examType.id.toString()
    );

    // Get the class-section IDs from the associations
    const associatedClassSections = examAssociations.map((association) => {
      return `${association.mg_course_id}-${association.mg_batch_id}`;
    });
    console.log(associatedClassSections,"class section")

    // Set the pre-selected classes
    setSelectedClass(associatedClassSections);

    // Set the exam type being edited
    setEditingExamType(examType);

    // Show the edit form
    setShowEditForm(true);
  };
  const handleEditSubmit = (values, { setSubmitting }) => {
    if (selectedClass.length === 0) {
      message.error("Atleast One Class and Section must be selected")
      setSubmitting(false)
      return;
    }
    // Get currently selected classes
    const currentlySelectedClasses = new Set(selectedClass);
    console.log(currentlySelectedClasses,"already selected classes")
    // Find previously selected classes
    const examAssociations = userData.other_particular_class_section.filter(
      (association) => association.mg_co_scholastic_exam_particular_id === editingExamType.id.toString()
    );

    // Get classes that need to be deleted
    const deletedClasses = examAssociations
      .map((association) => `${association.mg_course_id}-${association.mg_batch_id}`)
      .filter((classId) => !currentlySelectedClasses.has(classId));
      console.log(deletedClasses,"unselected classes")

    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch(`other_particular/co_scholastic_update/${editingExamType.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        mg_cbsc_co_scholastic_exam_components: {
          name: values.name,
          description: values.description,
          index:values.index,
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
        // setShowEditForm(false);
       window.location.reload();
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Failed to update co scholatic. Please try again.");
      })
      .finally(() => {
        setSubmitting(false);
      });
  };
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
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

  // First, make sure these state variables are defined at the top with your other useState declarations
const [showSectionsModal, setShowSectionsModal] = useState(false);
const [selectClass, setSelectClass] = useState(null);
const [sections, setSections] = useState([]);
const [showNewSectionForm, setShowNewSectionForm] = useState(false);

  // New function to fetch and show sections
  const handleComponents = (id, particularItem) => {
    setSelectClass(particularItem); // Store the selected class details
    setShowSectionsModal(true); // Show the modal
   let filterComponents  = userData?.other_component.filter((item)=>item.mg_cbsc_co_scholastic_exam_component_id==id); 
    setSections(filterComponents);
    console.log(filterComponents,"filter components")
    // fetchSections(id);
  };
//   const fetchSections = (classId) => {
//     axios.get(`/batches/batcheList/${classId}`)
//       .then(response => {
//         setSections(response.data);
//       })
//       .catch(error => {
//         console.error("Error fetching batches:", error);
//       });
//   };
  const handleDeleteComponent = (id) => {
  
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      axios
        .delete(`/other_particular/delete_component/${id}`, {
          headers: {
            "X-CSRF-Token": csrfToken,
          },
        })
        .then(() => {
          window.location.reload();
          // Optionally, you can add a success message here
        })
        .catch((error) => {
          console.error("Error deleting Section:", error);

        });
    
  };
  const handleCreateComponent = (values, { setSubmitting, resetForm }) => {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content");

    fetch('other_particular/co_scholastic_component_create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token
      },
      body: JSON.stringify( {
        mg_cbsc_co_scholastic_exam_particular:{        
            mg_cbsc_co_scholastic_exam_component_id: selectClass.id,
            name: values.name,
            scoring_type:values.scoring_type,
            description :values.description}

        
        }
      )
    })
    .then(response => response.json())
    .then(data => {
      window.location.reload();
     // fetchSections(selectedClass.id); 
     // Refresh sections list
      setShowNewSectionForm(false);
      resetForm();
    })
    .catch(error => console.error('Error:', error))
    .finally(() => setSubmitting(false));
  };

  // Add these state variables near the top of the component with other state declarations
const [editingComponent, setEditingComponent] = useState(null);

// Add this function to handle editing a component
const handleEditComponent = (values, { setSubmitting }) => {
  const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content");

  fetch(`other_particular/co_scholastic_component_update/${editingComponent.id}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': token
    },
    body: JSON.stringify({
      mg_cbsc_co_scholastic_exam_particular: {        
        name: values.name,
        scoring_type: values.scoring_type,
        description: values.description
      }
    })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    window.location.reload();
  })
  .catch(error => {
    console.error('Error:', error);
    alert('Failed to update component. Please try again.');
  })
  .finally(() => {
    setSubmitting(false);
  });
};

  return (
    <div className="container mt-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Other Particular </h5>
            <Button
              variant="info"
              size="sm"
              className="me-2"
              onClick={() => {setShowCreateForm(true)
                setSelectedClass([])}
              }
            >
              + New Particular
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
                <th>Particular Name</th>
                <th>Description</th>
                <th>Index</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {currentEntries.map((item) => (
                <tr key={item.id}>
                  <td>{item.name}</td>
                  <td>{item.description}</td>
                  <td>{item.index}</td>
                  <td>
                    <Button
                      variant="link"
                      className="text-primary p-0 me-2"
                      onClick={() => handleEditClick(item)}
                    >
                      <Edit size={18} />
                    </Button>
                    <Popconfirm
                  title="Are you sure you want to delete this particular?"
                
                  onConfirm={() => handleDelete(item.id)}
                  okText="Yes, Delete"
                  cancelText="No, Cancel"
                  okButtonProps={{ danger: true }}
                >
                  <Button
                    variant="link"
                    className="text-danger p-0"
                  >
                    <Trash size={18} />
                  </Button>
                </Popconfirm>
                    <Button
  variant="link"
  className="text-info p-0 ms-2"
  onClick={() => handleComponents(item.id, item)}
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
          <Offcanvas.Title>Create New Particular</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              name: "",
              description: "",
              mg_time_table_id: "",
              index:null,
              particulars: [
                {
                  name: "",
                  description: "",
                  scoring_type: "",
                },
              ],
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, isSubmitting, setFieldValue,values }) => (
              <Form>
                <div className="row">
                  <div className="col-md-4">
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

                  <div className="col-md-4">
                    <label> Name</label>
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
                    <label>Index</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="index"
                       
                        className={`form-control ${
                          touched.index && errors.index ? "is-invalid" : ""
                        }`}
                        type="number"
                      />
                      <ErrorMessage
                        name="index"
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
            
                 <FieldArray
  name="particulars"
  render={(arrayHelpers) => (
    <div className="p-3 mb-2">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h5>Components</h5>
        <button
          type="button"
          className="btn btn-info btn-sm"
          onClick={() =>
            arrayHelpers.push({
              name: "",
              description: "",
              scoring_type: "",
            })
          }
        >
          + Add Component
        </button>
      </div>
      {values.particulars.map((particular, index) => (
        <div key={index} className="row mb-2 g-2 align-items-center">
          <div className="col-md-4">
            <div className="input-group input-group-outline">
              <Field
                name={`particulars.${index}.name`}
                className={`form-control ${
                  errors.particulars?.[index]?.name && touched.particulars?.[index]?.name 
                    ? "is-invalid" 
                    : ""
                }`}
                placeholder="Component Name"
              />
              <ErrorMessage
                name={`particulars.${index}.name`}
                component="div"
                className="invalid-feedback"
              />
            </div>
          </div>
          <div className="col-md-4">
            <div className="input-group input-group-outline">
              <Field
                as="select"
                name={`particulars.${index}.scoring_type`}
                className={`form-select ${
                  errors.particulars?.[index]?.scoring_type && touched.particulars?.[index]?.scoring_type 
                    ? "is-invalid" 
                    : ""
                }`}
              >
                <option value="">Select Scoring Type</option>
                <option value="Marks Entry">Marks Entry</option>
                <option value="Grading">Grading</option>
              </Field>
              <ErrorMessage
                name={`particulars.${index}.scoring_type`}
                component="div"
                className="invalid-feedback"
              />
            </div>
          </div>
          <div className="col-md-3">
            <div className="input-group input-group-outline">
              <Field
                name={`particulars.${index}.description`}
                className="form-control"
                placeholder="Description (Optional)"
                 as="textarea"
              />
                    <ErrorMessage
                name={`particulars.${index}.description`}
                component="div"
                className="invalid-feedback"
              />

            </div>
          </div>
          <div className="col-md-1 mt-2">
            {values.particulars.length > 1 && (
              <button
                type="button"
                className="btn btn-outline-danger btn-sm"
                onClick={() => arrayHelpers.remove(index)}
              >
                ✕
              </button>
            )}
          </div>
        </div>
      ))}
      {errors.particulars && touched.particulars && (
        <div className="text-danger mb-2">
          {typeof errors.particulars === 'string' ? errors.particulars : ''}
        </div>
      )}
    </div>
  )}
/>

          </div>
                <div className="row">
                  <div className="col-md-12 d-flex justify-content-end">
                    <button type="submit" className="btn btn-info my-4" 
                    disabled={isSubmitting}>
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
          <Offcanvas.Title>Edit Particular</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingExamType && (
            <Formik
              initialValues={{
               name: editingExamType.name,
                description: editingExamType.description,
                mg_time_table_id: editingExamType.mg_time_table_id,
                index:editingExamType.index,
              }}
              validationSchema={editValidationSchema}
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
  className={`form-control bg-gray-200 text-gray-600 ${
    touched.mg_time_table_id && errors.mg_time_table_id ? "is-invalid" : ""
  }`}
  disabled
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
                      <label>Name</label>
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
                    <div className="col-md-6">
                    <label>Index</label>
                    <div className="input-group input-group-outline my-1">
                      <Field
                        name="index"
                       
                        className={`form-control ${
                          touched.index && errors.index ? "is-invalid" : ""
                        }`}
                        type="number"
                      />
                      <ErrorMessage
                        name="index"
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
      <Offcanvas 
        show={showSectionsModal} 
        onHide={() => {
          setShowSectionsModal(false);
          setShowNewSectionForm(false);
        }}
        placement="end"
        style={{ width: "50%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>
            Components in {selectClass?.name}
          </Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <div className="mb-4">
          {!showNewSectionForm &&  <Button 
              variant="info" 
              onClick={() => setShowNewSectionForm(true)}
              className="mb-3"
            >
              <Plus size={18} className="me-2" />
              Add New Component
            </Button>} 
          </div>

          {showNewSectionForm && (
  <div className="mb-4 p-3 border rounded">
    <h6 className="mb-3">
      {editingComponent ? "Edit Component" : "Create New Component"}
    </h6>
    <Formik
      initialValues={{
        name: editingComponent ? editingComponent.name : "",
        scoring_type: editingComponent ? editingComponent.scoring_type : "Marks Entry",
        description: editingComponent ? editingComponent.description : ""
      }}
      onSubmit={editingComponent ? handleEditComponent : handleCreateComponent}
      validationSchema = {componentValidation}
    >
      {({ errors, touched, isSubmitting }) => (
        <Form>
          {/* ... existing form fields ... */}
          <div className="row">
                      <div className="col-md-4">
                        <label>Name</label>
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
                        <label>Scoring Type</label>
                        <div className="input-group input-group-outline my-1">
                          <Field
                            as="select"
                            name="scoring_type"
                            className={`form-control ${
                              touched.scoring_type && errors.scoring_type ? "is-invalid" : ""
                            }`}
                          >
                            <option value="Marks Entry">Marks Entry</option>
                            <option value="Grading">Grading</option>
                          </Field>
                          <ErrorMessage
                            name="scoring_type"
                            component="div"
                            className="invalid-feedback"
                          />
                        </div>
                      </div>
                      <div className="col-md-4">
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
                    
          <div className="d-flex justify-content-end gap-2 my-4">
            <Button 
              variant="secondary" 
              onClick={() => {
                setShowNewSectionForm(false);
                setEditingComponent(null);
              }}
            >
              Cancel
            </Button>
            <Button 
              type="submit" 
              variant="info"
              disabled={isSubmitting}
            >
              {isSubmitting 
                ? (editingComponent ? "Updating..." : "Creating...") 
                : (editingComponent ? "Update Component" : "Create Component")
              }
            </Button>
          </div>  </div>
        </Form>
      )}
    </Formik>
  </div>
)}

          {sections.length > 0 ? (
            <Table responsive striped bordered hover>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Scoring Type</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              {sections.map((section) => (
  <tr key={section.id}>
    <td>{section.name}</td>
    <td>{section.scoring_type}</td>
    <td>{section.description}</td>
    <td>
      <Button
        variant="link"
        className="text-primary p-0 me-2"
        onClick={() => {
          setEditingComponent(section);
          setShowNewSectionForm(true);
        }}
      >
        <Edit size={18} />
      </Button>
      <Popconfirm
                  title="Are you sure you want to delete this component?"
                
                  onConfirm={() => handleDeleteComponent(section.id)}
                  okText="Yes, Delete"
                  cancelText="No, Cancel"
                  okButtonProps={{ danger: true }}
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
          ) : (
            <div className="text-center py-4">
              <p className="text-muted">No Components found for this particular</p>
            </div>
          )}
        </Offcanvas.Body>
      </Offcanvas>
    </div>
  );
};
export default OtherParticular;
