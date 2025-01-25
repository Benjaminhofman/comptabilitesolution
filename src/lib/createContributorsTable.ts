import { supabase } from './supabase';

export const createContributorsTable = async () => {
  const { error } = await supabase.rpc('create_contributors_table', {});
  
  if (error) {
    console.error('Error creating contributors table:', error);
    return false;
  }
  
  return true;
};