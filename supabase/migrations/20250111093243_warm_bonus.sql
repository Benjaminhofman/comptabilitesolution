/*
  # Create shared files table

  1. New Tables
    - `shared_files`
      - `id` (uuid, primary key)
      - `filename` (text, original filename)
      - `storage_path` (text, path in storage bucket)
      - `title` (text, display title)
      - `description` (text, optional)
      - `author_name` (text)
      - `author_email` (text)
      - `created_at` (timestamp)
      - `created_by` (uuid, references auth.users)

  2. Security
    - Enable RLS on `shared_files` table
    - Add policy for public read access
    - Add policy for authenticated users to create files
*/

CREATE TABLE IF NOT EXISTS shared_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  filename text NOT NULL,
  storage_path text NOT NULL,
  title text NOT NULL,
  description text,
  author_name text NOT NULL,
  author_email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
);

ALTER TABLE shared_files ENABLE ROW LEVEL SECURITY;

-- Anyone can read shared files
CREATE POLICY "Anyone can read shared files"
  ON shared_files
  FOR SELECT
  USING (true);

-- Authenticated users can create shared files
CREATE POLICY "Users can create shared files"
  ON shared_files
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);