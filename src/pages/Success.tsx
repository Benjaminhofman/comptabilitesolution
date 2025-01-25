import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { CheckCircle } from 'lucide-react';

const Success = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [countdown, setCountdown] = useState(5);

  useEffect(() => {
    const timer = setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          navigate('/tools');
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [navigate]);

  return (
    <div className="max-w-2xl mx-auto text-center py-16">
      <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-6" />
      <h1 className="text-3xl font-bold text-gray-900 mb-4">
        Paiement réussi !
      </h1>
      <p className="text-lg text-gray-600 mb-8">
        Merci pour votre adhésion. Vous avez maintenant accès à tous nos outils premium.
      </p>
      <p className="text-gray-500">
        Redirection automatique dans {countdown} secondes...
      </p>
    </div>
  );
};

export default Success;