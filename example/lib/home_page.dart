import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';
import 'package:stellar_wallet_kit/src/services/transaction_builder.dart';

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
          children: [
            StellarConnectButton(),
            const SizedBox(height: 12),
            StellarAddressChip(),
            const SizedBox(height: 12),
            StellarBalanceDisplay(),
            const SizedBox(height: 12),
            StellarNetworkSwitcher(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.send),
        label: const Text('Pay (real)'),
        onPressed: () => _openPaySheet(context),
      ),
    );
  }

  void _openPaySheet(BuildContext context) async {
    // Show loading indicator while building transaction
    final navigator = Navigator.of(context);

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Build a real payment transaction
      // IMPORTANT: Replace these with your own testnet keys!
      const sourceSecret = 'S...'; // Replace with your testnet secret key
      const destinationAddress = 'G...'; // Replace with a testnet address
      const amount = '0.01'; // Send 0.01 XLM

      final transactionXdr = await TransactionBuilderService.buildPaymentTransaction(
        sourceSecret: sourceSecret,
        destinationAddress: destinationAddress,
        amount: amount,
        memoText: 'Demo payment from Stellar Wallet Kit',
        network: StellarNetwork.testnet,
      );

      // Close loading dialog
      navigator.pop();

      // Show the sign request sheet with real transaction
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => StellarSignRequestSheet(
          transactionXdr: transactionXdr,
          memo: 'Demo payment (${amount} XLM)',
        ),
      );
    } catch (e) {
      // Close loading dialog
      navigator.pop();

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to build transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
