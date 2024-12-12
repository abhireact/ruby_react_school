import React, { useState } from "react";
import { Upload, Button, Card, Typography, Alert, Spin } from "antd";
import {
  FileExcelOutlined,
  LoadingOutlined,CloudUploadOutlined
} from "@ant-design/icons";
import { handleImport, handleFileUpload } from "../../utils/excelFileExtract";

const { Title } = Typography;

const ExcelExtractSender = ({
  requiredHeaders,
  optionalHeaders = {},
  title,
  uploadEndpoint,
  headerline = 0,
  dataline = 1

}) => {
  const [excelData, setExcelData] = useState([]);
  const [errorMessage, setErrorMessage] = useState(""); // error message state
  const [uploadStatus, setUploadStatus] = useState(null);
  const [loading, setLoading] = useState(false);
  const [responseData, setResponseData] = useState(null);

  const processExcelData = (data) => {
    setExcelData(data);
  };

  const handleFileUploadAndImport = async () => {
    setLoading(true);
    const result = await handleImport(uploadEndpoint, { data: excelData });

    console.log(result, "result from handleImport");  // Verify result structure

    if (result && result.status === "success") {
      setResponseData(result);  // Store the response data
      setUploadStatus("success");
    } else {
      setResponseData(result);
      setUploadStatus("error");
    }
    setLoading(false);
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
   <Title
  level={2}
  className="text-center mb-6"
  style={{ color: "#204E7A" }} // Explicitly set the color here
>
  {title}
</Title>
     
        <div className="mb-4" style={{
                
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-around',
                }}>
        <Upload
  beforeUpload={(file) => {
    setResponseData(null);
    setExcelData([])

    handleFileUpload(
      file,
      requiredHeaders,
      optionalHeaders,
      processExcelData,
      setErrorMessage,  // This updates the errorMessage state
      setLoading,
      setUploadStatus,
      headerline,
  dataline
    );
    return false; // Prevent auto-upload
  }}
  accept=".xlsx, .xls"
  showUploadList={false}
>
{uploadStatus === "loading" ? (
      <Spin indicator={<LoadingOutlined spin />} style={{ color: "white" }} />
    ) : ( <Button
    icon={<FileExcelOutlined />}
    style={{
      backgroundColor: "#1890ff",
      color: "white",
      borderRadius: "8px",
      border: "none",
      boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
      padding: "0 20px",
      fontSize: "16px",
      fontWeight: "bold",
      display: "flex",
      alignItems: "center",
      gap: "8px",
      justifyContent: "center",
    }}
    size="large"
    onMouseEnter={(e) => (e.target.style.backgroundColor = "#1890ff")}
    onMouseLeave={(e) => (e.target.style.backgroundColor = "#1890ff")}
  >
 Upload Excel File

   
  </Button>  )}
</Upload>

{excelData.length > 0 && !loading && (
  <Button
    type="primary"
    onClick={handleFileUploadAndImport}
    disabled={loading}
    style={{
      backgroundColor: "#1F1F1F",
      color: "white",
      borderRadius: "8px",
      border: "none",
      boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
      padding: "0 20px",
      fontSize: "16px",
      fontWeight: "bold",
      display: "flex",
      alignItems: "center",
      gap: "8px",
      justifyContent: "center",
    }}
    size="large"
    onMouseEnter={(e) => (e.target.style.backgroundColor = "#1F1F1F")}
    onMouseLeave={(e) => (e.target.style.backgroundColor = "#1F1F1F")}
  >
    <CloudUploadOutlined />
    &nbsp;&nbsp;
    Import
  </Button>
)}


        </div>

        {loading && (
  <div className="mb-4" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
       <div style={{ fontSize: "16px", color: "#000" }}>
    Please wait...
    </div>
    &nbsp;&nbsp;
    <Spin
      className="mr-2"
      indicator={<LoadingOutlined spin />}
      style={{ fontSize: "24px", color: "#1890ff" }} // Customize the size and color if needed
    />
 
  </div>
)}


        {/* Display general error message from handleFileUpload */}
        {errorMessage && (
          <Alert
            message={errorMessage}
            type="error"
            showIcon
            className="mb-4"
          />
        )}

{/* Display general response message */}
{responseData && responseData.message && (
  <Alert
    message={responseData.message}
    type={uploadStatus === "success" ? "success" : "error"}
    showIcon
    className="mb-4"
  />
)}

{/* Display Error records if any */}
{responseData && responseData.data?.duplicate?.length > 0 && (
  <div className="mt-4">
    <strong>Error Records Found:</strong>
    <ul>
      {responseData.data.duplicate.map((dup, index) => (
        <li key={index}>
          <strong>Row {dup.row}: </strong>
          {dup.error} ({dup.name})
        </li>
      ))}
    </ul>
  </div>
)}

{/* Display created records if any */}
{responseData && responseData.data?.created?.length > 0 && (
  <div className="mt-4">
    <strong>New Records:</strong>
    <ul>
      {responseData.data.created.map((record, index) => (
        <li key={index}>
          <strong>Row {record.row}: </strong>
          {record.name}
        </li>
      ))}
    </ul>
  </div>
)}


 
      
    </div>
  );
};

export default ExcelExtractSender;
