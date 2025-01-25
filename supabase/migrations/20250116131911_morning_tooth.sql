/*
  # Add membership system tables

  1. New Tables
    - `memberships` - Stores membership information
    - `membership_payments` - Tracks payment history
  
  2. Security
    - Enable RLS on new tables
    - Add policies for secure access
*/

-- Create memberships table
CREATE TABLE memberships (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) NOT NULL,
  status text NOT NULL CHECK (status IN ('active', 'expired', 'cancelled')),
  start_date timestamptz NOT NULL DEFAULT now(),
  end_date timestamptz NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

-- Create membership_payments table
CREATE TABLE membership_payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  membership_id uuid REFERENCES memberships(id) NOT NULL,
  amount integer NOT NULL CHECK (amount >= 0),
  currency text NOT NULL DEFAULT 'eur',
  stripe_session_id text,
  stripe_payment_intent_id text,
  status text NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_payments ENABLE ROW LEVEL SECURITY;

-- Policies for memberships
CREATE POLICY "Users can view own membership"
  ON memberships
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "System can create memberships"
  ON memberships
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "System can update memberships"
  ON memberships
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Policies for membership_payments
CREATE POLICY "Users can view own payments"
  ON membership_payments
  FOR SELECT
  TO authenticated
  USING (
    membership_id IN (
      SELECT id FROM memberships WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "System can create payments"
  ON membership_payments
  FOR INSERT
  TO authenticated
  WITH CHECK (
    membership_id IN (
      SELECT id FROM memberships WHERE user_id = auth.uid()
    )
  );

-- Indexes
CREATE INDEX idx_memberships_user_id ON memberships(user_id);
CREATE INDEX idx_memberships_status ON memberships(status);
CREATE INDEX idx_membership_payments_membership_id ON membership_payments(membership_id);
CREATE INDEX idx_membership_payments_status ON membership_payments(status);