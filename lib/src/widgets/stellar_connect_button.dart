import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';
import 'package:stellar_wallet_kit/lib/src/services/freighter_service.dart';

/// A button that initiates connection to the Freighter wallet.
/// Shows "Connect" when not connected, otherwise displays a truncated address.
class StellarConnectButton extends ConsumerWidget {
  const StellarConnectButton({Key? key, this.style}) : super(key: key);

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stellarAccountProvider);
    final notifier = ref.read(stellarAccountProvider.notifier);
    final isConnected = state.connectionStatus == ConnectionStatus.connected && state.address != null;

    return ElevatedButton(
      style: style,
      onPressed: () async {
        if (!isConnected) {
          // Simulate a connection flow: In real usage, this would be triggered by
          // the Freighter app via a deep link. Here we just prompt the user to enter
          // an address for demo purposes (since we cannot launch external apps in CI).
          // In production, you would construct a SEP‑0007 URL to request the user to
          // connect their wallet.
          final address = await _promptForAddress(context);
          if (address != null && address.isNotEmpty) {
            notifier.connect(address: address);
          }
        } else {
          // Optional: disconnect on tap
          notifier.disconnect();
        }
      },
      child: isConnected
          ? Text(_truncateAddress(state.address!))
          : const Text('Connect Freighter'),
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
