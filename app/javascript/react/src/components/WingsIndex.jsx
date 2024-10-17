// import * as React from "react";
// import * as ReactDOM from "react-dom/client";
// import { useSelector, useDispatch, Provider } from "react-redux";
// import store from "../store";

// const Wing = (props) => {
//   const user = JSON.parse(props.userData);
//   //   const dispatch = useDispatch();
  // const { academicYear, classData, sectionData } = useSelector((state) => ({
  //   academicYear: state.academicYear,
  //   classData: state.classData,
  //   sectionData: state.sectionData,
  // }));

//   // Now you can use academicYear, classData, and sectionData
//   console.log(academicYear,"academic"); // Logs academic year data
//   console.log(classData,"class"); // Logs class data
//   console.log(sectionData,"section"); // Logs section data
//   //   const handleAcademicYearChange = (event) => {
//   //     dispatch({ type: "SET_ACADEMIC_YEAR", payload: event.target.value });
//   //   };

//   return (
//     <div className="card mb-4">
//       <div className="card-body">
//         <form id="sectionChangeForm">
//           <div className="row">
//             <div className="col-md-6 mb-3">
//               <label htmlFor="academicYear" className="form-label">
//                 Academic Year
//               </label>
//               <select
//                 className="form-select"
//                 id="academicYear"
//                 name="academic_year"
//                 required
//                 // onChange={handleAcademicYearChange}
//               >
//                 <option value="">Select Academic Year</option>
//                 <option value="2024-2025">2024-2025</option>
//                 <option value="2025-2026">2025-2026</option>
//               </select>
//               <div className="invalid-feedback" id="error-academic_year"></div>
//             </div>
//             {/* ... (rest of your form elements) */}
//             <div className="col-12 mt-3">
//               <button type="submit" className="btn btn-primary">
//                 Submit
//               </button>
//             </div>
//           </div>
//         </form>
//       </div>
//     </div>
//   );
// };
// const renderComponent = () => {
//   const rootElement = document.getElementById("WingIndex");
//   if (!rootElement) {
//     console.error("Element with ID 'WingIndex' not found.");
//     return;
//   }
//   const userData = rootElement?.dataset.user;
//   const root = ReactDOM.createRoot(rootElement);

//   root.render(
//     <Provider store={store}>
//       <Wing userData={userData} />
//     </Provider>
//   );
//   //   root.render(<Wing userData={userData} />);
// };
// document.addEventListener("DOMContentLoaded", renderComponent);

// export default Wing;
// import React, { useState, useEffect } from "react";
// import { useSelector, useDispatch } from "react-redux";
// import AnimatedChatWithChart from "./animatedChat";
// const Wing = ({ userData }) => {
//   const dispatch = useDispatch();
//   const { academicYear, classData, sectionData } = useSelector((state) => ({
//     academicYear: state.academicYear,
//     classData: state.classData,
//     sectionData: state.sectionData,
//   }));

//   // Parse userData if it's a string, otherwise use it as is
//   const user = typeof userData === "string" ? JSON.parse(userData) : userData;
//   console.log(user, "userrrrr");

//   console.log(academicYear, "academic"); // Logs academic year data
//   console.log(classData, "class"); // Logs class data
//   console.log(sectionData, "section"); // Logs section data

//   //   const handleAcademicYearChange = (event) => {
//   //
//   //   };

    // useEffect(() => {
    //   if (user.academic_year) {
    //     dispatch({ type: "SET_ACADEMIC_YEAR", payload: user.academic_year });
    //   }
    // }, [dispatch]);
//     console.log(academicYear, "academicafeterupdate");
//   return (
//     <div className="card mb-4">
//       <div className="card-body">
//         <form id="sectionChangeForm">
//           <div className="row">
//             <div className="col-md-6 mb-3">
//               <label htmlFor="academicYear" className="form-label">
//                 Academic Year
//               </label>
//               <select className="form-select" id="academicYear" name="academic_year" required>
//                 <option value="">Select Academic Year</option>
//                 <option value="2024-2025">2024-2025</option>
//                 <option value="2025-2026">2025-2026</option>
//               </select>
//               <div className="invalid-feedback" id="error-academic_year"></div>
//             </div>
//             <div className="col-12 mt-3">
//               <button type="submit" className="btn btn-primary">
//                 Submit
//               </button>
//             </div>
//           </div>
//         </form>
//       </div>
//       <AnimatedChatWithChart />
//     </div>
//   );
// };

