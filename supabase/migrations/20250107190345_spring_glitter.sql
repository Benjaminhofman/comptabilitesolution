/*
  # Create tools table

  1. New Tables
    - `tools`
      - `id` (uuid, primary key)
      - `name` (text, required)
      - `description` (text)
      - `category` (text, required)
      - `characteristics` (text)
      - `file_url` (text)
      - `created_at` (timestamp)
      - `created_by` (uuid, references profiles)

  2. Security
    - Enable RLS on `tools` table
    - Add policies for authenticated users to read tools
    - Add policies for admins to manage tools
*/

CREATE TABLE IF NOT EXISTS tools (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  category text NOT NULL,
  characteristics text,
  file_url text,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES profiles(id)
);

ALTER TABLE tools ENABLE ROW LEVEL SECURITY;

-- Anyone can read tools
CREATE POLICY "Anyone can read tools"
  ON tools
  FOR SELECT
  USING (true);

-- Only admins can insert tools
CREATE POLICY "Only admins can insert tools"
  ON tools
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));

-- Only admins can update tools
CREATE POLICY "Only admins can update tools"
  ON tools
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));

-- Only admins can delete tools
CREATE POLICY "Only admins can delete tools"
  ON tools
  FOR DELETE
  TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));