# AidChain Beneficiary

AidChain Beneficiary is the mobile client used by beneficiaries inside the AidChain ecosystem. It provides identity, wallet, transaction, campaign, and support-facing flows for end users receiving aid through the platform.

This repository is published as a clean portfolio snapshot. Project provenance is documented in [PROVENANCE.md](./PROVENANCE.md).

## What This App Does

- authenticates beneficiary users against the AidChain backend
- displays campaign and wallet-related views
- exposes transaction history and user account data
- supports QR and barcode-related flows
- integrates local authentication, storage, and device services
- includes support for geolocation, file/image capture, and account recovery flows

## Tech Stack

- Flutter
- Dart
- Provider
- Dio
- Shared Preferences
- JSON serialization
- Local auth plugins
- Barcode / QR scanning packages
- Device and location plugins

## Repository Layout

```text
lib/
  api/            API clients for auth, campaigns, transactions, complaints
  models/         beneficiary, campaign, wallet, and transaction models
  screens/        splash, auth, and beneficiary-facing screens
  services/       local storage, base service, auth, and user service logic
  providers/      provider-based state models
  widgets/        reusable widgets and dialogs
  utils/          UI helpers, validators, formatting, and shared utilities
```

## Important Features

- login and signup flows
- beneficiary profile and account data
- wallet and transaction views
- campaign participation flows
- QR or barcode-assisted workflows
- local-device integrations for biometrics and device information

## Prerequisites

- Flutter SDK compatible with Dart `>=2.16.2 <3.0.0`
- Android Studio and/or Xcode depending on target platform

## Installation

```bash
flutter pub get
```

## Run in Development

```bash
flutter run
```

## Build

Example Android release build:

```bash
flutter build appbundle --release --no-sound-null-safety
```

The project also defines a helper script entry in `pubspec.yaml` for bundle generation.

## Assets and Fonts

The app bundles custom fonts and image assets declared in `pubspec.yaml`, including Gilroy font families and branded login/application assets.

## Backend Dependency

This mobile app depends on `AidChainPlatform/aid-api` for authentication, campaigns, wallet data, and transaction flows.

## Notes

- The repo includes mobile assets, platform folders, and Flutter-specific configuration for Android and iOS.
- The published org repository is a clean snapshot without prior git history.
