import React, { useState, useEffect } from "react";
import { Button, Offcanvas } from "react-bootstrap";
import { message, Select, Popconfirm } from "antd";
import * as Yup from "yup";
import { Formik, Form, Field, ErrorMessage } from "formik";
import DataTable from "./table";
import axios from "axios";
import { Edit, FileUp } from "lucide-react";

const { Option } = Select;

const validationSchema = Yup.object().shape({
  mg_archive_reason_id: Yup.string().required("Archive Reason is required"),
  archive_date: Yup.date().required("Archive Date is required"),
});

const ArchiveEmployee = ({ userData }) => {
  console.log(userData,"user data")
  const [reasonData, setReasonData] = useState(
    userData.reasons_data.map(item => ({
      reason: item[0],
      id: item[1],
    })) || []
  );

  const [departmentData, setDepartmentData] = useState(
    userData.employee_department.map(item => ({
      department_name: item[0],
      id: item[1],
    })) || []
  );

  const [archiveData, setArchiveData] = useState(userData.archive_data || []);
  const [employeeData,setEmployeeData] = useState(userData.employees_data||[])

  const [filteredEmployees, setFilteredEmployees] = useState([]);
  const [selectedEmployees, setSelectedEmployees] = useState([]);
  const [showCreateForm, setShowCreateForm] = useState(false);

  const [showEditForm, setShowEditForm] = useState(false);
  const [editingEmployee, setEditingEmployee] = useState(null);

  const fetchData = () => {
    axios
      .get(`/employee_archive/show_archive_employees`)
      .then(response => {
        console.log(response.data,"fetch data")
        setArchiveData(response.data.archive_employees);
        setEmployeeData(response.data.active_employees);
      })
      .catch(error => {
        console.error("Error while fetching data", error);
      });
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleSubmit = (values, { setSubmitting }) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch("/employee_archive/archive_employee", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        archive_date: values.archive_date,
        mg_archive_reason_id: values.mg_archive_reason_id,
        selectedemployees: selectedEmployees,
      }),
    })
      .then(response => response.json())
      .then(() => {
        setShowCreateForm(false);
        message.success("Archived Successfully");
        fetchData();
      })
      .catch(error => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };

  const handleEditSubmit = (values, { setSubmitting }) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch(`/employee_archive/update_archive_employee/${editingEmployee.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        archive_date: values.archive_date,
        mg_archive_reason_id: values.mg_archive_reason_id,
      }),
    })
      .then(response => response.json())
      .then(() => {
        setShowEditForm(false);
        setEditingEmployee(null);
        message.success("Updated Successfully");
        fetchData();
      })
      .catch(error => console.error("Error:", error))
      .finally(() => setSubmitting(false));
  };


  const handleUnarchive = (employee) => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch(`employee_archive/unarchive_employee/${employee.id}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
   
      }),
    })
      .then(response => response.json())
      .then(() => {
        message.success("UnArchived Successfully");
        fetchData();
     
      })
      .catch(error => {console.error("Error:", error)
        message.error(error)
      })

  };
  const handleEdit = employee => {
    setEditingEmployee(employee);
    setShowEditForm(true);
  };

  const handleDepartmentChange = departmentId => {
    if (!departmentId) {
      setFilteredEmployees([]); // Clear filtered employees when no department is selected
      return;
    }

    const filtered = employeeData.filter(
      emp => emp.mg_employee_department_id === parseInt(departmentId)
    );
    setFilteredEmployees(filtered);
  };

  const handleEmployeeSelection = (employeeId, isSelected) => {
    setSelectedEmployees(prev => {
      if (isSelected) {
        // Add the employee ID if not already in the list
        return prev.includes(employeeId) ? prev : [...prev, employeeId];
      } else {
        // Remove the employee ID
        return prev.filter(id => id !== employeeId);
      }
    });
  };
  

  const resetFormAndState = () => {
    setFilteredEmployees([]);
    setSelectedEmployees([]);
  };

  return (
    <div className="container my-4">
      <div className="card m-4">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Archive Employee List</h5>
            <Button variant="info" size="sm" onClick={() => setShowCreateForm(true)}>
              + Archive Employees
            </Button>
          </div>
        </div>
        <DataTable
          rowData={archiveData.map(emp => ({
            id: emp.id,
            username: emp.user_name,
            name: `${emp.first_name} ${emp.middle_name?emp.middle_name : ""} ${emp.last_name? emp.middle_name : ""}`.trim(),
            department_name: emp.department_name,
            action: (
              <>
                <Button
                  variant="link"
                  className="text-primary p-0 me-2"
                  onClick={() => handleEdit(emp)} // Fixed the dangling bracket and ensured proper method reference
                >
                  <Edit size={18} />
                </Button>
                <Popconfirm
                  title="Are you sure you want to UnArchive this Employee?"
                  onConfirm={() => handleUnarchive(emp)} // Ensure `onUnarchive` is properly defined and passed as a prop or local function
                  okText="Yes"
                  cancelText="No"
                >
                  <Button variant="link" className="text-danger p-0">
                    <FileUp size={18} />
                  </Button>
                </Popconfirm>
              </>
            ),
            
          }))}
       
          columns={[
            { header: "Name", rowKey: "name", style: { width: "25%" } },
            { header: "Username", rowKey: "username", style: { width: "25%" } },
            { header: "Department Name ", rowKey: "department_name", style: { width: "25%" } },
            { header: "Action", rowKey: "action", style: { width: "25%" } },
          ]}
        />
      </div>

      <Offcanvas
        show={showCreateForm}
        onHide={() => {
          setShowCreateForm(false);
          resetFormAndState();
        }}
        placement="end"
        style={{ width: "40%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Employee Archive</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <Formik
            initialValues={{
              archive_date: "",
              mg_archive_reason_id: "",
              mg_department_id: "",
            }}
            validationSchema={validationSchema}
            onSubmit={handleSubmit}
          >
            {({ errors, touched, values, setFieldValue }) => (
              <Form>
                <div className="row">
                  <div className="col-md-6">
                    <label>Department</label>
                    <div className="input-group input-group-outline my-1">
                      <Select
                        className="w-100"
                        placeholder="Select Department"
                        onChange={value => {
                          setFieldValue("mg_department_id", value);
                          handleDepartmentChange(value);
                        }}
                      >
                        {departmentData.map(item => (
                          <Option key={item.id} value={item.id}>
                            {item.department_name}
                          </Option>
                        ))}
                      </Select>
                    </div>
                  </div>

                  <div className="col-md-6">
                    <label>Reason</label>
                    <div className="input-group input-group-outline my-1">
                      <Select
                        className="w-100"
                        placeholder="Select Reason"
                        onChange={value => setFieldValue("mg_archive_reason_id", value)}
                      >
                        {reasonData.map(item => (
                          <Option key={item.id} value={item.id}>
                            {item.reason}
                          </Option>
                        ))}
                      </Select>
                    </div>
                  </div>

                  <div className="col-md-6">
                    <label>Archive Date</label>
                    <div className="input-group input-group-outline my-1">
                      <Field type="date" name="archive_date" className="form-control" />
                      <ErrorMessage name="archive_date" component="div" className="invalid-feedback" />
                    </div>
                  </div>
                </div>

                {filteredEmployees.length > 0 && (
  <div className="mt-3">
    <h6>Select Employees</h6>
    <div style={{ maxHeight: "300px", overflowY: "auto", border: "1px solid #ddd", padding: "10px" }}>
    {filteredEmployees.map(employee => (
  <div key={employee.id} style={{ display: "flex", alignItems: "center", marginBottom: "10px" }}>
    <label style={{ flexGrow: 1, marginRight: "10px" }}>
      {`${employee.first_name} ${employee.last_name} (${employee.user_name})`}
    </label>
    <input
      type="checkbox"
      style={{ transform: "scale(1.2)", marginLeft: "10px" }}
      checked={selectedEmployees.includes(employee.id)} // Bind to the state
      onChange={e => handleEmployeeSelection(employee.id, e.target.checked)}
    />
  </div>
))}

    </div>
  </div>
)}


                {filteredEmployees.length > 0 &&
                  selectedEmployees.length > 0 &&
                  values.mg_archive_reason_id &&
                  values.archive_date && (
                    <div className="mt-4">
                      <Button type="submit" className="btn btn-info">
                        Submit
                      </Button>
                    </div>
                  )}
              </Form>
            )}
          </Formik>
        </Offcanvas.Body>
      </Offcanvas>
      <Offcanvas
        show={showEditForm}
        onHide={() => {
          setShowEditForm(false);
          setEditingEmployee(null);
        }}
        placement="end"
        style={{ width: "40%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Edit Archive Details</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {editingEmployee && (
     <Formik
     initialValues={{
       archive_date: editingEmployee.archive_date,
       mg_archive_reason_id: editingEmployee.mg_archive_reason_id,
     }}
     validationSchema={validationSchema}
     onSubmit={handleEditSubmit}
   >
     {({ errors, touched, setFieldValue ,values}) => (
       <Form>
         <div className="mb-3">
           <label>Reason</label>
           <Select
             className="w-100"
             value={values.mg_archive_reason_id}  // Make sure the value of select is tied to Formik's state
             placeholder="Select Reason"
             onChange={value => {
               setFieldValue("mg_archive_reason_id", value); // Correctly updating Formik's state
             }}
           >
             {reasonData.map(item => (
               <Option key={item.id} value={item.id}>
                 {item.reason}
               </Option>
             ))}
           </Select>
           {errors.mg_archive_reason_id && touched.mg_archive_reason_id && (
             <div className="invalid-feedback">{errors.mg_archive_reason_id}</div>
           )}
         </div>
         <div className="mb-3">
           <label>Archive Date</label>
           <div className="input-group input-group-outline my-1">
             <Field type="date" name="archive_date" className="form-control" />
             <ErrorMessage name="archive_date" component="div" className="invalid-feedback" />
           </div>
         </div>
         <Button type="submit" className="btn btn-info">
           Update
         </Button>
       </Form>
     )}
   </Formik>
   
          )}
        </Offcanvas.Body>
      </Offcanvas>
    </div>
  );
};

export default ArchiveEmployee;
