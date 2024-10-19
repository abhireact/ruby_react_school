// import React, { useState, useMemo } from 'react';
// import { Table, Form, InputGroup, Pagination } from 'react-bootstrap';
// import { Search } from 'lucide-react';

// const useSearch = (items, searchKeys) => {
//   const [searchTerm, setSearchTerm] = useState('');

//   const filteredItems = useMemo(() => {
//     if (!searchTerm) return items;
//     return items.filter((item) =>
//       searchKeys.some((key) =>
//         item[key].toString().toLowerCase().includes(searchTerm.toLowerCase())
//       )
//     );
//   }, [items, searchTerm, searchKeys]);

//   return { searchTerm, setSearchTerm, filteredItems };
// };

// const usePagination = (items, itemsPerPage) => {
//   const [currentPage, setCurrentPage] = useState(1);

//   const totalPages = Math.ceil(items.length / itemsPerPage);
//   const indexOfLastItem = currentPage * itemsPerPage;
//   const indexOfFirstItem = indexOfLastItem - itemsPerPage;
//   const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

//   const paginate = (pageNumber) => setCurrentPage(pageNumber);

//   return {
//     currentItems,
//     currentPage,
//     totalPages,
//     paginate,
//   };
// };

// const DataTable = ({ columns, data }) => {
//   const [entriesPerPage, setEntriesPerPage] = useState(10);

//   const { searchTerm, setSearchTerm, filteredItems } = useSearch(
//     data,
//     columns.map((col) => col.key)
//   );

//   const { currentItems, currentPage, totalPages, paginate } = usePagination(
//     filteredItems,
//     entriesPerPage
//   );

//   return (
//     <div className="card">
//       <div className="card-body px-0 pb-0">
//         <div className="table-responsive p-0">
//           <div className="d-flex justify-content-between align-items-center px-3 py-3">
//             <div className="d-flex align-items-center">
//               <span>Show</span>
//               <Form.Select
//                 size="sm"
//                 className="mx-2"
//                 value={entriesPerPage}
//                 onChange={(e) => setEntriesPerPage(Number(e.target.value))}
//               >
//                 <option value={5}>5</option>
//                 <option value={10}>10</option>
//                 <option value={25}>25</option>
//                 <option value={50}>50</option>
//               </Form.Select>
//               <span>entries</span>
//             </div>
//             <InputGroup className="w-auto">
//               <InputGroup.Text>
//                 <Search size={18} />
//               </InputGroup.Text>
//               <Form.Control
//                 type="text"
//                 placeholder="Search..."
//                 value={searchTerm}
//                 onChange={(e) => setSearchTerm(e.target.value)}
//               />
//             </InputGroup>
//           </div>
//           <Table className="table table-hover table-striped mb-0">
//             <thead>
//               <tr>
//                 {columns.map((col) => (
//                   <th
//                     key={col.key}
//                     className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3"
//                   >
//                     {col.label}
//                   </th>
//                 ))}
//               </tr>
//             </thead>
//             <tbody>
//               {currentItems.map((item, index) => (
//                 <tr key={index}>
//                   {columns.map((col) => (
//                     <td key={col.key} className="align-middle text-sm ps-3">
//                       {item[col.key]}
//                     </td>
//                   ))}
//                 </tr>
//               ))}
//             </tbody>
//           </Table>
//         </div>
//         <div className="d-flex justify-content-end align-items-center mt-3">
//           <span className="me-3">
//             Page {currentPage} of {totalPages}
//           </span>
//           <Pagination className="mb-0">
//             <Pagination.Prev
//               onClick={() => paginate(currentPage - 1)}
//               disabled={currentPage === 1}
//             />
//             {[...Array(totalPages)].map((_, index) => (
//               <Pagination.Item
//                 key={index + 1}
//                 active={index + 1 === currentPage}
//                 onClick={() => paginate(index + 1)}
//               >
//                 {index + 1}
//               </Pagination.Item>
//             ))}
//             <Pagination.Next
//               onClick={() => paginate(currentPage + 1)}
//               disabled={currentPage === totalPages}
//             />
//           </Pagination>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default DataTable;

// import React, { useState, useMemo } from 'react';
// import { Table, Form, InputGroup, Pagination, Button } from 'react-bootstrap';
// import { Search, Eye, Edit, Trash } from 'lucide-react';

