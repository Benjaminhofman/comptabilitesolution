import React from 'react';
import { Link } from 'react-router-dom';
import { Linkedin } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-gradient text-white mt-12">
      <div className="container mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-12">
          <div className="md:col-span-1">
            <h4 className="font-semibold text-lg mb-4">Navigation</h4>
            <ul className="space-y-3">
              <li><Link to="/" className="text-sm hover:text-indigo-200 transition-colors">Accueil</Link></li>
              <li><Link to="/tools" className="text-sm hover:text-indigo-200 transition-colors">Outils</Link></li>
              <li><Link to="/contact" className="text-sm hover:text-indigo-200 transition-colors">Contact</Link></li>
            </ul>
          </div>
          
          <div className="md:col-span-1">
            <h4 className="font-semibold text-lg mb-4">Légal</h4>
            <ul className="space-y-3">
              <li><Link to="/mentions-legales" className="text-sm hover:text-indigo-200 transition-colors">Mentions légales</Link></li>
              <li><Link to="/confidentialite" className="text-sm hover:text-indigo-200 transition-colors">Politique de confidentialité</Link></li>
            </ul>
          </div>
          
          <div className="md:col-span-1">
            <h4 className="font-semibold text-lg mb-4">Contact</h4>
            <ul className="space-y-3 text-sm">
              <li>Email: benjamin.hofman@hotmail.com</li>
              <li>Tél: 06 34 43 08 26</li>
              <li>Vestric et Candiac, France</li>
            </ul>
          </div>
        </div>

        <div className="border-t border-indigo-800 mt-12 pt-8">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6">
            <p className="text-sm order-2 md:order-1">
              © {new Date().getFullYear()} ComptabiliteSolution.fr - Tous droits réservés
            </p>
            
            <a 
              href="https://www.linkedin.com/in/benjamin-hofman-22b1b5296/" 
              target="_blank" 
              rel="noopener noreferrer" 
              className="flex items-center space-x-4 group order-1 md:order-2 bg-indigo-800/50 rounded-xl p-4 hover:bg-indigo-800 transition-all"
            >
              <Linkedin className="h-8 w-8 text-indigo-200 group-hover:text-white transition-colors" />
              <div className="text-left">
                <p className="text-indigo-200 group-hover:text-white font-medium">Suivez-moi sur LinkedIn</p>
                <p className="text-xs text-indigo-300 group-hover:text-indigo-200">500+ relations professionnelles</p>
              </div>
              <span className="bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg group-hover:bg-indigo-600 transition-colors">
                Connectons-nous !
              </span>
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}

export default Footer;