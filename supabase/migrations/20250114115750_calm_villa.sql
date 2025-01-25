/*
  # Create paid tools system

  1. New Tables
    - `paid_tools`: Stores premium tools information
      - `id` (uuid, primary key)
      - `name` (text)
      - `description` (text)
      - `price` (integer, in cents)
      - `author_id` (uuid, references auth.users)
      - `storage_path` (text)
      - `created_at` (timestamptz)
    
    - `tool_purchases`: Tracks tool purchases
      - `id` (uuid, primary key)
      - `tool_id` (uuid, references paid_tools)
      - `user_id` (uuid, references auth.users)
      - `amount_paid` (integer, in cents)
      - `stripe_session_id` (text)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on both tables
    - Add policies for public reading of tools
    - Add policies for authenticated users to create/manage their tools
    - Add policies for purchase management
*/

-- Clean up any existing tables
DROP TABLE IF EXISTS tool_purchases CASCADE;
DROP TABLE IF EXISTS paid_tools CASCADE;

-- Create paid_tools table
CREATE TABLE paid_tools (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL CHECK (length(trim(name)) > 0),
    description text,
    price integer NOT NULL CHECK (price >= 0),
    author_id uuid REFERENCES auth.users(id) NOT NULL,
    storage_path text NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- Create tool_purchases table
CREATE TABLE tool_purchases (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id uuid REFERENCES paid_tools(id) ON DELETE CASCADE NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    amount_paid integer NOT NULL CHECK (amount_paid >= 0),
    stripe_session_id text,
    created_at timestamptz DEFAULT now(),
    UNIQUE(tool_id, user_id)
);

-- Enable Row Level Security
ALTER TABLE paid_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE tool_purchases ENABLE ROW LEVEL SECURITY;

-- Policies for paid_tools
CREATE POLICY "Anyone can view paid tools"
    ON paid_tools FOR SELECT
    USING (true);

CREATE POLICY "Authors can create tools"
    ON paid_tools FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Authors can update their tools"
    ON paid_tools FOR UPDATE
    TO authenticated
    USING (auth.uid() = author_id);

CREATE POLICY "Authors can delete their tools"
    ON paid_tools FOR DELETE
    TO authenticated
    USING (auth.uid() = author_id);

-- Policies for tool_purchases
CREATE POLICY "Users can view their purchases"
    ON tool_purchases FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create purchases"
    ON tool_purchases FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Indexes for better performance
CREATE INDEX idx_paid_tools_author ON paid_tools(author_id);
CREATE INDEX idx_paid_tools_created_at ON paid_tools(created_at DESC);
CREATE INDEX idx_tool_purchases_user ON tool_purchases(user_id);
CREATE INDEX idx_tool_purchases_tool ON tool_purchases(tool_id);

-- Comments
COMMENT ON TABLE paid_tools IS 'Premium tools available for purchase';
COMMENT ON TABLE tool_purchases IS 'Record of tool purchases by users';