import React, { useState } from "react";
import { motion } from "framer-motion";
import { Bar } from "react-chartjs-2";

const AnimatedChatWithChart = () => {
  const [messages, setMessages] = useState([
    { text: "Hello! Type 'Show chart' to view the chart.", sender: "bot" },
  ]);
  const [input, setInput] = useState("");
  const [showChart, setShowChart] = useState(false);

  const sendMessage = () => {
    if (input.trim()) {
      setMessages([...messages, { text: input, sender: "user" }]);

      if (input.toLowerCase() === "show chart") {
        setShowChart(true);
      }

      // Simulate bot reply
      setTimeout(() => {
        setMessages((prev) => [
          ...prev,
          {
            text:
              input.toLowerCase() === "show chart"
                ? "Here's your chart!"
                : "Let me check that for you.",
            sender: "bot",
          },
        ]);
      }, 1000);

      setInput("");
    }
  };

  const handleInput = (e) => {
    setInput(e.target.value);
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter") sendMessage();
  };

  // Chart.js data and configuration
  const data = {
    labels: ["January", "February", "March", "April", "May"],
    datasets: [
      {
        label: "Sales",
        data: [30, 50, 80, 40, 100],
        backgroundColor: "rgba(75,192,192,0.6)",
        borderColor: "rgba(75,192,192,1)",
        borderWidth: 1,
      },
    ],
  };

  const options = {
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  return (
    <div className="chat-container" style={styles.chatContainer}>
      <div className="chat-box" style={styles.chatBox}>
        {messages.map((message, index) => (
          <motion.div
            key={index}
            className={`message ${message.sender}`}
            initial={{ opacity: 0, y: 50 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            style={{
              ...styles.message,
              backgroundColor: message.sender === "user" ? "#DCF8C6" : "#EAEAEA",
              alignSelf: message.sender === "user" ? "flex-end" : "flex-start",
            }}
          >
            {message.text}
          </motion.div>
        ))}
      </div>

      {showChart && (
        <motion.div
          initial={{ opacity: 0, scale: 0.5 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8 }}
          style={styles.chartContainer}
        >
          <Bar data={data} options={options} />
        </motion.div>
      )}

      <div className="chat-input" style={styles.inputContainer}>
        <input
          type="text"
          value={input}
          onChange={handleInput}
          onKeyPress={handleKeyPress}
          placeholder="Type your message..."
          style={styles.input}
        />
        <button onClick={sendMessage} style={styles.sendButton}>
          Send
        </button>
      </div>
    </div>
  );
};

const styles = {
  chatContainer: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "center",
    alignItems: "center",
    height: "600px",
    width: "400px",
    border: "1px solid #ccc",
    borderRadius: "10px",
    padding: "10px",
    backgroundColor: "#F5F5F5",
    position: "relative",
  },
  chatBox: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "flex-start",
    alignItems: "flex-start",
    width: "100%",
    height: "400px",
    overflowY: "auto",
    padding: "10px",
    marginBottom: "10px",
    borderRadius: "10px",
    backgroundColor: "#FFF",
  },
  message: {
    padding: "10px 15px",
    borderRadius: "20px",
    marginBottom: "10px",
    maxWidth: "80%",
    wordBreak: "break-word",
  },
  inputContainer: {
    display: "flex",
    width: "100%",
    alignItems: "center",
  },
  input: {
    flex: 1,
    padding: "10px",
    borderRadius: "20px",
    border: "1px solid #ccc",
    marginRight: "10px",
  },
  sendButton: {
    padding: "10px 15px",
    backgroundColor: "#007bff",
    color: "#fff",
    border: "none",
    borderRadius: "20px",
    cursor: "pointer",
  },
  chartContainer: {
    width: "100%",
    padding: "10px",
    backgroundColor: "#FFF",
    borderRadius: "10px",
    marginBottom: "10px",
  },
};

export default AnimatedChatWithChart;
