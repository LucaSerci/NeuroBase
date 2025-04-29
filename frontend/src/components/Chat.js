import React, { useState, useEffect, useRef } from "react";
import axios from "axios";
import "./Chat.css";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeHighlight from "rehype-highlight";
import "highlight.js/styles/github-dark.css";
import { useChat } from "./ChatContext";

const ChatComponent = () => {

  function capitalizeFirstLetter(val) {
    return String(val).charAt(0).toUpperCase() + String(val).slice(1);
  }  
  const [pendingQuery, setPendingQuery] = useState(null);
  const [showConfirm, setShowConfirm] = useState(false);  
  const { messages, setMessages } = useChat();
  const [input, setInput] = useState("");
  const bottomRef = useRef(null);
  const userRole = localStorage.getItem("role");
  const username = capitalizeFirstLetter(localStorage.getItem("username"))
  const userId = localStorage.getItem("id")
  const [isTyping, setisTyping] = useState(false);  

  const formatResult = (rows) => {
    if (rows.length === 0) return "⚠️ No data found.";
  
    const headers = Object.keys(rows[0]);
    const table = [
      `| ${headers.join(" | ")} |`,
      `| ${headers.map(() => "---").join(" | ")} |`,
      ...rows.map(row =>
        `| ${headers.map(h => row[h] !== null ? row[h] : "NULL").join(" | ")} |`
      )
    ];
    return table.join("\n");
  };

  const sendMessage = async () => {
    if (!input.trim()) return;

    const userMsg = { sender: "user", text: input };
    const updatedMessages = [...messages, userMsg];
    setMessages(updatedMessages);

    const formatted = updatedMessages.map(m => ({
      role: m.sender === "user" ? "user" : "assistant",
      content: m.text,
      userRole: userRole,
      username: username,
    }));
    setisTyping(true);

    try {
      setInput("");
      const res = await axios.post("http://localhost:5000/chat", {
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          ...formatted
        ],
        userRole: userRole,
        username: username,
        userId: userId,  
      });

      const newMessages = [];

      setisTyping(false);

      if (res.data.confirm) {
        setPendingQuery(res.data); // store response with SQL + explanation
        setShowConfirm(true);      // trigger modal
        return;
      }

      if (res.data.response) {
        newMessages.push({ sender: "bot", text: res.data.response });
      }

      if (res.data.result && Array.isArray(res.data.result)) {
        const table = formatResult(res.data.result);
        newMessages.push({ sender: "bot", text: table });
      }

      if (res.data.error) {
        newMessages.push({ sender: "bot", text: `❌ ${res.data.error}` });
      }

      if (res.data.query) {
        newMessages.push({ sender: "bot", text: `📝 SQL:\n\`\`\`sql\n${res.data.query}\n\`\`\`` });
      }      

      setMessages((prev) => [...prev, ...newMessages]);

    } catch (err) {
      setMessages((prev) => [...prev, { sender: "bot", text: "Error occurred" }]);
    }

  };

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const executePendingQuery = async () => {
    try {
      const res = await axios.post("http://localhost:5000/execute-confirmed", {
        query: pendingQuery.query,
        username,
        role: userRole,
        userId: userId,  
      });
  
      const newMessages = [
        { sender: "bot", text: pendingQuery.response },
        { sender: "bot", text: res.data.result || "✅ Query executed." }
      ];
  
      setMessages(prev => [...prev, ...newMessages]);
    } catch (err) {
      setMessages(prev => [...prev, { sender: "bot", text: "❌ Failed to execute the query." }]);
    } finally {
      setShowConfirm(false);
      setPendingQuery(null);
    }
  };  

  return (
    <div className="chat-container">
      <div className="messages">
        {messages.map((m, i) => (
          <div
            key={i}
            className={`message-bubble ${m.sender === "user" ? "user" : "bot"}`}
          >
            <ReactMarkdown
              remarkPlugins={[remarkGfm]}
              rehypePlugins={[rehypeHighlight]}
              components={{
                p: ({ node, ...props }) => <p className="markdown-paragraph" {...props} />,
                code: ({ node, inline, className, children, ...props }) => {
                  return inline ? (
                    <code className="inline-code" {...props}>{children}</code>
                  ) : (
                    <pre className="code-block">
                      <code className={className} {...props}>{children}</code>
                    </pre>
                  );
                }
              }}
            >
              {m.text}
            </ReactMarkdown>
          </div>
        ))}        
        {isTyping && (
          <div className='message-container bot'>
            <div className='message bot'>
              <div className='typing-indicator'>
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </div>
        )}
        <div ref={bottomRef} />
      </div>
      {showConfirm && (
        <div className="confirm-modal">
          <div className="confirm-box">
            <h3>⚠️ Confirm SQL Execution</h3>
            <p className="confirm-response">{pendingQuery.response}</p>
            <pre className="confirm-query">{pendingQuery.query}</pre>
            <div className="modal-buttons">
              <button className="btn" onClick={executePendingQuery}>Confirm</button>
              <button className="btn cancel" onClick={() => setShowConfirm(false)}>Cancel</button>
            </div>
          </div>
        </div>
      )}
      <div className="input-wrapper">
        <div className="input-area">
          <input
            className="chat-input"
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && sendMessage()}
          />
          <button onClick={sendMessage} className="send-button">
            <span className="send-icon">►</span> {/* use an icon lib if you want */}
          </button>
        </div>
      </div>
    </div>

  );
};

export default ChatComponent;
