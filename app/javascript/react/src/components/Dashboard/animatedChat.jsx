// Charts.js
import React from "react";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  RadialLinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Filler,
  Tooltip,
  Legend,
} from "chart.js";
import { Line, Bar, Radar, Pie } from "react-chartjs-2";

// Register necessary components
ChartJS.register(
  CategoryScale,
  LinearScale,
  RadialLinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Filler,
  Tooltip,
  Legend
);

const Charts = () => {
  // Data for Line Chart
  const lineData = {
    labels: ["January", "February", "March", "April", "May", "June"],
    datasets: [
      {
        label: "Monthly Sales",
        data: [65, 59, 80, 81, 56, 55],
        fill: true,
        backgroundColor: "rgba(75, 192, 192, 0.2)",
        borderColor: "rgba(75, 192, 192, 1)",
        borderWidth: 1,
      },
    ],
  };

  // Options for Line Chart
  const lineOptions = {
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  // Data for Bar Chart
  const barData = {
    labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
    datasets: [
      {
        label: "# of Votes",
        data: [12, 19, 3, 5, 2, 3],
        backgroundColor: [
          "rgba(255, 99, 132, 0.2)",
          "rgba(54, 162, 235, 0.2)",
          "rgba(255, 206, 86, 0.2)",
          "rgba(75, 192, 192, 0.2)",
          "rgba(153, 102, 255, 0.2)",
          "rgba(255, 159, 64, 0.2)",
        ],
        borderColor: [
          "rgba(255, 99, 132, 1)",
          "rgba(54, 162, 235, 1)",
          "rgba(255, 206, 86, 1)",
          "rgba(75, 192, 192, 1)",
          "rgba(153, 102, 255, 1)",
          "rgba(255, 159, 64, 1)",
        ],
        borderWidth: 1,
      },
    ],
  };

  // Options for Bar Chart
  const barOptions = {
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  // Data for Radar Chart
  const radarData = {
    labels: ["Eating", "Drinking", "Sleeping", "Working", "Playing"],
    datasets: [
      {
        label: "Daily Activities",
        data: [2, 1, 5, 3, 4],
        backgroundColor: "rgba(255, 99, 132, 0.2)",
        borderColor: "rgba(255, 99, 132, 1)",
        borderWidth: 1,
      },
    ],
  };

  // Options for Radar Chart
  const radarOptions = {
    scales: {
      r: {
        angleLines: {
          display: false,
        },
        suggestedMin: 0,
        suggestedMax: 5,
      },
    },
  };

  // Data for Pie Chart
  const pieData = {
    labels: ["Red", "Blue", "Yellow"],
    datasets: [
      {
        label: "Colors",
        data: [300, 50, 100],
        backgroundColor: [
          "rgba(255, 99, 132, 0.2)",
          "rgba(54, 162, 235, 0.2)",
          "rgba(255, 206, 86, 0.2)",
        ],
        borderColor: ["rgba(255, 99, 132, 1)", "rgba(54, 162, 235, 1)", "rgba(255, 206, 86, 1)"],
        borderWidth: 1,
      },
    ],
  };

  return (
    <div className="container">
      <div className="row mb-4">
        <div className="col-md-6">
          <Line data={lineData} options={lineOptions} />
        </div>
        <div className="col-md-6">
          <Bar data={barData} options={barOptions} />
        </div>
      </div>
      <div className="row mb-4">
        <div className="col-md-4">
          <Radar data={radarData} options={radarOptions} />
        </div>
        <div className="col-md-4">
          <Pie data={pieData} />
        </div>
      </div>
    </div>
  );
};

export default Charts;
