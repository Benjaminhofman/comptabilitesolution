/*
  # Create profiles and tools tables

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key, references auth.users)
      - `role` (text, default 'user')
      - `created_at` (timestamp)
    - `tools`
      - `id` (uuid, primary key)
      - `name` (text)
      - `description` (text)
      - `category` (text)
      - `file_url` (text)
      - `created_at` (timestamp)
      - `created_by` (uuid, references profiles)

  2. Security
    - Enable RLS on both tables
    - Add policies for tools:
      - Anyone can read
      - Only admins can create/update/delete
    - Add policies for profiles:
      - Users can read their own profile
      - Only admins can update roles
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users,
  role text NOT NULL DEFAULT 'user',
  created_at timestamptz DEFAULT now()
);

-- Create tools table
CREATE TABLE IF NOT EXISTS tools (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  category text NOT NULL,
  file_url text,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES profiles(id)
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tools ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Only admins can update roles"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));

-- Tools policies
CREATE POLICY "Anyone can read tools"
  ON tools
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Only admins can insert tools"
  ON tools
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));

CREATE POLICY "Only admins can update tools"
  ON tools
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));

CREATE POLICY "Only admins can delete tools"
  ON tools
  FOR DELETE
  TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM profiles WHERE role = 'admin'
  ));