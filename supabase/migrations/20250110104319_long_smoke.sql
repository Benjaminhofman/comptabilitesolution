/*
  # Ajout des commentaires pour les outils

  1. Nouvelles Tables
    - `tool_comments`
      - `id` (uuid, primary key)
      - `tool_id` (uuid, foreign key)
      - `user_id` (uuid, foreign key)
      - `content` (text)
      - `created_at` (timestamp)
      - `parent_id` (uuid, self-reference pour les réponses)

  2. Sécurité
    - Enable RLS sur `tool_comments`
    - Ajouter des politiques pour la lecture et l'écriture des commentaires
*/

CREATE TABLE IF NOT EXISTS tool_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tool_id uuid REFERENCES tools(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id),
  content text NOT NULL,
  created_at timestamptz DEFAULT now(),
  parent_id uuid REFERENCES tool_comments(id) ON DELETE CASCADE,
  CONSTRAINT valid_parent CHECK (parent_id != id)
);

ALTER TABLE tool_comments ENABLE ROW LEVEL SECURITY;

-- Tout le monde peut lire les commentaires
CREATE POLICY "Anyone can read comments"
  ON tool_comments
  FOR SELECT
  USING (true);

-- Les utilisateurs authentifiés peuvent créer des commentaires
CREATE POLICY "Authenticated users can create comments"
  ON tool_comments
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Les utilisateurs peuvent modifier leurs propres commentaires
CREATE POLICY "Users can update own comments"
  ON tool_comments
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Les utilisateurs peuvent supprimer leurs propres commentaires
CREATE POLICY "Users can delete own comments"
  ON tool_comments
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);