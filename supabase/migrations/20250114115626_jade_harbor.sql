/*
  # Correction du schéma des outils payants

  1. Structure
    - Table `paid_tools` avec les champs essentiels
    - Relations avec auth.users
    - Politiques de sécurité simplifiées
*/

-- Nettoyage des tables existantes
DROP TABLE IF EXISTS tool_purchases CASCADE;
DROP TABLE IF EXISTS paid_tools CASCADE;

-- Table des outils payants
CREATE TABLE paid_tools (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    price integer NOT NULL CHECK (price >= 0),
    author_id uuid REFERENCES auth.users(id) NOT NULL,
    storage_path text NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- Table des achats
CREATE TABLE tool_purchases (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id uuid REFERENCES paid_tools(id) NOT NULL,
    user_id uuid REFERENCES auth.users(id) NOT NULL,
    amount_paid integer NOT NULL,
    stripe_session_id text,
    created_at timestamptz DEFAULT now(),
    UNIQUE(tool_id, user_id)
);

-- Activation RLS
ALTER TABLE paid_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE tool_purchases ENABLE ROW LEVEL SECURITY;

-- Politiques simplifiées
CREATE POLICY "allow_select" ON paid_tools FOR SELECT USING (true);
CREATE POLICY "allow_insert" ON paid_tools FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "allow_update" ON paid_tools FOR UPDATE USING (auth.uid() = author_id);

CREATE POLICY "allow_purchase_select" ON tool_purchases FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "allow_purchase_insert" ON tool_purchases FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Index essentiels
CREATE INDEX idx_paid_tools_author ON paid_tools(author_id);
CREATE INDEX idx_paid_tools_created_at ON paid_tools(created_at DESC);