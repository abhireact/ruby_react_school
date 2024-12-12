import React, { useState, useEffect } from 'react';
import { Button, Card, Tag, Space, Spin, Modal,Tooltip } from 'antd';
import { CheckOutlined, CloseOutlined, UploadOutlined, ReloadOutlined ,CloudUploadOutlined,DownloadOutlined} from '@ant-design/icons';
import ExcelExtractSender from "./ExcelExtractSender";
import exportedSet1Data from "./Sets/set1";
import exportedSet2Data from './Sets/set2';
import exportedSet3Data from './Sets/set3';
import exportedSet4Data from './Sets/set4';
import exportedSet5Data from './Sets/set5';
//Set One 
import academicYearExcel from './sample_excel_sheets/set_one/academic_year_excel.xlsx'
import wingsExcel from './sample_excel_sheets/set_one/wings_excel.xlsx'
import accountsExcel from './sample_excel_sheets/set_one/accounts_excel.xlsx'
import classExcel from './sample_excel_sheets/set_one/class_excel.xlsx'
import sectionExcel from './sample_excel_sheets/set_one/section_excel.xlsx'
// Set Two
import employeeDepartmentExcel from './sample_excel_sheets/set_two/employee_department_excel.xlsx';
import employeeExcel from './sample_excel_sheets/set_two/employee_excel.xlsx';
import employeeGradeExcel from './sample_excel_sheets/set_two/employee_grade_excel.xlsx';
import employeeLeavesExcel from './sample_excel_sheets/set_two/employee_leaves_excel.xlsx';
import employeeProfileExcel from './sample_excel_sheets/set_two/employee_profile_excel.xlsx';
import employeeSalaryExcel from './sample_excel_sheets/set_two/employee_salary_excel.xlsx';
import employeeTypeExcel from './sample_excel_sheets/set_two/employee_type_excel.xlsx';
// Set Three
import casteCategoryExcel from './sample_excel_sheets/set_three/caste_category_excel.xlsx';
import casteExcel from './sample_excel_sheets/set_three/caste_excel.xlsx';
import houseDetailsExcel from './sample_excel_sheets/set_three/house_details_excel.xlsx';
import sectionSubjectExcel from './sample_excel_sheets/set_three/section_subject_excel.xlsx';
import studentCategoryExcel from './sample_excel_sheets/set_three/student_category_excel.xlsx';
import studentExcel from './sample_excel_sheets/set_three/student_excel.xlsx';
import subjectExcel from './sample_excel_sheets/set_three/subject_excel.xlsx';
// Set Four
import feeCategoryExcel from './sample_excel_sheets/set_four/fee_category_excel.xlsx';
import feeDiscountExcel from './sample_excel_sheets/set_four/fee_discount_excel.xlsx';
import feeParticularExcel from './sample_excel_sheets/set_four/fee_particular_excel.xlsx';
import lateFeeFineExcel from './sample_excel_sheets/set_four/latefeefine_excel.xlsx';

// Set Five
import kioskExcel from './sample_excel_sheets/set_five/kiosk_excel.xlsx';
import libraryAssistantInchargeExcel from './sample_excel_sheets/set_five/library_assistant_incharge_excel.xlsx';
import libraryInchargeExcel from './sample_excel_sheets/set_five/library_incharge_excel.xlsx';
import libraryManageSubjectExcel from './sample_excel_sheets/set_five/library_manage_subject_excel.xlsx';
import libraryResourceCategoryExcel from './sample_excel_sheets/set_five/library_resource_category_excel.xlsx';
import libraryResourceInventoryExcel from './sample_excel_sheets/set_five/library_resource_inventory_excel.xlsx';
import libraryResourceTypeExcel from './sample_excel_sheets/set_five/library_resource_type_excel.xlsx';
import libraryStackManagementExcel from './sample_excel_sheets/set_five/library_stack_management_excel.xlsx';





