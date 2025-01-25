import React from 'react';
import { Link } from 'react-router-dom';
import { Wrench, TrendingUp, Share2, Euro } from 'lucide-react';
import NewsletterSignup from '../components/NewsletterSignup';
import MembershipButton from '../components/MembershipButton';

const Home = () => {
  return (
    <div className="max-w-6xl mx-auto px-4">
      <div className="text-center mb-16 pt-8">
        <h1 className="text-5xl font-bold text-indigo-900 mb-6 animate-[float_4s_ease-in-out_infinite]">
          L'efficacité comptable simplifiée
        </h1>
        <p className="text-xl text-gray-600 max-w-3xl mx-auto">
          Partagez, collaborez et optimisez votre travail d'expert-comptable
        </p>
      </div>

      <div className="grid md:grid-cols-2 gap-8 mb-16">
        <div className="service-card bg-white p-8 rounded-xl shadow-lg border-t-4 border-indigo-600">
          <Wrench className="h-12 w-12 text-indigo-600 mb-6" />
          <h3 className="text-xl font-semibold mb-4">Outils Professionnels</h3>
          <p className="text-gray-600">
            Accédez à une bibliothèque d'outils spécialisés pour experts-comptables
          </p>
        </div>

        <div className="service-card bg-white p-8 rounded-xl shadow-lg border-t-4 border-indigo-600">
          <TrendingUp className="h-12 w-12 text-indigo-600 mb-6" />
          <h3 className="text-xl font-semibold mb-4">Productivité</h3>
          <p className="text-gray-600">
            Optimisez votre temps et améliorez votre efficacité
          </p>
        </div>
      </div>

      {/* Section d'adhésion */}
      <div className="bg-gradient rounded-2xl p-8 md:p-12 mb-16 text-white shadow-xl">
        <div className="flex items-center justify-center mb-6">
          <Euro className="h-16 w-16 text-white opacity-90" />
        </div>
        <h2 className="text-3xl font-bold text-center mb-6">Une offre unique pour les professionnels</h2>
        <div className="max-w-3xl mx-auto text-lg leading-relaxed mb-8 space-y-4">
          <p>
            Pour <span className="font-bold text-2xl">300 €</span>, bénéficiez d'outils sur mesure conçus par un expert-comptable fort d'une expérience solide et reconnue. Accédez à des ressources simples mais pertinentes, pensées pour répondre aux besoins concrets des professionnels, et contribuez au développement progressif d'une bibliothèque d'outils toujours plus riche.
          </p>
        </div>
        <div className="text-center">
          <MembershipButton />
        </div>
      </div>

      {/* Section de contribution */}
      <div className="bg-indigo-50 rounded-2xl p-8 md:p-12 mb-16">
        <div className="flex items-center justify-center mb-6">
          <Share2 className="h-16 w-16 text-indigo-600" />
        </div>
        <h2 className="text-3xl font-bold text-center text-indigo-900 mb-6">Contribuez à la communauté</h2>
        <div className="max-w-3xl mx-auto text-lg leading-relaxed text-gray-700 mb-8">
          <p>
            Si vous appréciez mon travail et l'initiative, je vous invite à partager vos propres outils (Excel, Python, web, etc.), qui enrichiront la plateforme et bénéficieront à la communauté. Ensemble, faisons grandir cet espace d'échange et de solutions pratiques.
          </p>
        </div>
        <div className="text-center">
          <Link
            to="/contributors"
            className="inline-block bg-indigo-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:bg-indigo-700 transform transition-all hover:-translate-y-1 shadow-lg hover:shadow-xl"
          >
            Devenir contributeur
          </Link>
        </div>
      </div>

      <div className="max-w-md mx-auto mb-16">
        <NewsletterSignup />
      </div>
    </div>
  );
};

export default Home;