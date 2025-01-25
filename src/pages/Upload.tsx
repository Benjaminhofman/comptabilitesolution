import React, { useState } from 'react';
import { Upload as UploadIcon } from 'lucide-react';
import { supabase } from '../lib/supabase';

const Upload = () => {
  const [dragActive, setDragActive] = useState(false);
  const [files, setFiles] = useState<File[]>([]);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const handleDrag = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.type === "dragenter" || e.type === "dragover") {
      setDragActive(true);
    } else if (e.type === "dragleave") {
      setDragActive(false);
    }
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setDragActive(false);
    
    const droppedFiles = Array.from(e.dataTransfer.files);
    setFiles(droppedFiles);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    e.preventDefault();
    if (e.target.files) {
      const uploadedFiles = Array.from(e.target.files);
      setFiles(uploadedFiles);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(false);
    setUploading(true);

    try {
      for (const file of files) {
        const { error: uploadError } = await supabase.storage
          .from('files')
          .upload(`${Date.now()}-${file.name}`, file);

        if (uploadError) {
          throw uploadError;
        }
      }
      
      setSuccess(true);
      setFiles([]);
    } catch (err) {
      setError('Erreur lors du téléchargement. Veuillez réessayer.');
      console.error('Upload error:', err);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <h2 className="text-2xl font-bold mb-6">Uploader vos fichiers</h2>
      
      <form onSubmit={handleSubmit} className="space-y-6">
        <div 
          className={`border-2 border-dashed rounded-lg p-8 text-center ${
            dragActive ? "border-blue-600 bg-blue-50" : "border-gray-300"
          }`}
          onDragEnter={handleDrag}
          onDragLeave={handleDrag}
          onDragOver={handleDrag}
          onDrop={handleDrop}
        >
          <UploadIcon className="mx-auto h-12 w-12 text-gray-400 mb-4" />
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Glissez-déposez vos fichiers ici ou
            <input
              type="file"
              multiple
              onChange={handleChange}
              className="hidden"
            />
            <span className="text-blue-600 hover:text-blue-700 ml-1 cursor-pointer">
              parcourez
            </span>
          </label>
          <p className="text-xs text-gray-500">
            Taille maximale: 100MB
          </p>
        </div>

        {files.length > 0 && (
          <div className="bg-white p-4 rounded-lg shadow">
            <h3 className="font-semibold mb-2">Fichiers sélectionnés:</h3>
            <ul className="space-y-2">
              {files.map((file, index) => (
                <li key={index} className="text-sm text-gray-600">
                  {file.name} ({(file.size / 1024 / 1024).toFixed(2)} MB)
                </li>
              ))}
            </ul>
          </div>
        )}

        {error && (
          <div className="bg-red-50 text-red-600 p-3 rounded">
            {error}
          </div>
        )}

        {success && (
          <div className="bg-green-50 text-green-600 p-3 rounded">
            Fichiers téléchargés avec succès !
          </div>
        )}

        <button
          type="submit"
          className="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors disabled:bg-blue-300"
          disabled={files.length === 0 || uploading}
        >
          {uploading ? 'Téléchargement en cours...' : 'Uploader'}
        </button>
      </form>
    </div>
  );
}

export default Upload;