const setOneFiles = [
  { name: "Academic Year", path: academicYearExcel },
  {name:"Wings ",path:wingsExcel},
  {name:"Class",path:classExcel},
  {name:"Section",path:sectionExcel},
  {name:"Account",path:accountsExcel}

];
const setTwoFiles = [
  { name: "Employee Department", path: employeeDepartmentExcel },
  { name: "Employee Profile", path: employeeProfileExcel },
  { name: "Employee Type", path: employeeTypeExcel },
  { name: "Employee Salary", path: employeeSalaryExcel },

  { name: "Employee Grade", path: employeeGradeExcel },
  { name: "Employee Leaves", path: employeeLeavesExcel },
  { name: "Employee Details", path: employeeExcel },


 
];
const setThreeFiles = [
  { name: "Caste Details", path: casteExcel },
  { name: "Caste Category", path: casteCategoryExcel },
  { name: "Student Category", path: studentCategoryExcel },
  { name: "House Details", path: houseDetailsExcel },
  { name: "Subject Details", path: subjectExcel },
  { name: "Section Subject", path: sectionSubjectExcel },
 
  { name: "Student Details", path: studentExcel },
 
];
const setFourFiles = [
  { name: "Fee Category", path: feeCategoryExcel },
  { name: "Fee Particular", path: feeParticularExcel },
  { name: "Fee Discount", path: feeDiscountExcel },
  
  { name: "Late Fee Fine", path: lateFeeFineExcel }
];
const setFiveFiles = [
  { name: "Library Resource Category", path: libraryResourceCategoryExcel },
  { name: "Library Resource Type", path: libraryResourceTypeExcel },
  { name: "Library Manage Subject", path: libraryManageSubjectExcel },
  { name: "Library Stack Management", path: libraryStackManagementExcel },
  { name: "Library Resource Inventory", path: libraryResourceInventoryExcel },
  { name: "Library Incharge", path: libraryInchargeExcel },
  { name: "Library Assistant Incharge", path: libraryAssistantInchargeExcel },
  { name: "Kiosk", path: kioskExcel },
 ];
