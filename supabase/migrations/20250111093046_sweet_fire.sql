/*
  # Add shared files metadata

  1. New Tables
    - `shared_files`
      - `id` (uuid, primary key)
      - `filename` (text) - Original filename
      - `storage_path` (text) - Path in Supabase storage
      - `title` (text) - User-provided title
      - `description` (text) - Brief description
      - `author_name` (text) - Creator's full name
      - `author_email` (text) - Creator's email
      - `created_at` (timestamptz)
      - `created_by` (uuid) - Reference to auth.users

  2. Security
    - Enable RLS
    - Add policies for reading and creating files
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