import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Trash2, Download } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { isAdmin } from '../lib/auth';

const AdminFiles = () => {
  const navigate = useNavigate();
  const [files, setFiles] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const checkAdmin = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      const admin = await isAdmin(user);
      if (!admin) {
        navigate('/');
      }
    };

    const fetchFiles = async () => {
      const { data } = await supabase
        .storage
        .from('files')
        .list();
      setFiles(data || []);
      setLoading(false);
    };

    checkAdmin();
    fetchFiles();
  }, [navigate]);

  const handleDelete = async (fileName: string) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer ce fichier ?')) {
      await supabase.storage.from('files').remove([fileName]);
      setFiles(files.filter(file => file.name !== fileName));
    }
  };

  if (loading) {
    return <div>Chargement...</div>;
  }

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Gestion des Fichiers</h1>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nom</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Taille</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
              <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {files.map((file) => (
              <tr key={file.id}>
                <td className="px-6 py-4 whitespace-nowrap">{file.name}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {(file.metadata?.size / 1024 / 1024).toFixed(2)} MB
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {new Date(file.created_at).toLocaleDateString()}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <button
                    onClick={() => window.open(supabase.storage.from('files').getPublicUrl(file.name).data.publicUrl)}
                    className="text-blue-600 hover:text-blue-900 mr-3"
                  >
                    <Download className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(file.name)}
                    className="text-red-600 hover:text-red-900"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminFiles;