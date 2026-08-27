import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

/// Displays a truncated Stellar address with copy‑to‑clipboard and QR code.
class StellarAddressChip extends ConsumerWidget {
  const StellarAddressChip({Key? key, this.style}) : super(key: key);

  final ChipThemeData? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(stellarAccountProvider.select((s) => s.address));
    if (address == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => _showQr(context, address),
      child: Chip(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        label: Text(_truncate(address)),
        avatar: const Icon(Icons.account_balance_wallet, size: 16),
        deleteIcon: const Icon(Icons.copy, size: 16),
        onDeleted: () => _copyToClipboard(context, address),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address copied to clipboard')),
    );
  }

  void _showQr(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Address QR'),
        content: QrImageView(data: address, size: 200),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  String _truncate(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}…${address.substring(address.length - 3)}';
  }
}
