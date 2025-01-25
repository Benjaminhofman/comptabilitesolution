/*
  # Correction finale de la table shared_files

  1. Nettoyage complet
    - Suppression de toutes les politiques existantes
    - Suppression de la table et de ses dépendances
  
  2. Nouvelle Structure
    - Création de la table avec tous les champs nécessaires
    - Configuration des contraintes et valeurs par défaut
  
  3. Sécurité
    - Activation de RLS
    - Configuration des politiques d'accès
    - Index pour les performances
*/

DO $$ 
BEGIN
  -- Suppression des politiques existantes s'il y en a
  DROP POLICY IF EXISTS "Lecture publique des fichiers partagés" ON shared_files;
  DROP POLICY IF EXISTS "Création de fichiers par utilisateurs authentifiés" ON shared_files;
  DROP POLICY IF EXISTS "Anyone can read shared files" ON shared_files;
  DROP POLICY IF EXISTS "Users can create shared files" ON shared_files;
EXCEPTION 
  WHEN undefined_table THEN 
    NULL;
END $$;

-- Suppression de la table si elle existe
DROP TABLE IF EXISTS shared_files CASCADE;

-- Création de la nouvelle table
CREATE TABLE shared_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  filename text NOT NULL,
  storage_path text NOT NULL,
  title text NOT NULL,
  description text,
  author_name text NOT NULL,
  author_email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Activation de RLS
ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité
CREATE POLICY "Lecture publique des fichiers partagés"
  ON shared_files
  FOR SELECT
  USING (true);

CREATE POLICY "Création de fichiers par utilisateurs authentifiés"
  ON shared_files
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_shared_files_created_at 
  ON shared_files(created_at DESC);

-- Ajout de données de test
INSERT INTO shared_files (filename, storage_path, title, description, author_name, author_email, created_by)
SELECT 
  'exemple.pdf',
  'exemple.pdf',
  'Guide de démarrage',
  'Un guide pour bien débuter avec la plateforme',
  'Benjamin Hofman',
  'benjamin.hofman@hotmail.com',
  id
FROM auth.users
WHERE email = 'benjamin.hofman@hotmail.com'
LIMIT 1
ON CONFLICT DO NOTHING;