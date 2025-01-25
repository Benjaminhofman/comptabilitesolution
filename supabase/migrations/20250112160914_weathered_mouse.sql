-- Drop table if exists
DROP TABLE IF EXISTS newsletter_subscribers CASCADE;

-- Create newsletter_subscribers table
CREATE TABLE newsletter_subscribers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    created_at timestamptz DEFAULT now(),
    CONSTRAINT valid_email CHECK (length(trim(email)) > 0)
);

-- Enable RLS
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable insert for public"
    ON newsletter_subscribers
    FOR INSERT
    TO public
    WITH CHECK (true);

CREATE POLICY "Enable select for authenticated users"
    ON newsletter_subscribers
    FOR SELECT
    TO authenticated
    USING (true);

-- Create indexes
CREATE INDEX idx_newsletter_subscribers_email ON newsletter_subscribers(email);
CREATE INDEX idx_newsletter_subscribers_created_at ON newsletter_subscribers(created_at DESC);

-- Add comments
COMMENT ON TABLE newsletter_subscribers IS 'Table storing newsletter subscribers';
COMMENT ON COLUMN newsletter_subscribers.email IS 'Email address of the subscriber';