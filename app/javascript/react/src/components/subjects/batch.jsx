import React, { useState, useCallback, useEffect } from "react";
import axios from "axios";
import DataTable from "../Datatable";
import { Button } from "react-bootstrap";
import { Edit } from "lucide-react";

const BatchSubjectManagement = () => {
  const [academicYears, setAcademicYears] = useState([]);
  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");
  const [batches, setBatches] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const fetchAcademicYears = useCallback(async () => {
    setIsLoading(true);
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      const headers = {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      };

      const response = await axios.get(`/academic_years`, {
        headers,
      });
      setAcademicYears(response.data);
    } catch (error) {
      console.error("Error fetching academic years", error);
      setErrorMessage("Failed to fetch academic years. Please try again.");
    } finally {
      setIsLoading(false);
    }
  }, []);

  const fetchBatches = useCallback(async (academicYearId) => {
    setIsLoading(true);
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      const headers = {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      };

      const response = await axios.get(`/batches`, {
        headers,
        params: { mg_time_table_id: academicYearId },
      });
      setBatches(response.data);
    } catch (error) {
      console.error("Error fetching batches", error);
      setErrorMessage("Failed to fetch batches. Please try again.");
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchAcademicYears();
  }, [fetchAcademicYears]);

  useEffect(() => {
    if (selectedAcademicYear) {
      fetchBatches(selectedAcademicYear);
    }
  }, [selectedAcademicYear, fetchBatches]);

  const handleAcademicYearChange = (e) => {
    setSelectedAcademicYear(e.target.value);
  };

  const columns = [
    { key: "course_name", label: "Course Batch Name" },
    {
      key: "actions",
      label: "Actions",
      render: (item) => (
        <Button
          variant="link"
          className="text-secondary p-0"
          onClick={() => handleManageSubject(item.id)}
        >
          <Edit size={18} />
        </Button>
      ),
    },
  ];

  const handleManageSubject = (batchId) => {
    window.location.href = `/select_subject/${batchId}`;
  };

  return (
    <div className="p-2">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">
          Batch Subject Management
        </h1>
        <p className="text-gray-600">View and manage batch subjects</p>
      </div>

      {errorMessage && <div className="alert alert-danger">{errorMessage}</div>}

      <div className="form-group col-lg-4 col-md-4 col-sm-4 col-xs-12">
        <label htmlFor="mg-label mg-leave-width">
          Select Academic Year<span className="required-field"> *</span>
        </label>
        <select
          className="form-control"
          value={selectedAcademicYear}
          onChange={handleAcademicYearChange}
        >
          <option value="">Select</option>
          {academicYears.map((year) => (
            <option key={year.id} value={year.id}>
              {year.name}
            </option>
          ))}
        </select>
      </div>

      <div className="card-body px-0 pb-0">
        <DataTable columns={columns} data={batches} isLoading={isLoading} />
      </div>
    </div>
  );
};

export default BatchSubjectManagement;
