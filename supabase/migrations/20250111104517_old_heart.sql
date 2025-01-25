-- Suppression complète de la table et de ses dépendances
DROP TABLE IF EXISTS shared_files CASCADE;
DROP TABLE IF EXISTS tool_files CASCADE;

-- Création de la table shared_files avec une structure minimale
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

-- Une seule politique permissive pour toutes les opérations
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    TO PUBLIC
    USING (true)
    WITH CHECK (true);

-- Index essentiel
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);