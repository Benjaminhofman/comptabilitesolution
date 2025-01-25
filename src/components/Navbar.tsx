import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Calculator, FileUp, Files, Home, Wrench, User, Users } from 'lucide-react';

const Navbar = () => {
  const location = useLocation();
  const isActive = (path: string) => location.pathname === path ? 'active' : '';

  return (
    <nav className="bg-gradient shadow-lg">
      <div className="container mx-auto px-4 py-4">
        {/* Logo et titre */}
        <div className="flex justify-center items-center mb-4">
          <Link to="/" className="flex items-center space-x-3 group">
            <Calculator className="h-10 w-10 text-white transition-transform group-hover:scale-110" />
            <span className="text-2xl font-bold text-white">ComptabiliteSolution.fr</span>
          </Link>
        </div>

        {/* Navigation */}
        <div className="flex justify-center flex-wrap gap-6">
          <Link to="/" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/')}`}>
            <Home className="h-5 w-5" />
            <span>Accueil</span>
          </Link>
          <Link to="/about" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/about')}`}>
            <User className="h-5 w-5" />
            <span>À propos</span>
          </Link>
          <Link to="/tools" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/tools')}`}>
            <Wrench className="h-5 w-5" />
            <span>Outils</span>
          </Link>
          <Link to="/upload" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/upload')}`}>
            <FileUp className="h-5 w-5" />
            <span>Partager</span>
          </Link>
          <Link to="/files" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/files')}`}>
            <Files className="h-5 w-5" />
            <span>Bibliothèque</span>
          </Link>
          <Link to="/contributors" className={`nav-link flex items-center space-x-2 text-white hover:text-indigo-200 ${isActive('/contributors')}`}>
            <Users className="h-5 w-5" />
            <span>Contributeurs</span>
          </Link>
        </div>
      </div>
      
      <div className="bg-indigo-800/80 backdrop-blur-sm py-4 px-4">
        <p className="container mx-auto text-white font-medium text-base">
          Objectif : Créer une plateforme web dédiée aux experts-comptables permettant le partage d'outils professionnels et de fichiers spécialisés pour optimiser leur productivité et la qualité de leur travail.
        </p>
      </div>
    </nav>
  );
}

export default Navbar;