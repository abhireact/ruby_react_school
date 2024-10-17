import { createStore } from "redux";

// Initial state with academicYear, classData, and sectionData
const initialState = {
  academicYear: null, // Stores academic year
  classData: null, // Stores class data
  sectionData: null, // Stores section data
  wingsData: null, // Make sure to initialize wingsData as well if you are using it
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
    case "SET_WINGS_DATA":
      return { ...state, wingsData: action.payload }; // Update wings data
    default:
      return state; // Return the current state if no actions match
  }
};

// Load state from localStorage
const loadState = () => {
  try {
    const serializedState = localStorage.getItem("state");
    return serializedState ? JSON.parse(serializedState) : undefined;
  } catch (err) {
    console.error("Could not load state", err);
    return undefined;
  }
};

// Save state to localStorage
const saveState = (state) => {
  try {
    const serializedState = JSON.stringify(state);
    localStorage.setItem("state", serializedState);
  } catch (err) {
    console.error("Could not save state", err);
  }
};

// Create Redux store with initial state from localStorage
const store = createStore(reducer, loadState());

// Subscribe to store updates and save state to localStorage
store.subscribe(() => {
  saveState({
    academicYear: store.getState().academicYear,
    classData: store.getState().classData,
    sectionData: store.getState().sectionData,
    wingsData: store.getState().wingsData, // Save wings data if it's used
  });
});

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

export default store;
