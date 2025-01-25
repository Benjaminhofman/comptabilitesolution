import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Upload from './pages/Upload';
import Files from './pages/Files';
import ToolsPage from './pages/Tools';
import AdminTools from './pages/AdminTools';
import AdminFiles from './pages/AdminFiles';
import Footer from './components/Footer';
import Contact from './pages/Contact';
import LegalNotice from './pages/LegalNotice';
import Privacy from './pages/Privacy';
import About from './pages/About';
import Contributors from './pages/Contributors';
import Success from './pages/Success';

const App = () => {
  return (
    <BrowserRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
      <div className="min-h-screen bg-slate-50 flex flex-col">
        <Navbar />
        <main className="container mx-auto px-4 py-8 flex-grow">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/upload" element={<Upload />} />
            <Route path="/files" element={<Files />} />
            <Route path="/tools" element={<ToolsPage />} />
            <Route path="/admin/tools" element={<AdminTools />} />
            <Route path="/admin/files" element={<AdminFiles />} />
            <Route path="/contact" element={<Contact />} />
            <Route path="/mentions-legales" element={<LegalNotice />} />
            <Route path="/confidentialite" element={<Privacy />} />
            <Route path="/about" element={<About />} />
            <Route path="/contributors" element={<Contributors />} />
            <Route path="/success" element={<Success />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </BrowserRouter>
  );
};

export default App;