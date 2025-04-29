import React, { useEffect, useState } from "react"; import "./style.css";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const UserManagement = () => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchUsers = async () => {
            try {
                const response = await axios.get("http://localhost:5000/listUsers");
                setUsers(response.data);
            } catch (err) {
                setError("Failed to fetch users");
            } finally {
                setLoading(false);
            }
        };

        fetchUsers();
    }, []);

    function capitalizeFirstLetter(val) {
        return String(val).charAt(0).toUpperCase() + String(val).slice(1);
    }


    if (loading) return <p>Loading users...</p>;
    if (error) return <p>{error}</p>;

    return (
        <div className="container">
            <div className="header">
                <h1>User Management</h1>
                <button className="btn" onClick={() => navigate("/createUser")}>Add User</button>
            </div>
            <div className="user-list">
                <ul>
                    {users.map((user) => (
                        <li key={user.id}>
                            <div className="user-card" key={user.id}>
                                {user.username}
                                <div>{capitalizeFirstLetter(user.role)}</div>
                                <button className="btn" onClick={() => navigate("/modifyUser", { state: {user}})}>Modify User</button>
                            </div>
                        </li>
                    ))}
                </ul>
            </div>
        </div>
    );
};

export default UserManagement;
