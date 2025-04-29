import React from "react";
import { useNavigate } from "react-router-dom";
import "./Login.css";
import { useState } from "react";
import axios from "axios";

const LoginPage = () => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const navigate = useNavigate();

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post("http://localhost:5000/login", { username, password });
            localStorage.setItem("token", res.data.token);
            localStorage.setItem("username", res.data.user.username);
            localStorage.setItem("role", res.data.user.role);
            localStorage.setItem("id", res.data.user.userid);
            navigate("/chat"); // Redirect to protected page
        } catch (err) {
            console.log(err)
            setError("Invalid credentials");
        }
    };
    return (
        <div className="login-container">
            <div className="login-box">
                <h1 className="title">NeuroBase</h1>
                {error && <p style={{ color: "red" }}>{error}</p>}
                <form onSubmit={handleLogin}>
                    <div className="form-group">
                        <label htmlFor="username">Username</label>
                        <input id="username" type="text" className="input-field" value={username} onChange={(e) => setUsername(e.target.value)} required />
                    </div>
                    <div className="form-group">
                        <label htmlFor="password">Password</label>
                        <input id="password" type="password" className="input-field" value={password} onChange={(e) => setPassword(e.target.value)} required />
                    </div>
                    <button type="submit" className="login-button">Sign in</button>
                </form>
            </div>
        </div>
    );
};

export default LoginPage;