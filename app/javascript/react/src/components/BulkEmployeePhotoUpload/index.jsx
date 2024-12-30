import React, { useState } from "react";
import { Upload, Button, message, Typography, Form, Tooltip, Alert, Card, Space } from "antd";
import { UploadOutlined, CloseCircleOutlined } from "@ant-design/icons";
import axios from "axios";

const { Title, Text } = Typography;

const EmployeePhotoUpload = () => {
  const [fileList, setFileList] = useState([]);
  const [uploadResponse, setUploadResponse] = useState(null);

  // Validate file format and size
  const isValidFile = (file) => {
    const validFormats = ["image/jpeg", "image/png"];
    const isValidFormat = validFormats.includes(file.type);
    const isValidSize = file.size / 1024 / 1024 <= 2; // Convert bytes to MB

    if (!isValidFormat) {
      message.error(`${file.name} is not a valid file format. Only JPG/PNG allowed.`);
    }
    if (!isValidSize) {
      message.error(`${file.name} exceeds the 2 MB size limit.`);
    }

    return isValidFormat && isValidSize;
  };

  // Handle file upload via Ant Design's Upload component
  const handleChange = ({ file, fileList: newFileList }) => {
    // Filter out invalid files
    const filteredList = newFileList.filter((f) => isValidFile(f));
    setFileList(filteredList);
  };

  // Handle form submission
  const handleSubmit = async () => {
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    
    if (fileList.length === 0) {
      message.warning("No files selected. Please choose files to upload.");
      return;
    }
  
    const formData = new FormData();
    fileList.forEach((file) => {
      formData.append("employeeFiles[]", file.originFileObj); // Extract raw file object
    });
  
    try {
      const response = await axios.post(
        "/bulk_employee_photo_upload/bulk_photo_upload",
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
            "X-CSRF-Token": token,
          },
        }
      );
  
      console.log("Response received:", response);
  
      // Store the full response for rendering
      setUploadResponse(response.data);
  
      // Show message based on response
      if (response.data.status === "success") {
        message.success(response.data.message);
        setFileList([]);
      } else {
        message.error(response.data.message);
        setFileList([]);
      }
    } catch (error) {
      console.error("Error occurred during upload:", error);
      if (error.response) {
        setUploadResponse(error.response.data);
        message.error(error.response.data.message);
        setFileList([]);
      } else {
        message.error("An unexpected error occurred.");
      }
    }
  };
  

  // Render detailed response information
  const renderResponseDetails = () => {
    if (!uploadResponse) return null;

    const isSuccess = uploadResponse.status === "success";
    const hasAvailablePhotos = uploadResponse.available_photos && uploadResponse.available_photos.length > 0;
    const hasUnavailablePhotos = uploadResponse.unavailable_photos && uploadResponse.unavailable_photos.length > 0;

    return (
      <Card 
        style={{ 
          marginTop: 16, 
        //   backgroundColor: isSuccess ? "#f6ffed" : "#fff2f0" 
        }}
      >
        {/* <Title level={4} style={{ color: isSuccess ? 'green' : 'red' }}> */}
        <Title level={4}>
          UPLOAD RESULT
        </Title>

   

        {hasAvailablePhotos && (
          <div style={{ marginTop: 16 }}>
            <Text strong style={{ color: 'green' }}>Successfully Uploaded Photos:</Text>
            <ul>
              {uploadResponse.available_photos.map((photo, index) => (
                <li key={index} style={{ color: 'green' }}>{photo}</li>
              ))}
            </ul>
          </div>
        )}

        {hasUnavailablePhotos && (
          <div style={{ marginTop: 16 }}>
            <Text strong style={{ color: 'red' }}>Photos Not Uploaded:</Text>
            <ul>
              {uploadResponse.unavailable_photos.map((photo, index) => (
                <li key={index} style={{ color: 'red' }}>{photo}</li>
              ))}
            </ul>
          </div>
        )}

        {uploadResponse.errors && uploadResponse.errors.length > 0 && (
          <div style={{ marginTop: 16 }}>
            <Text strong style={{ color: 'red' }}>Error Details:</Text>
            <ul>
              {uploadResponse.errors.map((error, index) => (
                <li key={index} style={{ color: 'red' }}>
                  {error.photo_name}: {error.error}
                </li>
              ))}
            </ul>
          </div>
        )}
      </Card>
    );
  };

  return (
    <div className="container mt-4">
      <div className="card">
        <div className="card-body px-4 pb-4">
          <Tooltip title="Upload photos of employees. You can select multiple JPG or PNG files. Each file must be ≤ 2 MB.">
            <Title level={3}>Upload Employee Photos</Title>
          </Tooltip>
          <Form layout="vertical" onFinish={handleSubmit}>
            <Form.Item>
              <Upload
                multiple
                listType="picture"
                fileList={fileList}
                beforeUpload={() => false} // Disable automatic upload
                onChange={handleChange}
                maxCount={10} // Optional: limit to 10 files
              >
                <Button icon={<UploadOutlined />}>Select Employee Images</Button>
              </Upload>
            </Form.Item>
            {fileList.length > 0 &&<Button type="primary" htmlType="submit">
              Upload
            </Button>} 
          </Form>

          {/* Render detailed response */}
          {renderResponseDetails()}
        </div>
      </div>
    </div>
  );
};

export default EmployeePhotoUpload;
