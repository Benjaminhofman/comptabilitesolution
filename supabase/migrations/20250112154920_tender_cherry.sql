/*
  # Create contributors table with public access

  1. New Tables
    - `contributors`
      - `id` (uuid, primary key)
      - `first_name` (text)
      - `last_name` (text)
      - `email` (text)
      - `tool_name` (text)
      - `tool_description` (text)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on `contributors` table
    - Add policies for public access (read, create, delete)
*/

-- Drop existing table and policies if they exist
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Lecture publique des contributeurs" ON contributors;
    DROP POLICY IF EXISTS "Création publique de contributions" ON contributors;
    DROP POLICY IF EXISTS "Suppression publique de contributions" ON contributors;
EXCEPTION 
    WHEN undefined_object THEN NULL;
END $$;

DROP TABLE IF EXISTS contributors CASCADE;

-- Create contributors table
CREATE TABLE contributors (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name text NOT NULL CHECK (length(trim(first_name)) > 0),
    last_name text NOT NULL CHECK (length(trim(last_name)) > 0),
    email text NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    tool_name text NOT NULL CHECK (length(trim(tool_name)) > 0),
    tool_description text NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE contributors ENABLE ROW LEVEL SECURITY;

-- Create policies for public access
CREATE POLICY "allow_select" ON contributors FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "allow_insert" ON contributors FOR INSERT TO PUBLIC WITH CHECK (true);
CREATE POLICY "allow_delete" ON contributors FOR DELETE TO PUBLIC USING (true);

-- Create index for better performance
CREATE INDEX idx_contributors_created_at ON contributors(created_at DESC);