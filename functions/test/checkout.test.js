'use strict';
const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const { normalizeRequest, priceOrder, orderIdFor, fingerprintFor, placeOrder } = require('../checkout');

const valid = overrides => ({
  requestId: 'demo-request-000001', lines: [{ productId: 'p1', quantity: 2 }],
  shipping: { fullName: 'Demo User', street: '1 Demo St', city: 'Cairo', postal: '11511', phone: '01000000000' },
  paymentMethodIndex: 0, ...overrides,
});
const catalog = stock => new Map([['p1', { name: 'Chair', price: 19.95, stock, imageUrl: '' }]]);

describe('trusted checkout validation', () => {
  it('ignores client-supplied prices, totals, user ids and status', () => {
    const request = normalizeRequest(valid({ total: 0, userId: 'victim', status: 'paid', lines: [{ productId: 'p1', quantity: 2, unitPrice: 0 }] }));
    const result = priceOrder(request, catalog(10));
    assert.equal(result.subtotal, 39.9);
    assert.equal(result.tax, 3.19);
    assert.equal(result.total, 43.09);
    assert.equal(result.lines[0].unitPrice, 19.95);
    assert.equal(request.userId, undefined);
  });
  it('aggregates stock demand across variants of the same product', () => {
    const request = normalizeRequest(valid({ lines: [{ productId: 'p1', quantity: 2, variantLabel: 'A' }, { productId: 'p1', quantity: 2, variantLabel: 'B' }] }));
    assert.throws(() => priceOrder(request, catalog(3)), /Not enough stock/);
    assert.equal(priceOrder(request, catalog(4)).quantities.get('p1'), 4);
  });
  for (const quantity of [0, -1, 1.5, 100, NaN, Infinity, '2']) {
    it('rejects invalid quantity ' + String(quantity), () => {
      assert.throws(() => normalizeRequest(valid({ lines: [{ productId: 'p1', quantity }] })));
    });
  }
  it('rejects empty and oversized orders', () => {
    assert.throws(() => normalizeRequest(valid({ lines: [] })));
    assert.throws(() => normalizeRequest(valid({ lines: Array(21).fill({ productId: 'p1', quantity: 1 }) })));
  });
  it('rejects malformed product ids and shipping addresses', () => {
    assert.throws(() => normalizeRequest(valid({ lines: [{ productId: '../orders', quantity: 1 }] })));
    assert.throws(() => normalizeRequest(valid({ shipping: { fullName: '   ' } })));
  });
  it('rejects invalid payment and retry identifiers', () => {
    assert.throws(() => normalizeRequest(valid({ paymentMethodIndex: 9 })));
    assert.throws(() => normalizeRequest(valid({ requestId: 'short' })));
  });
  it('rejects missing products and invalid catalog prices', () => {
    const request = normalizeRequest(valid());
    assert.throws(() => priceOrder(request, new Map()), /no longer available/);
    for (const price of [-1, NaN, Infinity]) {
      assert.throws(() => priceOrder(request, new Map([['p1', { price, stock: 9 }]])));
    }
  });
  it('uses stable user-scoped order ids and payload fingerprints', () => {
    assert.equal(orderIdFor('alice', 'key'), orderIdFor('alice', 'key'));
    assert.notEqual(orderIdFor('alice', 'key'), orderIdFor('bob', 'key'));
    assert.notEqual(fingerprintFor(normalizeRequest(valid())), fingerprintFor(normalizeRequest(valid({ paymentMethodIndex: 1 }))));
  });
  it('requires authentication before accessing the database', async () => {
    await assert.rejects(placeOrder(null, null, valid(), () => null), { code: 'unauthenticated' });
  });
});
