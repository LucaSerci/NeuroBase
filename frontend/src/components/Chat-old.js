import React, { useEffect, useRef, useState } from 'react'
import "./Chat.css"
import ReactMarkdown from "react-markdown"
import remarkGfm from "remark-gfm"
import {Prism as SyntaxHighlighter} from "react-syntax-highlighter"
import { materialDark } from 'react-syntax-highlighter/dist/esm/styles/prism'

function Chat() {
  const [messages, setMessages] = useState([
    // {sender: "user", text: "Hello"},
    // {sender: "bot", text: "Hello"},
    // {sender: "user", text: "bing bong"}
  ]);
  const [input, setInput] = useState("");
  const [isTyping, setisTyping] = useState(false);
  const messageEndRef = useRef(null);

  // const scrollToBottom = () => {
  //   messageEndRef.current?.scollIntoView({ behavior: "smooth" });
  // };

  // useEffect(scrollToBottom, [messages]);

  const sendMessage = async() => {
    if(!input.trim()) return;

    const userMessages = {sender: "user", text: input};
    setMessages((prevMessages) => [...prevMessages, userMessages]);
    setInput("");
    setisTyping(true);

    try{
      const response = await fetch("http://127.0.0.1:5000/chat", {
        method: "POST",
        headers:{
          "Content-Type": "application/json"
        },
        body: JSON.stringify({message: input})
      });

      const reader = response.body.getReader();
      const decoder = new TextDecoder("utf-8");
      let botResponse = "";

      setisTyping(false);

      const processline = (line) =>{
        if(line.startsWith("data: ")){
          const data = JSON.parse(line.slice(6));
          botResponse += data.message;

          setMessages((prevMessages) => {
            const newMessage = [...prevMessages];
            if(newMessage[newMessage.length - 1].sender === "bot"){
              newMessage[newMessage.length - 1].text = botResponse;
            }else{
              newMessage.push({sender: "bot", text: botResponse})
            }
            return newMessage;
          });
        }else if (line === "event: end") {
          setisTyping(false);
        }
      };

      while (true){
        const{value, done} = await reader.read()
        if (done) break

        const chunk = decoder.decode(value)
        const lines = chunk.split("\n\n")

        lines.forEach(processline)
      }
    }catch(error){
      console.error("Error sending message", error)
    }
  };

  return (
    <div className="chat-container">
      <div className='messages'>
        {messages.map((msg, index) => (
          <div key={index} className={'message-container '+msg.sender}>
            <div className={'message '+msg.sender}>
              <ReactMarkdown
                children={msg.text}
                remarkPlugins={[remarkGfm,]}
                components={{
                  code({node, inline, className, children, ...props}) {
                    const match = /language-(\w+)/.exec(className || "")
                    return !inline && match ? (
                      <SyntaxHighlighter
                        children={String(children).replace(/\n$/, "")}
                        style={materialDark}
                        language={match[1]}
                        PreTag="div"
                        {...props}
                      />
                    ):(
                      <code className={className} {...props}>
                        {children}
                      </code>
                    )
                  }
                }}
              />
            </div>
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

        <div ref={messageEndRef}/>               
      </div>
      <div className='input-container'>
        <input 
          type="text" 
          value={input} 
          onChange={(e) => setInput(e.target.value)}
          placeholder='Type a message...'
        />

        <button className='button' onClick={sendMessage}>Send</button>
      </div>
    </div>
  );
}

export default Chat;
