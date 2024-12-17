import React, { useState } from "react";
import { Formik, Form } from "formik";
import axios from "axios";
import * as Yup from "yup";
import { message, Select, Table, Input, Button } from "antd";

const validationSchema = Yup.object().shape({
  academicYear: Yup.string().required(" Academic Year is required"),
  section: Yup.string().required(" Section is required"),
  examType: Yup.string().required("Exam Type is required"),
  otherParticular: Yup.string().required("Other Particular is required"),
  otherComponent:Yup.string().required("Other Component is required"),
});

const OtherMarksEntry = ({ userData }) => {
  console.log(userData,"user data")
  const [sections, setSections] = useState(userData.batches_data || []);
  const [academicYears, setAcademicYears] = useState(userData.academic_year_data || []);
  const [examTypes, setExamTypes] = useState(userData.exam_types_data || []);
  const [otherParticulars,setOtherParticulars] = useState(userData.particular_class_section||[]);
  const [otherComponents,setOtherComponents] = useState(userData.particular_component_data||[])
  const [otherGrades,setOtherGrades] = useState(userData.other_grades_data || [])
  
  const [studentData,setStudentData]=useState([])
  const [studentMarks,setStudentMarks] = useState([])
  const [selectedValues, setSelectedValues] = useState({
    academicYear: "",
    section: "",
    examType: "",
    otherParticular: "",
    otherComponent: ""
  });

  const filterSectionsForYear = (academicYearId) => {
    return sections.filter(
      (section) => section.mg_time_table_id === Number(academicYearId)
    );
  };

  const filterExamTypesForBatch = (batchId) => {
    return examTypes.filter(
      (examType) => examType.mg_batch_id === Number(batchId)
    );
  };

  const filterOtherParticularsForBatch = (batchId) => {
    return otherParticulars.filter(
      (particular) => particular.mg_batch_id ==batchId
    );
  };

  const filterOtherComponentsForParticular = (particularId) => {
    return otherComponents.filter(
      (component) => component.other_particular_id ==particularId
    );
  };

  const filterOtherGradesForBatch = (batchId) => {
    let otherGradesForBatchId = otherGrades.filter(
      (grade) => grade.mg_batch_id ==batchId && grade.mg_time_table_id == selectedValues.academicYear
    );
    let otherGradesForNull =  otherGrades.filter(
      (grade) => grade.mg_batch_id ==null && grade.mg_time_table_id == selectedValues.academicYear
    );

    if(otherGradesForBatchId.length>0){
      console.log(otherGradesForBatchId,"batch id for other grades")
      return otherGradesForBatchId
    }
    else{
      console.log(otherGradesForNull," Null batch id for other grades")
      return otherGradesForNull
    }
  };

  const handleSubmit = (values, { setSubmitting, resetForm }) => {
    setStudentData([]);
    const selectedSection = sections.find(
      (section) => section.mg_batch_id === Number(values.section)
    );
    const payload = {
      mg_course_id: selectedSection?.mg_course_id,
      mg_time_table_id: Number(values.academicYear),
      mg_batch_id:Number(values.section),
      mg_cbsc_exam_type_id:Number(values.examType),
      otherPartco_scholastic_component_id:Number(values.otherParticular),
      co_scholastic_particular_id:Number(values.otherComponent)
    };

    axios.get(`/other_marks_entry/other_marksEntry/${payload.mg_course_id}/${payload.mg_time_table_id}/${payload.mg_batch_id}/${payload.mg_cbsc_exam_type_id}/${payload.otherPartco_scholastic_component_id}/${payload.co_scholastic_particular_id}`)
      .then(response => {
        let responseData = [];
        responseData = response.data;
        setStudentData(response.data.students);
        setStudentMarks(response.data.other_marks)
        console.log((response.data.other_marks,"marks data"))
        setSelectedValues(values);
        if(responseData.students.length<1){
          message.error('No Student Data is Available');
        }
        setSubmitting(false)
        console.log(response.data,"response data")
      })
      .catch(error => {
        setSubmitting(false)
        message.error(error.response?.data?.error || 'Failed to get Student Data.');
     
        console.error("Error while fetching grades", error);
      });
  };

  const handleStudentDataSubmit = async (updatedStudentData) => {
    // Validate that we have student data
    if (!updatedStudentData || updatedStudentData.length === 0) {
      message.error('No student data to submit');
      return;
    }
  
    // Ensure we have default values for missing fields
    const payload = {
      student_ids: updatedStudentData.map(student => student.id),
      modified_students: updatedStudentData
        .filter(student => student.otherGrade) // Only include students with a grade
        .map(student => student.id.toString()),
      co_scholastic_grade: updatedStudentData.map(student => student.otherGrade || ''),
      co_scholastic_grade_comments: updatedStudentData.map(() => ''), 
      co_scholastic_obtained_marks: updatedStudentData.map(() => 0), 
      rollNumber: updatedStudentData.map(student => student.roll_number || ''),
      mg_cbsc_exam_type_id: Number(selectedValues.examType),
      mg_cbsc_co_scholastic_exam_component_id: Number(selectedValues.otherParticular),
      mg_cbsc_co_scholastic_exam_particular_id: Number(selectedValues.otherComponent),
      mg_batch_id: Number(selectedValues.section),
    };
  
    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
  
    try {
      const response = await fetch("/other_marks_entry/create_other_marks_entry", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({
          examMarksEntry: payload
        }),
      });
  
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(errorText || 'Network response was not ok');
      }
  
      const data = await response.json();
      message.success('Student Marks Updated Successfully.');
      
    } catch (error) {
      console.error("Error:", error);
      message.error(`Failed to update Student Marks: ${error.message}`);
    }
  };

  return (
    <div className="container mt-4">
      <div className="card m-4">
      <h4 className="m-3">Other Marks Entry</h4>
        <Formik
          initialValues={{
            academicYear: academicYears.length
              ? String(academicYears[academicYears.length - 1].id)
              : "",
            section: "",
            examType: "",
            otherParticular: "",
            otherComponent:"",
          }}
          onSubmit={handleSubmit}
          validationSchema={validationSchema}
        >
          {({ errors, touched, isSubmitting, values, setFieldValue }) => (
            <Form>
              <div className="row m-2">
                <div className="col-md-4">
                  <label>Academic Year</label>
                  <Select
                    style={{ width: "100%" }}
                    placeholder="Select Academic Year"
                    value={values.academicYear}
                    onChange={(value) => {
                      setFieldValue("academicYear", value);
                      setFieldValue("section", "");
                      setFieldValue("examType", "");
                      setFieldValue("otherParticular", "");
                      setFieldValue("otherComponent", "");
                      setStudentData([]);
                    }}
                    options={academicYears.map((year) => ({
                      value: year.id.toString(),
                      label: year.name,
                    }))}
                  />
                  {touched.academicYear && errors.academicYear && (
                    <div className="text-danger">{errors.academicYear}</div>
                  )}
                </div>

                <div className="col-md-4">
                  <label>Class & Section</label>
                  <Select
                    style={{ width: "100%" }}
                    placeholder="Select Class & Section"
                    value={values.section}
                    onChange={(value) => {
                      setFieldValue("section", value);
                      setFieldValue("examType", "");
                      setFieldValue("otherParticular", "");
                      setFieldValue("otherComponent", "");
                      setStudentData([]);
                    }}
                    disabled={!values.academicYear}
                    options={values.academicYear
                      ? filterSectionsForYear(values.academicYear).map((section) => ({
                          value: section.mg_batch_id.toString(),
                          label: section.name,
                        }))
                      : []}
                  />
                  {touched.section && errors.section && (
                    <div className="text-danger">{errors.section}</div>
                  )}
                </div>

                <div className="col-md-4">
                  <label>Exam Type</label>
                  <Select
                    style={{ width: "100%" }}
                    placeholder="Select Exam Type"
                    value={values.examType}
                    onChange={(value) => {setFieldValue("examType", value);
                      setStudentData([]);
                      setFieldValue("otherParticular", "");
                      setFieldValue("otherComponent", "");
                    }}
                    disabled={!values.academicYear || !values.section}
                    options={values.section
                      ? filterExamTypesForBatch(values.section).map((examType) => ({
                          value: examType.mg_cbsc_exam_type_id.toString(),
                          label: examType.exam_type_name,
                        }))
                      : []}
                  />
                  {touched.examType && errors.examType && (
                    <div className="text-danger">{errors.examType}</div>
                  )}
                </div>
              </div>
              <div className="row m-3">
                <div className="col-md-4">
                  <label>Other Particular</label>
                  <Select
                    style={{ width: "100%" }}
                    placeholder="Select Other Particular"
                    value={values.otherParticular}
                    onChange={(value) => {
                      setFieldValue("otherParticular", value);
                      setFieldValue("otherComponent", "");
                      setStudentData([]);
                    }}
                    disabled={!values.academicYear || !values.section ||!values.examType}
                    options={values.section
                      ? filterOtherParticularsForBatch(values.section).map((particular) => ({
                          value: particular.mg_co_scholastic_exam_particular_id.toString(),
                          label: particular.particular_name,
                        }))
                      : []}
                  />
                  {touched.otherParticular && errors.otherParticular && (
                    <div className="text-danger">{errors.otherParticular}</div>
                  )}
                </div>
                <div className="col-md-4">
                  <label>Other Component</label>
                  <Select
                    style={{ width: "100%" }}
                    placeholder="Select Other Component"
                    value={values.otherComponent}
                    onChange={(value) => {
                      setFieldValue("otherComponent", value)
                      setStudentData([]);
                    }}
                    disabled={!values.academicYear || !values.section || !values.otherParticular}
                    options={values.otherParticular
                      ? filterOtherComponentsForParticular(values.otherParticular).map((component) => ({
                          value: component.other_component_id.toString(),
                          label: component.other_component_name,
                        }))
                      : []}
                  />
                  {touched.otherComponent && errors.otherComponent && (
                    <div className="text-danger">{errors.otherComponent}</div>
                  )}
                </div>
              </div>

              <div className="row m-3">
                <div className="col-md-12 d-flex justify-content-end">
                  <button
                    type="submit"
                    className="btn btn-info"
                    disabled={isSubmitting}
                  >
                    {isSubmitting ? "Showing..." : "Show Student Marks"}
                  </button>
                </div>
              </div>
            </Form>
          )}
        </Formik>
      </div>
      {studentData.length > 0 && (
        <div className="card m-4">
       
       <StudentTable
    studentData={studentData}
    studentMarks={studentMarks}  // Add this line
    section={selectedValues.section}
    filterOtherGradesForBatch={filterOtherGradesForBatch}
    onSubmit={handleStudentDataSubmit}
  />

        </div>
      )}
    </div>
  );
};

