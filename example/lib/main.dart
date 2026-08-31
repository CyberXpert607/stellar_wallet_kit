import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

void main() {
  runApp(const ProviderScope(child: StellarWalletDemoApp()));
}

class StellarWalletDemoApp extends StatelessWidget {
  const StellarWalletDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stellar Wallet Kit Demo',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
