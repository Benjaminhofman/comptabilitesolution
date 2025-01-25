/*
  # Configuration finale de la table shared_files

  1. Structure
    - Table unique pour les métadonnées des fichiers
    - Contraintes de validation
    - Index optimisés

  2. Sécurité
    - RLS activé
    - Politique permissive unique
*/

-- Nettoyage complet et sécurisé
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "shared_files_policy" ON shared_files;
    DROP TABLE IF EXISTS shared_files CASCADE;
EXCEPTION 
    WHEN undefined_table THEN NULL;
END $$;

-- Création de la table
CREATE TABLE shared_files (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_path text NOT NULL UNIQUE,
    title text NOT NULL,
    description text,
    author_name text NOT NULL,
    author_email text NOT NULL,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT valid_storage_path CHECK (storage_path != ''),
    CONSTRAINT valid_title CHECK (length(trim(title)) > 0)
);

-- Activation de RLS
ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Politique unique et permissive
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index optimisés
CREATE UNIQUE INDEX idx_shared_files_storage_path ON shared_files(storage_path);
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);

-- Commentaires
COMMENT ON TABLE shared_files IS 'Métadonnées des fichiers stockés';
COMMENT ON COLUMN shared_files.storage_path IS 'Identifiant unique du fichier dans le bucket';
COMMENT ON COLUMN shared_files.title IS 'Titre affiché du fichier';
COMMENT ON COLUMN shared_files.description IS 'Description optionnelle';