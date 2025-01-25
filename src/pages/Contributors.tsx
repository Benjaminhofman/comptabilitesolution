import React, { useState, useEffect } from 'react';
import { Plus, Trash2, Mail, Wrench } from 'lucide-react';

interface Contributor {
  id: string;
  first_name: string;
  last_name: string;
  email: string;
  tool_name: string;
  tool_description: string;
  created_at: string;
}

const Contributors = () => {
  const [contributors, setContributors] = useState<Contributor[]>([]);
  const [formData, setFormData] = useState({
    first_name: '',
    last_name: '',
    email: '',
    tool_name: '',
    tool_description: ''
  });

  // Charger les données depuis localStorage au démarrage
  useEffect(() => {
    const savedContributors = localStorage.getItem('contributors');
    if (savedContributors) {
      setContributors(JSON.parse(savedContributors));
    }
  }, []);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    const newContributor: Contributor = {
      id: crypto.randomUUID(),
      ...formData,
      created_at: new Date().toISOString()
    };

    const updatedContributors = [newContributor, ...contributors];
    setContributors(updatedContributors);
    localStorage.setItem('contributors', JSON.stringify(updatedContributors));

    // Reset form
    setFormData({
      first_name: '',
      last_name: '',
      email: '',
      tool_name: '',
      tool_description: ''
    });
  };

  const handleDelete = (id: string) => {
    const updatedContributors = contributors.filter(c => c.id !== id);
    setContributors(updatedContributors);
    localStorage.setItem('contributors', JSON.stringify(updatedContributors));
  };

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <div className="mb-12">
        <h1 className="text-3xl font-bold text-indigo-900 mb-4">Contribuez à la communauté</h1>
        <p className="text-gray-600">
          Partagez vos outils et solutions avec la communauté des experts-comptables.
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-8">
        {/* Formulaire de contribution */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-6">Proposer un outil</h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Prénom
                </label>
                <input
                  type="text"
                  required
                  value={formData.first_name}
                  onChange={(e) => setFormData({...formData, first_name: e.target.value})}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nom
                </label>
                <input
                  type="text"
                  required
                  value={formData.last_name}
                  onChange={(e) => setFormData({...formData, last_name: e.target.value})}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Email
              </label>
              <input
                type="email"
                required
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Nom de l'outil
              </label>
              <input
                type="text"
                required
                value={formData.tool_name}
                onChange={(e) => setFormData({...formData, tool_name: e.target.value})}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Description de l'outil
              </label>
              <textarea
                required
                value={formData.tool_description}
                onChange={(e) => setFormData({...formData, tool_description: e.target.value})}
                rows={4}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <button
              type="submit"
              className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 flex items-center justify-center gap-2"
            >
              <Plus className="h-5 w-5" />
              Proposer l'outil
            </button>
          </form>
        </div>

        {/* Liste des contributions */}
        <div className="space-y-6">
          <h2 className="text-xl font-semibold">Contributions récentes</h2>
          {contributors.length === 0 ? (
            <p className="text-gray-500">Aucune contribution pour le moment.</p>
          ) : (
            contributors.map((contributor) => (
              <div
                key={contributor.id}
                className="bg-white p-6 rounded-lg shadow-md"
              >
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h3 className="font-semibold text-lg text-indigo-900">
                      {contributor.tool_name}
                    </h3>
                    <p className="text-sm text-gray-600">
                      {new Date(contributor.created_at).toLocaleDateString('fr-FR')}
                    </p>
                  </div>
                  <button
                    onClick={() => handleDelete(contributor.id)}
                    className="text-red-600 hover:text-red-800"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </div>

                <p className="text-gray-700 mb-4">{contributor.tool_description}</p>

                <div className="flex items-center justify-between text-sm text-gray-600">
                  <div className="flex items-center gap-2">
                    <Wrench className="h-4 w-4" />
                    <span>
                      Par {contributor.first_name} {contributor.last_name}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Mail className="h-4 w-4" />
                    <a
                      href={`mailto:${contributor.email}`}
                      className="hover:text-indigo-600"
                    >
                      Contacter
                    </a>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

export default Contributors;