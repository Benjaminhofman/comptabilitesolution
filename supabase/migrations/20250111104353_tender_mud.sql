-- Nettoyage complet
DROP TABLE IF EXISTS shared_files CASCADE;

-- Création de la table simplifiée
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

-- Une seule politique simple pour permettre toutes les opérations
CREATE POLICY "allow_all"
    ON shared_files
    FOR ALL
    TO PUBLIC
    USING (true)
    WITH CHECK (true);