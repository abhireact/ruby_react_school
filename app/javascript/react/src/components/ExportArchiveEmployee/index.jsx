import React, { useState, useEffect } from "react";
import { DatePicker, message, Button } from "antd";
import ArchiveTable from "./table";
import axios from "axios";
import * as XLSX from "xlsx";
import jsPDF from "jspdf";
import "jspdf-autotable";

const ExportArchiveEmployee = () => {
  const [archiveData, setArchiveData] = useState([]);
  const [filteredData, setFilteredData] = useState([]);
  const [fromDate, setFromDate] = useState(null);
  const [toDate, setToDate] = useState(null);

  // Fetch archive data
  const fetchData = () => {
    axios
      .get(`/employee_archive/show_archive_employees`)
      .then((response) => {
        setArchiveData(response.data.archive_employees);
        setFilteredData(response.data.archive_employees); // Initialize with all records
      })
      .catch((error) => {
        console.error("Error while fetching data", error);
        message.error("Failed to fetch data.");
      });
  };

  useEffect(() => {
    fetchData();
  }, []);


 

  // Auto filter data only when both `fromDate` and `toDate` are filled
  useEffect(() => {
    if (fromDate && toDate) {
      const from = new Date(fromDate).setHours(0, 0, 0, 0);
      const to = new Date(toDate).setHours(23, 59, 59, 999);

      const filtered = archiveData.filter((item) => {
        const archiveDate = new Date(item.archive_date).getTime();
        return archiveDate >= from && archiveDate <= to;
      });

      setFilteredData(filtered);
    } else {
      setFilteredData(archiveData); // Reset to all data if both dates are not set
    }
  }, [fromDate, toDate, archiveData]);

  // Export to Excel
  const exportToExcel = () => {
    const worksheet = XLSX.utils.json_to_sheet(
      filteredData.map((emp) => ({
        ID: emp.id,
        Name: `${emp.first_name} ${
          emp.middle_name !== "-" ? emp.middle_name : ""
        } ${emp.last_name}`.trim(),
        Username: emp.user_name,
        Department: emp.department_name,
        "Archive Date": new Date(emp.archive_date).toLocaleDateString("en-GB"),
      }))
    );
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Archive Employees");
    XLSX.writeFile(workbook, "Archive_Employees.xlsx");
  };

  // Export to PDF
  const exportToPDF = () => {
    const doc = new jsPDF();
    const tableData = filteredData.map((emp) => [
      
      `${emp.first_name} ${
        emp.middle_name !== "-" ? emp.middle_name : ""
      } ${emp.last_name}`.trim(),
      emp.user_name,
      emp.department_name,
      new Date(emp.archive_date).toLocaleDateString("en-GB"),
    ]);

    doc.text("Archive Employee List", 14, 10);
    doc.autoTable({
      head: [["Name", "Username", "Department", "Archive Date"]],
      body: tableData,
    });

    doc.save("Archive_Employees.pdf");
  };

  return (
    <div className="container my-4">
      <div className="card m-2">
        <div className="card-header pb-0">
          <div className="d-flex justify-content-between align-items-center">
            <h5 className="mb-0">Archive Employee List</h5>
            <div>
              <DatePicker
                placeholder="From Date"
                value={fromDate}
                onChange={(date) => setFromDate(date)}
                style={{ marginRight: "10px" }}
              />
              <DatePicker
                placeholder="To Date"
                value={toDate}
                onChange={(date) => setToDate(date)}
                style={{ marginRight: "10px" }}
              />
            </div>
            {filteredData.length > 0 && (
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
        <ArchiveTable
          rowData={filteredData.map((emp) => ({
            id: emp.id,
            username: emp.user_name,
            name: `${emp.first_name} ${
              emp.middle_name !== "-" ? emp.middle_name : ""
            } ${emp.last_name}`.trim(),
            department_name: emp.department_name,
            archive_date: new Date(emp.archive_date).toLocaleDateString(
              "en-GB"
            ), // Format for display
          }))}
          entriesPerPage={5}
          columns={[
            { header: "Name", rowKey: "name", style: { width: "25%" } },
            { header: "Username", rowKey: "username", style: { width: "25%" } },
            { header: "Department Name", rowKey: "department_name", style: { width: "25%" } },
            { header: "Archive Date", rowKey: "archive_date", style: { width: "25%" } },
          ]}
        />
      </div>

 
    </div>
  );
};

export default ExportArchiveEmployee;
