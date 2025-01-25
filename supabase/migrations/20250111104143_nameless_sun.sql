-- Nettoyage sécurisé des anciennes tables et politiques
DO $$ 
BEGIN
    -- Suppression des politiques existantes
    DROP POLICY IF EXISTS "Lecture des fichiers" ON shared_files;
    DROP POLICY IF EXISTS "Création de fichiers" ON shared_files;
    DROP POLICY IF EXISTS "Lecture publique des fichiers" ON shared_files;
    DROP POLICY IF EXISTS "Insertion de fichiers" ON shared_files;
    DROP POLICY IF EXISTS "Mise à jour des fichiers" ON shared_files;
    DROP POLICY IF EXISTS "Lecture publique des fichiers partagés" ON shared_files;
    DROP POLICY IF EXISTS "Modification des fichiers partagés" ON shared_files;
EXCEPTION 
    WHEN undefined_object THEN NULL;
END $$;

-- Suppression et recréation de la table
DROP TABLE IF EXISTS shared_files CASCADE;

CREATE TABLE shared_files (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_path text NOT NULL,
    title text NOT NULL,
    description text,
    author_name text NOT NULL,
    author_email text NOT NULL,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT valid_email CHECK (author_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_storage_path CHECK (storage_path != ''),
    CONSTRAINT valid_title CHECK (length(trim(title)) > 0)
);

-- Activation de RLS
ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité simplifiées
CREATE POLICY "shared_files_select_policy"
    ON shared_files
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY "shared_files_insert_policy"
    ON shared_files
    FOR INSERT
    TO PUBLIC
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);
CREATE INDEX idx_shared_files_storage_path ON shared_files(storage_path);

-- Commentaires
COMMENT ON TABLE shared_files IS 'Stockage des métadonnées des fichiers partagés';
COMMENT ON COLUMN shared_files.storage_path IS 'Chemin du fichier dans le bucket Storage';
COMMENT ON COLUMN shared_files.title IS 'Titre du fichier partagé';
COMMENT ON COLUMN shared_files.description IS 'Description optionnelle du fichier';
COMMENT ON COLUMN shared_files.author_name IS 'Nom de l''auteur';
COMMENT ON COLUMN shared_files.author_email IS 'Email de l''auteur';