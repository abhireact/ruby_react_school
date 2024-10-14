import React, { useState } from "react";
import { useSelector } from "react-redux";

const Home = ({ userData }) => {
  const [count, setCount] = useState(0);

  // Parse userData if it's a string, otherwise use it as is
  const user = typeof userData === "string" ? JSON.parse(userData) : userData;

  const academicYear = useSelector((state) => state.academicYear);
  console.log(academicYear, "homepage index");

  const increment = () => setCount((prevCount) => prevCount + 1);
  const decrement = () => setCount((prevCount) => prevCount - 1);

  return (
    <div>
      <h1>React Home Component</h1>
      <p>Welcome, {user.name}!</p> {/* Assuming user object has a name property */}
      <button onClick={increment} style={{ marginRight: "10px", padding: "5px 10px" }}>
        +
      </button>
      <div style={{ fontSize: "24px", margin: "20px 0" }}>Counter: {count}</div>
      <button onClick={decrement} style={{ padding: "5px 10px" }}>
        -
      </button>
      <p>Current Academic Year: {academicYear}</p>
    </div>
  );
};

export default Home;
