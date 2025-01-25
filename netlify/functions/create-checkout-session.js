const { Handler } = require('@netlify/functions');
const Stripe = require('stripe');

const stripe = new Stripe(process.env.VITE_STRIPE_SECRET_KEY, {
  apiVersion: '2023-10-16',
});

const SITE_URL = 'https://comptabilitesolution.netlify.app';

exports.handler = async (event) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
    'Content-Type': 'application/json',
  };

  if (event.httpMethod === 'GET') {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        message: 'La fonction est opérationnelle'
      })
    };
  }

  try {
    if (event.httpMethod !== 'POST') {
      return { statusCode: 405, headers, body: JSON.stringify({ error: true, message: 'Méthode non autorisée' }) };
    }

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price: process.env.VITE_STRIPE_PRICE_ID,
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: `${SITE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${SITE_URL}/`,
      allow_promotion_codes: true,
      locale: 'fr',
      billing_address_collection: 'required',
      customer_creation: 'always',
      payment_intent_data: {
        metadata: {
          product: 'Adhésion ComptabiliteSolution',
        },
      },
    });

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ id: session.id, url: session.url }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({
        error: true,
        message: error.message || 'Erreur serveur interne'
      }),
    };
  }
};