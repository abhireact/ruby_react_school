import React, { useEffect } from "react"; // Add useEffect import
import AnimatedChart from "./animatedChat";
import { useDispatch, useSelector } from "react-redux";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
const Dashboard = ({ userData }) => {
     const [age, setAge] = React.useState("");

     const handleChange = (event) => {
       setAge(event.target.value);
     };
  const { academicYear, classData, sectionData, wingsData } = useSelector((state) => ({
    academicYear: state.academicYear,
    classData: state.classData,
    sectionData: state.sectionData,
    wingsData: state.wingsData,
  }));
  const redux_data = typeof userData === "string" ? JSON.parse(userData) : userData;
  const dispatch = useDispatch();

  useEffect(() => {
    if (redux_data.academic_years) {
      dispatch({ type: "SET_ACADEMIC_YEAR", payload: redux_data.academic_years });
    }
    if (redux_data.class) {
      dispatch({ type: "SET_CLASS_DATA", payload: redux_data.class });
    }
    if (redux_data.section) {
      dispatch({ type: "SET_SECTION_DATA", payload: redux_data.section });
    }
    if (redux_data.wings) {
      dispatch({ type: "SET_WINGS_DATA", payload: redux_data.wings });
    }
  }, [redux_data, dispatch]);
  return (
    <>
      <FormControl fullWidth>
        <InputLabel id="demo-simple-select-label">Age</InputLabel>
      </FormControl>
      <AnimatedChart />
    </>
  );
};

export default Dashboard;
