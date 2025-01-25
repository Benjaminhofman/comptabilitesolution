import React, { useState, useEffect } from 'react';
import { Euro, Lock, Download } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { createCheckoutSession } from '../lib/stripe';

interface PaidTool {
  id: string;
  name: string;
  description: string;
  price: number;
  author_name: string;
  author_email: string;
  is_purchased?: boolean;
}

const PaidTools = () => {
  const [tools, setTools] = useState<PaidTool[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTools = async () => {
      const { data: toolsData, error } = await supabase
        .from('paid_tools')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Error fetching tools:', error);
        return;
      }

      // Check purchased tools for current user
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data: purchases } = await supabase
          .from('tool_purchases')
          .select('tool_id')
          .eq('user_id', user.id);

        const purchasedToolIds = new Set(purchases?.map(p => p.tool_id));
        const toolsWithPurchaseStatus = toolsData.map(tool => ({
          ...tool,
          is_purchased: purchasedToolIds.has(tool.id)
        }));

        setTools(toolsWithPurchaseStatus);
      } else {
        setTools(toolsData);
      }
      setLoading(false);
    };

    fetchTools();
  }, []);

  const handlePurchase = async (tool: PaidTool) => {
    try {
      const session = await createCheckoutSession(tool.id, tool.price);
      window.location.href = session.url;
    } catch (error) {
      console.error('Error initiating purchase:', error);
    }
  };

  if (loading) {
    return <div>Chargement...</div>;
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-indigo-900 mb-8">Outils Premium</h1>
      
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {tools.map((tool) => (
          <div key={tool.id} className="bg-white rounded-lg shadow-md p-6 border border-gray-200">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl font-semibold text-indigo-900">{tool.name}</h3>
              <div className="flex items-center text-indigo-600 font-semibold">
                <Euro className="h-5 w-5 mr-1" />
                {tool.price.toFixed(2)}
              </div>
            </div>
            
            <p className="text-gray-600 mb-6">{tool.description}</p>
            
            <div className="flex items-center text-sm text-gray-500 mb-6">
              <p>Par {tool.author_name}</p>
            </div>

            {tool.is_purchased ? (
              <button
                onClick={() => window.open(supabase.storage.from('paid_tools').getPublicUrl(`${tool.id}/file`).data.publicUrl)}
                className="w-full bg-green-600 text-white py-2 px-4 rounded-lg hover:bg-green-700 transition-colors flex items-center justify-center gap-2"
              >
                <Download className="h-5 w-5" />
                Télécharger
              </button>
            ) : (
              <button
                onClick={() => handlePurchase(tool)}
                className="w-full bg-indigo-600 text-white py-2 px-4 rounded-lg hover:bg-indigo-700 transition-colors flex items-center justify-center gap-2"
              >
                <Lock className="h-5 w-5" />
                Acheter
              </button>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

export default PaidTools;