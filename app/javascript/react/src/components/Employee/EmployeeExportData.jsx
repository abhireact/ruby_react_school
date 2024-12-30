import React, { useState, useEffect } from "react";
import { Button, Checkbox, message } from "antd";
import { Field } from "formik";
import DataTable from "./table";
import axios from "axios";
import * as XLSX from "xlsx";
import jsPDF from "jspdf";
import "jspdf-autotable";

const ExportEmployeeData = ({ userData, handleClose }) => {
  const [employeeData, setEmployeeData] = useState([]);
  const [selectedColumns, setSelectedColumns] = useState([
    "fullName",
    "employeeNumber",
    "positionName",
    "departmentName",
    "employeeType",
    "categoryName",
    "gradeName",
  ]);

  const [employeeCategories, setEmployeeCategories] = useState(
    userData.employee_category || []
  );
  const [employeeDepartments, setEmployeeDepartments] = useState(
    userData.employee_department || []
  );
  const [employeeTypes, setEmployeeTypes] = useState(
    userData.employee_type || []
  );
  const [employeePosition, setEmployeePosition] = useState(
    userData.employee_position || []
  );
  const [employeeGrades, setEmployeeGrades] = useState(
    userData.employee_grade || []
  );
  const [selectedCategory, setSelectedCategory] = useState("");
  const [selectedDepartment, setSelectedDepartment] = useState("");

  const getEmployeeType = (id) =>
    employeeTypes?.find((type) => type.id === id)?.employee_type || "N/A";
  const getCategoryName = (id) =>
    employeeCategories?.find((category) => category.id === id)?.category_name ||
    "N/A";
  const getPositionName = (id) =>
    employeePosition?.find((position) => position.id === id)?.position_name ||
    "N/A";
  const getDepartmentName = (id) =>
    employeeDepartments?.find((dept) => dept.id === id)?.department_name || "N/A";
  const getGradeName = (id) =>
    employeeGrades?.find((grade) => grade.id === id)?.grade_name || "N/A";

  const columnOptions = [
    { label: "Full Name", value: "fullName" },
    { label: "Employee Number", value: "employeeNumber" },
    { label: "Position", value: "positionName" },
    { label: "Department", value: "departmentName" },
    { label: "Type", value: "employeeType" },
    { label: "Category", value: "categoryName" },
    { label: "Grade", value: "gradeName" },
  ];

  const fetchData = () => {
    axios
      .get(`/employee_archive/show_archive_employees`)
      .then((response) => {
        setEmployeeData(response.data.active_employees);
      })
      .catch((error) => {
        console.error("Error while fetching data", error);
        message.error("Failed to fetch data.");
      });
  };

  useEffect(() => {
    fetchData();
  }, []);

  const allEmployeeData = employeeData
    .filter((emp) =>
      (selectedCategory ? emp.mg_employee_category_id === Number(selectedCategory) : true) &&
      (selectedDepartment ? emp.mg_employee_department_id === Number(selectedDepartment) : true)
    )
    .map((emp) => ({
      id: emp.id,
      employeeNumber: emp.employee_number || "N/A",
      fullName: `${emp.first_name?.trim() || ""} ${
        emp.middle_name?.trim() || ""
      } ${emp.last_name?.trim() || ""}`.trim(),
      employeeType: getEmployeeType(emp.mg_employee_type_id),
      categoryName: getCategoryName(emp.mg_employee_category_id),
      positionName: getPositionName(emp.mg_employee_position_id),
      departmentName: getDepartmentName(emp.mg_employee_department_id),
      gradeName: getGradeName(emp.mg_employee_grade_id),
      status: emp.status || "N/A",
      joiningDate: emp.joining_date || "N/A",
      dateOfBirth: emp.date_of_birth || "N/A",
      qualification: emp.qualification || "N/A",
      emergencyContact: emp.emergency_contact_number || "N/A",
    }));

  const handleColumnChange = (checkedValues) => {
    setSelectedColumns(checkedValues);
  };

  const exportToExcel = () => {
    const worksheet = XLSX.utils.json_to_sheet(
      allEmployeeData.map((emp) => {
        const filteredEmp = {};
        selectedColumns.forEach((col) => {
          const label = columnOptions.find((opt) => opt.value === col).label;
          filteredEmp[label] = emp[col] || "N/A";
        });
        return filteredEmp;
      })
    );
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Employees");
    XLSX.writeFile(workbook, "Employees.xlsx");
  };

  const exportToPDF = () => {
    const doc = new jsPDF();
    const tableHead = columnOptions
      .filter((col) => selectedColumns.includes(col.value))
      .map((col) => col.label);
    const tableData = allEmployeeData.map((emp) =>
      selectedColumns.map((col) => emp[col] || "N/A")
    );

    doc.text("Employee List", 14, 10);
    doc.autoTable({
      head: [tableHead],
      body: tableData,
    });

    doc.save("Employees.pdf");
  };

  return (
    <div className="container my-4">
      <div className="card m-2">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Employee List</h5>
            {allEmployeeData.length > 0 && (
              <div>
                <Button
                  type="primary"
                  onClick={exportToExcel}
                  style={{ marginRight: "10px" }}
                >
                  Export to Excel
                </Button>
                <Button color="default" variant="solid" onClick={exportToPDF}>
                  Export to PDF
                </Button>
              </div>
            )}
          </div>
        </div>

        <div className="row p-3">
        <div className="col-md-4">
            <label>Employee Category</label>
            <div className="input-group input-group-outline my-1">
              <select
                className="form-control"
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
              >
                <option value="">All Category</option>
                {employeeCategories.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.category_name}
                  </option>
                ))}
              </select>
            </div>
          </div>
          
          <div className="col-md-4">
            <label>Employee Department</label>
            <div className="input-group input-group-outline my-1">
              <select
                className="form-control"
                value={selectedDepartment}
                onChange={(e) => setSelectedDepartment(e.target.value)}
              >
                <option value="">All Department</option>
                {employeeDepartments.map((dept) => (
                  <option key={dept.id} value={dept.id}>
                    {dept.department_name}
                  </option>
                ))}
              </select>
            </div>
          </div>

       
        </div>
        <div className="p-3">
          <Checkbox.Group
            options={columnOptions}
            defaultValue={selectedColumns}
            onChange={handleColumnChange}
          />
        </div>


        <DataTable
          rowData={allEmployeeData.map((emp) => {
            const filteredEmp = {};
            selectedColumns.forEach((col) => {
              filteredEmp[col] = emp[col];
            });
            return filteredEmp;
          })}
          entriesPerPage={5}
          columns={columnOptions
            .filter((col) => selectedColumns.includes(col.value))
            .map((col) => ({
              header: col.label,
              rowKey: col.value,
              style: { width: "15%" },
            }))}
        />
      </div>
    </div>
  );
};

export default ExportEmployeeData;
