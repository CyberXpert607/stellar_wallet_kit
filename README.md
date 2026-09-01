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

## Known Limitations

- The **StellarSignRequestSheet** uses SEP‑0007 deep‑link URLs to launch the Freighter wallet. This approach works on mobile devices or desktop wallet apps that can handle the custom URL scheme, but it does **not** function in web browsers (e.g., Chrome) because browser extensions cannot intercept SEP‑0007 links. When running the example on the web, the sheet will show a "could not launch Freighter" message, which is expected.
- To test the full sign‑flow, run the example on a real mobile device or emulator with the Freighter (or compatible) wallet installed.


## Roadmap
- Albedo wallet support
- xBull wallet support
- Handle network switch mid‑transaction
- Dark‑theme enhancements

---
*This README will be expanded with deeper usage documentation.*
