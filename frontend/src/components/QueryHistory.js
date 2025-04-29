import React, { useEffect, useState } from "react";
import "./style.css";
import axios from "axios";

const QueryHistory = () => {
  const [queries, setQueries] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Filter states
  const [usernameFilter, setUsernameFilter] = useState("");
  const [responseFilter, setResponseFilter] = useState("");
  const [dateFilter, setDateFilter] = useState("");

  useEffect(() => {
    const fetchHistory = async () => {
      try {
        const response = await axios.post("http://localhost:5000/queryHistory", {
          username: localStorage.getItem("username"),
          role: localStorage.getItem("role"),
        });
        setQueries(response.data);
        setFiltered(response.data);
      } catch (err) {
        setError("Failed to fetch query history");
      } finally {
        setLoading(false);
      }
    };

    fetchHistory();
  }, []);

  // Filtering logic
  useEffect(() => {
    const filteredResults = queries.filter((q) => {
      const dateString = new Date(q.executionDate).toISOString().slice(0, 10);

      return (
        q.username.toLowerCase().includes(usernameFilter.toLowerCase()) &&
        q.response.toLowerCase().includes(responseFilter.toLowerCase()) &&
        dateString.includes(dateFilter)
      );
    });

    setFiltered(filteredResults);
  }, [usernameFilter, responseFilter, dateFilter, queries]);

  if (loading) return <p>Loading query history...</p>;
  if (error) return <p>{error}</p>;

  return (
    <div className="container">
      <div className="header">
        <h1>Query History</h1>
        <p>Viewing {localStorage.getItem("role") === "user" ? "your own" : "all"} queries</p>
      </div>

      <div className="filters">
        <input
          type="text"
          className="input-field"
          placeholder="Filter by username"
          value={usernameFilter}
          onChange={(e) => setUsernameFilter(e.target.value)}
        />
        <input
          type="text"
          className="input-field"
          placeholder="Filter by response content"
          value={responseFilter}
          onChange={(e) => setResponseFilter(e.target.value)}
        />
        <input
          type="date"
          className="input-field"
          value={dateFilter}
          onChange={(e) => setDateFilter(e.target.value)}
        />
      </div>

      <div className="table-wrapper">
        <table className="result-table">
          <thead>
            <tr>
              <th>User ID</th>
              <th>Username</th>
              <th>Query</th>
              <th>Response</th>
              <th>Execution Date</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((entry) => (
              <tr key={entry.id}>
                <td>{entry.userId}</td>
                <td>{entry.username}</td>
                <td style={{ whiteSpace: "pre-wrap" }}>{entry.query}</td>
                <td style={{ whiteSpace: "pre-wrap" }} className="response-column">{entry.response}</td>
                <td>{entry.executionDate}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default QueryHistory;