// export default Wing;
import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import AnimatedChatWithChart from "./animatedChat";

const Wing = ({ userData }) => {
  const dispatch = useDispatch();
  const { academicYear, classData, sectionData } = useSelector((state) => ({
    academicYear: state.academicYear,
    classData: state.classData,
    sectionData: state.sectionData,
  }));

  const user = typeof userData === "string" ? JSON.parse(userData) : userData;

  const [selectedAcademicYear, setSelectedAcademicYear] = useState("");

  useEffect(() => {
    if (user.academic_year) {
      dispatch({ type: "SET_ACADEMIC_YEAR", payload: user.academic_year });
    }
  }, [dispatch, user]);

  const handleSubmit = async (event) => {
    event.preventDefault(); // Prevent page refresh

    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
    console.log(token, "tokenaaa");
    const data = {
      academic_year: selectedAcademicYear, // Get the selected academic year from state
    };

    try {
      const response = await fetch("/wings", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token, // Include CSRF token here
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error("Network response was not ok");
      }

      const result = await response.json();
      console.log(result);
    } catch (error) {
      console.error("Error submitting data:", error);
    }
  };

  return (
    <div className="card mb-4">
      <div className="card-body">
        <form id="sectionChangeForm" onSubmit={handleSubmit}>
          <div className="row">
            <div className="col-md-6 mb-3">
              <label htmlFor="academicYear" className="form-label">
                Academic Year
              </label>
              <select
                className="form-select"
                id="academicYear"
                name="academic_year"
                required
                value={selectedAcademicYear}
                onChange={(e) => setSelectedAcademicYear(e.target.value)}
              >
                <option value="">Select Academic Year</option>
                <option value="2024-2025">2024-2025</option>
                <option value="2025-2026">2025-2026</option>
              </select>
              <div className="invalid-feedback" id="error-academic_year"></div>
            </div>
            <div className="col-12 mt-3">
              <button type="submit" className="btn btn-primary">
                Submit
              </button>
            </div>
          </div>
        </form>
      </div>
      <AnimatedChatWithChart />

      <div className="card mt-4" id="basic-info">
        <div className="card-header">
          <h5>Basic Info</h5>
        </div>
        <div className="card-body pt-0">
          <div className="row">
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>First Name</label>
                <input type="text" className="form-control" placeholder="Alec" />
              </div>
            </div>
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>Last Name</label>
                <input type="text" className="form-control" placeholder="Thompson" />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-6 col-sm-4 mt-3 mt-sm-0">
              <select className="form-control" name="choices-state" id="choices-state">
                <option value="Asia" selected="">
                  Asia
                </option>
                <option value="America">America</option>
              </select>
            </div>
          </div>

          <div className="row mt-4">
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>Email</label>
                <input type="email" className="form-control" placeholder="example@email.com" />
              </div>
            </div>
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>Confirm Email</label>
                <input type="email" className="form-control" placeholder="example@email.com" />
              </div>
            </div>
          </div>
          <div className="row mt-4">
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>Your location</label>
                <input type="text" className="form-control" placeholder="Sydney, A" />
              </div>
            </div>
            <div className="col-6">
              <div className="input-group input-group-static">
                <label>Phone Number</label>
                <input type="number" className="form-control" placeholder="+40 735 631 620" />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-6 align-self-center">
              <label className="form-label mt-4 ms-0">Language</label>
              <select className="form-control" name="choices-language" id="choices-language">
                <option value="English">English</option>
                <option value="French">French</option>
                <option value="Spanish">Spanish</option>
              </select>
            </div>
            <div className="col-md-6">
              <label className="form-label mt-4">Skills</label>
              <input
                className="form-control"
                id="choices-skills"
                type="text"
                value="vuejs, angular, react"
                placeholder="Enter something"
              />
            </div>
            <div className="input-group input-group-outline my-3">
              <label className="form-label">Password</label>
              <input
                id="password"
                type="text"
                className="form-control"
                onFocus="focused(this)"
                onFocusOut="defocused(this)"
              />
              <small>Error message</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Wing;
