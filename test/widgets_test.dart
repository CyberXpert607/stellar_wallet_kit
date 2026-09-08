import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_wallet_kit/stellar_wallet_kit.dart';

void main() {
  group('StellarAddressChip', () {
    testWidgets('displays truncated address when provided', (tester) async {
      final container = ProviderContainer(overrides: [
        stellarAccountProvider.overrideWith((ref) {
          final notifier = StellarAccountNotifier();
          notifier.connect(address: 'GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWHF');
          return notifier;
        })
      ]);
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: Scaffold(body: StellarAddressChip())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('GAAAAA…WHF'), findsOneWidget);
    });
  });

  group('StellarBalanceDisplay', () {
    testWidgets('shows balance when available', (tester) async {
      final container = ProviderContainer(overrides: [
        stellarAccountProvider.overrideWith((ref) {
          final notifier = StellarAccountNotifier();
          // manually set state with balance
          notifier.state = notifier.state.copyWith(
            address: 'GTEST',
            balance: '100.0',
            connectionStatus: ConnectionStatus.connected,
          );
          return notifier;
        })
      ]);
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: Scaffold(body: StellarBalanceDisplay())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Balance: 100.0 XLM'), findsOneWidget);
    });
  });

  group('StellarNetworkSwitcher', () {
    testWidgets('shows dropdown with current network', (tester) async {
      final container = ProviderContainer(overrides: [
        stellarAccountProvider.overrideWith((ref) {
          final notifier = StellarAccountNotifier();
          notifier.state = notifier.state.copyWith(network: StellarNetwork.futurenet);
          return notifier;
        })
      ]);
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: Scaffold(body: StellarNetworkSwitcher())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Futurenet'), findsOneWidget);
    });
  });

  group('StellarConnectButton', () {
    testWidgets('shows Freighter and xBull options when disconnected', (tester) async {
      final container = ProviderContainer(overrides: [
        stellarAccountProvider.overrideWith((ref) => StellarAccountNotifier())
      ]);
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: Scaffold(body: StellarConnectButton())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Connect Wallet'), findsOneWidget);

      await tester.tap(find.text('Connect Wallet'));
      await tester.pumpAndSettle();

      expect(find.text('Freighter'), findsOneWidget);
      expect(find.text('xBull'), findsOneWidget);
    });
  });

  group('StellarSignRequestSheet', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StellarSignRequestSheet(
              transactionXdr: 'AAAABBBB',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sign Transaction'), findsOneWidget);
    });
  });
}
