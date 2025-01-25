import React, { useState, useEffect } from 'react';
import { FileSpreadsheet, FileText, Calculator as CalcIcon, TrendingUp, Wrench, File } from 'lucide-react';
import { supabase } from '../lib/supabase';

const ICONS = {
  finance: TrendingUp,
  comptabilite: FileText,
  fiscal: CalcIcon,
  reporting: FileSpreadsheet,
  autre: Wrench
};

const ToolsPage = () => {
  const [tools, setTools] = useState([]);
  const [files, setFiles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [descriptions, setDescriptions] = useState({});

  useEffect(() => {
    // Charger les descriptions sauvegardées
    const savedDescriptions = localStorage.getItem('toolDescriptions');
    if (savedDescriptions) {
      setDescriptions(JSON.parse(savedDescriptions));
    }

    const fetchData = async () => {
      // Récupérer les outils de la base de données
      const { data: toolsData } = await supabase
        .from('tools')
        .select('*')
        .order('created_at', { ascending: false });

      // Récupérer les fichiers du stockage
      const { data: filesData } = await supabase
        .storage
        .from('files')
        .list();

      setTools(toolsData || []);
      setFiles(filesData || []);
      setLoading(false);
    };

    fetchData();
  }, []);

  const handleDescriptionChange = (id, value) => {
    const newDescriptions = { ...descriptions, [id]: value };
    setDescriptions(newDescriptions);
    localStorage.setItem('toolDescriptions', JSON.stringify(newDescriptions));
  };

  if (loading) return <div>Chargement...</div>;

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className="text-3xl font-bold text-indigo-900 mb-8">Bibliothèque d'Outils</h1>
      
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Afficher les outils de la base de données */}
        {tools.map((tool) => {
          const IconComponent = ICONS[tool.category] || Wrench;
          return (
            <div key={tool.id} className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
              <div className="flex items-center mb-4">
                <IconComponent className="h-8 w-8 text-indigo-600 mr-3" />
                <div>
                  <h3 className="font-semibold text-lg">{tool.name}</h3>
                  <span className="text-sm text-indigo-600 capitalize">{tool.category}</span>
                </div>
              </div>
              <p className="text-gray-600 mb-4">{tool.description}</p>
              {tool.characteristics && (
                <details className="mt-2 mb-4">
                  <summary className="text-indigo-600 cursor-pointer hover:text-indigo-700">
                    Voir les caractéristiques
                  </summary>
                  <p className="mt-2 text-sm text-gray-600 pl-4">
                    {tool.characteristics}
                  </p>
                </details>
              )}
              <div className="mt-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Ajouter une description personnelle
                </label>
                <textarea
                  value={descriptions[tool.id] || ''}
                  onChange={(e) => handleDescriptionChange(tool.id, e.target.value)}
                  placeholder="Ajoutez vos notes et commentaires sur cet outil..."
                  className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                  rows={3}
                />
              </div>
              {tool.file_url && (
                <button 
                  onClick={() => window.open(tool.file_url)}
                  className="w-full mt-4 bg-indigo-50 text-indigo-600 px-4 py-2 rounded hover:bg-indigo-100 transition-colors"
                >
                  Télécharger
                </button>
              )}
            </div>
          );
        })}

        {/* Afficher les fichiers de la bibliothèque */}
        {files.map((file) => (
          <div key={file.id} className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
            <div className="flex items-center mb-4">
              <File className="h-8 w-8 text-indigo-600 mr-3" />
              <div>
                <h3 className="font-semibold text-lg">{file.name}</h3>
                <span className="text-sm text-indigo-600">Document</span>
              </div>
            </div>
            <p className="text-gray-600 mb-4">
              Taille: {(file.metadata?.size / 1024 / 1024).toFixed(2)} MB
            </p>
            <div className="mt-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Ajouter une description personnelle
              </label>
              <textarea
                value={descriptions[file.id] || ''}
                onChange={(e) => handleDescriptionChange(file.id, e.target.value)}
                placeholder="Ajoutez vos notes et commentaires sur ce fichier..."
                className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                rows={3}
              />
            </div>
            <button 
              onClick={() => window.open(supabase.storage.from('files').getPublicUrl(file.name).data.publicUrl)}
              className="w-full mt-4 bg-indigo-50 text-indigo-600 px-4 py-2 rounded hover:bg-indigo-100 transition-colors"
            >
              Télécharger
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default ToolsPage;