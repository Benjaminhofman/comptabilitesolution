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

-- Drop existing table if it exists
DROP TABLE IF EXISTS contributors CASCADE;

-- Create contributors table
CREATE TABLE contributors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL,
  tool_name text NOT NULL,
  tool_description text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE contributors ENABLE ROW LEVEL SECURITY;

-- Create policies for public access
CREATE POLICY "Lecture publique des contributeurs"
  ON contributors
  FOR SELECT
  TO PUBLIC
  USING (true);

CREATE POLICY "Création publique de contributions"
  ON contributors
  FOR INSERT
  TO PUBLIC
  WITH CHECK (true);

CREATE POLICY "Suppression publique de contributions"
  ON contributors
  FOR DELETE
  TO PUBLIC
  USING (true);

-- Create index for better performance
CREATE INDEX idx_contributors_created_at ON contributors(created_at DESC);