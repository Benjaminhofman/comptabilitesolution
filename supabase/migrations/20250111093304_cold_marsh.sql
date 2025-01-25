/*
  # Création de la table des fichiers partagés

  1. Nouvelle Table
    - `shared_files`
      - `id` (uuid, clé primaire)
      - `filename` (text, nom du fichier original)
      - `storage_path` (text, chemin dans le stockage)
      - `title` (text, titre d'affichage)
      - `description` (text, optionnel)
      - `author_name` (text, nom de l'auteur)
      - `author_email` (text, email de l'auteur)
      - `created_at` (timestamp, date de création)
      - `created_by` (uuid, référence vers auth.users)

  2. Sécurité
    - Activation de RLS sur la table `shared_files`
    - Politique de lecture publique
    - Politique de création pour les utilisateurs authentifiés
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

-- Tout le monde peut lire les fichiers partagés
CREATE POLICY "Lecture publique des fichiers partagés"
  ON shared_files
  FOR SELECT
  USING (true);

-- Les utilisateurs authentifiés peuvent créer des fichiers
CREATE POLICY "Création de fichiers par utilisateurs authentifiés"
  ON shared_files
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);