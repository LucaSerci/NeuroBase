import { createContext, useState, useContext, useEffect } from "react";

const ChatContext = createContext();

export const ChatProvider = ({ children }) => {
  const [messages, setMessages] = useState([]);

  const resetChat = () => setMessages([]);

  return (
    <ChatContext.Provider value={{ messages, setMessages, resetChat }}>
      {children}
    </ChatContext.Provider>
  );

  useEffect(() => {
    const saved = localStorage.getItem("chat-messages");
    if (saved) setMessages(JSON.parse(saved));
  }, []);
  
  useEffect(() => {
    localStorage.setItem("chat-messages", JSON.stringify(messages));
  }, [messages]);

};

export const useChat = () => {
  const context = useContext(ChatContext);
  if (!context) throw new Error("useChat must be used within a ChatProvider");
  return context;
};
