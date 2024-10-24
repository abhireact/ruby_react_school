// import React, {
//   useState,
//   useEffect,
//   useMemo,
//   useCallback,
//   useRef,
// } from "react";
// import { Formik, Field, Form, ErrorMessage } from "formik";
// import * as Yup from "yup";
// import * as XLSX from "xlsx";
// import axios from "axios";
// import {
//   Table,
//   Button,
//   Form as BootstrapForm,
//   InputGroup,
//   Pagination,
// } from "react-bootstrap";
// import { Eye, Edit, Trash, Search } from "lucide-react";

// const useSearch = (items, searchKeys) => {
//   const [searchTerm, setSearchTerm] = useState("");

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

// // Custom hook for pagination
// const usePagination = (items, itemsPerPage) => {
//   const [currentPage, setCurrentPage] = useState(1);
//   const [pageRange, setPageRange] = useState({ start: 1, end: 3 });

//   const totalPages = Math.ceil(items.length / itemsPerPage);
//   const indexOfLastItem = currentPage * itemsPerPage;
//   const indexOfFirstItem = indexOfLastItem - itemsPerPage;
//   const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

//   const paginate = useCallback(
//     (pageNumber) => {
//       setCurrentPage(pageNumber);
//       const rangeSize = 3;
//       if (pageNumber > pageRange.end) {
//         setPageRange((prev) => ({
//           start: prev.start + 1,
//           end: prev.end + 1,
//         }));
//       } else if (pageNumber < pageRange.start) {
//         setPageRange((prev) => ({
//           start: prev.start - 1,
//           end: prev.end - 1,
//         }));
//       }
//     },
//     [pageRange]
//   );

//   return {
//     currentItems,
//     currentPage,
//     totalPages,
//     paginate,
//     pageRange,
//   };
// };

// const GenericCRUD = ({
//   title,
//   description,
//   initialData,
//   columns,
//   apiEndpoint,
//   validationSchema,
//   formFields,
// }) => {
//   const [items, setItems] = useState([]);
//   const [showDrawer, setShowDrawer] = useState(false);
//   const [editData, setEditData] = useState(null);
//   const [entriesPerPage, setEntriesPerPage] = useState(10);
//   const [errorMessage, setErrorMessage] = useState("");
//   const [isViewMode, setIsViewMode] = useState(false);
//   console.log(
//     title,
//     description,
//     initialData,
//     columns,
//     apiEndpoint,
//     validationSchema,
//     formFields,
//     "data from components"
//   );

//   useEffect(() => {
//     setItems(initialData);
//   }, [initialData]);

//   const { searchTerm, setSearchTerm, filteredItems } = useSearch(
//     items,
//     columns.map((col) => col.key)
//   );

//   const { currentItems, currentPage, totalPages, paginate, pageRange } =
//     usePagination(filteredItems, entriesPerPage);

//   const handleShowDrawer = useCallback((item = null) => {
//     setEditData(item);
//     setShowDrawer(true);
//   }, []);
//   const handleShowDrawerview = useCallback((item = null) => {
//     setEditData(item);
//     setShowDrawer(true);
//     setIsViewMode(true); // Set view mode to true
//   }, []);

//   const handleCloseDrawer = useCallback(() => {
//     setShowDrawer(false);
//     setEditData(null);
//     setErrorMessage("");
//     setIsViewMode(false); // Set view mode to true
//     // if (formikRef.current) {
//     //   formikRef.current.resetForm();
//     // }
//     fetchItems();
//   }, []);

//   const fetchItems = useCallback(async () => {
//     try {
//       // Get the CSRF token from the meta tag
//       const token = document
//         .querySelector('meta[name="csrf-token"]')
//         .getAttribute("content");

//       // Set the headers, including the CSRF token
//       const headers = {
//         "X-CSRF-Token": token,
//         "Content-Type": "application/json",
//       };

//       // Make the GET request with headers and params
//       const response = await axios.get(`/${apiEndpoint}`, {
//         headers,
//         params: {
//           api_request: true,
//           format: "json",
//         },
//       });

//       // Update the items with the fetched data
//       console.log(response);
//       setItems(response.data);
//     } catch (error) {
//       console.error("Error fetching items", error);
//       setErrorMessage("Failed to fetch items. Please try again.");
//     }
//   }, [apiEndpoint]);

//   const handleFormSubmit = useCallback(
//     async (values, { setSubmitting, setErrors }) => {
//       const token = document
//         .querySelector('meta[name="csrf-token"]')
//         .getAttribute("content");
//       try {
//         let response;
//         const headers = {
//           "X-CSRF-Token": token,
//           "Content-Type": "application/json",
//         };

//         const payload = { [apiEndpoint]: values };

//         if (editData) {
//           response = await axios.patch(
//             `/${apiEndpoint}/${editData.id}`,
//             payload,
//             { headers }
//           );
//         } else {
//           response = await axios.post(`/${apiEndpoint}`, payload, { headers });
//         }

//         if (response.status === 201 || response.status === 200) {
//           const updatedItem = response.data;
//           setItems((prevItems) => {
//             if (editData) {
//               return prevItems.map((item) =>
//                 item.id === updatedItem.id ? updatedItem : item
//               );
//             } else {
//               return [...prevItems, updatedItem];
//             }
//           });
//           handleCloseDrawer();
//           setErrorMessage("");
//           // window.location.reload()
//         }
//       } catch (error) {
//         console.error("There was an error submitting the form!", error);
//         if (error.response) {
//           if (error.response.status === 404) {
//             setErrorMessage("Item not found.");
//           } else if (error.response.status === 422) {
//             setErrors(error.response.data.errors);
//           } else {
//             setErrorMessage("An error occurred while processing your request.");
//           }
//         } else {
//           setErrorMessage("An unexpected error occurred. Please try again.");
//         }
//       } finally {
//         setSubmitting(false);
//       }
//     },
//     [editData, handleCloseDrawer, apiEndpoint]
//   );

