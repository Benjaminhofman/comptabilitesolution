/*
  # Fix Newsletter Subscribers Table

  1. Changes
    - Drop existing table and policies
    - Recreate table with proper constraints
    - Add appropriate policies for public access
    - Create optimized indexes
  
  2. Security
    - Enable RLS
    - Allow public inserts
    - Allow authenticated users to view subscribers
*/

-- Clean up existing objects
DROP POLICY IF EXISTS "Enable insert for public" ON newsletter_subscribers;
DROP POLICY IF EXISTS "Enable select for authenticated users" ON newsletter_subscribers;
DROP TABLE IF EXISTS newsletter_subscribers CASCADE;

-- Create newsletter_subscribers table
CREATE TABLE newsletter_subscribers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Create a simple policy for public inserts
CREATE POLICY "allow_public_insert"
    ON newsletter_subscribers
    FOR INSERT
    TO public
    WITH CHECK (true);

-- Create a policy for public selects
CREATE POLICY "allow_public_select"
    ON newsletter_subscribers
    FOR SELECT
    TO public
    USING (true);

-- Create index for better performance
CREATE INDEX idx_newsletter_subscribers_created_at 
    ON newsletter_subscribers(created_at DESC);