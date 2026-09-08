import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';


/// A button that initiates connection to a Stellar wallet (Freighter or xBull).
/// Shows a wallet picker when not connected, otherwise displays a truncated address.
class StellarConnectButton extends ConsumerWidget {
  const StellarConnectButton({Key? key, this.style}) : super(key: key);

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stellarAccountProvider);
    final notifier = ref.read(stellarAccountProvider.notifier);
    final isConnected = state.connectionStatus == ConnectionStatus.connected && state.address != null;

    if (isConnected) {
      return ElevatedButton(
        style: style,
        onPressed: () => notifier.disconnect(),
        child: Text(_truncateAddress(state.address!)),
      );
    }

    return PopupMenuButton<String>(
      onSelected: (wallet) async {
        // Simulate a connection flow: In real usage, this would be triggered by
        // the wallet app via a deep link. Here we just prompt the user to enter
        // an address for demo purposes (since we cannot launch external apps in CI).
        // In production, you would construct a SEP‑0007 URL to request the user to
        // connect their wallet.
        final address = await _promptForAddress(context);
        if (address != null && address.isNotEmpty) {
          notifier.connect(address: address);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'freighter', child: Text('Freighter')),
        PopupMenuItem(value: 'xbull', child: Text('xBull')),
      ],
      child: ElevatedButton(
        style: style,
        onPressed: null,
        child: const Text('Connect Wallet'),
      ),
    );
  }

  Future<String?> _promptForAddress(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Enter Stellar address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'G...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(c).pop(controller.text), child: const Text('Connect')),
        ],
      ),
    );
  }

  String _truncateAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}…${address.substring(address.length - 4)}';
  }
}