//   const handleDelete = useCallback(
//     async (id) => {
//       if (window.confirm("Are you sure you want to delete this item?")) {
//         const token = document
//           .querySelector('meta[name="csrf-token"]')
//           .getAttribute("content");

//         try {
//           await axios.delete(`/${apiEndpoint}/${id}`, {
//             headers: { "X-CSRF-Token": token },
//           });
//           fetchItems();
//           setItems((prevItems) => prevItems.filter((item) => item.id !== id));
//         } catch (error) {
//           console.error("Error deleting item", error);
//         }
//       }
//     },
//     [apiEndpoint]
//   );

//   const handleExport = useCallback(() => {
//     const ws = XLSX.utils.json_to_sheet(items);
//     const wb = XLSX.utils.book_new();
//     XLSX.utils.book_append_sheet(wb, ws, "Data");
//     XLSX.writeFile(wb, `${apiEndpoint}.xlsx`);
//   }, [items, apiEndpoint]);

//   const handleImport = useCallback((e) => {
//     const file = e.target.files[0];
//     const reader = new FileReader();
//     reader.onload = (event) => {
//       const data = new Uint8Array(event.target.result);
//       const workbook = XLSX.read(data, { type: "array" });
//       const firstSheetName = workbook.SheetNames[0];
//       const worksheet = workbook.Sheets[firstSheetName];
//       const json = XLSX.utils.sheet_to_json(worksheet);
//       setItems(json);
//     };
//     reader.readAsArrayBuffer(file);
//   }, []);

//   return (
//     <div className="container-fluid py-4">
//       <div className="row">
//         <div className="col-12">
//           <div className="card">
//             <div className="card-header pb-0">
//               <div className="d-lg-flex">
//                 <div>
//                   <h5 className="mb-0">{title}</h5>
//                   <p className="text-sm mb-0">{description}</p>
//                 </div>
//                 <div className="ms-auto my-auto mt-lg-0 mt-4">
//                   <div className="ms-auto my-auto">
//                     <Button
//                       variant="info"
//                       size="sm"
//                       className="mb-0"
//                       onClick={() => handleShowDrawer()}
//                     >
//                       + New Item
//                     </Button>
//                     <Button
//                       variant="outline-info"
//                       size="sm"
//                       className="mb-0 ms-2"
//                       onClick={() =>
//                         document.getElementById("fileInput").click()
//                       }
//                     >
//                       Import
//                     </Button>
//                     <Button
//                       variant="outline-info"
//                       size="sm"
//                       className="export mb-0 ms-2"
//                       onClick={handleExport}
//                     >
//                       Export
//                     </Button>
//                     <input
//                       type="file"
//                       id="fileInput"
//                       style={{ display: "none" }}
//                       accept=".xlsx"
//                       onChange={handleImport}
//                     />
//                   </div>
//                 </div>
//               </div>
//             </div>
//             <div className="card-body px-0 pb-0">
//               <div className="table-responsive p-0">
//                 <div className="d-flex justify-content-between align-items-center px-3 py-3">
//                   <div className="d-flex align-items-center">
//                     <span>Show</span>
//                     <BootstrapForm.Select
//                       size="sm"
//                       className="mx-2"
//                       value={entriesPerPage}
//                       onChange={(e) =>
//                         setEntriesPerPage(Number(e.target.value))
//                       }
//                     >
//                       <option value={5}>5</option>
//                       <option value={10}>10</option>
//                       <option value={25}>15</option>
//                       <option value={50}>20</option>
//                     </BootstrapForm.Select>
//                     <span>entries</span>
//                   </div>
//                   <InputGroup className="w-auto">
//                     <InputGroup.Text>
//                       <Search size={18} />
//                     </InputGroup.Text>
//                     <BootstrapForm.Control
//                       type="text"
//                       placeholder="Search..."
//                       value={searchTerm}
//                       onChange={(e) => setSearchTerm(e.target.value)}
//                     />
//                   </InputGroup>
//                 </div>
//                 <Table
//                   id="items-list"
//                   className="table table-hover table-striped mb-0"
//                 >
//                   <thead>
//                     <tr>
//                       {columns.map((col) => (
//                         <th
//                           key={col.key}
//                           className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3"
//                         >
//                           {col.label}
//                         </th>
//                       ))}
//                       <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3">
//                         Action
//                       </th>
//                     </tr>
//                   </thead>
//                   <tbody>
//                     {currentItems.map((item) => (
//                       <tr key={item.id}>
//                         {columns.map((col) => (
//                           <td
//                             key={col.key}
//                             className="align-middle text-sm ps-3"
//                           >
//                             {item[col.key]}
//                           </td>
//                         ))}
//                         <td className="align-middle ps-3">
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0 me-2"
//                             onClick={() => handleShowDrawerview(item)}
//                           >
//                             <Eye size={18} />
//                           </Button>
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0 me-2"
//                             onClick={() => handleShowDrawer(item)}
//                           >
//                             <Edit size={18} />
//                           </Button>
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0"
//                             onClick={() => handleDelete(item.id)}
//                           >
//                             <Trash size={18} />
//                           </Button>
//                         </td>
//                       </tr>
//                     ))}
//                   </tbody>
//                 </Table>
//               </div>
//               <div className="d-flex justify-content-end align-items-center mt-3">
//                 <span className="me-3">
//                   Page {currentPage} of {totalPages}
//                 </span>
//                 <Pagination className="custom-pagination">
//                   <Pagination.Prev
//                     className="prev"
//                     disabled={currentPage === 1}
//                     onClick={() => paginate(currentPage - 1)}
//                   >
//                     &lt;
//                   </Pagination.Prev>
//                   {Array.from({ length: totalPages })
//                     .map((_, index) => index + 1)
//                     .filter(
//                       (number) =>
//                         number === 1 ||
//                         number === totalPages ||
//                         (number >= currentPage - 1 && number <= currentPage + 1)
//                     )
//                     .map((number, index, array) => (
//                       <React.Fragment key={number}>
//                         {index > 0 && array[index - 1] !== number - 1 && (
//                           <Pagination.Ellipsis />
//                         )}
//                         <Pagination.Item
//                           active={number === currentPage}
//                           onClick={() => paginate(number)}
//                         >
//                           {number}
//                         </Pagination.Item>
//                       </React.Fragment>
//                     ))}
//                   <Pagination.Next
//                     className="next"
//                     disabled={currentPage === totalPages}
//                     onClick={() => paginate(currentPage + 1)}
//                   >
//                     &gt;
//                   </Pagination.Next>
//                 </Pagination>
//               </div>
//             </div>
//           </div>
//         </div>
//       </div>

