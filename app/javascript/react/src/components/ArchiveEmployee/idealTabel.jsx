import React, { useState, useMemo } from "react";
import { Table, Pagination, Button, Form, InputGroup } from "react-bootstrap";
import { Edit, Trash, Search } from "lucide-react";
import { Popconfirm } from "antd";

const IdealTable = ({
  rowData = [],
  initialEntriesPerPage = 10,
  columns = [],
}) => {
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [entriesPerPage, setEntriesPerPage] = useState(initialEntriesPerPage);

  const filteredData = useMemo(() => {
    return rowData.filter((row) =>
      columns.some(({ rowKey }) =>
        String(row[rowKey] || "")
          .toLowerCase()
          .includes(searchTerm.toLowerCase())
      )
    );
  }, [rowData, searchTerm, columns]);

  const indexOfLastEntry = currentPage * entriesPerPage;
  const indexOfFirstEntry = indexOfLastEntry - entriesPerPage;
  const currentEntries = filteredData.slice(indexOfFirstEntry, indexOfLastEntry);

  const totalPages = Math.ceil(filteredData.length / entriesPerPage);

  const handleEntriesPerPageChange = (e) => {
    setEntriesPerPage(Number(e.target.value));
    setCurrentPage(1); // Reset to first page when changing entries per page
  };

  return (
    <div className="card-body px-0 pb-2">
      <div className="d-flex justify-content-between align-items-center px-3 mb-3">
        <div className="d-flex align-items-center">
          <span>Show</span>
          <Form.Select
            size="sm"
            className="mx-2"
            value={entriesPerPage}
            onChange={handleEntriesPerPageChange}
          >
            <option value={5}>5</option>
            <option value={10}>10</option>
            <option value={25}>25</option>
            <option value={50}>50</option>
          </Form.Select>
          <span>entries</span>
        </div>
        <InputGroup className="w-auto">
          <InputGroup.Text>
            <Search size={18} />
          </InputGroup.Text>
          <Form.Control
            type="text"
            placeholder="Search..."
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value);
              setCurrentPage(1);
            }}
          />
        </InputGroup>
      </div>

      <Table responsive bordered hover striped>
        <thead>
          <tr>
            {columns.map((col) => (
              <th key={col.rowKey} style={col.style}>
                {col.header}
              </th>
            ))}

          </tr>
        </thead>
        <tbody>
          {currentEntries.map((row, rowIndex) => (
            <tr key={row.id || rowIndex}>
              {columns.map((col) => (
                <td key={col.rowKey}>{row[col.rowKey]}</td>
              ))}
       
            </tr>
          ))}
        </tbody>
      </Table>

      <div className="d-flex justify-content-between align-items-center px-3 mt-3">
        <span>
          Showing {indexOfFirstEntry + 1} to{" "}
          {Math.min(indexOfLastEntry, filteredData.length)} of{" "}
          {filteredData.length} entries
        </span>
        <Pagination>
          <Pagination.Prev
            onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
            disabled={currentPage === 1}
          />
          {[...Array(totalPages)].map((_, index) => (
            <Pagination.Item
              key={index + 1}
              active={index + 1 === currentPage}
              onClick={() => setCurrentPage(index + 1)}
            >
              {index + 1}
            </Pagination.Item>
          ))}
          <Pagination.Next
            onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
            disabled={currentPage === totalPages}
          />
        </Pagination>
      </div>
    </div>
  );
};

export default IdealTable;
//Example how to use 
{/* 
    const rowData = [
    { id: 1, name: "John Doe", email: "john@example.com"},
    { id: 2, name: "Jane Smith", email: "jane@example.com" },

  ];

  const columns = [
    { header: "Name", rowKey: "name", style: { width: "20%" }  },
    { header: "Email", rowKey: "email" },
  ];

  <IdealTable
  rowData={rowData}
  entriesPerPage={5}
  columns={columns}

/>

*/}