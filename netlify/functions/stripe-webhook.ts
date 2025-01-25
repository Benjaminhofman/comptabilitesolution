import { Handler } from '@netlify/functions';
import Stripe from 'stripe';
import { createClient } from '@supabase/supabase-js';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
});

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export const handler: Handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const sig = event.headers['stripe-signature']!;
  let stripeEvent;

  try {
    stripeEvent = stripe.webhooks.constructEvent(
      event.body!,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch (err) {
    return { statusCode: 400, body: `Webhook Error: ${err.message}` };
  }

  if (stripeEvent.type === 'checkout.session.completed') {
    const session = stripeEvent.data.object as Stripe.Checkout.Session;
    const userId = session.metadata?.userId;

    if (!userId) {
      return { statusCode: 400, body: 'Missing userId in session metadata' };
    }

    // Calculate membership end date (1 year from now)
    const endDate = new Date();
    endDate.setFullYear(endDate.getFullYear() + 1);

    // Create membership
    const { data: membership, error: membershipError } = await supabase
      .from('memberships')
      .insert([
        {
          user_id: userId,
          status: 'active',
          end_date: endDate.toISOString(),
        },
      ])
      .select()
      .single();

    if (membershipError) {
      console.error('Error creating membership:', membershipError);
      return { statusCode: 500, body: 'Error creating membership' };
    }

    // Record payment
    const { error: paymentError } = await supabase
      .from('membership_payments')
      .insert([
        {
          membership_id: membership.id,
          amount: session.amount_total,
          currency: session.currency,
          stripe_session_id: session.id,
          stripe_payment_intent_id: session.payment_intent as string,
          status: 'completed',
        },
      ]);

    if (paymentError) {
      console.error('Error recording payment:', paymentError);
      return { statusCode: 500, body: 'Error recording payment' };
    }
  }

  return { statusCode: 200, body: JSON.stringify({ received: true }) };
};