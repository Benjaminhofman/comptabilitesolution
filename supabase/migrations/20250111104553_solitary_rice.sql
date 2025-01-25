-- Nettoyage complet des tables existantes
DROP TABLE IF EXISTS shared_files CASCADE;
DROP TABLE IF EXISTS tool_files CASCADE;

-- Création de la table shared_files
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

-- Politique unique pour toutes les opérations
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);