import './App.css';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Chat from './components/Chat';
import Login from './components/Login';
import CreateUser from './components/CreateUser';
import LinkManagement from './components/Settings';
import ManualQuery from './components/ManualQuery';
import ModifyUser from './components/ModUser';
import QueryHistory from './components/QueryHistory';
import UserManagement from './components/UserManagement';
import Sidebar from './components/Sidebar';
import PrivateRoute from "./components/PrivateRoute";
import { ChatProvider } from './components/ChatContext';

const Layout = ({ children }) => {

  return (
    <div className="app-container">
      {<Sidebar />}
      <div className="content">{children}</div>
    </div>
  );
};

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route
          path="/*"
          element={
            <PrivateRoute>
              <ChatProvider>
                <Layout>
                  <Routes>
                    <Route path="/chat" element={<Chat />} />
                    <Route path="/createUser" element={<CreateUser />} />
                    <Route path="/settings" element={<LinkManagement />} />
                    <Route path="/ManualQuery" element={<ManualQuery />} />
                    <Route path="/modifyUser" element={<ModifyUser />} />
                    <Route path="/queryHistory" element={<QueryHistory />} />
                    <Route path="/userManagement" element={<UserManagement />} />
                  </Routes>
                </Layout>
              </ChatProvider>
            </PrivateRoute>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
