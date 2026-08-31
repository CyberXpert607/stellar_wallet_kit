import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

/// Displays the current XLM balance for the connected address.
class StellarBalanceDisplay extends ConsumerWidget {
  const StellarBalanceDisplay({Key? key, this.textStyle}) : super(key: key);

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(stellarAccountProvider.select((s) => s.balance));
    final status = ref.watch(stellarAccountProvider.select((s) => s.connectionStatus));

    if (status == ConnectionStatus.connecting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (balance == null) {
      return const Text('Balance: –', style: TextStyle(fontSize: 16));
    }
    return Text('Balance: $balance XLM', style: textStyle ?? Theme.of(context).textTheme.bodyMedium);
  }
}
