'use strict';
const { createHash } = require('node:crypto');

class CheckoutError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}
const fail = (code, message) => { throw new CheckoutError(code, message); };
const isObject = value => value !== null && typeof value === 'object' && !Array.isArray(value);

function normalizeRequest(data) {
  if (!isObject(data)) fail('invalid-argument', 'Invalid checkout request.');
  if (typeof data.requestId !== 'string' || !/^[A-Za-z0-9_-]{16,80}$/.test(data.requestId)) {
    fail('invalid-argument', 'A valid retry identifier is required.');
  }
  if (!Array.isArray(data.lines) || data.lines.length < 1 || data.lines.length > 20) {
    fail('invalid-argument', 'An order must contain between 1 and 20 lines.');
  }
  const lines = data.lines.map(line => {
    if (!isObject(line) || typeof line.productId !== 'string' ||
        !/^[A-Za-z0-9_-]{1,100}$/.test(line.productId) ||
        !Number.isSafeInteger(line.quantity) || line.quantity < 1 || line.quantity > 99) {
      fail('invalid-argument', 'Invalid product or quantity.');
    }
    if (line.variantLabel != null && (typeof line.variantLabel !== 'string' || line.variantLabel.length > 100)) {
      fail('invalid-argument', 'Invalid product variant.');
    }
    return { productId: line.productId, quantity: line.quantity, variantLabel: line.variantLabel || '' };
  });
  if (!Number.isInteger(data.paymentMethodIndex) || data.paymentMethodIndex < 0 || data.paymentMethodIndex > 2) {
    fail('invalid-argument', 'Invalid payment method.');
  }
  if (!isObject(data.shipping)) fail('invalid-argument', 'A shipping address is required.');
  const shipping = {};
  for (const key of ['fullName', 'street', 'city', 'postal', 'phone']) {
    const value = data.shipping[key];
    if (typeof value !== 'string' || !value.trim() || value.length > 300) {
      fail('invalid-argument', 'Complete the shipping address.');
    }
    shipping[key] = value.trim();
  }
  return { requestId: data.requestId, lines, shipping, paymentMethodIndex: data.paymentMethodIndex };
}

function priceOrder(request, catalog) {
  const quantities = new Map();
  for (const line of request.lines) {
    quantities.set(line.productId, (quantities.get(line.productId) || 0) + line.quantity);
  }
  for (const [id, quantity] of quantities) {
    const product = catalog.get(id);
    if (!product) fail('not-found', 'A product is no longer available.');
    if (!Number.isFinite(product.price) || product.price < 0 || product.price > 1_000_000 ||
        !Number.isSafeInteger(product.stock) || product.stock < 0) {
      fail('failed-precondition', 'A product requires administrator attention.');
    }
    if (quantity > 99 || quantity > product.stock) fail('failed-precondition', 'Not enough stock.');
  }
  let subtotalCents = 0;
  const lines = request.lines.map(line => {
    const product = catalog.get(line.productId);
    const unitCents = Math.round(product.price * 100);
    const lineCents = unitCents * line.quantity;
    subtotalCents += lineCents;
    return {
      productId: line.productId, name: String(product.name || '').slice(0, 300),
      subtitle: line.variantLabel || String(product.subtitle || '').slice(0, 300),
      imageUrl: String(product.imageUrl || '').slice(0, 2000),
      quantity: line.quantity, unitPrice: unitCents / 100, lineTotal: lineCents / 100,
    };
  });
  const taxCents = Math.round(subtotalCents * 8 / 100);
  return { lines, quantities, subtotal: subtotalCents / 100, tax: taxCents / 100, shippingAmount: 0, total: (subtotalCents + taxCents) / 100 };
}

function orderIdFor(uid, requestId) {
  return createHash('sha256').update(JSON.stringify([uid, requestId])).digest('hex');
}
function fingerprintFor(request) {
  return createHash('sha256').update(JSON.stringify(request)).digest('hex');
}
function orderResponse(orderId, order) {
  return { orderId, subtotal: order.subtotal, tax: order.tax, shipping: order.shippingAmount, total: order.total, lines: order.lines, shippingAddress: order.shipping };
}

async function placeOrder(db, uid, rawData, serverTimestamp) {
  if (!uid) fail('unauthenticated', 'Sign in to place an order.');
  const request = normalizeRequest(rawData);
  const orderId = orderIdFor(uid, request.requestId);
  const fingerprint = fingerprintFor(request);
  const orderRef = db.collection('orders').doc(orderId);
  return db.runTransaction(async transaction => {
    const previous = await transaction.get(orderRef);
    if (previous.exists) {
      const saved = previous.data();
      if (saved.userId !== uid || saved.requestFingerprint !== fingerprint) {
        fail('already-exists', 'This retry identifier was used for a different order.');
      }
      return orderResponse(orderId, saved);
    }
    const ids = [...new Set(request.lines.map(line => line.productId))];
    const refs = ids.map(id => db.collection('products').doc(id));
    const snapshots = await transaction.getAll(...refs);
    const catalog = new Map(snapshots.filter(snapshot => snapshot.exists).map(snapshot => [snapshot.id, snapshot.data()]));
    const priced = priceOrder(request, catalog);
    const order = {
      userId: uid, createdAt: serverTimestamp(), status: 'processing',
      paymentStatus: 'unpaid', paymentMethodIndex: request.paymentMethodIndex,
      shipping: request.shipping, lines: priced.lines,
      subtotal: priced.subtotal, tax: priced.tax, shippingAmount: priced.shippingAmount,
      total: priced.total, requestFingerprint: fingerprint,
    };
    for (const ref of refs) {
      transaction.update(ref, { stock: catalog.get(ref.id).stock - priced.quantities.get(ref.id) });
    }
    transaction.create(orderRef, order);
    return orderResponse(orderId, order);
  });
}

module.exports = { CheckoutError, normalizeRequest, priceOrder, orderIdFor, fingerprintFor, placeOrder };
