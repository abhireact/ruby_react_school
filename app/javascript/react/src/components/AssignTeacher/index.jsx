import React, { useState, useEffect } from "react";
import { Formik, Form } from "formik";
import { Table, Button, Offcanvas } from "react-bootstrap";
import { message } from 'antd';
import { UserAddOutlined, UserSwitchOutlined } from '@ant-design/icons';
import {CircleUser} from "lucide-react";

import axios from 'axios';

const AssignTeacher = ({ userData }) => {
  console.log(userData,"sdfsd")
  const [academicYearData] = useState(userData.academic_year_data || []);
  const [wingData] = useState(userData.wings_data || []);
  const [sectionClassData] = useState(userData.section_class || []);
  const [teacherData] = useState(userData.employees_data || []);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedWing, setSelectedWing] = useState("");
  const [filteredSections, setFilteredSections] = useState([]);
  const [availableTeachers, setAvailableTeachers] = useState([]);
  const [selectedSection, setSelectedSection] = useState(null);
  const [showAssignForm, setShowAssignForm] = useState(false);
  const [selectedTeacher, setSelectedTeacher] = useState(null);

  useEffect(() => {
    if (selectedAcademicYear && selectedWing) {
      const enrichedSections = sectionClassData.map((section) => {
        const matchedTeacher = teacherData.find(
          (teacher) => teacher.id === section.mg_employee_id
        );
        return {
          ...section,
          teacherName: matchedTeacher
            ? `${matchedTeacher.first_name || ""} ${matchedTeacher.middle_name || ""} ${matchedTeacher.last_name || ""}`.trim()
            : null,
          userName: matchedTeacher ? matchedTeacher.user_name : null,
        };
      });

      const filtered = enrichedSections.filter(
        (section) =>
          section.mg_time_table_id === parseInt(selectedAcademicYear) &&
          section.mg_wing_id === parseInt(selectedWing)
      );

      setFilteredSections(filtered);

      const assignedTeacherIds = new Set(
        enrichedSections.map((section) => section.mg_employee_id)
      );
      const unassignedTeachers = teacherData.filter(
        (teacher) => !assignedTeacherIds.has(teacher.id) 
      );
      setAvailableTeachers(unassignedTeachers);
    } else {
      setFilteredSections([]);
      setAvailableTeachers([]);
    }
  }, [selectedAcademicYear, selectedWing, sectionClassData, teacherData]);

  const handleAssign = (section) => {
    setSelectedSection(section);
    setSelectedTeacher(null); // Reset selected teacher
    setShowAssignForm(true);
  };

  const handleSubmitAssign = async () => {
    const token = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");
    if (selectedTeacher) {
      const payload = {
        id: selectedSection.mg_batch_id,
        mg_employee_id: selectedTeacher.id,
      };
      console.log("Assignment submitted:", payload);

      const response = await axios.post("/assign_teacher/assign_teacher_update_or_create", payload, {
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        }
      });
      if(response.data.success){
      message.success(response.data.message)
      setShowAssignForm(false);
      setSelectedSection(null);
      window.location.reload();
      }
      else{
        message.error(response.data.message)
        setShowAssignForm(false);
        setSelectedSection(null);
      }

      console.log(response,"repsonse")
  
    }
  };

  return (
    <div className="container my-4">
      <div className="card mb-4">
        <div className="card-header pb-0">
          <h5 className="my-2">Assign Class Teacher</h5>
          <Formik
            initialValues={{
              mg_time_table_id: "",
              mg_wing_id: "",
            }}
            onSubmit={() => {}}
          >
            {({ setFieldValue, values }) => (
              <Form>
                <div className="row">
                  <div className="col-md-4">
                    <label>Academic Year</label>
                    <div className="input-group input-group-outline my-3">
                      <select
                        name="mg_time_table_id"
                        className="form-control"
                        onChange={(e) => {
                          setFieldValue("mg_time_table_id", e.target.value);
                          setFieldValue("mg_wing_id", "");
                          setSelectedAcademicYear(e.target.value);
                          setSelectedWing("");
                        }}
                      >
                        <option value="">Select Academic Year</option>
                        {academicYearData.map((year) => (
                          <option key={year.id} value={year.id}>
                            {year.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="col-md-4">
                    <label>Wing Name</label>
                    <div className="input-group input-group-outline my-3">
                      <select
                        name="mg_wing_id"
                        className="form-control"
                        onChange={(e) => {
                          setFieldValue("mg_wing_id", e.target.value);
                          setSelectedWing(e.target.value);
                        }}
                        disabled={!values.mg_time_table_id}
                      >
                        <option value="">Select Wing</option>
                        {wingData.map((wing) => (
                          <option key={wing.id} value={wing.id}>
                            {wing.wing_name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                </div>
              </Form>
            )}
          </Formik>
        </div>

        {filteredSections.length > 0 && (
          <div className="card-body">
            <Table striped bordered hover>
              <thead>
                <tr>
                  <th>Class & Section</th>
                  <th>Teacher Name</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {filteredSections.map((section, index) => (
                  <tr key={index}>
                    <td>{section.name}</td>
                    <td>
                      {section.teacherName || "N/A"} ({section.userName || "N/A"})
                    </td>
                    <td>
                    <Button
                        variant="text"
                        onClick={() => handleAssign(section)}
                      >
                      {section.teacherName ? (
    <span style={{ fontSize: "12px", color: "black" }}>
      <UserSwitchOutlined style={{ fontSize: "24px", marginRight: "8px" }} />
      Edit
    </span>
  ) : (
    <span style={{ fontSize: "12px", color: "blue" }}>
      <UserAddOutlined style={{ fontSize: "24px", marginRight: "8px" }} />
      Assign
    </span>
  )}
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        )}
      </div>

      <Offcanvas
        show={showAssignForm}
        onHide={() => setShowAssignForm(false)}
        placement="end"
        style={{ width: "40%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>
            Choose Teacher for {selectedSection?.name || ""}
          </Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
  {selectedSection && (
    <div>
 {availableTeachers.length>0?     <div >
        <p className="card-text">Select One from Available Teachers</p>

        {/* Scrollable Teacher Cards */}
        <div
          className="row g-3"
          style={{
            maxHeight: "500px",
            overflowY: "auto",
            border: "1px solid #ddd",
            borderRadius: "8px",
            padding: "10px",
          }}
        >
          {availableTeachers.map((teacher) => (
            <div
              key={teacher.id}
              className="col-12"
              onClick={() => setSelectedTeacher(teacher)}
              style={{ cursor: "pointer" }}
            >
              <div
                className={`card ${
                  selectedTeacher?.id === teacher.id ? "border-info" : "border-light"
                }`}
                style={{
                  backgroundColor:
                    selectedTeacher?.id === teacher.id ? "#e8f5fe" : "#ffffff",
                  boxShadow: "0px 4px 8px rgba(0, 0, 0, 0.1)",
                  transition: "transform 0.2s",
                }}
              >
                <div className="card-body d-flex justify-content-between align-items-center">
                  {/* Teacher Details */}
                  <div className="d-flex align-items-center">
  <CircleUser
    className="me-3"
    style={{
      width: "24px",
      height: "24px",
      color: "#17a2b8",
    }}
  />
  <div>
    <h6 className="mb-0">
      {teacher.first_name} {teacher.last_name}
    </h6>
  </div>
</div>

                  {/* Username */}
                  <div>
                    <small className="text-muted">
                      <strong>{teacher.user_name}</strong>
                    </small>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
        {selectedTeacher &&    <div className="m-1">
        <Button
          type="button"
          variant="info"
          onClick={handleSubmitAssign}
          disabled={!selectedTeacher}
          className="px-4"
        >
          Submit
        </Button>
      </div>}
      </div>:  <p className="card-text">Teachers are not Available</p>}

  
   
    </div>
  )}
</Offcanvas.Body>





      </Offcanvas>
    </div>
  );
};

export default AssignTeacher;
