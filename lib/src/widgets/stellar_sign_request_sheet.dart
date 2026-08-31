import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';
import 'package:stellar_wallet_kit/lib/src/services/freighter_service.dart';

/// Bottom sheet that shows transaction details and triggers signing via Freighter.
class StellarSignRequestSheet extends ConsumerWidget {
  const StellarSignRequestSheet({
    Key? key,
    required this.transactionXdr,
    this.memo,
  }) : super(key: key);

  final String transactionXdr; // base64 XDR string
  final String? memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(stellarAccountProvider.select((s) => s.network));
    final service = FreighterService();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.payment),
            title: Text('Sign Transaction'),
          ),
          if (memo != null) ListTile(title: Text('Memo: $memo')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final url = service.buildSignUrl(
                xdr: transactionXdr,
                network: _networkString(network),
              );
              final launched = await service.launchSigning(signUrl: url);
              if (!launched) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch Freighter')),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Open Freighter to Sign'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _networkString(StellarNetwork net) {
    switch (net) {
      case StellarNetwork.mainnet:
        return 'Public';
      case StellarNetwork.testnet:
        return 'Testnet';
      case StellarNetwork.futurenet:
        return 'Futurenet';
    }
  }
}
