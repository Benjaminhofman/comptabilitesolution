/*
  # Fix shared_files table

  1. Changes
    - Drop existing table and policies
    - Create new shared_files table with minimal structure
    - Add permissive RLS policy
    - Add test data
*/

-- Nettoyage complet
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

-- Politique permissive
CREATE POLICY "shared_files_policy"
    ON shared_files
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_shared_files_created_at ON shared_files(created_at DESC);

-- Données de test
INSERT INTO shared_files (storage_path, title, description, author_name, author_email)
VALUES 
    ('exemple-1.pdf', 'Guide de démarrage', 'Guide complet pour bien débuter avec la plateforme', 'Benjamin Hofman', 'benjamin.hofman@hotmail.com'),
    ('exemple-2.xlsx', 'Template Excel Comptable', 'Modèle de tableau de bord financier', 'Benjamin Hofman', 'benjamin.hofman@hotmail.com'),
    ('exemple-3.pdf', 'Checklist Fiscale', 'Liste de vérification pour les déclarations fiscales', 'Benjamin Hofman', 'benjamin.hofman@hotmail.com');