'use strict';
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { CheckoutError, placeOrder } = require('./checkout');

initializeApp();

exports.placeOrder = onCall({ region: 'us-central1', maxInstances: 10 }, async request => {
  try {
    return await placeOrder(getFirestore(), request.auth?.uid, request.data, () => FieldValue.serverTimestamp());
  } catch (error) {
    if (error instanceof CheckoutError) throw new HttpsError(error.code, error.message);
    console.error('Checkout transaction failed', { code: error.code || 'unknown' });
    throw new HttpsError('internal', 'Unable to place the order. Please retry.');
  }
});
