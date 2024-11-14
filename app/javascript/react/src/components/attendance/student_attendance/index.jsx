import React, { useState, useEffect } from "react";
import { Formik, Form } from "formik";
import { Button } from "react-bootstrap";
import { useSelector } from "react-redux";
import CustomAutocomplete from "../../Autocomplete";
import { getClassSection } from "../../../utils/utils.js";
import axios from "axios";
const StudentAttendance = ({ userData }) => {
  const { academicYear, classData, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear,
    classData: state.classData,
    sectionData: state.sectionData,
  }));
  const [items, setItems] = useState([]);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [selectedClassSection, setSelectedClassSection] = useState(null); // Track selected class section
  const [classSection, setClassSection] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().slice(0, 10)); // Set default date as today's date

  useEffect(() => {
    if (selectedAcademicYear) {
      const result = getClassSection(selectedAcademicYear, classData, sectionData);
      setClassSection(result);
    }
  }, [selectedAcademicYear, classData, sectionData]);

  // Function to handle date change and print academic year, selected class section, and date
  useEffect(() => {
    const fetchSubjects = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`/attendances/time_table_for_attendance`, {
          headers: {
            Accept: "application/json",
          },
          params: {
            mg_batch_id: selectedClassSection,
            absentDate: "06-11-2024",
            sort: "admission_number",
            mg_time_table_id: selectedAcademicYear,
            isapi: true,
          },
        });

        console.log();
      } catch (error) {
        console.error("Error fetching subjects:", error);
        setError("Failed to load subjects data. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    fetchSubjects();
  }, [selectedDate]);
  const handleDateChange = (newDate) => {
    setSelectedDate(newDate);
    // Log academic year, selected class section, and the selected date
    console.log("Academic Year:", selectedAcademicYear);
    console.log("Selected Class Section:", selectedClassSection); // Only selected section
    console.log("Selected Date:", newDate);
  };

  const handleFormSubmit = async (values) => {
    setLoading(true);
    try {
      console.log("Form submitted with:", values);
      setLoading(false);
    } catch (error) {
      console.error("Submission error:", error);
      setLoading(false);
    }
  };
  const columns = [
    { key: "subject_name", label: "Class/Batch Name" },
    {
      key: "actions",
      label: "Actions",
      render: (item) => (
        <Button
          variant="link"
          className="text-secondary p-0"
          onClick={() => {
            setSelectedBatchId(item.id);
            setIsCreate(true);
          }}
        >
          <Wrench size={18} />
        </Button>
      ),
    },
  ];
  return (
    <div className="container-fluid py-4">
      <div className="card">
        <div className="card-header pb-0">
          <h5 className="mb-0">Academic Year Selector</h5>
          <p className="text-sm mb-0">Select an academic year to proceed</p>
        </div>
        <div className="card-body px-0 pb-0">
          <Formik
            initialValues={{ academicYear: selectedAcademicYear, date: selectedDate }} // Add date to initialValues
            onSubmit={(values) => handleFormSubmit(values)}
          >
            {({ setFieldValue }) => (
              <Form className="mx-4">
                <div className="row mb-4">
                  <div className="col-md-4">
                    <div className="input-group input-group-outline">
                      <label className="ms-0">Academic Year</label>
                      <CustomAutocomplete
                        field={{
                          name: "academicYear",
                          value: selectedAcademicYear,
                          onChange: () => {}, // Handled by setFieldValue
                        }}
                        form={{
                          setFieldValue: (name, value) => {
                            setSelectedAcademicYear(value);
                            setFieldValue(name, value);
                          },
                        }}
                        options={academicYear.map((year) => ({
                          value: year.id,
                          label: year.name,
                        }))}
                        label="Select Academic Year"
                        width="100%"
                        showClearButton={true}
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <div className="input-group input-group-outline">
                      <label className="ms-0">Class Section</label>
                      <CustomAutocomplete
                        field={{
                          name: "classSection",
                          value: selectedClassSection ? selectedClassSection.name : "", // Show the selected section name
                          onChange: () => {},
                        }}
                        form={{
                          setFieldValue: (name, value) => {
                            setSelectedClassSection(value); // Store the selected class section object
                            setFieldValue(name, value.name); // Update the field value to class section name
                          },
                        }}
                        options={classSection.map((section) => ({
                          value: section.id,
                          label: section.name,
                        }))}
                        label="Select Class Section"
                        width="100%"
                        showClearButton={true}
                        disabled={classSection.length === 0}
                      />
                    </div>
                  </div>
                  <div className="col-md-4">
                    <div className="input-group input-group-outline">
                      <label className="ms-0">Date</label>
                      <input
                        type="date"
                        className="form-control"
                        value={selectedDate}
                        onChange={(e) => handleDateChange(e.target.value)}
                      />
                    </div>
                  </div>
                </div>

                <Button type="submit" disabled={loading}>
                  {loading ? "Saving..." : "Save Changes"}
                </Button>
              </Form>
            )}
          </Formik>
        </div>
      </div>
    </div>
  );
};

export default StudentAttendance;
