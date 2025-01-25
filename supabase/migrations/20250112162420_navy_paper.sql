-- Suppression des anciennes politiques
DROP POLICY IF EXISTS "newsletter_insert_policy" ON newsletter_subscribers;
DROP POLICY IF EXISTS "newsletter_select_policy" ON newsletter_subscribers;

-- Création d'une nouvelle politique simplifiée pour l'insertion
CREATE POLICY "allow_insert"
    ON newsletter_subscribers
    FOR INSERT
    TO PUBLIC
    WITH CHECK (
        -- Vérifie uniquement la validité de l'email
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    );

-- Politique pour la lecture
CREATE POLICY "allow_select"
    ON newsletter_subscribers
    FOR SELECT
    TO PUBLIC
    USING (true);