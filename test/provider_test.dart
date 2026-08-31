import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

void main() {
  test('Initial state is disconnected with testnet', () {
    final container = ProviderContainer();
    final state = container.read(stellarAccountProvider);
    expect(state.connectionStatus, ConnectionStatus.disconnected);
    expect(state.network, StellarNetwork.testnet);
    expect(state.address, isNull);
    expect(state.balance, isNull);
  });

  test('Connect updates address and status', () async {
    final container = ProviderContainer();
    final notifier = container.read(stellarAccountProvider.notifier);
    notifier.connect(address: 'GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWHF');
    final state = container.read(stellarAccountProvider);
    expect(state.address, isNotNull);
    expect(state.connectionStatus, ConnectionStatus.connected);
    // Balance will be fetched asynchronously; we allow null here
  });
}
