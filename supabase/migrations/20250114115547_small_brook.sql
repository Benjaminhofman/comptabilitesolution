/*
  # Configuration de la plateforme de paiement

  1. Tables
    - `paid_tools`: Stockage des outils payants
    - `tool_purchases`: Suivi des achats
    - `payouts`: Gestion des versements aux contributeurs

  2. Sécurité
    - RLS activé sur toutes les tables
    - Politiques d'accès spécifiques pour chaque opération
    - Protection des données sensibles

  3. Relations
    - Liens avec auth.users pour les auteurs et acheteurs
    - Contraintes de clés étrangères pour l'intégrité des données
*/

-- Nettoyage des tables existantes si nécessaire
DROP TABLE IF EXISTS payouts;
DROP TABLE IF EXISTS tool_purchases;
DROP TABLE IF EXISTS paid_tools;

-- Table des outils payants
CREATE TABLE paid_tools (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL CHECK (length(trim(name)) > 0),
    description text,
    price integer NOT NULL CHECK (price >= 0),
    author_id uuid REFERENCES auth.users(id) NOT NULL,
    storage_path text NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Table des achats
CREATE TABLE tool_purchases (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id uuid REFERENCES paid_tools(id) NOT NULL,
    user_id uuid REFERENCES auth.users(id) NOT NULL,
    amount_paid integer NOT NULL CHECK (amount_paid >= 0),
    stripe_session_id text,
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'refunded')),
    created_at timestamptz DEFAULT now(),
    completed_at timestamptz,
    UNIQUE(tool_id, user_id)
);

-- Table des versements aux contributeurs
CREATE TABLE payouts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id uuid REFERENCES auth.users(id) NOT NULL,
    amount integer NOT NULL CHECK (amount >= 0),
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processed', 'failed')),
    processed_at timestamptz,
    created_at timestamptz DEFAULT now()
);

-- Activation RLS
ALTER TABLE paid_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE tool_purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE payouts ENABLE ROW LEVEL SECURITY;

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

CREATE POLICY "Suppression d'outils par l'auteur"
    ON paid_tools FOR DELETE
    TO authenticated
    USING (auth.uid() = author_id);

-- Politiques pour tool_purchases
CREATE POLICY "Lecture des achats par l'acheteur ou l'auteur"
    ON tool_purchases FOR SELECT
    TO authenticated
    USING (
        auth.uid() = user_id OR 
        auth.uid() IN (
            SELECT author_id FROM paid_tools WHERE id = tool_id
        )
    );

CREATE POLICY "Création des achats par l'acheteur"
    ON tool_purchases FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Politiques pour payouts
CREATE POLICY "Lecture des versements par l'auteur"
    ON payouts FOR SELECT
    TO authenticated
    USING (auth.uid() = author_id);

-- Index pour les performances
CREATE INDEX idx_paid_tools_author ON paid_tools(author_id);
CREATE INDEX idx_paid_tools_created_at ON paid_tools(created_at DESC);
CREATE INDEX idx_tool_purchases_user ON tool_purchases(user_id);
CREATE INDEX idx_tool_purchases_tool ON tool_purchases(tool_id);
CREATE INDEX idx_tool_purchases_status ON tool_purchases(status);
CREATE INDEX idx_payouts_author ON payouts(author_id);
CREATE INDEX idx_payouts_status ON payouts(status);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_paid_tools_updated_at
    BEFORE UPDATE ON paid_tools
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

-- Commentaires
COMMENT ON TABLE paid_tools IS 'Outils payants proposés par les contributeurs';
COMMENT ON TABLE tool_purchases IS 'Historique des achats d''outils';
COMMENT ON TABLE payouts IS 'Versements aux contributeurs';