//       {/* Offcanvas for Editing */}
//       <div
//         className={`offcanvas offcanvas-end ${showDrawer ? "show" : ""}`}
//         tabIndex="-1"
//         id="editDrawer"
//         aria-labelledby="editDrawerLabel"
//         style={{ width: "40%", visibility: showDrawer ? "visible" : "hidden" }}
//       >
//         <div className="offcanvas-header">
//           <h5 className="offcanvas-title" id="editDrawerLabel">
//             {editData ? "Update Item" : "New Item"}
//           </h5>
//           <button
//             type="button"
//             style={{
//               backgroundColor: "transparent",
//               border: "none",
//               color: "#000",
//               fontSize: "1.5rem",
//               cursor: "pointer",
//             }}
//             aria-label="Close"
//             onClick={handleCloseDrawer}
//           >
//             &times;
//           </button>
//         </div>
//         <div className="offcanvas-body">
//           <div className="card">
//             <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
//               <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
//                 <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
//                   Fill the Item Info below
//                 </h4>
//               </div>
//             </div>
//             <div className="card-body">
//               {errorMessage && (
//                 <div className="alert alert-danger" role="alert">
//                   {errorMessage}
//                 </div>
//               )}
//               {/* <Formik
//                 initialValues={editData || {}}
//                 enableReinitialize={true}
//                 validationSchema={validationSchema}
//                 onSubmit={handleFormSubmit}
//               >
//                 {({ errors, touched, isSubmitting }) => (
//                   <Form>
//                     {formFields.map((field) => (
//                       <div className="row" key={field.name}>
//                         <div className="col-md-12">
//                           <label htmlFor={field.name}>{field.label}</label>
//                           <div
//                            className="input-group input-group-outline my-1"
//                            >
//                             <Field
//                               name={field.name}
//                               type={field.type}
//                               className={`form-control ${
//                                 touched[field.name] && errors[field.name]
//                                   ? "is-invalid"
//                                   : ""
//                               }`}
//                               placeholder={field.label}
//                             />
//                             <ErrorMessage
//                               name={field.name}
//                               component="div"
//                               className="invalid-feedback"
//                             />
//                           </div>
//                         </div>
//                       </div>
//                     ))}
//                     <div className="row">
//                       <div className="col-md-12 d-flex justify-content-end">
//                         <button
//                           type="submit"
//                           className="btn btn-info my-4"
//                           disabled={isSubmitting}
//                         >
//                           {isSubmitting
//                             ? "Updating..."
//                             : editData
//                             ? "Update"
//                             : "Create"}
//                         </button>
//                       </div>
//                     </div>
//                   </Form>
//                 )}
//               </Formik> */}
//               <Formik
//                 initialValues={editData || {}}
//                 enableReinitialize={true}
//                 validationSchema={validationSchema}
//                 onSubmit={handleFormSubmit}
//               >
//                 {({ errors, touched, isSubmitting }) => (
//                   <Form>
//                     {formFields.map((field) => (
//                       <div className="row" key={field.name}>
//                         <div className="col-md-12">
//                           <label htmlFor={field.name}>{field.label}</label>
//                           <div
//                             className={
//                               isViewMode
//                                 ? "my-1" // No input-group class when in view mode
//                                 : "input-group input-group-outline my-1"
//                             }
//                           >
//                             <Field
//                               name={field.name}
//                               type={field.type}
//                               className={`form-control ${
//                                 touched[field.name] && errors[field.name]
//                                   ? "is-invalid"
//                                   : ""
//                               }`}
//                               placeholder={field.label}
//                               disabled={isViewMode} // Disable field in view mode
//                             />
//                             <ErrorMessage
//                               name={field.name}
//                               component="div"
//                               className="invalid-feedback"
//                             />
//                           </div>
//                         </div>
//                       </div>
//                     ))}
//                     {!isViewMode && ( // Only show buttons if not in view mode
//                       <div className="row">
//                         <div className="col-md-12 d-flex justify-content-end">
//                           <button
//                             type="submit"
//                             className="btn btn-info my-4"
//                             disabled={isSubmitting}
//                           >
//                             {isSubmitting
//                               ? "Updating..."
//                               : editData
//                               ? "Update"
//                               : "Create"}
//                           </button>
//                         </div>
//                       </div>
//                     )}
//                   </Form>
//                 )}
//               </Formik>
//             </div>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default GenericCRUD;

// with more flexibility added***************************************************

// import React, {
//   useState,
//   useEffect,
//   useMemo,
//   useCallback,
//   useRef,
// } from "react";
// import { Formik, Field, Form, ErrorMessage } from "formik";
// // import Select from "react-select";
// import * as Yup from "yup";
// import * as XLSX from "xlsx";
// import axios from "axios";
// import {
//   Table,
//   Button,
//   Form as BootstrapForm,
//   InputGroup,
//   Pagination,
// } from "react-bootstrap";
// import { Eye, Edit, Trash, Search } from "lucide-react";

// const useSearch = (items, searchKeys) => {
//   const [searchTerm, setSearchTerm] = useState("");

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

