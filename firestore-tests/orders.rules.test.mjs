import { readFileSync } from 'node:fs';
import { after, before, beforeEach, it } from 'node:test';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc, updateDoc, deleteDoc } from 'firebase/firestore';

let env;
before(async () => {
  env = await initializeTestEnvironment({ projectId: 'demo-atelier', firestore: {
    rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
  }});
});
after(async () => { await env?.cleanup(); });
beforeEach(async () => { await env.clearFirestore(); });
const db = uid => uid ? env.authenticatedContext(uid).firestore() : env.unauthenticatedContext().firestore();

it('even an internally consistent direct client order is rejected', async () => {
  await assertFails(setDoc(doc(db('alice'), 'orders/o1'), {
    userId: 'alice', status: 'processing', subtotal: 100, tax: 8, total: 108,
    lines: [{ productId: 'p1', quantity: 1, unitPrice: 100 }],
  }));
});
it('signed-out clients cannot create orders', async () => {
  await assertFails(setDoc(doc(db(null), 'orders/o1'), { userId: 'alice' }));
});
it('forged order ownership and prices cannot bypass the callable', async () => {
  await assertFails(setDoc(doc(db('alice'), 'orders/o1'), { userId: 'bob', total: 0, status: 'paid' }));
});
it('users can read their own server-created orders', async () => {
  await env.withSecurityRulesDisabled(async ctx => { await setDoc(doc(ctx.firestore(), 'orders/o1'), { userId: 'alice', total: 108 }); });
  await assertSucceeds(getDoc(doc(db('alice'), 'orders/o1')));
  await assertFails(getDoc(doc(db('bob'), 'orders/o1')));
  await assertFails(getDoc(doc(db(null), 'orders/o1')));
});
it('clients cannot update or delete server-created orders', async () => {
  await env.withSecurityRulesDisabled(async ctx => { await setDoc(doc(ctx.firestore(), 'orders/o1'), { userId: 'alice' }); });
  await assertFails(updateDoc(doc(db('alice'), 'orders/o1'), { status: 'paid' }));
  await assertFails(deleteDoc(doc(db('alice'), 'orders/o1')));
});
for (const collection of ['products', 'categories']) {
  it(collection + ' are publicly readable but cannot be created by shoppers', async () => {
    await env.withSecurityRulesDisabled(async ctx => { await setDoc(doc(ctx.firestore(), collection + '/p1'), { name: 'Demo' }); });
    await assertSucceeds(getDoc(doc(db(null), collection + '/p1')));
    await assertFails(setDoc(doc(db('alice'), collection + '/new'), { name: 'Injected' }));
  });
  it(collection + ' cannot be modified or deleted by shoppers', async () => {
    await env.withSecurityRulesDisabled(async ctx => { await setDoc(doc(ctx.firestore(), collection + '/p1'), { name: 'Demo' }); });
    await assertFails(updateDoc(doc(db('alice'), collection + '/p1'), { price: 0 }));
    await assertFails(deleteDoc(doc(db('alice'), collection + '/p1')));
  });
}
it('profiles are private to their owner', async () => {
  await assertSucceeds(setDoc(doc(db('alice'), 'users/alice'), { displayName: 'Alice' }));
  await assertFails(getDoc(doc(db('bob'), 'users/alice')));
  await assertFails(setDoc(doc(db('bob'), 'users/alice'), { displayName: 'Mallory' }));
});
it('clients cannot attach privileged role fields to profiles', async () => {
  await assertFails(setDoc(doc(db('alice'), 'users/alice'), { displayName: 'Alice', role: 'admin' }));
});