// const useSearch = (items, searchKeys) => {
//   const [searchTerm, setSearchTerm] = useState('');

//   const filteredItems = useMemo(() => {
//     if (!searchTerm) return items;
//     return items.filter((item) =>
//       searchKeys.some((key) =>
//         item[key].toString().toLowerCase().includes(searchTerm.toLowerCase())
//       )
//     );
//   }, [items, searchTerm, searchKeys]);

//   return { searchTerm, setSearchTerm, filteredItems };
// };

// const usePagination = (items, itemsPerPage) => {
//   const [currentPage, setCurrentPage] = useState(1);

//   const totalPages = Math.ceil(items.length / itemsPerPage);
//   const indexOfLastItem = currentPage * itemsPerPage;
//   const indexOfFirstItem = indexOfLastItem - itemsPerPage;
//   const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

//   const paginate = (pageNumber) => setCurrentPage(pageNumber);

//   return {
//     currentItems,
//     currentPage,
//     totalPages,
//     paginate,
//   };
// };

// const DataTable = ({ columns, data, onView, onEdit, onDelete }) => {
//   const [entriesPerPage, setEntriesPerPage] = useState(10);

//   const { searchTerm, setSearchTerm, filteredItems } = useSearch(
//     data,
//     columns.map((col) => col.key)
//   );

//   const { currentItems, currentPage, totalPages, paginate } = usePagination(
//     filteredItems,
//     entriesPerPage
//   );

//   return (
//     <div className="card">
//       <div className="card-body px-0 pb-0">
//         <div className="table-responsive p-0">
//           <div className="d-flex justify-content-between align-items-center px-3 py-3">
//             <div className="d-flex align-items-center">
//               <span>Show</span>
//               <Form.Select
//                 size="sm"
//                 className="mx-2"
//                 value={entriesPerPage}
//                 onChange={(e) => setEntriesPerPage(Number(e.target.value))}
//               >
//                 <option value={5}>5</option>
//                 <option value={10}>10</option>
//                 <option value={25}>25</option>
//                 <option value={50}>50</option>
//               </Form.Select>
//               <span>entries</span>
//             </div>
//             <InputGroup className="w-auto">
//               <InputGroup.Text>
//                 <Search size={18} />
//               </InputGroup.Text>
//               <Form.Control
//                 type="text"
//                 placeholder="Search..."
//                 value={searchTerm}
//                 onChange={(e) => setSearchTerm(e.target.value)}
//               />
//             </InputGroup>
//           </div>
//           <Table className="table table-hover table-striped mb-0">
//             <thead>
//               <tr>
//                 {columns.map((col) => (
//                   <th
//                     key={col.key}
//                     className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3"
//                   >
//                     {col.label}
//                   </th>
//                 ))}
//                 <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3">
//                   Action
//                 </th>
//               </tr>
//             </thead>
//             <tbody>
//               {currentItems.map((item, index) => (
//                 <tr key={index}>
//                   {columns.map((col) => (
//                     <td key={col.key} className="align-middle text-sm ps-3">
//                       {item[col.key]}
//                     </td>
//                   ))}
//                   <td className="align-middle ps-3">
//                     <Button
//                       variant="link"
//                       className="text-secondary p-0 me-2"
//                       onClick={() => onView(item)}
//                     >
//                       <Eye size={18} />
//                     </Button>
//                     <Button
//                       variant="link"
//                       className="text-secondary p-0 me-2"
//                       onClick={() => onEdit(item)}
//                     >
//                       <Edit size={18} />
//                     </Button>
//                     <Button
//                       variant="link"
//                       className="text-secondary p-0"
//                       onClick={() => onDelete(item.id)}
//                     >
//                       <Trash size={18} />
//                     </Button>
//                   </td>
//                 </tr>
//               ))}
//             </tbody>
//           </Table>
//         </div>
//         <div className="d-flex justify-content-end align-items-center mt-3">
//           <span className="me-3">
//             Page {currentPage} of {totalPages}
//           </span>
//           <Pagination className="mb-0">
//             <Pagination.Prev
//               onClick={() => paginate(currentPage - 1)}
//               disabled={currentPage === 1}
//             />
//             {[...Array(totalPages)].map((_, index) => (
//               <Pagination.Item
//                 key={index + 1}
//                 active={index + 1 === currentPage}
//                 onClick={() => paginate(index + 1)}
//               >
//                 {index + 1}
//               </Pagination.Item>
//             ))}
//             <Pagination.Next
//               onClick={() => paginate(currentPage + 1)}
//               disabled={currentPage === totalPages}
//             />
//           </Pagination>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default DataTable;

