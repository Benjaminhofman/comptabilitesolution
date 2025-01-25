import React from 'react';

const LegalNotice = () => {
  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-indigo-900 mb-8">Mentions Légales</h1>
      
      <div className="bg-white rounded-lg shadow-md p-8 space-y-6">
        <section>
          <h2 className="text-xl font-semibold mb-4">Éditeur du site</h2>
          <p>Benjamin Hofman</p>
          <p>7 rue Charlemagne</p>
          <p>30600 Vestric et Candiac</p>
          <p>Téléphone : 06 34 43 08 26</p>
          <p>Email : benjamin.hofman@hotmail.com</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Hébergeur du site</h2>
          <p>Netlify, Inc.</p>
          <p>2325 3rd Street, Suite 296</p>
          <p>San Francisco, California 94107</p>
          <p>United States</p>
          <p>Site web : www.netlify.com</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Propriété intellectuelle</h2>
          <p>L'ensemble de ce site relève de la législation française et internationale sur le droit d'auteur et la propriété intellectuelle. Tous les droits de reproduction sont réservés. La reproduction de tout ou partie de ce site sur quelque support que ce soit est formellement interdite sauf autorisation expresse de Benjamin Hofman.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Protection des données personnelles</h2>
          <p>Conformément au Règlement Général sur la Protection des Données (RGPD), vous disposez d'un droit d'accès, de rectification et de suppression des données vous concernant. Ces droits peuvent être exercés en contactant :</p>
          <p className="mt-2">Benjamin Hofman</p>
          <p>Email : benjamin.hofman@hotmail.com</p>
          <p className="mt-2">Les informations collectées sur ce site sont uniquement destinées à un usage interne et ne seront en aucun cas cédées ou vendues à des tiers.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Cookies</h2>
          <p>Ce site utilise des cookies techniques nécessaires à son bon fonctionnement. En navigant sur ce site, vous acceptez leur utilisation.</p>
        </section>

        <section>
          <h2 className="text-xl font-semibold mb-4">Loi applicable</h2>
          <p>Les présentes mentions légales sont soumises au droit français. En cas de litige, les tribunaux français seront seuls compétents.</p>
        </section>
      </div>
    </div>
  );
}

export default LegalNotice;