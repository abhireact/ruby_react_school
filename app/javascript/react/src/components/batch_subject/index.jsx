import React, { useState, useCallback, useEffect } from "react";
import axios from "axios";
import DataTable from "../Datatable";
import { Button } from "react-bootstrap";
import { Wrench } from "lucide-react";
import CustomAutocomplete from "../Autocomplete";
import { useSelector } from "react-redux";
import Create from "./create";

const BatchSubjectsIndex = () => {
  const [items, setItems] = useState([]);
  const [isCreate, setIsCreate] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState(null);
  const [selectedBatchId, setSelectedBatchId] = useState(null); // State to hold the selected batch ID
  const { academicYear, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear,
    sectionData: state.sectionData,
  }));

  const academicYearOptions = academicYear.map((year) => ({
    value: year.id,
    label: year.name,
  }));

  useEffect(() => {
    const defaultYear = academicYear.find((year) => year.name === "2023-2024");
    if (defaultYear) {
      setSelectedAcademicYear(defaultYear.id);
    }
  }, [academicYear]);

  const fetchCoursesAndBatches = useCallback(async () => {
    if (!selectedAcademicYear) return;

    try {
      setIsLoading(true);
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const response = await axios.get("/application/get_course", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          mg_time_table_id: selectedAcademicYear,
        },
      });

      if (response.data.courses_batches) {
        setItems(
          response.data.courses_batches.map((batch) => ({
            subject_name: batch[0],
            id: batch[1],
          }))
        );
      } else {
        setItems([]);
      }
    } catch (error) {
      setErrorMessage("Failed to fetch classes and batches");
      console.error(error);
    } finally {
      setIsLoading(false);
    }
  }, [selectedAcademicYear]);

  useEffect(() => {
    if (selectedAcademicYear && !isCreate) {
      fetchCoursesAndBatches();
    }
  }, [selectedAcademicYear, fetchCoursesAndBatches, isCreate]);

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
    <>
      {isCreate ? (
        <Create onBack={() => setIsCreate(false)} batchId={selectedBatchId} />
      ) : (
        <div className="container-fluid">
          <div className="row">
            <div className="col-12">
              <div className="card">
                <div className="p-2">
                  <div className="d-flex justify-content-between align-items-center">
                    <h4 className="card-title">Subject Archive Management</h4>
                    <div className="col-md-6">
                      <label className="ms-0">Academic Year</label>
                      <CustomAutocomplete
                        field={{
                          name: "academicYear",
                          value: selectedAcademicYear,
                          onChange: () => {},
                        }}
                        form={{
                          setFieldValue: (name, value) => {
                            setSelectedAcademicYear(value);
                          },
                        }}
                        options={academicYearOptions}
                        label="Select Academic Year"
                        width="100%"
                        showClearButton={true}
                      />
                    </div>
                  </div>
                </div>
                <DataTable
                  columns={columns}
                  data={items}
                  isLoading={isLoading}
                />
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default BatchSubjectsIndex;