// // Custom hook for pagination
// const usePagination = (items, itemsPerPage) => {
//   const [currentPage, setCurrentPage] = useState(1);
//   const [pageRange, setPageRange] = useState({ start: 1, end: 3 });

//   const totalPages = Math.ceil(items.length / itemsPerPage);
//   const indexOfLastItem = currentPage * itemsPerPage;
//   const indexOfFirstItem = indexOfLastItem - itemsPerPage;
//   const currentItems = items.slice(indexOfFirstItem, indexOfLastItem);

//   const paginate = useCallback(
//     (pageNumber) => {
//       setCurrentPage(pageNumber);
//       const rangeSize = 3;
//       if (pageNumber > pageRange.end) {
//         setPageRange((prev) => ({
//           start: prev.start + 1,
//           end: prev.end + 1,
//         }));
//       } else if (pageNumber < pageRange.start) {
//         setPageRange((prev) => ({
//           start: prev.start - 1,
//           end: prev.end - 1,
//         }));
//       }
//     },
//     [pageRange]
//   );

//   return {
//     currentItems,
//     currentPage,
//     totalPages,
//     paginate,
//     pageRange,
//   };
// };

// // Custom form field components
// const CustomInput = ({ field, form, ...props }) => (
//   <input {...field} {...props} className="form-control" />
// );

// const CustomSelect = ({ field, form, options, ...props }) => (
//   <select {...field} {...props} className="form-control">
//     <option value="">Select {props.placeholder}</option>
//     {options.map((option) => (
//       <option key={option.value} value={option.value}>
//         {option.label}
//       </option>
//     ))}
//   </select>
// );

// const CustomCheckbox = ({ field, form, label, ...props }) => (
//   <div className="form-check">
//     <input
//       type="checkbox"
//       {...field}
//       {...props}
//       checked={field.value}
//       className="form-check-input"
//     />
//     <label className="form-check-label">{label}</label>
//   </div>
// );

// const CustomRadio = ({ field, form, options, ...props }) => (
//   <div>
//     {options.map((option) => (
//       <div key={option.value} className="form-check">
//         <input
//           type="radio"
//           {...field}
//           {...props}
//           value={option.value}
//           checked={field.value === option.value}
//           className="form-check-input"
//         />
//         <label className="form-check-label">{option.label}</label>
//       </div>
//     ))}
//   </div>
// );

// const CustomAutoComplete = ({ field, form, options, ...props }) => (
//   <select {...field} {...props} className="form-control">
//     <option value="">Search {props.placeholder}</option>
//     {options.map((option) => (
//       <option key={option.value} value={option.value}>
//         {option.label}
//       </option>
//     ))}
//   </select>
// );

// const FormField = ({ field, isViewMode, ...props }) => {
//   switch (field.fieldType) {
//     case "select":
//       return (
//         <Field
//           name={field.name}
//           component={CustomSelect}
//           options={field.options}
//           disabled={isViewMode}
//           placeholder={field.label}
//         />
//       );
//     case "checkbox":
//       return (
//         <Field
//           name={field.name}
//           component={CustomCheckbox}
//           label={field.label}
//           disabled={isViewMode}
//         />
//       );
//     case "radio":
//       return (
//         <Field
//           name={field.name}
//           component={CustomRadio}
//           options={field.options}
//           disabled={isViewMode}
//         />
//       );
//     case "autocomplete":
//       return (
//         <Field
//           name={field.name}
//           component={CustomAutoComplete}
//           options={field.options}
//           disabled={isViewMode}
//           placeholder={field.label}
//         />
//       );
//     default:
//       return (
//         <Field
//           name={field.name}
//           component={CustomInput}
//           type={field.type || "text"}
//           placeholder={field.label}
//           disabled={isViewMode}
//           className="form-control"
//         />
//       );
//   }
// };

// const GenericCRUD = ({
//   title,
//   description,
//   initialData,
//   columns,
//   apiEndpoint,
//   validationSchema,
//   formFields,
// }) => {
//   const [items, setItems] = useState([]);
//   const [showDrawer, setShowDrawer] = useState(false);
//   const [editData, setEditData] = useState(null);
//   const [entriesPerPage, setEntriesPerPage] = useState(10);
//   const [errorMessage, setErrorMessage] = useState("");
//   const [isViewMode, setIsViewMode] = useState(false);
//   console.log(
//     title,
//     description,
//     initialData,
//     columns,
//     apiEndpoint,
//     validationSchema,
//     formFields,
//     "data from components"
//   );

//   useEffect(() => {
//     setItems(initialData);
//   }, [initialData]);

//   const { searchTerm, setSearchTerm, filteredItems } = useSearch(
//     items,
//     columns.map((col) => col.key)
//   );

//   const { currentItems, currentPage, totalPages, paginate, pageRange } =
//     usePagination(filteredItems, entriesPerPage);

//   const handleShowDrawer = useCallback((item = null) => {
//     setEditData(item);
//     setShowDrawer(true);
//   }, []);
//   const handleShowDrawerview = useCallback((item = null) => {
//     setEditData(item);
//     setShowDrawer(true);
//     setIsViewMode(true); // Set view mode to true
//   }, []);

//   const handleCloseDrawer = useCallback(() => {
//     setShowDrawer(false);
//     setEditData(null);
//     setErrorMessage("");
//     setIsViewMode(false); // Set view mode to true
//     // if (formikRef.current) {
//     //   formikRef.current.resetForm();
//     // }
//     fetchItems();
//   }, []);

//   const fetchItems = useCallback(async () => {
//     try {
//       // Get the CSRF token from the meta tag
//       const token = document
//         .querySelector('meta[name="csrf-token"]')
//         .getAttribute("content");

//       // Set the headers, including the CSRF token
//       const headers = {
//         "X-CSRF-Token": token,
//         "Content-Type": "application/json",
//       };

