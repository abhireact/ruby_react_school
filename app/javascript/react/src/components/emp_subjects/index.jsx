import React, { useState, useCallback, useEffect } from "react";
import axios from "axios";
import DataTable from "../Datatable";
import { Button } from "react-bootstrap";
import { Edit } from "lucide-react";

const EmpSybIndex = () => {
  const [items, setItems] = useState([]);
  const [categoryInfo, setCategoryInfo] = useState(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const fetchItems = useCallback(async () => {
    setIsLoading(true);
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        ?.getAttribute("content");

      if (!token) {
        throw new Error("CSRF token not found");
      }

      const headers = {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        Accept: "application/json",
      };

      const response = await axios.get("/emp_subjects", {
        headers,
        params: {
          api_request: true,
          format: "json",
        },
      });

      setItems(response.data.employees || []);
      setCategoryInfo(response.data.employee_category || null);
    } catch (error) {
      console.error("Error fetching items:", error);
      setErrorMessage(
        error.response?.data?.message ||
          "Failed to fetch items. Please try again."
      );
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchItems();
  }, [fetchItems]);

  const getFullName = (item) => {
    const firstName = item.first_name || "";
    const middleName = item.middle_name || "";
    const lastName = item.last_name || "";
    return [firstName, middleName, lastName].filter(Boolean).join(" ").trim();
  };

  const columns = [
    {
      key: "employee_number",
      label: "Employee Number",
      render: (item) => item.employee_number || "N/A",
    },
    {
      key: "name",
      label: "Name",
      render: (item) => getFullName(item) || "N/A",
    },
    {
      key: "category",
      label: "Category Position",
      render: (item) => categoryInfo?.category_name || "N/A",
    },
    {
      key: "actions",
      label: "Actions",
      render: (item) => (
        <a
          href={`/select_subject_emp/${item.id}`}
          className="btn btn-link text-secondary p-0"
          onClick={() => localStorage.setItem("selectedEmployeeId", item.id)}
        >
          <Edit size={18} />
        </a>
      ),
    },
  ];

  return (
    <div className="container-fluid">
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="p-2">
              <h4 className="card-title">Employee Directory</h4>
              <p className="card-description">View employee information</p>
            </div>
            {/* <div className="card-body"> */}

            <DataTable
              columns={columns}
              data={items}
              isLoading={isLoading}
              emptyMessage="No employees found"
            />
            {/* </div> */}
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmpSybIndex;
