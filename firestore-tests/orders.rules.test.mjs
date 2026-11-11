// Security rules tests, run against the Firestore emulator:
//   firebase emulators:exec --only firestore --project demo-atelier "npm --prefix firestore-tests test"
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  addDoc,
  collection,
  doc,
  getDoc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-atelier',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
    },
  });
});

after(async () => {
  await env?.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
});

const db = (uid) =>
  uid ? env.authenticatedContext(uid).firestore() : env.unauthenticatedContext().firestore();

const order = (uid, overrides = {}) => ({
  userId: uid,
  createdAt: serverTimestamp(),
  status: 'processing',
  paymentMethodIndex: 0,
  lines: [{ productId: 'p1', name: 'Oak chair', quantity: 1, unitPrice: 120, lineTotal: 120 }],
  subtotal: 120,
  tax: 9.6,
  total: 129.6,
  shipping: { fullName: 'Test User', street: '1 Main St', city: 'Cairo', postal: '11511', phone: '0100' },
  ...overrides,
});

describe('orders', () => {
  it('a signed-in user can place a valid order for themselves', async () => {
    await assertSucceeds(addDoc(collection(db('alice'), 'orders'), order('alice')));
  });

  it('nobody can place an order while signed out', async () => {
    await assertFails(addDoc(collection(db(null), 'orders'), order('alice')));
  });

  it('a user cannot place an order for someone else', async () => {
    await assertFails(addDoc(collection(db('alice'), 'orders'), order('bob')));
  });

  it('rejects a total that does not equal subtotal + tax', async () => {
    await assertFails(addDoc(collection(db('alice'), 'orders'), order('alice', { total: 1 })));
  });

  it('rejects negative amounts', async () => {
    await assertFails(
      addDoc(collection(db('alice'), 'orders'), order('alice', { subtotal: -120, tax: 0, total: -120 })),
    );
  });

  it('rejects an order without lines', async () => {
    await assertFails(addDoc(collection(db('alice'), 'orders'), order('alice', { lines: [] })));
  });

  it('rejects a status other than processing', async () => {
    await assertFails(addDoc(collection(db('alice'), 'orders'), order('alice', { status: 'paid' })));
  });

  it('rejects a client-supplied creation time', async () => {
    await assertFails(
      addDoc(collection(db('alice'), 'orders'), order('alice', { createdAt: new Date('2020-01-01') })),
    );
  });

  it('users read only their own orders and cannot change them', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'orders/o1'), { ...order('alice'), createdAt: new Date() });
    });
    await assertSucceeds(getDoc(doc(db('alice'), 'orders/o1')));
    await assertFails(getDoc(doc(db('bob'), 'orders/o1')));
    await assertFails(updateDoc(doc(db('alice'), 'orders/o1'), { status: 'delivered' }));
  });
});

describe('catalog and profiles', () => {
  it('anyone can read products, nobody can edit them', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'products/p1'), { name: 'Oak chair', price: 120 });
    });
    await assertSucceeds(getDoc(doc(db(null), 'products/p1')));
    await assertFails(updateDoc(doc(db('alice'), 'products/p1'), { price: 1 }));
  });

  it('a profile is private to its owner', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice'), { name: 'Alice' }));
    await assertFails(getDoc(doc(db('bob'), 'users/alice')));
    await assertFails(setDoc(doc(db('bob'), 'users/alice'), { name: 'Mallory' }));
  });
});