//       // Make the GET request with headers and params
//       const response = await axios.get(`/${apiEndpoint}`, {
//         headers,
//         params: {
//           api_request: true,
//           format: "json",
//         },
//       });

//       // Update the items with the fetched data
//       console.log(response);
//       setItems(response.data);
//     } catch (error) {
//       console.error("Error fetching items", error);
//       setErrorMessage("Failed to fetch items. Please try again.");
//     }
//   }, [apiEndpoint]);

//   const handleFormSubmit = useCallback(
//     async (values, { setSubmitting, setErrors }) => {
//       const token = document
//         .querySelector('meta[name="csrf-token"]')
//         .getAttribute("content");
//       try {
//         let response;
//         const headers = {
//           "X-CSRF-Token": token,
//           "Content-Type": "application/json",
//         };

//         const payload = { [apiEndpoint]: values };

//         if (editData) {
//           response = await axios.patch(
//             `/${apiEndpoint}/${editData.id}`,
//             payload,
//             { headers }
//           );
//         } else {
//           response = await axios.post(`/${apiEndpoint}`, payload, { headers });
//         }

//         if (response.status === 201 || response.status === 200) {
//           const updatedItem = response.data;
//           setItems((prevItems) => {
//             if (editData) {
//               return prevItems.map((item) =>
//                 item.id === updatedItem.id ? updatedItem : item
//               );
//             } else {
//               return [...prevItems, updatedItem];
//             }
//           });
//           handleCloseDrawer();
//           setErrorMessage("");
//           // window.location.reload()
//         }
//       } catch (error) {
//         console.error("There was an error submitting the form!", error);
//         if (error.response) {
//           if (error.response.status === 404) {
//             setErrorMessage("Item not found.");
//           } else if (error.response.status === 422) {
//             setErrors(error.response.data.errors);
//           } else {
//             setErrorMessage("An error occurred while processing your request.");
//           }
//         } else {
//           setErrorMessage("An unexpected error occurred. Please try again.");
//         }
//       } finally {
//         setSubmitting(false);
//       }
//     },
//     [editData, handleCloseDrawer, apiEndpoint]
//   );

//   const handleDelete = useCallback(
//     async (id) => {
//       if (window.confirm("Are you sure you want to delete this item?")) {
//         const token = document
//           .querySelector('meta[name="csrf-token"]')
//           .getAttribute("content");

//         try {
//           await axios.delete(`/${apiEndpoint}/${id}`, {
//             headers: { "X-CSRF-Token": token },
//           });
//           fetchItems();
//           setItems((prevItems) => prevItems.filter((item) => item.id !== id));
//         } catch (error) {
//           console.error("Error deleting item", error);
//         }
//       }
//     },
//     [apiEndpoint]
//   );

//   const handleExport = useCallback(() => {
//     const ws = XLSX.utils.json_to_sheet(items);
//     const wb = XLSX.utils.book_new();
//     XLSX.utils.book_append_sheet(wb, ws, "Data");
//     XLSX.writeFile(wb, `${apiEndpoint}.xlsx`);
//   }, [items, apiEndpoint]);

//   const handleImport = useCallback((e) => {
//     const file = e.target.files[0];
//     const reader = new FileReader();
//     reader.onload = (event) => {
//       const data = new Uint8Array(event.target.result);
//       const workbook = XLSX.read(data, { type: "array" });
//       const firstSheetName = workbook.SheetNames[0];
//       const worksheet = workbook.Sheets[firstSheetName];
//       const json = XLSX.utils.sheet_to_json(worksheet);
//       setItems(json);
//     };
//     reader.readAsArrayBuffer(file);
//   }, []);

