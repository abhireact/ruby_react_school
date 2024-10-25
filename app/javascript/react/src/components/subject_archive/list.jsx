import React, { useState, useCallback, useEffect } from "react";
import axios from "axios";
import DataTable from "../Datatable";
import { Button } from "react-bootstrap";
import { Edit, Archive } from "lucide-react";

const ListManagement = () => {
  const [items, setItems] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const fetchItems = useCallback(async () => {
    setIsLoading(true);
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      const headers = {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      };

      const response = await axios.get(`/subjects/archived_subject_list`, {
        headers,
        params: { api_request: true, format: "json" },
      });
      setItems(response.data);
    } catch (error) {
      console.error("Error fetching items", error);
      setErrorMessage("Failed to fetch items. Please try again.");
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchItems();
  }, [fetchItems]);

  const handleUnarchive = async (id) => {
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      await axios.post(`/subjects/${id}/unarchive`, null, {
        headers: { "X-CSRF-Token": token, "Content-Type": "application/json" },
      });
      fetchItems();
    } catch (error) {
      console.error("Error unarchiving subject:", error);
      setErrorMessage("Failed to unarchive subject. Please try again.");
    }
  };

  const columns = [
    { key: "subject_name", label: "Subject Name" },
    { key: "subject_code", label: "Subject Code" },
    { key: "max_weekly_class", label: "Max Weekly Class" },
    {
      key: "is_core",
      label: "Core Subject",
      render: (item) => (item.is_core ? "Yes" : "No"),
    },
    {
      key: "is_lab",
      label: "Is Lab",
      render: (item) => (item.is_lab ? "Yes" : "No"),
    },
    {
      key: "is_extra_curricular",
      label: "Is Extra Curricular",
      render: (item) => (item.is_extra_curricular ? "Yes" : "No"),
    },
    { key: "no_of_classes", label: "Number of Classes" },
    {
      key: "actions",
      label: "Actions",
      render: (item) => (
        <Button
          variant="link"
          className="text-secondary p-0"
          onClick={() => handleUnarchive(item.id)}
        >
          <Edit size={18} />
        </Button>
      ),
    },
  ];

  return (
    <div className="p-2">
      <div className="mb-6 flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            Subject Archive Management
          </h1>
          <p className="text-gray-600">View and manage archived subjects</p>
        </div>
        <a
          href="/subjects/subject_archive"
          className="btn btn-primary d-flex align-items-center gap-2"
          style={{ textDecoration: "none" }}
        >
          <Archive size={18} />
          Create Subject Archive
        </a>
      </div>

      {errorMessage && <div className="alert alert-danger">{errorMessage}</div>}

      <div className="card-body px-0 pb-0">
        <DataTable columns={columns} data={items} isLoading={isLoading} />
      </div>
    </div>
  );
};

export default ListManagement;
