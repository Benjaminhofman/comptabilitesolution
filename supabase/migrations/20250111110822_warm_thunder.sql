/*
  # Création de la table shared_files

  1. Nouvelle Table
    - `shared_files`
      - `id` (uuid, clé primaire)
      - `storage_path` (text, chemin du fichier dans le bucket)
      - `title` (text, titre du fichier)
      - `description` (text, description optionnelle)
      - `author_name` (text, nom de l'auteur)
      - `author_email` (text, email de l'auteur)
      - `created_at` (timestamptz, date de création)

  2. Sécurité
    - Activation de RLS
    - Politique permissive pour toutes les opérations
*/

-- Nettoyage des anciennes tables et politiques
DROP POLICY IF EXISTS "shared_files_policy" ON shared_files;
DROP TABLE IF EXISTS shared_files CASCADE;

-- Création de la table
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

-- Politique permissive pour toutes les opérations
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);