//   return (
//     <div className="container-fluid py-4">
//       <div className="row">
//         <div className="col-12">
//           <div className="card">
//             <div className="card-header pb-0">
//               <div className="d-lg-flex">
//                 <div>
//                   <h5 className="mb-0">{title}</h5>
//                   <p className="text-sm mb-0">{description}</p>
//                 </div>
//                 <div className="ms-auto my-auto mt-lg-0 mt-4">
//                   <div className="ms-auto my-auto">
//                     <Button
//                       variant="info"
//                       size="sm"
//                       className="mb-0"
//                       onClick={() => handleShowDrawer()}
//                     >
//                       + New Item
//                     </Button>
//                     <Button
//                       variant="outline-info"
//                       size="sm"
//                       className="mb-0 ms-2"
//                       onClick={() =>
//                         document.getElementById("fileInput").click()
//                       }
//                     >
//                       Import
//                     </Button>
//                     <Button
//                       variant="outline-info"
//                       size="sm"
//                       className="export mb-0 ms-2"
//                       onClick={handleExport}
//                     >
//                       Export
//                     </Button>
//                     <input
//                       type="file"
//                       id="fileInput"
//                       style={{ display: "none" }}
//                       accept=".xlsx"
//                       onChange={handleImport}
//                     />
//                   </div>
//                 </div>
//               </div>
//             </div>
//             <div className="card-body px-0 pb-0">
//               <div className="table-responsive p-0">
//                 <div className="d-flex justify-content-between align-items-center px-3 py-3">
//                   <div className="d-flex align-items-center">
//                     <span>Show</span>
//                     <BootstrapForm.Select
//                       size="sm"
//                       className="mx-2"
//                       value={entriesPerPage}
//                       onChange={(e) =>
//                         setEntriesPerPage(Number(e.target.value))
//                       }
//                     >
//                       <option value={5}>5</option>
//                       <option value={10}>10</option>
//                       <option value={25}>15</option>
//                       <option value={50}>20</option>
//                     </BootstrapForm.Select>
//                     <span>entries</span>
//                   </div>
//                   <InputGroup className="w-auto">
//                     <InputGroup.Text>
//                       <Search size={18} />
//                     </InputGroup.Text>
//                     <BootstrapForm.Control
//                       type="text"
//                       placeholder="Search..."
//                       value={searchTerm}
//                       onChange={(e) => setSearchTerm(e.target.value)}
//                     />
//                   </InputGroup>
//                 </div>
//                 <Table
//                   id="items-list"
//                   className="table table-hover table-striped mb-0"
//                 >
//                   <thead>
//                     <tr>
//                       {columns.map((col) => (
//                         <th
//                           key={col.key}
//                           className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3"
//                         >
//                           {col.label}
//                         </th>
//                       ))}
//                       <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-3">
//                         Action
//                       </th>
//                     </tr>
//                   </thead>
//                   <tbody>
//                     {currentItems.map((item) => (
//                       <tr key={item.id}>
//                         {columns.map((col) => (
//                           <td
//                             key={col.key}
//                             className="align-middle text-sm ps-3"
//                           >
//                             {item[col.key]}
//                           </td>
//                         ))}
//                         <td className="align-middle ps-3">
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0 me-2"
//                             onClick={() => handleShowDrawerview(item)}
//                           >
//                             <Eye size={18} />
//                           </Button>
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0 me-2"
//                             onClick={() => handleShowDrawer(item)}
//                           >
//                             <Edit size={18} />
//                           </Button>
//                           <Button
//                             variant="link"
//                             className="text-secondary p-0"
//                             onClick={() => handleDelete(item.id)}
//                           >
//                             <Trash size={18} />
//                           </Button>
//                         </td>
//                       </tr>
//                     ))}
//                   </tbody>
//                 </Table>
//               </div>
//               <div className="d-flex justify-content-end align-items-center mt-3">
//                 <span className="me-3">
//                   Page {currentPage} of {totalPages}
//                 </span>
//                 <Pagination className="custom-pagination">
//                   <Pagination.Prev
//                     className="prev"
//                     disabled={currentPage === 1}
//                     onClick={() => paginate(currentPage - 1)}
//                   >
//                     &lt;
//                   </Pagination.Prev>
//                   {Array.from({ length: totalPages })
//                     .map((_, index) => index + 1)
//                     .filter(
//                       (number) =>
//                         number === 1 ||
//                         number === totalPages ||
//                         (number >= currentPage - 1 && number <= currentPage + 1)
//                     )
//                     .map((number, index, array) => (
//                       <React.Fragment key={number}>
//                         {index > 0 && array[index - 1] !== number - 1 && (
//                           <Pagination.Ellipsis />
//                         )}
//                         <Pagination.Item
//                           active={number === currentPage}
//                           onClick={() => paginate(number)}
//                         >
//                           {number}
//                         </Pagination.Item>
//                       </React.Fragment>
//                     ))}
//                   <Pagination.Next
//                     className="next"
//                     disabled={currentPage === totalPages}
//                     onClick={() => paginate(currentPage + 1)}
//                   >
//                     &gt;
//                   </Pagination.Next>
//                 </Pagination>
//               </div>
//             </div>
//           </div>
//         </div>
//       </div>

//       {/* Offcanvas for Editing */}
//       <div
//         className={`offcanvas offcanvas-end ${showDrawer ? "show" : ""}`}
//         tabIndex="-1"
//         id="editDrawer"
//         aria-labelledby="editDrawerLabel"
//         style={{ width: "40%", visibility: showDrawer ? "visible" : "hidden" }}
//       >
//         <div className="offcanvas-header">
//           <h5 className="offcanvas-title" id="editDrawerLabel">
//             {editData ? "Update Item" : "New Item"}
//           </h5>
//           <button
//             type="button"
//             style={{
//               backgroundColor: "transparent",
//               border: "none",
//               color: "#000",
//               fontSize: "1.5rem",
//               cursor: "pointer",
//             }}
//             aria-label="Close"
//             onClick={handleCloseDrawer}
//           >
//             &times;
//           </button>
//         </div>
//         <div className="offcanvas-body">
//           <div className="card">
//             <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
//               <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
//                 <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
//                   Fill the Item Info below
//                 </h4>
//               </div>
//             </div>
//             <div className="card-body">
//               {errorMessage && (
//                 <div className="alert alert-danger" role="alert">
//                   {errorMessage}
//                 </div>
//               )}
//               <Formik
//                 initialValues={editData || {}}
//                 enableReinitialize={true}
//                 validationSchema={validationSchema}
//                 onSubmit={handleFormSubmit}
//               >
//                 {({ errors, touched, isSubmitting }) => (
//                   <Form>
//                     {formFields.map((field) => (
//                       <div className="row" key={field.name}>
//                         <div className="col-md-12">
//                           <label htmlFor={field.name}>{field.label}</label>
//                           <div
//                             className={
//                               isViewMode
//                                 ? "my-1"
//                                 : "input-group input-group-outline my-1"
//                             }
//                           >
//                             <FormField field={field} isViewMode={isViewMode} />
//                             <ErrorMessage
//                               name={field.name}
//                               component="div"
//                               className="invalid-feedback"
//                             />
//                           </div>
//                         </div>
//                       </div>
//                     ))}
//                     {!isViewMode && (
//                       <div className="row">
//                         <div className="col-md-12 d-flex justify-content-end">
//                           <button
//                             type="submit"
//                             className="btn btn-info my-4"
//                             disabled={isSubmitting}
//                           >
//                             {isSubmitting
//                               ? "Updating..."
//                               : editData
//                               ? "Update"
//                               : "Create"}
//                           </button>
//                         </div>
//                       </div>
//                     )}
//                   </Form>
//                 )}
//               </Formik>
//               {/* <Formik
//                 initialValues={editData || {}}
//                 enableReinitialize={true}
//                 validationSchema={validationSchema}
//                 onSubmit={handleFormSubmit}
//               >
//                 {({ errors, touched, isSubmitting }) => (
//                   <Form>
//                     {formFields.map((field) => (
//                       <div className="row" key={field.name}>
//                         <div className="col-md-12">
//                           <label htmlFor={field.name}>{field.label}</label>
//                           <div
//                             className={
//                               isViewMode
//                                 ? "my-1" // No input-group class when in view mode
//                                 : "input-group input-group-outline my-1"
//                             }
//                           >
//                             <Field
//                               name={field.name}
//                               type={field.type}
//                               className={`form-control ${
//                                 touched[field.name] && errors[field.name]
//                                   ? "is-invalid"
//                                   : ""
//                               }`}
//                               placeholder={field.label}
//                               disabled={isViewMode} // Disable field in view mode
//                             />
//                             <ErrorMessage
//                               name={field.name}
//                               component="div"
//                               className="invalid-feedback"
//                             />
//                           </div>
//                         </div>
//                       </div>
//                     ))}
//                     {!isViewMode && ( // Only show buttons if not in view mode
//                       <div className="row">
//                         <div className="col-md-12 d-flex justify-content-end">
//                           <button
//                             type="submit"
//                             className="btn btn-info my-4"
//                             disabled={isSubmitting}
//                           >
//                             {isSubmitting
//                               ? "Updating..."
//                               : editData
//                               ? "Update"
//                               : "Create"}
//                           </button>
//                         </div>
//                       </div>
//                     )}
//                   </Form>
//                 )}
//               </Formik> */}
//             </div>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default GenericCRUD;

