import React, { useState } from "react";
import axios from "axios";
import "./style.css";

const ManualQuery = () => {
  const [sql, setSql] = useState("");
  const [result, setResult] = useState("");
  const [error, setError] = useState("");
  const userid = localStorage.getItem("id")
  const role = localStorage.getItem("role")
  const isWriteQuery = /^(insert|update|delete)/i.test(sql.trim());

  const runQuery = async () => {
    setResult("");
    setError("");


    if (isWriteQuery && role === "user") {
      setError("❌ You do not have permission to modify the database.");
      return;
    }

    try {
      const res = await axios.post("http://localhost:5000/run-query", {
        query: sql,
        userid: userid,
      });
      if (res.data.error) {
        setError(res.data.error);
      } else {
        setResult(JSON.stringify(res.data.result, null, 2));
      }
    } catch (err) {
      setError("An error occurred while running the query.");
      console.error(err);
    }
  };

  return (
    <div className="container">
      <div className="header">
        <h2>Manual SQL Query</h2>
      </div>
      <div className="form-group">
        <label>SQL Input</label>
        <textarea
          className="sql-input-field"
          rows={8}
          value={sql}
          onChange={(e) => setSql(e.target.value)}
          placeholder="e.g., SELECT * FROM orders WHERE date >= '2024-01-01';"
        />
      </div>

      <div className="bottom-page">
        <button className="btn submit" onClick={runQuery}>
          Run
        </button>
      </div>

      <div className="form-group">
        <label>Output</label>
        {error ? (
          <pre className="input-field" style={{ whiteSpace: "pre-wrap" }}>
            ❌ {error}
          </pre>
        ) : result && Array.isArray(JSON.parse(result)) ? (
          <div className="table-wrapper">
            <table className="result-table">
              <thead>
                <tr>
                  {Object.keys(JSON.parse(result)[0]).map((key) => (
                    <th key={key}>{key}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {JSON.parse(result).map((row, i) => (
                  <tr key={i}>
                    {Object.values(row).map((value, j) => (
                      <td key={j}>{value}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <pre className="input-field" style={{ whiteSpace: "pre-wrap" }}>
            {result}
          </pre>
        )}
      </div>
    </div>
  );
};

export default ManualQuery;