const ExcelReader = () => {
  const [expandedSets, setExpandedSets] = useState({});
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false); // For modal visibility
  const [selectedItem, setSelectedItem] = useState(null); // For selected item data to pass to modal
  const [set1Data, setSet1Data] = useState([]); // Store the resolved set1Data
  const [set2Data,setSet2Data] = useState([]);
  const [set3Data,setSet3Data] = useState([]);
  const [set4Data,setSet4Data] = useState([]);
  const [set5Data,setSet5Data] = useState([]);

  useEffect(() => {
    // Fetch the set1Data once the component mounts
    const fetchData = async () => {
      try {
        const setOneData = await exportedSet1Data; // Wait for the promise to resolve
        setSet1Data(setOneData);
        const setTwoData = await exportedSet2Data; // Wait for the promise to resolve
        setSet2Data(setTwoData);
        const setThreeData = await exportedSet3Data; // Wait for the promise to resolve
        setSet3Data(setThreeData);
        const setFourData = await exportedSet4Data; // Wait for the promise to resolve
        setSet4Data(setFourData);
        const setFiveData = await exportedSet5Data; // Wait for the promise to resolve
        setSet5Data(setFiveData);
      } catch (error) {
        console.error("Error fetching", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const sets = [
    { number: 1, data: set1Data },
    {number:2,data:set2Data},
    {number:3,data:set3Data},
    {number:4,data:set4Data},
    {number:5,data:set5Data}
  ];

  const handleSetClick = (setNumber) => {
    setExpandedSets((prev) => ({
      ...prev,
      [setNumber]: !prev[setNumber],
    }));
  };

  const handleUploadClick = (item) => {
    setSelectedItem(item); // Set selected item data for modal
    setModalVisible(true); // Show modal
  };

  const renderSetData = (setNumber, data, setFiles) => {
    if (!expandedSets[setNumber]) return null;
  
    let isBlocked = false;
  
    return (
      <div style={{ marginLeft: '16px', marginTop: '16px' }}>
        {data.map((item, index) => {
          const currentBlocked = isBlocked;
          if (!item.done) isBlocked = true;
  
          return (
            <div
              key={item.id}
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                padding: '12px',
                borderBottom: '1px solid #f0f0f0',
              }}
            >
              <span
                style={{
                  fontSize: '14px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                }}
              >
                {item.name}
              </span>
              <span
                style={{
                  fontSize: '14px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                }}
              >
                <span
                  style={{
                    fontSize: '14px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                  }}
                >
                  {/* Icon based on "done" state */}
                  {item.done ? (
                    <Tag icon={<CheckOutlined />} color="success">
                      Done
                    </Tag>
                  ) : (
                    <Tag icon={<CloseOutlined />} color="error">
                      Not Done
                    </Tag>
                  )}
                </span>
                <span style={{ margin: '0 50px' }} /> {/* Spacer between buttons */}
                <Space size="large">
                  <Button
                    style={{
                      backgroundColor: item.done ? undefined : '#52C41B',
                      borderColor: item.done ? undefined : '#52C41B',
                    }}
                    icon={<CloudUploadOutlined />}
                    onClick={() => handleUploadClick(item)}
                    disabled={currentBlocked}
                  >
                    {item.done ? 'Upload More Data' : 'Upload Data'}
                  </Button>
                  <Tooltip title="Download Sample Excel">
                    {setFiles[index] && (
                      <a href={setFiles[index].path} download={setFiles[index].name}>
                        <Button
                          icon={<DownloadOutlined style={{ color: '#1890ff' }} />}
                          style={{ borderColor: '#1890ff', color: '#1890ff' }}
                        >
                          
                        </Button>
                      </a>
                    )}
                  </Tooltip>
                </Space>
              </span>
            </div>
          );
        })}
      </div>
    );
  };
  
  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '50px' }}>
        <Spin size="large" />
      </div>
    );
  }

  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '24px' }}>
      <Card>
        <h2
          style={{
            textAlign: 'center',
            color: '#1890ff',
            marginBottom: '24px',
            fontSize: '24px',
            fontWeight: 'bold',
          }}
        >
          Data Upload Portal
        </h2>
        <Space direction="vertical" style={{ width: '100%' }} size={16}>
          {sets.map(({ number, data }) => (
            <Card
              key={number}
              title={`SET - ${number}`}
              extra={
                data.every((item) => item.done) ? (
                  <Tag icon={<CheckOutlined />} color="success">
                    Data Available
                  </Tag>
                ) : (
                  <Tag icon={<CloseOutlined />} color="error">
                    Incomplete Data
                  </Tag>
                )
              }
              onClick={() => handleSetClick(number)}
              style={{ cursor: 'pointer' }}
              hoverable
            >
                  {renderSetData(
              number,
              data,
              number === 1
                ? setOneFiles
                : number === 2
                ? setTwoFiles
                : number === 3
                ? setThreeFiles
                : number === 4
                ? setFourFiles
                : setFiveFiles
            )}
            </Card>
          ))}
        </Space>
      </Card>

      {/* Modal for ExcelExtractSender */}
      <Modal
        title={''}
        visible={modalVisible}
        onCancel={() => {
          setModalVisible(false);
          window.location.reload();
        }}
        footer={null}
        width={800}
      >
        {selectedItem && (
          <ExcelExtractSender
            requiredHeaders={selectedItem.requiredHeaders}
            optionalHeaders={selectedItem.optionalHeaders}
            title={selectedItem.title}
            uploadEndpoint={selectedItem.uploadEndpoint}
            formatData={selectedItem.formatData}
            headerline = {selectedItem.headerline||0}
            dataline = {selectedItem.dataline||1}
          />
        )}
      </Modal>
    </div>
  );
};

export default ExcelReader;
