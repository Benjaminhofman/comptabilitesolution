/*
  # Configuration des outils payants

  1. Nouvelles Tables
    - `paid_tools`
      - `id` (uuid, primary key)
      - `name` (text)
      - `description` (text)
      - `price` (integer, en centimes)
      - `author_id` (uuid, référence vers auth.users)
      - `storage_path` (text)
      - `created_at` (timestamp)
    - `tool_purchases`
      - `id` (uuid, primary key)
      - `tool_id` (uuid, référence vers paid_tools)
      - `user_id` (uuid, référence vers auth.users)
      - `amount_paid` (integer)
      - `created_at` (timestamp)
      - `stripe_session_id` (text)

  2. Sécurité
    - Enable RLS sur les deux tables
    - Politiques pour la lecture publique des outils
    - Politiques pour la création et la modification par les auteurs
    - Politiques pour la lecture des achats par les acheteurs
*/

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

-- Politiques pour paid_tools
CREATE POLICY "Lecture publique des outils payants"
    ON paid_tools FOR SELECT
    USING (true);

CREATE POLICY "Création d'outils par l'auteur"
    ON paid_tools FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Modification d'outils par l'auteur"
    ON paid_tools FOR UPDATE
    TO authenticated
    USING (auth.uid() = author_id);

-- Politiques pour tool_purchases
CREATE POLICY "Lecture des achats par l'acheteur"
    ON tool_purchases FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Création des achats"
    ON tool_purchases FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Index pour les performances
CREATE INDEX idx_paid_tools_author ON paid_tools(author_id);
CREATE INDEX idx_tool_purchases_user ON tool_purchases(user_id);
CREATE INDEX idx_tool_purchases_tool ON tool_purchases(tool_id);