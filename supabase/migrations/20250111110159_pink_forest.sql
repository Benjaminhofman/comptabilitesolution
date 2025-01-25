/*
  # Restauration de la table shared_files

  1. Changes
    - Suppression de la table existante
    - Recréation de la table avec la structure de base
    - Ajout d'une politique RLS simple
*/

-- Nettoyage
DROP POLICY IF EXISTS "shared_files_policy" ON shared_files;
DROP TABLE IF EXISTS shared_files CASCADE;

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

-- Politique simple
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);