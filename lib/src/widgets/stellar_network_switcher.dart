import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

/// Allows the user to switch between Stellar networks.
class StellarNetworkSwitcher extends ConsumerWidget {
  const StellarNetworkSwitcher({Key? key, this.onChanged}) : super(key: key);

  final ValueChanged<StellarNetwork>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(stellarAccountProvider.select((s) => s.network));
    final notifier = ref.read(stellarAccountProvider.notifier);
    return DropdownButton<StellarNetwork>(
      value: network,
      onChanged: (value) {
        if (value != null) {
          notifier.switchNetwork(value);
          if (onChanged != null) onChanged!(value);
        }
      },
      items: StellarNetwork.values.map((net) {
        return DropdownMenuItem(
          value: net,
          child: Text(_label(net)),
        );
      }).toList(),
    );
  }

  String _label(StellarNetwork net) {
    switch (net) {
      case StellarNetwork.mainnet:
        return 'Mainnet';
      case StellarNetwork.testnet:
        return 'Testnet';
      case StellarNetwork.futurenet:
        return 'Futurenet';
    }
  }
}
