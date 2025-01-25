import { User } from '@supabase/supabase-js';

export const isAdmin = async (user: User | null): Promise<boolean> => {
  return false;
};