export default OtherMarksEntry;

const StudentTable = ({ 
  studentData, 
  studentMarks,  // Add this parameter
  onSubmit, 
  section, 
  filterOtherGradesForBatch 
}) => {
  const [studentGrades, setStudentGrades] = useState(
    studentData.map((student) => {
      // Find the corresponding other_marks entry for this student
      const existingMarks = studentMarks?.find(
        mark => mark.mg_student_id === student.id
      );
      
      return {
        ...student,
        otherGrade: existingMarks?.mg_cbsc_co_scholastic_grade_id 
          ? existingMarks.mg_cbsc_co_scholastic_grade_id.toString() 
          : "",
        key: student.id,
      };
    })
  );
  console.log(studentGrades,"student grades")
  // State to track the selected grade to apply to all students
  const [selectedGrade, setSelectedGrade] = useState("");

  const handleGradeChange = (key, value) => {
    const updatedData = studentGrades.map((student) =>
      student.key === key ? { ...student, otherGrade: value } : student
    );
    setStudentGrades(updatedData);
  };

  const handleMarksChange = (key, value) => {
    const updatedData = studentGrades.map((student) =>
      student.key === key ? { ...student, roll_number: value } : student
    );
    setStudentGrades(updatedData);
  };

  const handleBulkGradeChange = (value) => {
    setSelectedGrade(value);
    const updatedData = studentGrades.map((student) => ({
      ...student,
      otherGrade: value,
    }));
    setStudentGrades(updatedData);
  };

  const columns = [
    {
      title: "Name",
      dataIndex: "first_name",
      key: "first_name",
      render: (text, record) => `${record.first_name} ${record.last_name}`,
    },
    {
      title: "Admission Number",
      dataIndex: "admission_number",
      key: "admission_number",
    },
    {
      title: "Roll Number",
      dataIndex: "roll_number",
      key: "roll_number",
      render: (text, record) => (
        <Input
          value={record.roll_number}
          onChange={(e) => handleMarksChange(record.key, e.target.value)}
        />
      ),
    },
    {
      title: "Grade",
      dataIndex: "otherGrade",
      key: "otherGrade",
      render: (text, record) => (
        <Select
          style={{ width: "100%" }}
          placeholder="Select Other Grade"
          value={record.otherGrade}
          onChange={(value) => handleGradeChange(record.key, value)}
          options={filterOtherGradesForBatch(section).map((grade) => ({
            value: grade.id.toString(),
            label: grade.name,
          }))}
          disabled={!section}
        />
      ),
    },
  ];

  return (
    <div>
      <div className="row my-4 mx-2">
        <div className="col-md-12 d-flex justify-content-start">
          <h6>Applicable to All Students: </h6> &nbsp;&nbsp;
          <Select
            style={{ width: "50%" }}
            placeholder="Select Grade for All"
            value={selectedGrade}
            onChange={handleBulkGradeChange}
            options={filterOtherGradesForBatch(section).map((grade) => ({
              value: grade.id.toString(),
              label: grade.name,
            }))}
            disabled={!section}
          />
        </div>
      </div>

      <Table
        dataSource={studentGrades}
        columns={columns}
        rowKey="key"
        pagination={false}
      />

      <div className="col-md-12 m-2 d-flex justify-content-start">
        <button
          type="submit"
          className="btn btn-info"
          onClick={() => onSubmit(studentGrades)}
        >
          Save
        </button>
      </div>
    </div>
  );
};
