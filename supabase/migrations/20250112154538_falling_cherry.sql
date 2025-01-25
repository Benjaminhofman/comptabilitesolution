/*
  # Add contributors table

  1. New Tables
    - `contributors`
      - `id` (uuid, primary key)
      - `first_name` (text)
      - `last_name` (text)
      - `email` (text)
      - `tool_name` (text)
      - `tool_description` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `contributors` table
    - Add policies for public read access
    - Add policies for authenticated users to create/delete their own contributions
*/

CREATE TABLE contributors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL,
  tool_name text NOT NULL,
  tool_description text NOT NULL,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
);

ALTER TABLE contributors ENABLE ROW LEVEL SECURITY;

-- Tout le monde peut lire les contributeurs
CREATE POLICY "Lecture publique des contributeurs"
  ON contributors
  FOR SELECT
  USING (true);

-- Les utilisateurs authentifiés peuvent créer des contributions
CREATE POLICY "Création de contributions"
  ON contributors
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Les utilisateurs peuvent supprimer leurs propres contributions
CREATE POLICY "Suppression de ses propres contributions"
  ON contributors
  FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);