import React, { useState, useMemo } from "react";
import { Table, Form, InputGroup, Pagination, Button } from "react-bootstrap";
import { Search, Eye, Edit, Trash } from "lucide-react";

const useSearch = (items, searchKeys) => {
  const [searchTerm, setSearchTerm] = useState("");

  const filteredItems = useMemo(() => {
    if (!searchTerm) return items;
    return items.filter((item) =>
      searchKeys.some((key) => {
        const value = item[key];
        return (
          value != null &&
          value.toString().toLowerCase().includes(searchTerm.toLowerCase())
        );
      })
    );
  }, [items, searchTerm, searchKeys]);

  return { searchTerm, setSearchTerm, filteredItems };
};

const usePagination = (items, itemsPerPage) => {
  const [currentPage, setCurrentPage] = useState(1);

  const totalPages = Math.ceil(items.length / itemsPerPage);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  return {
    currentItems,
    currentPage,
    totalPages,
    paginate,
  };
};

const DataTable = ({ columns, data, onView, onEdit, onDelete }) => {
  const [entriesPerPage, setEntriesPerPage] = useState(10);

  const { searchTerm, setSearchTerm, filteredItems } = useSearch(
    data,
    columns.map((col) => col.key)
  );

  const { currentItems, currentPage, totalPages, paginate } = usePagination(
    filteredItems,
    entriesPerPage
  );

  return (
    <div className="card">
      <div className="card-body px-0 pb-0">
        <div className="table-responsive p-0">
          <div className="d-flex justify-content-between align-items-center px-3 py-3">
            <div className="d-flex align-items-center">
              <span>Show</span>
              <Form.Select
                size="sm"
                className="mx-2"
                value={entriesPerPage}
                onChange={(e) => setEntriesPerPage(Number(e.target.value))}
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
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </InputGroup>
          </div>
          <Table className="table table-hover table-striped mb-0">
            <thead>
              <tr>
                {columns.map((col) => (
                  <th
                    key={col.key}
                    className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3"
                  >
                    {col.label}
                  </th>
                ))}
                <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3">
                  Action
                </th>
              </tr>
            </thead>
            <tbody>
              {currentItems.map((item, index) => (
                <tr key={index}>
                  {columns.map((col) => (
                    <td key={col.key} className="align-middle text-sm ps-3">
                      {/* {item[col.key]} */}
                      {col.render ? col.render(item) : item[col.key]}
                    </td>
                  ))}
                  <td className="align-middle ps-3">
                    {/* <Button
                      variant="link"
                      className="text-secondary p-0 me-2"
                      onClick={() => onView(item)}
                    >
                      <Eye size={18} />
                    </Button> */}
                    {/* <Button
                      variant="link"
                      className="text-secondary p-0 me-2"
                      onClick={() => onEdit(item)}
                    >
                      <Edit size={18} />
                    </Button> */}
                    {/* <Button
                      variant="link"
                      className="text-secondary p-0"
                      onClick={() => onDelete(item.id)}
                    >
                      <Trash size={18} />
                    </Button> */}
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
        <div className="d-flex justify-content-end align-items-center mt-3">
          <span className="me-3">
            Page {currentPage} of {totalPages}
          </span>
          <Pagination className="mb-0">
            <Pagination.Prev
              onClick={() => paginate(currentPage - 1)}
              disabled={currentPage === 1}
            />
            {[...Array(totalPages)].map((_, index) => (
              <Pagination.Item
                key={index + 1}
                active={index + 1 === currentPage}
                onClick={() => paginate(index + 1)}
              >
                {index + 1}
              </Pagination.Item>
            ))}
            <Pagination.Next
              onClick={() => paginate(currentPage + 1)}
              disabled={currentPage === totalPages}
            />
          </Pagination>
        </div>
      </div>
    </div>
  );
};

export default DataTable;
