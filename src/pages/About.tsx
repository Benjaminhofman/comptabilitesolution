import React from 'react';
import { Brain, Code, Share2, Award } from 'lucide-react';

const About = () => {
  return (
    <div className="max-w-6xl mx-auto px-4 py-12">
      <div className="text-center mb-12">
        <h1 className="text-4xl md:text-5xl font-serif font-bold text-indigo-900 mb-4">Benjamin Hofman</h1>
        <h2 className="text-xl md:text-2xl font-serif text-indigo-600">
          Expert-Comptable diplômé passionné par l'intelligence artificielle
        </h2>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <div className="bg-white p-6 rounded-xl shadow-md hover:shadow-lg transition-shadow">
          <Brain className="h-8 w-8 text-indigo-600 mb-4" />
          <h3 className="font-serif text-lg font-semibold mb-2">Expert IA</h3>
          <p className="text-gray-600">Passionné par l'IA et son application dans l'expertise comptable</p>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-md hover:shadow-lg transition-shadow">
          <Code className="h-8 w-8 text-indigo-600 mb-4" />
          <h3 className="font-serif text-lg font-semibold mb-2">Développeur</h3>
          <p className="text-gray-600">Création d'outils sur mesure pour optimiser les processus comptables</p>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-md hover:shadow-lg transition-shadow">
          <Share2 className="h-8 w-8 text-indigo-600 mb-4" />
          <h3 className="font-serif text-lg font-semibold mb-2">Collaboratif</h3>
          <p className="text-gray-600">Promotion du partage d'expérience et de l'entraide professionnelle</p>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-md hover:shadow-lg transition-shadow">
          <Award className="h-8 w-8 text-indigo-600 mb-4" />
          <h3 className="font-serif text-lg font-semibold mb-2">DEC Autodidacte</h3>
          <p className="text-gray-600">Parcours unique du DCG au DEC en autodidacte</p>
        </div>
      </div>

      <div className="prose prose-lg max-w-none bg-white rounded-xl shadow-md p-8 md:p-12">
        <p className="mb-6">
          Après une reconversion professionnelle il y a 14 ans, j'ai choisi le milieu de l'expertise comptable comme voie d'épanouissement professionnel. Ce parcours a été marqué par un défi unique : réussir le Diplôme d'Expertise Comptable (DEC) seul, en autodidacte, par correspondance, du DCG au DEC. Cette expérience a forgé ma rigueur, ma persévérance et ma capacité à m'adapter rapidement aux nouveaux savoirs.
        </p>

        <p className="mb-6">
          Depuis huit ans, je cultive une passion pour la gestion de la donnée et le développement de logiciels, une expertise que j'applique au quotidien pour transformer notre métier. Cette démarche proactive m'a conduit à concevoir des outils personnalisés pour optimiser les processus comptables et faciliter les missions de conseil. Mon mémoire d'expertise comptable est d'ailleurs consacré au développement d'un logiciel CRM sur mesure pour les cabinets d'expertise comptable.
        </p>

        <p className="mb-6">
          Je suis également un fervent utilisateur des technologies d'intelligence artificielle (IA), que j'emploie quotidiennement pour automatiser, analyser et innover. En veille permanente sur les évolutions de l'IA, j'anticipe une révolution sans précédent dans notre profession avec l'arrivée massive de ces outils. Convaincu que l'intelligence artificielle redéfinira profondément notre manière de travailler, je souhaite être un acteur clé de cette transition, en accompagnant nos métiers dans ce tournant décisif.
        </p>

        <p className="mb-6">
          Mon but est de promouvoir le partage d'expérience, l'entraide et la collaboration. Je crois fermement que c'est la somme des intelligences individuelles qui contribue à une intelligence collective renforcée, et je consomme volontiers les outils que chacun crée dans son coin. Valoriser chaque apport individuel est essentiel à mes yeux, car c'est cette dynamique qui permet de construire ensemble un avenir solide.
        </p>

        <p className="mb-6">
          Je ressens une immense fierté de contribuer à la protection et à l'évolution de notre métier, qui se trouve aujourd'hui à un tournant critique face aux évolutions technologiques. Ces changements vont profondément perturber notre avenir, mais ils représentent aussi une opportunité unique de redéfinir notre rôle et notre impact.
        </p>

        <p>
          Basé à Vestric-et-Candiac dans le Gard, je suis toujours prêt à collaborer avec ceux qui partagent cette vision et cette passion pour la transformation positive de l'expertise comptable.
        </p>
      </div>
    </div>
  );
};

export default About;