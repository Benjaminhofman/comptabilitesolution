-- Suppression de la table si elle existe
DROP TABLE IF EXISTS newsletter_subscribers CASCADE;

-- Création de la table newsletter_subscribers
CREATE TABLE newsletter_subscribers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text NOT NULL,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT unique_email UNIQUE (email)
);

-- Activation de RLS
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Politique pour l'insertion publique
CREATE POLICY "newsletter_insert_policy"
    ON newsletter_subscribers
    FOR INSERT
    TO PUBLIC
    WITH CHECK (
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' AND
        NOT EXISTS (
            SELECT 1 
            FROM newsletter_subscribers 
            WHERE email = NEW.email
        )
    );

-- Politique pour la lecture
CREATE POLICY "newsletter_select_policy"
    ON newsletter_subscribers
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Index pour les performances
CREATE INDEX idx_newsletter_subscribers_email ON newsletter_subscribers(email);
CREATE INDEX idx_newsletter_subscribers_created_at ON newsletter_subscribers(created_at DESC);