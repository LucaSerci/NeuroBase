import React, { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import "./Sidebar.css";

const Sidebar = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const username = capitalizeFirstLetter(localStorage.getItem("username"))
  const role = capitalizeFirstLetter(localStorage.getItem("role"))

  function capitalizeFirstLetter(val) {
    return String(val).charAt(0).toUpperCase() + String(val).slice(1);
  }  

  const menuItems = [
      { path: "/chat", label: "NeuroBase Chat" },
      { path: "/manualQuery", label: "Manual Query" },
      { path: "/queryHistory", label: "Query History" },
  ];

  if (role == "Admin"){
    menuItems.push(
      { path: "/userManagement", label: "User Management" },
      { path: "/settings", label: "Database and Chat Settings" }
    )
  } 

  if (role == "Manager"){
    menuItems.push(
      { path: "/userManagement", label: "User Management" },
    )
  } 

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("username");

    navigate('/');
  };

  return (
    <div className="sidebar">
      <h2 className="sidebar-title">{role}: {username}</h2>
      <ul className="sidebar-menu">
        {menuItems.map((item) => (
          <li key={item.path}>
            <button
              className={`sidebar-button ${location.pathname === item.path ? "active" : ""}`}
              onClick={() => navigate(item.path)}
            >
              {item.label}
              {location.pathname === item.path && <span className="indicator"></span>}
            </button>
          </li>
        ))}
      </ul>
      <button onClick={handleLogout} className="logoff-button">Log off</button>
    </div> 
  );
};

export default Sidebar;
