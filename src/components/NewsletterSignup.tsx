import React, { useState } from 'react';
import { Mail } from 'lucide-react';
import { supabase } from '../lib/supabase';

const NewsletterSignup = () => {
  const [email, setEmail] = useState('');
  const [status, setStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');
  const [message, setMessage] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus('loading');

    try {
      const { error } = await supabase
        .from('newsletter_subscribers')
        .insert([{ email }]);

      if (error) throw error;

      setStatus('success');
      setMessage('Merci pour votre inscription !');
      setEmail('');
    } catch (error) {
      setStatus('error');
      setMessage('Une erreur est survenue. Veuillez réessayer.');
    }
  };

  return (
    <div className="bg-indigo-50 p-6 rounded-lg shadow-sm">
      <div className="flex items-center gap-3 mb-4">
        <Mail className="h-6 w-6 text-indigo-600" />
        <h3 className="text-lg font-semibold text-indigo-900">Newsletter</h3>
      </div>
      
      <p className="text-gray-600 mb-4">
        Recevez nos derniers outils et actualités directement dans votre boîte mail.
      </p>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Votre adresse email"
            required
            className="w-full px-4 py-2 rounded-md border-gray-300 focus:border-indigo-500 focus:ring-indigo-500"
          />
        </div>

        <button
          type="submit"
          disabled={status === 'loading'}
          className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 transition-colors disabled:opacity-50"
        >
          {status === 'loading' ? 'Inscription...' : 'S\'inscrire'}
        </button>

        {status === 'success' && (
          <p className="text-green-600 text-sm">{message}</p>
        )}

        {status === 'error' && (
          <p className="text-red-600 text-sm">{message}</p>
        )}
      </form>
    </div>
  );
};

export default NewsletterSignup;