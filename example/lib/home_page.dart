import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stellar Wallet Kit Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            StellarConnectButton(),
            SizedBox(height: 12),
            StellarAddressChip(),
            SizedBox(height: 12),
            StellarBalanceDisplay(),
            SizedBox(height: 12),
            StellarNetworkSwitcher(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.send),
        label: const Text('Pay (dummy)') ,
        onPressed: () => _openPaySheet(context),
      ),
    );
  }

  void _openPaySheet(BuildContext context) {
    // Dummy transaction XDR – in a real app you would build a proper transaction.
    const dummyXdr = 'AAAAAgAAAAB...'; // truncated placeholder
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const StellarSignRequestSheet(
        transactionXdr: dummyXdr,
        memo: 'Demo payment',
      ),
    );
  }
}
