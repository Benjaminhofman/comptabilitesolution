/*
  # Configuration finale de la table shared_files

  1. Nouvelle Table
    - `shared_files`
      - `id` (uuid, clé primaire)
      - `storage_path` (text, chemin du fichier dans le stockage)
      - `title` (text, titre personnalisé du fichier)
      - `description` (text, description optionnelle)
      - `author_name` (text, nom de l'auteur)
      - `author_email` (text, email de l'auteur)
      - `created_at` (timestamptz, date de création)

  2. Sécurité
    - Activation de RLS
    - Politique de lecture publique
    - Politique de modification publique
*/

-- Nettoyage des anciennes politiques et table
DROP POLICY IF EXISTS "Lecture publique des fichiers partagés" ON shared_files;
DROP POLICY IF EXISTS "Modification des fichiers partagés" ON shared_files;
DROP TABLE IF EXISTS shared_files CASCADE;

-- Création de la nouvelle table
CREATE TABLE shared_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  storage_path text NOT NULL,
  title text NOT NULL,
  description text,
  author_name text NOT NULL,
  author_email text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Activation de RLS
ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité
CREATE POLICY "Lecture publique des fichiers partagés"
  ON shared_files
  FOR SELECT
  USING (true);

CREATE POLICY "Modification des fichiers partagés"
  ON shared_files
  FOR ALL
  USING (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_storage_path ON shared_files(storage_path);
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);