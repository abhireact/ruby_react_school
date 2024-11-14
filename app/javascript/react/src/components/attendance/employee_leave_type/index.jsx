import React, { useState, useEffect, useCallback } from "react";
import axios from "axios";
import DataTable from "../../Datatable";
import { Button, Offcanvas, Form } from "react-bootstrap";
import { Eye, Edit, Trash } from "lucide-react";
import { useSelector } from "react-redux";
import Show from "./show";
import CreateEdit from "./create_edit";

const EmployeeLeaveTypes = ({ userData }) => {
  const [leaveTypes, setLeaveTypes] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [showDrawer, setShowDrawer] = useState(false);
  const [selectedLeaveType, setSelectedLeaveType] = useState(null);
  const [isViewMode, setIsViewMode] = useState(false);
  const [isCreateMode, setIsCreateMode] = useState(false); // Add state for create mode

  const { academicYear } = useSelector((state) => ({
    academicYear: state.academicYear,
  }));

  const fetchLeaveTypes = useCallback(async () => {
    try {
      setIsLoading(true);
      const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");

      const response = await axios.get("/mg_employee_leave_types", {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
        params: {
          api_request: true,
        },
      });
      setLeaveTypes(response.data || []);
    } catch (error) {
      setErrorMessage("Failed to fetch leave types");
      console.error(error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchLeaveTypes();
  }, [fetchLeaveTypes]);

  const handleDelete = async (id) => {
    const confirmDelete = window.confirm("Are you sure you want to delete this leave type?");
    if (!confirmDelete) return;

    try {
      const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
      await axios.delete(`/mg_employee_leave_types/${id}`, {
        headers: {
          "X-CSRF-Token": token,
        },
      });
      fetchLeaveTypes();
    } catch (error) {
      console.error("Error deleting leave type:", error);
      setErrorMessage("Failed to delete leave type");
    }
  };

  const handleView = (leaveType) => {
    setSelectedLeaveType(leaveType);
    setIsViewMode(true);
    setIsCreateMode(false); // Ensure we're not in create mode
    setShowDrawer(true);
  };

  const handleEdit = (leaveType) => {
    setSelectedLeaveType(leaveType);
    setIsViewMode(false);
    setIsCreateMode(false); // Not in create mode
    setShowDrawer(true);
  };

  const handleCreateNew = () => {
    setSelectedLeaveType(null); // Clear selected leave type for new creation
    setIsViewMode(false); // Not in view mode
    setIsCreateMode(true); // Set create mode to true
    setShowDrawer(true); // Open the drawer
  };

  const handleSaveChanges = async () => {
    try {
      const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
      await axios.put(`/mg_employee_leave_types/${selectedLeaveType.id}`, selectedLeaveType, {
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        },
      });
      fetchLeaveTypes();
      setShowDrawer(false);
    } catch (error) {
      console.error("Error saving leave type:", error);
      setErrorMessage("Failed to save leave type");
    }
  };

  const columns = [
    { key: "leave_name", label: "Leave Name" },
    { key: "leave_code", label: "Leave Code" },
    { key: "max_leave_count", label: "Max Leave Count" },
    {
      key: "reset_period",
      label: "Reset Period",
      render: (item) => {
        switch (item.reset_period) {
          case 1:
            return "Monthly";
          case 6:
            return "Quarterly";
          case 12:
            return "Yearly";
          default:
            return "Not Defined";
        }
      },
    },
    { key: "gender", label: "Gender" },
    { key: "employee_type", label: "Employee Type" },
    { key: "marital_status", label: "Marital Status" },
    {
      key: "actions",
      label: "Actions",
      render: (item) => (
        <div className="d-flex">
          <Button
            variant="link"
            className="text-secondary p-0 mx-1"
            title="View"
            onClick={() => handleView(item)}
          >
            <Eye size={18} />
          </Button>
          <Button
            variant="link"
            className="text-secondary p-0 mx-1"
            title="Edit"
            onClick={() => handleEdit(item)}
          >
            <Edit size={18} />
          </Button>
          <Button
            variant="link"
            className="text-danger p-0 mx-1"
            title="Delete"
            onClick={() => handleDelete(item.id)}
          >
            <Trash size={18} />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="container-fluid card">
      <h4 className="form-section-heading"></h4>
      <div className="d-flex justify-content-between align-items-center">
        <h5 className="mb-0">Employee Leave Types</h5>
        <Button variant="info" size="sm" className="me-2" onClick={handleCreateNew}>
          + New Leave Type
        </Button>
      </div>
      <div>
        <DataTable columns={columns} data={leaveTypes} isLoading={isLoading} />
      </div>
      {errorMessage && <p className="text-danger">{errorMessage}</p>}

      {/* View/Edit/Create Drawer */}
      <Offcanvas
        show={showDrawer} // This should open if showDrawer is true
        onHide={() => setShowDrawer(false)}
        placement="end"
        style={{ width: "60%" }}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>
            {isCreateMode
              ? "Create New Leave Type"
              : isViewMode
              ? "View Leave Type"
              : "Edit Leave Type"}
          </Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          {isCreateMode ? (
            <CreateEdit data={selectedLeaveType} />
          ) : isViewMode ? (
            <Show employeeLeaveType={selectedLeaveType} />
          ) : (
            <CreateEdit data={selectedLeaveType} />
          )}
        </Offcanvas.Body>
      </Offcanvas>
    </div>
  );
};

export default EmployeeLeaveTypes;
