import React, { useState, useEffect } from "react";
import axios from "axios";
import "./style.css";
import { useChat  } from "./ChatContext.js"

const Settings = () => {
  const [config, setConfig] = useState({
    openai_key: "",
    model: "gpt-4",
    db: {
      host: "",
      user: "",
      password: "",
      database: ""
    }
  });

  const { resetChat } = useChat();

  useEffect(() => {
    const fetchConfig = async () => {
      try {
        const res = await axios.get("http://localhost:5000/load-config");
        if (res.data) {
          setConfig(res.data);
        }
      } catch (err) {
        console.error("Error loading config:", err);
      }
    };

    fetchConfig();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;

    if (["host", "user", "password", "database"].includes(name)) {
      setConfig((prev) => ({
        ...prev,
        db: {
          ...prev.db,
          [name]: value
        }
      }));
    } else {
      setConfig((prev) => ({ ...prev, [name]: value }));
    }
  };

  const handleSave = async () => {
    try {
      await axios.post("http://localhost:5000/save-config", config);
      alert("Settings saved!");
      resetChat();
    } catch (err) {
      console.error("Failed to save settings", err);
      alert("Failed to save settings");
    }
  };

  return (
    <div className="container">
      <div class="aligner">
        <h2>Chat settings</h2>
        <div className="form-group">
          <label>LLM Model</label>
          <select
            className="input-field"
            name="model"
            value={config.model}
            onChange={handleChange}
          >
            <option value="gpt-3.5-turbo">GPT-3.5 Turbo</option>
            <option value="gpt-4">GPT-4</option>
            <option value="gpt-4-1106-preview">GPT-4 1106 Preview</option>
            <option value="gpt-4-turbo">GPT-4 Turbo</option>
          </select>
        </div>


        <div className="form-group">
          <label>API Key</label>
          <input
            type="password"
            className="input-field"
            name="openai_key"
            value={config.openai_key}
            onChange={handleChange}
          />
        </div>

        <h2>Database connection settings</h2>

        <div className="form-group">
          <label>Host</label>
          <input
            type="text"
            className="input-field"
            name="host"
            value={config.db.host}
            onChange={handleChange}
          />
        </div>

        <div className="form-group">
          <label>User</label>
          <input
            type="text"
            className="input-field"
            name="user"
            value={config.db.user}
            onChange={handleChange}
          />
        </div>

        <div className="form-group">
          <label>Password</label>
          <input
            type="password"
            className="input-field"
            name="password"
            value={config.db.password}
            onChange={handleChange}
          />
        </div>

        <div className="form-group">
          <label>Database Name</label>
          <input
            type="text"
            className="input-field"
            name="database"
            value={config.db.database}
            onChange={handleChange}
          />
        </div>

        <div className="bottom-page">
          <button className="btn submit" onClick={handleSave}>
            Save
          </button>
        </div>
      </div>
    </div>
  );
};

export default Settings;
