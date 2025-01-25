/*
  # Correction de la table des fichiers partagés

  1. Suppression et recréation de la table
    - Supprime les anciennes politiques
    - Recrée la table avec la bonne structure
    - Ajoute les nouvelles politiques de sécurité
*/

-- Suppression des anciennes politiques
DROP POLICY IF EXISTS "Anyone can read shared files" ON shared_files;
DROP POLICY IF EXISTS "Users can create shared files" ON shared_files;
DROP POLICY IF EXISTS "Lecture publique des fichiers partagés" ON shared_files;
DROP POLICY IF EXISTS "Création de fichiers par utilisateurs authentifiés" ON shared_files;

-- Suppression et recréation de la table
DROP TABLE IF EXISTS shared_files;

CREATE TABLE shared_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  filename text NOT NULL,
  storage_path text NOT NULL,
  title text NOT NULL,
  description text,
  author_name text NOT NULL,
  author_email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
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

-- Ajout d'un index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_shared_files_created_at ON shared_files(created_at DESC);