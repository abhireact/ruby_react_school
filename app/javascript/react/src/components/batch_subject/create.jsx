import React, { useEffect, useState } from "react";
import axios from "axios";
import { Button, Table, Form } from "react-bootstrap";

const SelectSubject = ({ batchId, onBack }) => {
  const [subjects, setSubjects] = useState([]);
  const [selectedSubjects, setSelectedSubjects] = useState([]);
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchSubjects = async () => {
      try {
        setLoading(true);
        const response = await axios.get(
          `/subjects/select_subject/${batchId}`,
          {
            headers: {
              Accept: "application/json",
            },
          }
        );

        setSubjects(response.data.subjects);
        setSelectedSubjects(response.data.selectedSubjects);
        setEmployees(response.data.employees);
        setError(null);
      } catch (error) {
        console.error("Error fetching subjects:", error);
        setError("Failed to load subjects data. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    fetchSubjects();
  }, [batchId]);

  const handleSelectChange = (subjectId, employeeId) => {
    setSelectedSubjects((prevSelected) => {
      const existing = prevSelected.find((s) => s.id === subjectId);
      if (existing) {
        return prevSelected.map((s) =>
          s.id === subjectId ? { ...s, employeeId } : s
        );
      }
      return [...prevSelected, { id: subjectId, employeeId }];
    });
  };

  const handleCheckboxChange = (subjectId) => {
    setSelectedSubjects((prevSelected) =>
      prevSelected.some((s) => s.id === subjectId)
        ? prevSelected.filter((s) => s.id !== subjectId)
        : [...prevSelected, { id: subjectId }]
    );
  };

  const handleSubmit = async () => {
    if (selectedSubjects.length === 0) {
      alert("Please select at least one subject");
      return;
    }

    const token = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    try {
      await axios.post(
        "/subjects/batch_subject",
        {
          batch_id: batchId,
          sub_id_list: selectedSubjects.map((s) => s.id),
          checked_employee_list: selectedSubjects.map((s) => s.employeeId),
        },
        {
          headers: {
            "X-CSRF-Token": token, 
          },
        }
      );
      window.location.href = "/subjects/batch_subject_asso";
    } catch (error) {
      console.error("Error updating subjects:", error);
      alert("Error updating subjects");
    }
  };

  if (loading) return <div className="p-4">Loading subjects...</div>;
  if (error) return <div className="p-4 text-danger">{error}</div>;

  return (
    <div className="p-4 card">
      <h4 className="text-xl font-bold mb-4">Batch {batchId} Subjects</h4>

      <div className="overflow-x-auto">
        <Table striped bordered hover responsive>
          <thead>
            <tr>
              <th>Subject Name</th>
              <th>Subject Code</th>
              <th>Teacher</th>
              <th>Select</th>
            </tr>
          </thead>
          <tbody>
            {subjects.map((sub) => {
              const selected = selectedSubjects.find((s) => s.id === sub.id);
              return (
                <tr key={sub.id} className="hover:bg-gray-50">
                  <td>{sub.subject_name}</td>
                  <td>{sub.subject_code}</td>
                  <td>
                    <Form.Select
                      onChange={(e) =>
                        handleSelectChange(sub.id, e.target.value)
                      }
                      value={selected?.employeeId || ""}
                    >
                      <option value="">Select Teacher</option>
                      {employees.map((emp) => (
                        <option key={emp.id} value={emp.id}>
                          {`${emp.first_name} ${emp.last_name}`.trim()}
                        </option>
                      ))}
                    </Form.Select>
                  </td>
                  <td className="text-center">
                    <Form.Check
                      type="checkbox"
                      checked={!!selected}
                      onChange={() => handleCheckboxChange(sub.id)}
                      label=""
                      style={{ width: "20px", height: "20px" }} // Adjust size as needed
                    />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </Table>
      </div>

      <div className="text-center d-flex justify-content-between gap-3">
        <Button variant="secondary" onClick={onBack} className="mt-2 mb-2">
          Back
        </Button>
        <Button
          type="submit"
          onClick={handleSubmit}
          className="btn btn-info mt-2 mb-2"
          disabled={loading}
        >
          Save
        </Button>
      </div>
    </div>
  );
};

export default SelectSubject;
