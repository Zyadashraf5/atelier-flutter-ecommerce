'use strict';
// Public fixture credentials; this script refuses non-emulator destinations.
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore } = require('firebase-admin/firestore');

if (!process.env.FIRESTORE_EMULATOR_HOST || !process.env.FIREBASE_AUTH_EMULATOR_HOST || !process.env.GCLOUD_PROJECT?.startsWith('demo-')) {
  throw new Error('Demo seeding requires a demo project and local Auth/Firestore emulators.');
}
for (const host of [process.env.FIRESTORE_EMULATOR_HOST, process.env.FIREBASE_AUTH_EMULATOR_HOST]) {
  if (!/^(127\.0\.0\.1|localhost):\d+$/.test(host)) throw new Error('Only loopback emulators are allowed.');
}
initializeApp({ projectId: process.env.GCLOUD_PROJECT });
const db = getFirestore();
const photos = {
  chair: 'photo-1586023492125-27b2c045efd7', vase: 'photo-1578662996442-48f60103fc96',
  lamp: 'photo-1507473885765-e6ed057f782c', pillow: 'photo-1556228453-efd6c1ff04f6',
  ceramic: 'photo-1558618666-fcd25c85cd64', bowl: 'photo-1560769629-975ec94e6a86',
  shoe: 'photo-1549298916-b41d501d3772',
};
const image = photo => `https://images.unsplash.com/${photos[photo]}?auto=format&fit=crop&w=1000&q=80`;

async function seed() {
  await db.recursiveDelete(db.collection('products'));
  const batch = db.batch();
  for (const [index, [id, name]] of [['furniture', 'Furniture'], ['textiles', 'Textiles'], ['lighting', 'Lighting'], ['ceramics', 'Art & Objects']].entries()) {
    batch.set(db.doc('categories/' + id), { name, sortOrder: index + 1 });
  }
  const products = [
    ['p1', 'Amber Lounge Chair', 'A bright corner for slow mornings', 840, 'furniture', 'chair'],
    ['p2', 'Basalt Wall Print', 'Monochrome texture study', 125, 'ceramics', 'vase'],
    ['p4', 'Fjord Lounge Set', 'Natural textures and soft seating', 680, 'textiles', 'pillow'],
    ['p3', 'Orbital Desk Lamp', 'Focused light for your workspace', 310, 'lighting', 'lamp'],
  ];
  for (const [id, name, subtitle, price, categoryId, photo] of products) {
    batch.set(db.doc('products/' + id), { name, subtitle, description: 'Generated demo catalog item for the local Atelier showroom.', price, categoryId, stock: 20, isLimited: id === 'nomad', imageUrl: image(photo), imageUrls: [image(photo)] });
  }
  await batch.commit();
  const email = 'demo@example.com';
  const password = 'demo-only-password'; // gitleaks:allow -- public emulator-only fixture
  let user;
  try { user = await getAuth().getUserByEmail(email); }
  catch (error) { if (error.code !== 'auth/user-not-found') throw error; }
  if (!user) user = await getAuth().createUser({ email, password, displayName: 'Demo Visitor' });
  await db.doc('users/' + user.uid).set({ email, displayName: 'Demo Visitor' });
  console.log('Local demo ready: demo@example.com / demo-only-password. No production data was used.');
}
seed().then(() => process.exit(0)).catch(error => { console.error(error.message); process.exit(1); });
