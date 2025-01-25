/*
  # Création finale de la table shared_files

  1. Nouvelle Table
    - `shared_files`
      - `id` (uuid, clé primaire)
      - `storage_path` (text, chemin du fichier)
      - `title` (text, titre du fichier)
      - `description` (text, description optionnelle)
      - `author_name` (text, nom de l'auteur)
      - `author_email` (text, email de l'auteur)
      - `created_at` (timestamptz, date de création)

  2. Sécurité
    - Activation de RLS
    - Politique permissive pour toutes les opérations
*/

-- Nettoyage complet et sécurisé
DO $$ 
BEGIN
    -- Suppression des politiques existantes
    DROP POLICY IF EXISTS "shared_files_policy" ON shared_files;
    DROP POLICY IF EXISTS "allow_all" ON shared_files;
    -- Suppression de la table
    DROP TABLE IF EXISTS shared_files CASCADE;
EXCEPTION 
    WHEN undefined_table THEN 
        NULL;
END $$;

-- Création de la table
CREATE TABLE IF NOT EXISTS shared_files (
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

-- Politique unique et permissive
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_shared_files_created_at 
    ON shared_files(created_at DESC);

-- Commentaires
COMMENT ON TABLE shared_files IS 'Table stockant les métadonnées des fichiers partagés';
COMMENT ON COLUMN shared_files.storage_path IS 'Chemin du fichier dans le bucket Storage';
COMMENT ON COLUMN shared_files.title IS 'Titre du fichier';
COMMENT ON COLUMN shared_files.description IS 'Description optionnelle du fichier';
COMMENT ON COLUMN shared_files.author_name IS 'Nom de l''auteur';
COMMENT ON COLUMN shared_files.author_email IS 'Email de l''auteur';