import React, { useState } from 'react';
import { Euro, Loader } from 'lucide-react';

const MembershipButton = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handlePayment = async () => {
    setLoading(true);
    setError(null);

    try {
      console.log('Envoi de la requête de paiement...');
      
      const response = await fetch('/.netlify/functions/create-checkout-session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      console.log('Statut de la réponse:', response.status);
      const contentType = response.headers.get('content-type');
      console.log('Type de contenu:', contentType);

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Réponse serveur non-ok:', {
          status: response.status,
          statusText: response.statusText,
          body: errorText
        });
        throw new Error(`Erreur serveur: ${response.status} ${response.statusText}`);
      }

      if (!contentType || !contentType.includes('application/json')) {
        console.error('Type de contenu invalide:', contentType);
        throw new Error('Réponse invalide du serveur');
      }

      const data = await response.json();
      console.log('Données reçues:', data);

      if (!data.url) {
        console.error('URL manquante dans la réponse:', data);
        throw new Error('URL de paiement manquante dans la réponse');
      }

      // Redirection vers Stripe
      window.location.href = data.url;
      
    } catch (err) {
      console.error('Erreur lors du processus de paiement:', err);
      setError(
        err instanceof Error 
          ? `Erreur: ${err.message}`
          : 'Le service de paiement est temporairement indisponible'
      );
      setLoading(false);
    }
  };

  return (
    <div className="flex flex-col items-center gap-4">
      <button
        onClick={handlePayment}
        disabled={loading}
        className="group relative inline-flex items-center justify-center px-8 py-4 text-lg font-semibold text-white bg-gradient-to-r from-indigo-600 to-indigo-700 rounded-xl shadow-lg hover:from-indigo-700 hover:to-indigo-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
      >
        <span className="absolute inset-0 w-full h-full rounded-xl bg-white/10 group-hover:bg-white/20 transition-all duration-200"></span>
        {loading ? (
          <>
            <Loader className="w-5 h-5 mr-3 animate-spin" />
            <span>Préparation du paiement...</span>
          </>
        ) : (
          <>
            <Euro className="w-5 h-5 mr-3" />
            <span>Adhérer maintenant • 300€</span>
          </>
        )}
      </button>

      {error && (
        <div className="px-4 py-3 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm max-w-md text-center">
          {error}
        </div>
      )}
    </div>
  );
};

export default MembershipButton;