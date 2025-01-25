-- Insert tools data if not exists
INSERT INTO tools (name, description, category, characteristics) 
SELECT 
  'Calculateur de TVA',
  'Outil permettant de calculer rapidement la TVA et les montants HT/TTC',
  'fiscal',
  'Calcul automatique des différents taux de TVA\nExport des calculs en PDF\nHistorique des calculs'
WHERE NOT EXISTS (
  SELECT 1 FROM tools WHERE name = 'Calculateur de TVA'
);

INSERT INTO tools (name, description, category, characteristics)
SELECT 
  'Tableau de Bord Financier',
  'Template Excel pour suivre les indicateurs financiers clés',
  'finance',
  'Graphiques dynamiques\nRatios financiers automatisés\nTableau de bord personnalisable'
WHERE NOT EXISTS (
  SELECT 1 FROM tools WHERE name = 'Tableau de Bord Financier'
);

INSERT INTO tools (name, description, category, characteristics)
SELECT 
  'Plan Comptable Général',
  'Version numérique du plan comptable 2024',
  'comptabilite',
  'Recherche rapide des comptes\nMises à jour régulières\nNotes explicatives'
WHERE NOT EXISTS (
  SELECT 1 FROM tools WHERE name = 'Plan Comptable Général'
);

INSERT INTO tools (name, description, category, characteristics)
SELECT 
  'Générateur de Rapports',
  'Création automatisée de rapports financiers professionnels',
  'reporting',
  'Templates personnalisables\nExport multi-format\nIntégration de graphiques'
WHERE NOT EXISTS (
  SELECT 1 FROM tools WHERE name = 'Générateur de Rapports'
);

INSERT INTO tools (name, description, category, characteristics)
SELECT 
  'Simulateur Fiscal',
  'Outil de simulation pour l''optimisation fiscale',
  'fiscal',
  'Calculs d''impôts\nSimulations comparatives\nRecommandations automatiques'
WHERE NOT EXISTS (
  SELECT 1 FROM tools WHERE name = 'Simulateur Fiscal'
);