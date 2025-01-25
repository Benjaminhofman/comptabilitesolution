import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Pencil, Trash2, Plus } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { isAdmin } from '../lib/auth';

const AdminTools = () => {
  const navigate = useNavigate();
  const [tools, setTools] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const checkAdmin = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      const admin = await isAdmin(user);
      if (!admin) {
        navigate('/');
      }
    };

    const fetchTools = async () => {
      const { data } = await supabase
        .from('tools')
        .select('*')
        .order('created_at', { ascending: false });
      setTools(data || []);
      setLoading(false);
    };

    checkAdmin();
    fetchTools();
  }, [navigate]);

  const handleDelete = async (id: string) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cet outil ?')) {
      await supabase.from('tools').delete().eq('id', id);
      setTools(tools.filter(tool => tool.id !== id));
    }
  };

  if (loading) {
    return <div>Chargement...</div>;
  }

  return (
    <div className="max-w-6xl mx-auto">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Gestion des Outils</h1>
        <button
          onClick={() => navigate('/admin/tools/new')}
          className="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 flex items-center gap-2"
        >
          <Plus className="h-5 w-5" />
          Nouvel outil
        </button>
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nom</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Catégorie</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date de création</th>
              <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {tools.map((tool) => (
              <tr key={tool.id}>
                <td className="px-6 py-4 whitespace-nowrap">{tool.name}</td>
                <td className="px-6 py-4 whitespace-nowrap">{tool.category}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {new Date(tool.created_at).toLocaleDateString()}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <button
                    onClick={() => navigate(`/admin/tools/edit/${tool.id}`)}
                    className="text-indigo-600 hover:text-indigo-900 mr-3"
                  >
                    <Pencil className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(tool.id)}
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

export default AdminTools;