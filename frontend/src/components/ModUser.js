import React, { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import axios from "axios";
import "./style.css";

const ModifyUser = () => {
    const { state } = useLocation();
    const navigate = useNavigate();
    const user = state?.user;
    const currendUserRole = localStorage.getItem("role")


    const [username, setUsername] = useState(user?.username || "");
    const [password, setPassword] = useState(""); // leave empty unless changing
    const [role, setRole] = useState(user?.role || "user");

    const handleUpdate = async () => {
        try {
            await axios.put(`http://localhost:5000/updateUser/${user.id}`, {
                username,
                password: password || null,
                role
            });
            alert("User updated");
            navigate("/userManagement");
        } catch (err) {
            alert("Failed to update user");
        }
    };

    const handleDelete = async () => {
        if (!window.confirm("Are you sure you want to delete this user?")) return;

        try {
            await axios.delete(`http://localhost:5000/deleteUser/${user.id}`);
            alert("User deleted");
            navigate("/userManagement");
        } catch (err) {
            alert("Failed to delete user");
        }
    };

    return (
        <div className="container">
            <div className="header">
                <h2>Modify User: {username}</h2>
            </div>
            <div className="form-group">
                <label>Username</label>
                <input
                    className="input-field"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                />
            </div>

            <div className="form-group">
                <label>New Password (leave blank to keep current)</label>
                <input
                    type="password"
                    className="input-field"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                />
            </div>

            <div className="form-group">
                <label>Role</label>
                <select
                    className="input-field"
                    value={role}
                    onChange={(e) => setRole(e.target.value)}
                >
                    {role === "admin" && (
                        <option value="admin">Admin</option>
                    )}
                    <option value="manager">Manager</option>
                    <option value="user">User</option>
                </select>
            </div>

            <div className="bottom-page">
                <button className="btn submit" onClick={handleUpdate}>Update</button>
                <button className="btn cancel" onClick={handleDelete}>Delete</button>
            </div>
        </div>
    );
};

export default ModifyUser;
