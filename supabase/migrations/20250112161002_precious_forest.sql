/*
  # Fix Newsletter Table Final

  1. Changes
    - Complete cleanup of existing objects
    - Simplified table structure
    - Most permissive policies possible
    - Basic index for performance
*/

-- Nettoyage complet
DROP POLICY IF EXISTS "allow_public_insert" ON newsletter_subscribers;
DROP POLICY IF EXISTS "allow_public_select" ON newsletter_subscribers;
DROP POLICY IF EXISTS "Enable insert for public" ON newsletter_subscribers;
DROP POLICY IF EXISTS "Enable select for authenticated users" ON newsletter_subscribers;
DROP TABLE IF EXISTS newsletter_subscribers CASCADE;

-- Création de la table simplifiée
CREATE TABLE newsletter_subscribers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- Activation de RLS
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Politique unique et permissive pour toutes les opérations
CREATE POLICY "newsletter_policy"
    ON newsletter_subscribers
    FOR ALL
    TO PUBLIC
    USING (true)
    WITH CHECK (true);

-- Index basique
CREATE INDEX idx_newsletter_created_at ON newsletter_subscribers(created_at DESC);