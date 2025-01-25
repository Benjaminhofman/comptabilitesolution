import React from 'react';

const Privacy = () => {
  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-indigo-900 mb-8">Politique de Confidentialité</h1>
      
      <div className="bg-white rounded-lg shadow-md p-8 space-y-6">
        <section>
          <h2 className="text-xl font-semibold mb-4">Introduction</h2>
          <p>Cette politique de confidentialité décrit comment Benjamin Hofman collecte, utilise et protège vos informations lorsque vous utilisez notre site web.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Collecte des données</h2>
          <p>Nous collectons les informations suivantes :</p>
          <ul className="list-disc ml-6 mt-2 space-y-1">
            <li>Données de navigation (via les cookies techniques)</li>
            <li>Données que vous nous fournissez volontairement via les formulaires de contact</li>
            <li>Adresse IP et données de connexion pour des raisons de sécurité</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Utilisation des données</h2>
          <p>Vos données sont utilisées pour :</p>
          <ul className="list-disc ml-6 mt-2 space-y-1">
            <li>Assurer le bon fonctionnement technique du site</li>
            <li>Répondre à vos demandes de contact</li>
            <li>Améliorer l'expérience utilisateur</li>
            <li>Assurer la sécurité du site</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Protection des données</h2>
          <p>Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos données contre tout accès, modification, divulgation ou destruction non autorisés.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Durée de conservation</h2>
          <p>Les données sont conservées pour une durée limitée :</p>
          <ul className="list-disc ml-6 mt-2 space-y-1">
            <li>Données de navigation : 13 mois maximum</li>
            <li>Données de contact : 3 ans après le dernier contact</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Vos droits</h2>
          <p>Conformément au RGPD, vous disposez des droits suivants :</p>
          <ul className="list-disc ml-6 mt-2 space-y-1">
            <li>Droit d'accès à vos données</li>
            <li>Droit de rectification</li>
            <li>Droit à l'effacement</li>
            <li>Droit à la limitation du traitement</li>
            <li>Droit à la portabilité</li>
            <li>Droit d'opposition</li>
          </ul>
          <p className="mt-4">Pour exercer ces droits, contactez-nous à : benjamin.hofman@hotmail.com</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Cookies</h2>
          <p>Notre site utilise uniquement des cookies techniques essentiels au fonctionnement du site. Ces cookies ne collectent pas de données personnelles.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Partage des données</h2>
          <p>Nous ne vendons ni ne partageons vos données personnelles avec des tiers.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Modification de la politique</h2>
          <p>Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Les modifications seront publiées sur cette page.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Contact</h2>
          <p>Pour toute question concernant cette politique de confidentialité, contactez :</p>
          <div className="mt-2">
            <p>Benjamin Hofman</p>
            <p>7 rue Charlemagne</p>
            <p>30600 Vestric et Candiac</p>
            <p>Email : benjamin.hofman@hotmail.com</p>
            <p>Téléphone : 06 34 43 08 26</p>
          </div>
        </section>
      </div>
    </div>
  );
}

export default Privacy;