-- Suppression de l'ancienne politique
DROP POLICY IF EXISTS "newsletter_policy" ON newsletter_subscribers;

-- Création d'une nouvelle politique avec des conditions spécifiques
CREATE POLICY "newsletter_policy"
    ON newsletter_subscribers
    FOR ALL
    TO PUBLIC
    USING (
        -- Vérifie que l'email est valide et unique
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' AND
        NOT EXISTS (
            SELECT 1 
            FROM newsletter_subscribers ns 
            WHERE ns.email = newsletter_subscribers.email AND 
                  ns.id != newsletter_subscribers.id
        )
    )
    WITH CHECK (
        -- Vérifie que l'email est valide lors de l'insertion
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' AND
        NOT EXISTS (
            SELECT 1 
            FROM newsletter_subscribers 
            WHERE email = NEW.email
        )
    );

-- Ajout d'une contrainte unique sur l'email
ALTER TABLE newsletter_subscribers ADD CONSTRAINT unique_email UNIQUE (email);