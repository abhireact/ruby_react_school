import { createStore } from "redux";

// Initial state with academicYear, classData, and sectionData
const initialState = {
  academicYear: null, // Stores academic year
  classData: null, // Stores class data
  sectionData: null, // Stores section data
};

// Reducer function to handle actions
const reducer = (state = initialState, action) => {
  switch (action.type) {
    case "SET_ACADEMIC_YEAR":
      return { ...state, academicYear: action.payload }; // Update academic year
    case "SET_CLASS_DATA":
      return { ...state, classData: action.payload }; // Update class data
    case "SET_SECTION_DATA":
      return { ...state, sectionData: action.payload }; // Update section data
    default:
      return state; // Return the current state if no actions match
  }
};

// Create Redux store
const store = createStore(reducer);

// Action creator to set academic year
const setAcademicYear = (year) => {
  store.dispatch({
    type: "SET_ACADEMIC_YEAR",
    payload: year,
  });
};

// Action creator to set class data
const setClassData = (classData) => {
  store.dispatch({
    type: "SET_CLASS_DATA",
    payload: classData,
  });
};

// Action creator to set section data
const setSectionData = (sectionData) => {
  store.dispatch({
    type: "SET_SECTION_DATA",
    payload: sectionData,
  });
};

// Example usage: Setting academic year, class, and section data
setAcademicYear(["2020-2021", "2024-2025", "2022-2023"]);
setClassData(["Class 1", "Class 2", "Class 3"]);
setSectionData(["Section A", "Section B", "Section C"]);

export default store;
