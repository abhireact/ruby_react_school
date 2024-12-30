import React, { useState, useEffect } from "react";
import { Button } from "react-bootstrap";
import { Select, message } from "antd";
import { Formik, Form } from "formik";
import axios from "axios";
import CertificatePDF from "./CertificatePDF";

const { Option } = Select;

const ExperienceCertificate = ({ userData }) => {
  console.log(userData,"userData")
  const [departmentData, setDepartmentData] = useState(
    userData.employee_department.map(item => ({
      department_name: item[0],
      id: item[1],
    })) || []
  );
  const [employeeData, setEmployeeData] = useState(userData.employees_data || []);
  const [filteredEmployees, setFilteredEmployees] = useState([]);
  const [selectedEmployee, setSelectedEmployee] = useState(null);
  const [trackingDetails, setTrackingDetails] = useState(null);
  const [certificateDetails, setCertificateDetails] = useState(null);

  const [showCertificate,setShowCertificate] = useState(false);
  const [employeeId,setEmployeeId] = useState("");

  // Fetch data on mount
  useEffect(() => {
    axios
      .get(`/employee_archive/show_archive_employees`)
      .then(response => {
        setEmployeeData(response.data.active_employees);
      })
      .catch(error => console.error("Error while fetching data", error));
  }, []);

  const handleDepartmentChange = departmentId => {
    // Reset UI state
    setFilteredEmployees([]);
    setSelectedEmployee(null);
    setTrackingDetails(null);
    setCertificateDetails(null);
    setShowCertificate(false);
  
    if (!departmentId) {
      return;
    }
  
    const filtered = employeeData.filter(
      emp => emp.mg_employee_department_id === parseInt(departmentId)
    );
    setFilteredEmployees(filtered);
  };
  
  const handleEmployeeSelect = employeeId => {
    // Reset certificate-related state
    setCertificateDetails(null);
    setShowCertificate(false);
  
    setSelectedEmployee(employeeId);
  
    axios
      .get(`experience_certificates/issue_certificates/${employeeId}`)
      .then(response => {
        console.log(response.data, "certificate tracking data");
        setTrackingDetails(response.data);
      })
      .catch(error => console.error("Error fetching employee details:", error));
  
    axios
      .get(`experience_certificates/show_employee_certificate/${employeeId}`)
      .then(response => {
        console.log(response.data, "employee certificate data");
        setCertificateDetails(response.data.certificate);
      })
      .catch(error => console.error("Error fetching certificate details:", error));
  };
  

  return (
    <div className="container my-4">
      <div className="card m-2">
        <div className="card-header pb-0">
          <h5 className="mb-0">Experience Certificate</h5>
        </div>
        <div className="card-body px-0 pb-2">
          <Formik
            initialValues={{
              mg_department_id: "",
              mg_employee_id: "",  // New field for selected employee
            }}
            onSubmit={() => {}}
          >
            {({ setFieldValue }) => (
              <Form>
                <div className="row m-4">
                  <div className="col-md-6">
                    <label>Department</label>
                    <Select
                      className="w-100"
                      placeholder="Select Department"
                      onChange={value => {
                        setFieldValue("mg_department_id", value);
                        setFieldValue("mg_employee_id", "");
                        handleDepartmentChange(value);
                        setEmployeeId("");
                      }}
                    >
                      {departmentData.map(item => (
                        <Option key={item.id} value={item.id}>
                          {item.department_name}
                        </Option>
                      ))}
                    </Select>
                  </div>

                  {filteredEmployees.length > 0 && (
                    <div className="col-md-6">
                      <label>Employee</label>
                      <Select
                        className="w-100"
                        placeholder="Select Employee"
                        onChange={value => {
                          setFieldValue("mg_employee_id", value);
                          handleEmployeeSelect(value);
                          setEmployeeId(value);
                        }}
                      >
                        {filteredEmployees.map(employee => (
                          <Option key={employee.id} value={employee.id}>
                            {`${employee.first_name} ${employee.last_name} (${employee.user_name})`}
                          </Option>
                        ))}
                      </Select>
                    </div>
                  )}
                </div>
                {selectedEmployee && trackingDetails && !showCertificate && (
  <div className="m-4">
    <h6>Certificate Details:</h6>
    <p>{`Name: ${trackingDetails.employee?.full_name || "N/A"}`}</p>
    <p>{`Employee Number: ${trackingDetails.employee?.employee_number || "N/A"}`}</p>
    
    {trackingDetails.certificate && (
      <>
       
        <p>{`Date of Issue: ${trackingDetails.certificate.date_of_issue || "N/A"}`}</p>
        <p>{`Issued Times: ${trackingDetails.certificate.issued_times || "N/A"}`}</p>
      </>
    )}
    
    <Button
      className="btn btn-info"
      onClick={() => {
        setShowCertificate(true);
      }}
    >
      Experience Certificate
    </Button>
  </div>
)}

              </Form>
            )}
          </Formik>
        </div>
      </div>

   {showCertificate && <CertificatePDF certificateDetails={certificateDetails} mg_employee_id={employeeId?employeeId:""}/>}
    </div>
  );
};

export default ExperienceCertificate;
