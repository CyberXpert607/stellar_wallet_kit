# stellar_wallet_kit

A Flutter package that provides a drop‑in wallet integration toolkit for Stellar dApps.

## Features
- Riverpod (`hooks_riverpod`) state management (`StellarAccountProvider`).
- Real Freighter wallet integration via SEP‑0007 deep‑link signing on testnet.
- Ready‑to‑use widgets:
  - `StellarConnectButton`
  - `StellarAddressChip`
  - `StellarBalanceDisplay`
  - `StellarNetworkSwitcher`
  - `StellarSignRequestSheet`
- Example app that demonstrates a full flow: **Connect → Balance → Sign/Pay**.
- CI workflow (GitHub Actions) that runs `flutter test` on every push/PR.

## Installation (local development)
Add a path dependency in your app's `pubspec.yaml`:
```yaml
dependencies:
  stellar_wallet_kit:
    path: ../stellar_wallet_kit
```
Then run:
```bash
flutter pub get
```

## Quick Start
```dart
import 'package:flutter/material.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Stellar Wallet Kit Demo',
        theme: ThemeData(useMaterial3: true),
        home: const HomePage(),
      );
}
```

## Example App Flow
The example app (`/example`) shows a simple **Pay** screen:
1. **Connect** – taps `StellarConnectButton` to open Freighter via SEP‑0007.
2. **Balance** – once connected, `StellarBalanceDisplay` shows the testnet balance.
3. **Pay** – a dummy transaction button opens `StellarSignRequestSheet` to sign a test payment.

## Roadmap
- Albedo wallet support
- xBull wallet support
- Handle network switch mid‑transaction
- Dark‑theme enhancements

---
*This README will be expanded with deeper usage documentation.*
