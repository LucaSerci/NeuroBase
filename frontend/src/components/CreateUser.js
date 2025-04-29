import React from "react";
import { useNavigate } from "react-router-dom";
import "./style.css";
import { useState } from "react";
import axios from "axios";

const CreateUser = () => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [role, setRole] = useState("user");
    const [error, setError] = useState("");
    const navigate = useNavigate();

    const createuser = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post("http://localhost:5000/createUser", { username, password, role });
            navigate("/userManagement");
        } catch (err) {
            setError("User already exists");
        }
    };
    return (
        <div className="container">
                <form onSubmit={createuser} className="form">
                    <div className="form-group">
                        <label htmlFor="username">Username</label>
                        <input id="username" type="text" className="input-field" value={username} onChange={(e) => setUsername(e.target.value)} required />
                    </div>
                    <div className="form-group">
                        <label htmlFor="password">Password</label>
                        <input id="password" type="password" className="input-field" value={password} onChange={(e) => setPassword(e.target.value)} required />
                    </div>
                    <div className="form-group">
                        <label htmlFor="role">Role</label>
                        <select
                            id="role"
                            className="input-field"
                            value={role}
                            onChange={(e) => setRole(e.target.value)}
                        >
                            <option value="manager">Manager</option>
                            <option value="user">User</option>
                        </select>
                    </div>
                    <div className="bottom-page">
                        <button type="button" className="btn" onClick={() => navigate("/userManagement")}>Cancel</button>
                        <button type="submit" className="btn submit">Create New User</button>
                    </div>
                </form>
            {error && <p style={{ color: "red" }}>{error}</p>}
        </div>
    );
};

export default CreateUser;
