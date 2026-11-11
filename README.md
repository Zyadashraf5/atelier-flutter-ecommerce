# Atelier: Flutter e-commerce app with Firebase

[![CI](https://github.com/Zyadashraf5/atelier-flutter-ecommerce/actions/workflows/ci.yml/badge.svg)](https://github.com/Zyadashraf5/atelier-flutter-ecommerce/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.35%2B-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?logo=firebase&logoColor=black)

A shopping app for a small home-decor store: browse a live catalog, search, add pieces to a cart and place an order that is saved to Cloud Firestore. Built with Flutter, GetX and Firebase, with Firestore security rules that are tested against the emulator in CI.

**Portfolio demo:** this is not a production payment or order-processing system. Catalog creation is open to signed-in users for demo seeding, and order prices still require authoritative server-side validation.

## What the app does

| Screen | Behaviour |
|---|---|
| Sign up / sign in | Email and password with Firebase Auth. A profile document is written to `users/{uid}` and the session is cached locally. |
| Home | Live catalog from Firestore (real-time listeners), filtered by category, with quick add-to-cart. |
| Search | Free-text search plus category chips and trending terms. |
| Product detail | Image gallery, variants and stock state; out-of-stock pieces cannot be added. |
| Cart | Lines merge by product and variant; quantities can be changed or removed. |
| Checkout | Shipping address and payment method selection, then the order is written to Firestore. |
| Order confirmation | Shows the saved order id and the exact amounts that were stored. |
| Profile | Account details and sign-out. |

On first sign-in, if the catalog is empty, the app seeds demo categories and products so a fresh Firebase project works immediately. Layouts adapt to phone, tablet and desktop widths (`lib/core/responsive`).

## How it is built

```
lib/
├── core/        bindings (DI), constants, pricing rules, responsive helpers, session storage, theme
├── data/        models (product, category, cart line) and Firebase repositories (auth, orders, profiles)
├── features/    one folder per screen: binding + controller + view + widgets
└── routes/      GetX routes
```

- **Feature-first GetX.** Each screen gets its own binding and controller; the cart is a permanent shared controller.
- **Repositories wrap Firebase.** `AuthRepository`, `OrderRepository` and `UserProfileRepository` accept injected `FirebaseAuth` / `FirebaseFirestore` instances so they can be replaced in tests.
- **One pricing rule set.** `OrderPricing` (`lib/core/pricing`) owns the tax rate, shipping and rounding to the cent. The cart, the checkout screen and the saved order all use it, so the amounts a customer sees are the amounts stored.
- **Server-side checks in Firestore rules.** A new order must belong to the signed-in user, start as `processing`, contain at least one line, use the server timestamp and have `total = subtotal + tax` with non-negative amounts. Users can read only their own orders and profiles. Existing catalog documents cannot be updated or deleted by the app, but any signed-in user can create new ones for demo seeding.

## Tech stack

Flutter · Dart 3.9 · GetX · Firebase Auth · Cloud Firestore · shared_preferences · google_fonts · Node test runner + `@firebase/rules-unit-testing` · GitHub Actions

## Getting started

Requirements: Flutter 3.35 or newer and a Firebase project with Email/Password sign-in and Cloud Firestore enabled.

```bash
git clone https://github.com/Zyadashraf5/atelier-flutter-ecommerce.git
cd atelier-flutter-ecommerce
flutter pub get
```

### Firebase setup

1. Register the Android, iOS and/or Web apps in your Firebase project.
2. Enable **Email/Password** under Firebase Authentication → Sign-in method.
3. Copy `firebase.env.example.json` to `firebase.env.json` (ignored by git) and fill in the values from the Firebase console.
4. Android only: put your `google-services.json` in `android/app/` (ignored by git). The Google Services Gradle plugin is applied only when that file exists.
5. Deploy the rules: `firebase deploy --only firestore:rules --project <your-project-id>`.

### Run

```bash
flutter run --dart-define-from-file=firebase.env.json
```

## Tests and CI

```bash
flutter test                                   # Dart unit & widget tests

# Firestore rules (needs Node 20+ and Java 21)
npm --prefix firestore-tests install
firestore-tests/node_modules/.bin/firebase emulators:exec --only firestore --project demo-atelier "npm --prefix firestore-tests test"
```

| Suite | What it covers |
|---|---|
| `test/cart_and_pricing_test.dart` | Cart line merging, quantity rules, out-of-range indexes, tax/shipping/total rounding |
| `test/widget_test.dart` | App starts on the splash screen with mocked Firebase |
| `firestore-tests/orders.rules.test.mjs` | Order ownership, totals, status, empty orders, server timestamps, read isolation; read-only catalog; private profiles |

GitHub Actions runs `flutter analyze`, `flutter test` and the rules tests (Firestore emulator) on every push and pull request.

## Known limitations

- **No real payments.** Checkout records the chosen payment method; no payment provider is integrated.
- **Prices come from the client.** The rules check that the totals are consistent, but not that each line's price matches the catalog. A Cloud Function that recalculates the order on the server is the production fix.
- **Demo catalog seeding.** Any signed-in user may create (not edit) categories and products so a new project can seed itself; this should be restricted to admins in production.
- Social sign-in buttons and some profile menu entries are placeholders.
- Product photos are loaded from Unsplash URLs.

## Author

**Zyad Ashraf**, Flutter developer · [LinkedIn](https://www.linkedin.com/in/zyad-ashraf-flutter) · [Upwork](https://www.upwork.com/freelancers/~01f783ee63786311ea)
