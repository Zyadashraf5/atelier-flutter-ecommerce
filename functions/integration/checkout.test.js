'use strict';
const { before, beforeEach, after, it } = require('node:test');
const assert = require('node:assert/strict');
const { initializeApp, deleteApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getAuth } = require('firebase-admin/auth');
const { placeOrder, orderIdFor } = require('../checkout');

if (!process.env.FIRESTORE_EMULATOR_HOST || !process.env.GCLOUD_PROJECT?.startsWith('demo-')) {
  throw new Error('Tests require a demo project and Firestore emulator.');
}
const projectId = process.env.GCLOUD_PROJECT;
let app, db;
before(() => { app = initializeApp({ projectId }); db = getFirestore(app); });
after(async () => { await db.terminate(); await deleteApp(app); });
beforeEach(async () => {
  const response = await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/${projectId}/databases/(default)/documents`, { method: 'DELETE' });
  assert.equal(response.ok, true);
  await db.doc('products/p1').set({ name: 'Demo Chair', price: 100, stock: 5 });
});
const request = overrides => ({ requestId: 'demo-order-000001', lines: [{ productId: 'p1', quantity: 2 }], paymentMethodIndex: 0,
  shipping: { fullName: 'Demo', street: '1 Demo Street', city: 'Cairo', postal: '11511', phone: '01000000000' }, ...overrides });
const place = (uid, data) => placeOrder(db, uid, data, () => FieldValue.serverTimestamp());

it('uses catalog prices and atomically saves order and stock', async () => {
  const result = await place('alice', request({ total: 1, tax: 0, userId: 'bob' }));
  assert.equal(result.total, 216);
  assert.equal((await db.doc('products/p1').get()).data().stock, 3);
  const saved = (await db.doc('orders/' + result.orderId).get()).data();
  assert.equal(saved.userId, 'alice');
  assert.equal(saved.paymentStatus, 'unpaid');
  assert.deepEqual(result.shippingAddress, saved.shipping);
  assert.equal(result.shippingAddress.fullName, 'Demo');
  assert.ok(saved.createdAt);
});
it('a retry does not decrement stock twice', async () => {
  assert.deepEqual(await place('alice', request()), await place('alice', request()));
  assert.equal((await db.collection('orders').get()).size, 1);
  assert.equal((await db.doc('products/p1').get()).data().stock, 3);
});
it('rejects reuse of a retry key with a changed payload', async () => {
  await place('alice', request());
  await assert.rejects(place('alice', request({ paymentMethodIndex: 1 })), { code: 'already-exists' });
});
it('concurrent retries create only one order', async () => {
  const results = await Promise.all([place('alice', request()), place('alice', request())]);
  assert.equal(results[0].orderId, results[1].orderId);
  assert.equal((await db.collection('orders').get()).size, 1);
  assert.equal((await db.doc('products/p1').get()).data().stock, 3);
});
it('two shoppers cannot both buy the last unit', async () => {
  await db.doc('products/p1').update({ stock: 1 });
  const data = request({ lines: [{ productId: 'p1', quantity: 1 }] });
  const results = await Promise.allSettled([place('alice', data), place('bob', data)]);
  assert.equal(results.filter(r => r.status === 'fulfilled').length, 1);
  assert.equal(results.filter(r => r.status === 'rejected').length, 1);
  assert.equal((await db.doc('products/p1').get()).data().stock, 0);
  assert.equal((await db.collection('orders').get()).size, 1);
});
it('invalid stock leaves no partial order or inventory update', async () => {
  await assert.rejects(place('alice', request({ lines: [{ productId: 'p1', quantity: 6 }] })), { code: 'failed-precondition' });
  assert.equal((await db.doc('orders/' + orderIdFor('alice', 'demo-order-000001')).get()).exists, false);
  assert.equal((await db.doc('products/p1').get()).data().stock, 5);
});

it('the callable rejects unauthenticated HTTP requests', async () => {
  const response = await fetch(`http://127.0.0.1:5001/${projectId}/us-central1/placeOrder`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ data: request() }),
  });
  assert.equal(response.status, 401);
  assert.equal((await response.json()).error.status, 'UNAUTHENTICATED');
});

it('the callable verifies an Auth emulator session and returns server totals', async () => {
  const email = 'checkout-integration@example.com';
  const password = 'demo-only-password'; // gitleaks:allow -- emulator fixture
  let user;
  try { user = await getAuth(app).getUserByEmail(email); }
  catch (error) { if (error.code !== 'auth/user-not-found') throw error; }
  if (!user) user = await getAuth(app).createUser({ email, password });
  const login = await fetch(`http://${process.env.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=demo-key`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  assert.equal(login.ok, true);
  const { idToken } = await login.json();
  const response = await fetch(`http://127.0.0.1:5001/${projectId}/us-central1/placeOrder`, {
    method: 'POST', headers: { 'Content-Type': 'application/json', Authorization: 'Bearer ' + idToken },
    body: JSON.stringify({ data: request({ total: 0, userId: 'victim' }) }),
  });
  const body = await response.json();
  assert.equal(response.status, 200, JSON.stringify(body));
  assert.equal(body.result.total, 216);
  assert.equal((await db.doc('orders/' + body.result.orderId).get()).data().userId, user.uid);
});
