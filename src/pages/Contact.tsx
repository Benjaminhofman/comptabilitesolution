import React, { useState } from 'react';
import { Send } from 'lucide-react';
import emailjs from '@emailjs/browser';

const Contact = () => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [status, setStatus] = useState<'success' | 'error' | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsSubmitting(true);
    setStatus(null);

    try {
      await emailjs.sendForm(
        'service_default',
        'template_default',
        e.currentTarget,
        'YOUR_PUBLIC_KEY'
      );
      setStatus('success');
      e.currentTarget.reset();
    } catch (error) {
      console.error('EmailJS Error:', error);
      setStatus('error');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-indigo-900 mb-8">Contactez-nous</h1>
      
      <div className="bg-white rounded-lg shadow-md p-8">
        <div className="mb-6 p-4 bg-yellow-50 border border-yellow-200 rounded-md">
          <p className="text-yellow-800">
            Le formulaire de contact est temporairement désactivé. Pour nous contacter, veuillez envoyer un email à : benjamin.hofman@hotmail.com
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="user_name" className="block text-sm font-medium text-gray-700">Nom</label>
            <input
              type="text"
              id="user_name"
              name="user_name"
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              required
              disabled
            />
          </div>
          
          <div>
            <label htmlFor="user_email" className="block text-sm font-medium text-gray-700">Email</label>
            <input
              type="email"
              id="user_email"
              name="user_email"
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              required
              disabled
            />
          </div>
          
          <div>
            <label htmlFor="subject" className="block text-sm font-medium text-gray-700">Sujet</label>
            <input
              type="text"
              id="subject"
              name="subject"
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              required
              disabled
            />
          </div>
          
          <div>
            <label htmlFor="message" className="block text-sm font-medium text-gray-700">Message</label>
            <textarea
              id="message"
              name="message"
              rows={6}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              required
              disabled
            ></textarea>
          </div>

          {status === 'success' && (
            <div className="bg-green-50 text-green-600 p-4 rounded-md">
              Votre message a été envoyé avec succès !
            </div>
          )}

          {status === 'error' && (
            <div className="bg-red-50 text-red-600 p-4 rounded-md">
              Une erreur est survenue. Veuillez réessayer.
            </div>
          )}
          
          <button
            type="submit"
            disabled={true}
            className="w-full bg-gray-400 text-white px-4 py-2 rounded-lg transition-colors flex items-center justify-center gap-2 cursor-not-allowed"
          >
            <Send className="h-5 w-5" />
            Envoyer le message
          </button>
        </form>
      </div>
    </div>
  );
};

export default Contact;