// removed unnessary things and added Datatable **************************************
import React, { useState, useEffect, useCallback, useRef } from "react";
import { Formik, Field, Form, ErrorMessage } from "formik";
import * as Yup from "yup";
import * as XLSX from "xlsx";
import axios from "axios";
import { Button, Form as BootstrapForm, InputGroup } from "react-bootstrap";
import { Eye, Edit, Trash } from "lucide-react";
import DataTable from "../Datatable"; // Import your DataTable component
import CustomAutocomplete from "../Autocomplete";

const CustomInput = ({ field, form, ...props }) => (
  <input {...field} {...props} className="form-control" />
);

const CustomSelect = ({ field, form, options, ...props }) => (
  <select {...field} {...props} className="form-control">
    <option value="">Select {props.placeholder}</option>
    {options.map((option) => (
      <option key={option.value} value={option.value}>
        {option.label}
      </option>
    ))}
  </select>
);

const CustomCheckbox = ({ field, form, label, ...props }) => (
  <div className="form-check">
    <input
      type="checkbox"
      {...field}
      {...props}
      checked={field.value}
      className="form-check-input"
    />
    <label className="form-check-label">{label}</label>
  </div>
);

const CustomRadio = ({ field, form, options, ...props }) => (
  <div>
    {options.map((option) => (
      <div key={option.value} className="form-check">
        <input
          type="radio"
          {...field}
          {...props}
          value={option.value}
          checked={field.value === option.value}
          className="form-check-input"
        />
        <label className="form-check-label">{option.label}</label>
      </div>
    ))}
  </div>
);

const FormField = ({ field, isViewMode, ...props }) => {
  switch (field.fieldType) {
    case "select":
      return (
        <Field
          name={field.name}
          component={CustomSelect}
          options={field.options}
          disabled={isViewMode}
          placeholder={field.label}
        />
      );
    case "checkbox":
      return (
        <Field
          name={field.name}
          component={CustomCheckbox}
          label={field.label}
          disabled={isViewMode}
        />
      );
    case "radio":
      return (
        <Field
          name={field.name}
          component={CustomRadio}
          options={field.options}
          disabled={isViewMode}
        />
      );
    case "autocomplete":
      return (
        <Field
          name={field.name}
          component={CustomAutocomplete}
          options={field.options}
          disabled={isViewMode}
          placeholder={field.label}
        />
      );
    default:
      return (
        <Field
          name={field.name}
          component={CustomInput}
          type={field.type || "text"}
          placeholder={field.label}
          disabled={isViewMode}
          className="form-control"
        />
      );
  }
};

