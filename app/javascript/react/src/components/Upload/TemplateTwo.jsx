import React, { useState } from "react";
import * as XLSX from "xlsx";
import { Upload, Button, Card, Typography, Alert, Spin } from "antd";
import {
  FileExcelOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  LoadingOutlined,
  ReloadOutlined,
  AntDesignOutlined,
} from "@ant-design/icons";

const { Title } = Typography;

const ExcelReader = () => {
  const [employeeData, setEmployeeData] = useState([]);
  const [employeeErrorMessage, setEmployeeErrorMessage] = useState("");
  const [importResult, setImportResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [uploadStatus, setUploadStatus] = useState(null); // null, "loading", "success", "error"

  const normalizeHeader = (header) => (header ? header.toString().trim().toLowerCase() : "");

  const normalizeValue = (value, fieldName) => {
    // Check if the value is a number and the field is "employee_dob"
    if (fieldName === "date_of_birth" && typeof value === "number" && value > 59) { // Excel date serial numbers are greater than 59
      const excelStartDate = new Date(1900, 0, 1); // Excel's starting date (January 1, 1900)
      const date = new Date(excelStartDate.getTime() + (value - 1) * 24 * 60 * 60 * 1000); // Convert serial number to actual date
      
      // Format as "YYYY-MM-DD"
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0'); // Month is zero-based, so add 1
      const day = String(date.getDate()).padStart(2, '0');
      
      return `${year}-${month}-${day}`; // Return date in "YYYY-MM-DD" format
    }
    if (fieldName === "employee_joining_date" && typeof value === "number" && value > 59) { // Excel date serial numbers are greater than 59
      const excelStartDate = new Date(1900, 0, 1); // Excel's starting date (January 1, 1900)
      const date = new Date(excelStartDate.getTime() + (value - 1) * 24 * 60 * 60 * 1000); // Convert serial number to actual date
      
      // Format as "YYYY-MM-DD"
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0'); // Month is zero-based, so add 1
      const day = String(date.getDate()).padStart(2, '0');
      
      return `${year}-${month}-${day}`; // Return date in "YYYY-MM-DD" format
    }
  
    // Default handling for other fields
    return value === undefined || value === null || value === "" ? "" : value.toString().trim();
  };
  const REQUIRED_HEADERS = {
    "first name *": "first_name",
    "employee category *": "emp_category",
    "employee department *": "emp_department",
    "mobile number *": "mobile_number",
    "date of birth":"date_of_birth",
    "joining date":"employee_joining_date",
  };

  const ALL_HEADERS = {
    ...REQUIRED_HEADERS,
   "last name *": "last_name",
    "middle name": "middle_name",
    "employee profile": "emp_profile",
    "job title": "job_title",
    "qualification": "qualification",
    "total year experience": "t_year_exp",
    "total month experience": "t_mon_exp",
    "employee type": "emp_type",
    "mother tongue": "mother_tongue",
    "ltc applicable": "ltc_applicable",
    "max class per day": "max_class_per_day",
    "employee grade": "emp_grade",
    "last working day": "last_work_day",
    "status": "status",
    "aadhar number": "aadhar_number",
    "bank name": "bank_name",
    "account number": "account_number",
    "branch name": "branch_name",
    "ifs code": "ifs_code",
    "phone number": "phone_number",
    "email id": "email_id",
  };

  const handleFileUploadEmployee = async (event) => {
    setEmployeeErrorMessage("");
    setEmployeeData([]);
    setImportResult(null);
    setLoading(true);
    setUploadStatus("loading");

    const file = event.target.files[0];
    if (!file) {
      setEmployeeErrorMessage("Please upload a valid Excel file.");
      setLoading(false);
      setUploadStatus("error");
      return;
    }

    const reader = new FileReader();

    reader.onload = async (e) => {
      try {
        const data = e.target.result;
        const workbook = XLSX.read(data, { type: "binary" });
        const worksheet = workbook.Sheets[workbook.SheetNames[0]];
        const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, defval: "" });

        if (jsonData.length < 2) {
          setEmployeeErrorMessage("The Excel sheet is empty or missing data rows.");
          setLoading(false);
          setUploadStatus("error");
          return;
        }

        const headers = jsonData[1] || [];
        const headerMap = {};
        const missingRequiredHeaders = [];

        headers.forEach((header, index) => {
          const normalizedHeader = normalizeHeader(header);
          if (ALL_HEADERS[normalizedHeader]) {
            headerMap[ALL_HEADERS[normalizedHeader]] = index;
          }
        });

        Object.entries(REQUIRED_HEADERS).forEach(([requiredHeader, fieldName]) => {
          if (headerMap[fieldName] === undefined) {
            missingRequiredHeaders.push(requiredHeader.toUpperCase());
          }
        });

        if (missingRequiredHeaders.length > 0) {
          setEmployeeErrorMessage(`Missing required headers: ${missingRequiredHeaders.join(", ")}`);
          setLoading(false);
          setUploadStatus("error");
          return;
        }

        const extractedData = [];
        const errors = [];
        
        for (let row = 2; row < jsonData.length; row++) {
          const rowData = jsonData[row];
          if (rowData.every((cell) => normalizeValue(cell) === "")) continue;
        
          const employeeRecord = {};
          Object.entries(ALL_HEADERS).forEach(([header, fieldName]) => {
            if (headerMap[fieldName] !== undefined) {
              // Pass fieldName along with value for normalization
              employeeRecord[fieldName] = normalizeValue(rowData[headerMap[fieldName]], fieldName);
            }
          });
        
          // Validate required fields
          const rowErrors = [];
          Object.entries(REQUIRED_HEADERS).forEach(([header, fieldName]) => {
            if (!employeeRecord[fieldName]) {
              rowErrors.push(`${header.toUpperCase()} is required`);
            }
          });
        
          if (rowErrors.length > 0) {
            errors.push(`Row ${row + 1}: ${rowErrors.join(", ")}`);
          }
        
          extractedData.push(employeeRecord);
        }

        setEmployeeData(extractedData);
        setUploadStatus(errors.length > 0 ? "error" : "success");
        setEmployeeErrorMessage(errors.join("\n"));
        setLoading(false);
      } catch (error) {
        console.error("Error processing Excel file:", error);
        setEmployeeErrorMessage("An error occurred while processing the file.");
        setLoading(false);
        setUploadStatus("error");
      }
    };

    reader.onerror = () => {
      setEmployeeErrorMessage("Failed to read the Excel file. Please try again.");
      setLoading(false);
      setUploadStatus("error");
    };

    reader.readAsBinaryString(file);
  };

  const handleSendEmployees = () => {
    if (employeeData.length === 0) {
      setEmployeeErrorMessage("No valid employee data to send.");
      return;
    }

    setLoading(true);
    setUploadStatus("loading");
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

    fetch("/upload_excel/upload_employees", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      body: JSON.stringify({
        employees: employeeData,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        setImportResult({
          status: data.status,
          message: data.message,
        });
        if (data.status === "success") {
          setEmployeeData([]);
          setUploadStatus("success");
        }
        setLoading(false);
      })
      .catch((error) => {
        console.error("Upload error:", error);
        setImportResult({
          status: "error",
          message: "Failed to upload employee data",
        });
        setLoading(false);
        setUploadStatus("error");
      });
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      <Title level={2} className="text-center mb-6 text-blue-600">
        Employee Upload
      </Title>
      <Card className="shadow-lg">
        <div className="mb-4">
          <AntDesignOutlined className="mr-2 text-blue-500" />
          <Upload
            beforeUpload={(file) => {
              handleFileUploadEmployee({ target: { files: [file] } });
              return false;
            }}
            accept=".xlsx, .xls"
            showUploadList={false}
          >
            <Button icon={<FileExcelOutlined />}>
              {uploadStatus === "loading" ? "Processing..." : "Upload Excel File"}
            </Button>
          </Upload>
        </div>

        {loading && <Spin className="mb-4" tip="Processing file, please wait..." />}

        {uploadStatus === "success" && (
          <Alert
            icon={<CheckCircleOutlined style={{ color: "green" }} />}
            message="File processed successfully!"
            type="success"
            showIcon
            className="mb-4"
          />
        )}

        {uploadStatus === "error" && (
          <Alert
            icon={<CloseCircleOutlined style={{ color: "red" }} />}
            message={employeeErrorMessage || "An error occurred. Please try again."}
            type="error"
            showIcon
            action={
              <Button
                icon={<ReloadOutlined />}
                type="link"
                onClick={() => document.querySelector("input[type=file]").click()}
              >
                Retry
              </Button>
            }
            className="mb-4"
          />
        )}

        {employeeData.length > 0 && (
          <div className="mt-4 space-x-4">
            <Button type="primary" onClick={handleSendEmployees} disabled={loading}>
              {loading ? <LoadingOutlined /> : "Import"}
            </Button>
          </div>
        )}

    
      </Card>
    </div>
  );
};

export default ExcelReader;
