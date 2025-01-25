-- Création de la table des outils payants
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

-- Politiques de sécurité
CREATE POLICY "allow_select_paid_tools"
    ON paid_tools
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY "allow_insert_paid_tools"
    ON paid_tools
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = author_id);

CREATE POLICY "allow_update_paid_tools"
    ON paid_tools
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = author_id);

CREATE POLICY "allow_select_purchases"
    ON tool_purchases
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "allow_insert_purchases"
    ON tool_purchases
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Index pour les performances
CREATE INDEX idx_paid_tools_author ON paid_tools(author_id);
CREATE INDEX idx_paid_tools_created_at ON paid_tools(created_at DESC);
CREATE INDEX idx_tool_purchases_user ON tool_purchases(user_id);
CREATE INDEX idx_tool_purchases_tool ON tool_purchases(tool_id);