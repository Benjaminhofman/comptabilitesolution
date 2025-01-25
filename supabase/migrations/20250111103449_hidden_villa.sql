-- Suppression sécurisée des politiques existantes
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Lecture publique des fichiers partagés" ON shared_files;
    DROP POLICY IF EXISTS "Modification des fichiers partagés" ON shared_files;
EXCEPTION 
    WHEN undefined_object THEN NULL;
END $$;

-- Suppression sécurisée de la table
DROP TABLE IF EXISTS shared_files CASCADE;

-- Création de la nouvelle table avec une structure optimisée
CREATE TABLE shared_files (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_path text NOT NULL,
    title text NOT NULL,
    description text,
    author_name text NOT NULL,
    author_email text NOT NULL,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT valid_email CHECK (author_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_storage_path CHECK (storage_path != '')
);

-- Activation de RLS
ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité plus précises
CREATE POLICY "Lecture publique des fichiers"
    ON shared_files
    FOR SELECT
    USING (true);

CREATE POLICY "Insertion de fichiers"
    ON shared_files
    FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Mise à jour des fichiers"
    ON shared_files
    FOR UPDATE
    USING (true);

-- Index optimisés
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);
CREATE INDEX idx_shared_files_storage_path ON shared_files(storage_path);
CREATE INDEX idx_shared_files_author_email ON shared_files(author_email);

-- Commentaires de table
COMMENT ON TABLE shared_files IS 'Table stockant les métadonnées des fichiers partagés';
COMMENT ON COLUMN shared_files.storage_path IS 'Chemin du fichier dans le bucket Supabase Storage';
COMMENT ON COLUMN shared_files.title IS 'Titre du fichier partagé';
COMMENT ON COLUMN shared_files.description IS 'Description optionnelle du fichier';
COMMENT ON COLUMN shared_files.author_name IS 'Nom de l''auteur du partage';
COMMENT ON COLUMN shared_files.author_email IS 'Email de l''auteur du partage';