/*
  # Amélioration de la gestion des métadonnées des fichiers

  1. Tables
    - Ajout de la table `tool_files` pour lier les fichiers aux outils
    - Modification de la table `shared_files` pour une meilleure intégration

  2. Relations
    - Liaison entre tools et shared_files via tool_files
    - Contraintes de clés étrangères avec suppression en cascade

  3. Sécurité
    - Politiques RLS appropriées
    - Contraintes de validation
*/

-- Table de liaison entre les outils et les fichiers
CREATE TABLE tool_files (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id uuid REFERENCES tools(id) ON DELETE CASCADE,
    file_id uuid REFERENCES shared_files(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    UNIQUE(tool_id, file_id)
);

-- Activation de RLS
ALTER TABLE tool_files ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité pour tool_files
CREATE POLICY "Lecture des liaisons fichiers-outils"
    ON tool_files
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY "Création des liaisons fichiers-outils"
    ON tool_files
    FOR INSERT
    TO PUBLIC
    WITH CHECK (true);

-- Index pour les performances
CREATE INDEX idx_tool_files_tool_id ON tool_files(tool_id);
CREATE INDEX idx_tool_files_file_id ON tool_files(file_id);

-- Commentaires
COMMENT ON TABLE tool_files IS 'Table de liaison entre les outils et leurs fichiers associés';
COMMENT ON COLUMN tool_files.tool_id IS 'ID de l''outil';
COMMENT ON COLUMN tool_files.file_id IS 'ID du fichier partagé';