const GenericCRUD = ({
  title,
  description,
  initialData,
  columns,
  apiEndpoint,
  validationSchema,
  formFields,
  payloadKey,
  needinbuilticon,
  additionalActions = [],
}) => {
  const [items, setItems] = useState([]);
  const [showDrawer, setShowDrawer] = useState(false);
  const [editData, setEditData] = useState(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [isViewMode, setIsViewMode] = useState(false);
  // const formikRef = useRef(null);
  console.log(additionalActions, needinbuilticon, "debhcdewj");

  useEffect(() => {
    setItems(initialData);
  }, [initialData]);

  const handleShowDrawer = useCallback((item = null) => {
    setEditData(item);
    setShowDrawer(true);
  }, []);

  const handleShowDrawerview = useCallback((item = null) => {
    setEditData(item);
    setShowDrawer(true);
    setIsViewMode(true); // Set view mode to true
  }, []);

  const handleCloseDrawer = useCallback(() => {
    setShowDrawer(false);

    setEditData(null);
    setErrorMessage("");
    setIsViewMode(false); // Set view mode to false
    // if (formikRef.current) {
    //   formikRef.current.resetForm();
    // }
    fetchItems();
  }, []);

  const fetchItems = useCallback(async () => {
    try {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      const headers = {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      };

      const response = await axios.get(`/${apiEndpoint}`, {
        headers,
        params: {
          api_request: true,
          format: "json",
        },
      });
      console.log(response);
      setItems(response.data);
    } catch (error) {
      console.error("Error fetching items", error);
      setErrorMessage("Failed to fetch items. Please try again.");
    }
  }, [apiEndpoint]);

  const handleFormSubmit = useCallback(
    async (values, { setSubmitting, setErrors }) => {
      const token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      try {
        let response;
        const headers = {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
        };

        const key = payloadKey || apiEndpoint.split("/")[0];
        const payload = { [key]: values };

        if (editData) {
          response = await axios.patch(
            `/${apiEndpoint}/${editData.id}`,
            payload,
            { headers }
          );
        } else {
          response = await axios.post(`/${apiEndpoint}`, payload, { headers });
        }

        if (response.status === 201 || response.status === 200) {
          const updatedItem = response.data;
          setItems((prevItems) => {
            if (editData) {
              return prevItems.map((item) =>
                item.id === updatedItem.id ? updatedItem : item
              );
            } else {
              return [...prevItems, updatedItem];
            }
          });
          handleCloseDrawer();
          setErrorMessage("");
        }
      } catch (error) {
        console.error("There was an error submitting the form!", error);
        if (error.response) {
          if (error.response.status === 404) {
            setErrorMessage("Item not found.");
          } else if (error.response.status === 422) {
            setErrors(error.response.data.errors);
          } else {
            setErrorMessage("An error occurred while processing your request.");
          }
        } else {
          setErrorMessage("An unexpected error occurred. Please try again.");
        }
      } finally {
        setSubmitting(false);
      }
    },
    [editData, handleCloseDrawer, apiEndpoint]
  );

  const handleDelete = useCallback(
    async (id) => {
      if (window.confirm("Are you sure you want to delete this item?")) {
        const token = document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content");

        try {
          await axios.delete(`/${apiEndpoint}/${id}`, {
            headers: { "X-CSRF-Token": token },
          });
          fetchItems();
          setItems((prevItems) => prevItems.filter((item) => item.id !== id));
        } catch (error) {
          console.error("Error deleting item", error);
        }
      }
    },
    [apiEndpoint]
  );

  const handleExport = useCallback(() => {
    const ws = XLSX.utils.json_to_sheet(items);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Data");
    XLSX.writeFile(wb, `${apiEndpoint}.xlsx`);
  }, [items, apiEndpoint]);

  const handleImport = useCallback((e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = (event) => {
      const data = new Uint8Array(event.target.result);
      const workbook = XLSX.read(data, { type: "array" });
      const firstSheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[firstSheetName];
      const json = XLSX.utils.sheet_to_json(worksheet);
      setItems(json);
    };
    reader.readAsArrayBuffer(file);
  }, []);

  return (
    <div className="container-fluid py-4">
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="card-header pb-0">
              <div className="d-lg-flex">
                <div>
                  <h5 className="mb-0">{title}</h5>
                  <p className="text-sm mb-0">{description}</p>
                </div>
                <div className="ms-auto my-auto mt-lg-0 mt-4">
                  <div className="ms-auto my-auto">
                    <Button
                      variant="info"
                      size="sm"
                      className="mb-0"
                      onClick={() => handleShowDrawer()}
                    >
                      + New Item
                    </Button>
                    <Button
                      variant="outline-info"
                      size="sm"
                      className="mb-0 ms-2"
                      onClick={() =>
                        document.getElementById("fileInput").click()
                      }
                    >
                      Import
                    </Button>
                    <Button
                      variant="outline-info"
                      size="sm"
                      className="export mb-0 ms-2"
                      onClick={handleExport}
                    >
                      Export
                    </Button>
                    <input
                      type="file"
                      id="fileInput"
                      style={{ display: "none" }}
                      accept=".xlsx"
                      onChange={handleImport}
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className="card-body px-0 pb-0">
              <DataTable
                columns={columns}
                data={items}
                onView={handleShowDrawerview}
                onEdit={handleShowDrawer}
                onDelete={handleDelete}
                needinbuilticon={needinbuilticon}
                additionalActions={additionalActions}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Offcanvas for Editing */}
      <div
        className={`offcanvas offcanvas-end ${showDrawer ? "show" : ""}`}
        tabIndex="-1"
        id="editDrawer"
        aria-labelledby="editDrawerLabel"
        style={{ width: "40%", visibility: showDrawer ? "visible" : "hidden" }}
      >
        <div className="offcanvas-header">
          <h5 className="offcanvas-title" id="editDrawerLabel">
            {editData ? "Update Item" : "New Item"}
          </h5>
          <button
            type="button"
            style={{
              backgroundColor: "transparent",
              border: "none",
              color: "#000",
              fontSize: "1.5rem",
              cursor: "pointer",
            }}
            aria-label="Close"
            onClick={handleCloseDrawer}
          >
            &times;
          </button>
        </div>
        <div className="offcanvas-body">
          <div className="card">
            <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
              <div className="bg-gradient-info shadow-primary border-radius-lg py-3 pe-1">
                <h4 className="text-white font-weight-bolder text-center mt-2 mb-0">
                  Fill the Item Info below
                </h4>
              </div>
            </div>
            <div className="card-body">
              {errorMessage && (
                <div className="alert alert-danger" role="alert">
                  {errorMessage}
                </div>
              )}
              <Formik
                // innerRef={formikRef}
                initialValues={editData || {}}
                enableReinitialize={true}
                validationSchema={validationSchema}
                onSubmit={handleFormSubmit}
              >
                {({ errors, touched, isSubmitting }) => (
                  <Form>
                    {formFields.map((field) => (
                      <div className="row" key={field.name}>
                        <div className="col-md-12">
                          <label htmlFor={field.name}>{field.label}</label>
                          <div
                            className={
                              isViewMode
                                ? "my-1"
                                : "input-group input-group-outline my-1"
                            }
                          >
                            <FormField field={field} isViewMode={isViewMode} />
                            <ErrorMessage
                              name={field.name}
                              component="div"
                              className="invalid-feedback"
                            />
                          </div>
                        </div>
                      </div>
                    ))}
                    {!isViewMode && (
                      <div className="row">
                        <div className="col-md-12 d-flex justify-content-end">
                          <button
                            type="submit"
                            className="btn btn-info my-4"
                            disabled={isSubmitting}
                          >
                            {isSubmitting
                              ? "Updating..."
                              : editData
                              ? "Update"
                              : "Create"}
                          </button>
                        </div>
                      </div>
                    )}
                  </Form>
                )}
              </Formik>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default GenericCRUD;
