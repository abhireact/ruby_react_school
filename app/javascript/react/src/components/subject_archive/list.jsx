import React, { useState, useCallback, useEffect } from "react";
import axios from "axios";
import DataTable from "../Datatable";
import { Button } from "react-bootstrap";
import { Edit, ArchiveRestore, Archive } from "lucide-react";
import Create from "./index";

const ListManagement = () => {
  const [items, setItems] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isCreate, setIsCreate] = useState(false); // Initialize with false to show the list first

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
    if (!isCreate) {
      fetchItems();
    }
  }, [fetchItems, isCreate]);

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
          <ArchiveRestore size={18} />
        </Button>
      ),
    },
  ];

  return (
    <>
      {isCreate ? (
        <Create onBack={() => setIsCreate(false)} />
      ) : (
        <div className="container-fluid">
          <div className="row">
            <div className="col-12">
              <div className="card">
                <div className="p-2">
                  <div className="d-flex justify-content-between align-items-center">
                    <h4 className="card-title"> Subject Archive Management</h4>

                    <Button
                      onClick={() => setIsCreate(true)}
                      className="btn btn-info d-flex align-items-center gap-2"
                      style={{ textDecoration: "none" }}
                    >
                      <Archive size={18} />
                      Create Subject Archive
                    </Button>
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

export default ListManagement;
