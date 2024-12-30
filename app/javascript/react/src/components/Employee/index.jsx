import React, { useState, useEffect } from "react";
import { Button, OverlayTrigger, Tooltip } from "react-bootstrap";
import { message, Select, Popconfirm } from "antd";
import * as Yup from "yup";
import { Formik, Form, Field, ErrorMessage } from "formik";
import DataTable from "./table";
import axios from "axios";
import { Edit, Trash,FileText } from "lucide-react";
import CreateEmployeeForm from "./CreateEmployeeForm";
import UpdateEmployeeForm from "./UpdateEmployeeForm"
import EmployeeExport from "./EmployeeExportData";
const { Option } = Select;



const Employee = ({ userData }) => {
  console.log(userData,"user data")


  const [departmentData, setDepartmentData] = useState(
    userData.employee_department.map(item => ({
      department_name: item[0],
      id: item[1],
    })) || []
  );
   
  const [employeeData,setEmployeeData] = useState(userData.employees_data||[])

  const [showCreateForm, setShowCreateForm] = useState(false);

  const [showEditForm, setShowEditForm] = useState(false);

  const [editingEmployee, setEditingEmployee] = useState(null);

  const [showExport,setShowExport] = useState(false)




  const fetchData = () => {
    axios
      .get(`mg_employees/get_all_employees`)
      .then(response => {
        console.log(response.data,"fetch data")
   
     setEmployeeData(response.data.data);
      })
      .catch(error => {
        console.error("Error while fetching data", error);
      });
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleDelete = (id) => {
      
    const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

    axios
        .delete(`mg_employees/delete_employee/${id}`, {
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
            console.error("Error Deleting Employee:", error);

        });

};





  const handleEdit = employee => {
    setEditingEmployee(employee);
    setShowEditForm(true);
  };

  const handleCloseCreateForm= ()=>{
    setShowCreateForm(false);
  }
  const handleCloseEditForm=()=>{
    setShowEditForm(false);
  }

  const handleCloseExport=()=>{
    setShowExport(false);
  }

  return (
  <>
    {!showCreateForm && !showExport && !showEditForm  &&<div className="container my-4">
      <div className="card m-4">
  <div className="card-header pb-0">
    <div className="d-flex justify-content-between align-items-center">
      <h5 className="mb-0">Employee List</h5>
      <div className="d-flex gap-2">
      <Button variant="info" onClick={() => setShowCreateForm(true)}>
          + Create Employees
        </Button>
        <Button
          variant="dark"
          onClick={() => setShowExport(true)}
        >
          Export Employee Data&nbsp;&nbsp;<FileText size={18} />
        </Button>
       
      </div>
    </div>
  </div>



        <DataTable
          rowData={employeeData.map(emp => ({
            id: emp.id,
            username: emp.employee_number,
            name: `${emp.first_name} ${emp.middle_name? emp.middle_name : ""} ${emp.last_name?emp.last_name:""}`.trim(),
            department_name: emp.emp_department,
            email_id:emp.email_id,
            action: (
              <>
                  <OverlayTrigger
                      placement="top"
                      overlay={<Tooltip>Edit Employee</Tooltip>}
                    >
                      <Button
                        variant="link"
                        className="text-primary p-0 me-2"
                        onClick={() => handleEdit(emp)}
                      >
                        <Edit size={18} />
                      </Button>
                    </OverlayTrigger>

          

                 
                      <Popconfirm
                        title="Are you sure you want to Delete this Employee?"
                        onConfirm={() => {
                          handleDelete(emp.id)
                        }}
                        okText="Yes"
                        cancelText="No"
                      >
                        <Button variant="link" className="text-danger p-0">
                          <Trash size={18} />
                        </Button>
                      </Popconfirm>
                 
              </>
            ),
            
          }))}
       
          columns={[
            { header: "Name", rowKey: "name", style: { width: "20%" } },
            { header: "Employee Number", rowKey: "username", style: { width: "20%" } },
            { header: "Department Name ", rowKey: "department_name", style: { width: "20%" } },
            { header: "Email",rowKey: "email_id", style: { width: "20%" } },
            { header: "Action", rowKey: "action", style: { width: "20%" } },
          ]}
        />
      </div>


    </div>}
    {showCreateForm && <CreateEmployeeForm handleClose={handleCloseCreateForm} userData={userData} fetchData={fetchData} />}

    {showEditForm && <UpdateEmployeeForm handleClose={handleCloseEditForm} userData={userData} employeeInfo={editingEmployee} fetchData={fetchData}/>}

    {showExport && <EmployeeExport  handleClose={handleCloseExport} userData={userData}/>}
  </>
  
  );
};

export default Employee;
