/*
  # Création de la table shared_files

  1. Nouvelle Table
    - `shared_files`
      - `id` (uuid, clé primaire)
      - `filename` (text, nom du fichier)
      - `storage_path` (text, chemin dans le stockage)
      - `title` (text, titre du fichier)
      - `description` (text, description optionnelle)
      - `author_name` (text, nom de l'auteur)
      - `author_email` (text, email de l'auteur)
      - `created_at` (timestamptz, date de création)
      - `created_by` (uuid, référence à auth.users)

  2. Sécurité
    - Activation de RLS
    - Politique de lecture publique
    - Politique de création pour utilisateurs authentifiés
    - Index sur created_at pour les performances
*/

-- Suppression de la table si elle existe
DROP TABLE IF EXISTS shared_files;

-- Création de la table
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

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_shared_files_created_at 
  ON shared_files(created_at DESC);