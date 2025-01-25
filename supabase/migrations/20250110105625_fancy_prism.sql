/*
  # Correction des tables et de l'authentification

  1. Modifications
    - Ajout de la table profiles si elle n'existe pas
    - Ajout d'un trigger pour créer automatiquement un profil à l'inscription
    - Correction des politiques de sécurité
    - Ajout de la table tool_comments si elle n'existe pas

  2. Sécurité
    - Mise à jour des politiques RLS
    - Ajout de politiques pour les commentaires
*/

-- Création de la table profiles si elle n'existe pas
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email text,
  role text DEFAULT 'user',
  created_at timestamptz DEFAULT now()
);

-- Activation de RLS sur profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Création du trigger pour créer automatiquement un profil
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Suppression du trigger s'il existe déjà
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Création du trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Politiques pour profiles
CREATE POLICY IF NOT EXISTS "Users can read own profile"
  ON profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY IF NOT EXISTS "Users can update own profile"
  ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Table des commentaires
CREATE TABLE IF NOT EXISTS tool_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tool_id uuid REFERENCES tools(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  content text NOT NULL,
  created_at timestamptz DEFAULT now(),
  parent_id uuid REFERENCES tool_comments(id) ON DELETE CASCADE,
  CONSTRAINT valid_parent CHECK (parent_id != id)
);

-- Activation de RLS sur tool_comments
ALTER TABLE tool_comments ENABLE ROW LEVEL SECURITY;

-- Politiques pour les commentaires
CREATE POLICY IF NOT EXISTS "Anyone can read comments"
  ON tool_comments
  FOR SELECT
  USING (true);

CREATE POLICY IF NOT EXISTS "Authenticated users can create comments"
  ON tool_comments
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "Users can update own comments"
  ON tool_comments
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own comments"
  ON tool_comments
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);