import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_sdk/stellar_sdk.dart';

enum StellarNetwork { testnet, mainnet, futurenet }

enum ConnectionStatus { disconnected, connecting, connected }

class StellarAccountState {
  final String? address;
  final StellarNetwork network;
  final ConnectionStatus connectionStatus;
  final String? balance; // raw XLM balance as string

  const StellarAccountState({
    this.address,
    this.network = StellarNetwork.testnet,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.balance,
  });

  StellarAccountState copyWith({
    String? address,
    StellarNetwork? network,
    ConnectionStatus? connectionStatus,
    String? balance,
  }) {
    return StellarAccountState(
      address: address ?? this.address,
      network: network ?? this.network,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      balance: balance ?? this.balance,
    );
  }
}

class StellarAccountNotifier extends StateNotifier<StellarAccountState> {
  StellarAccountNotifier() : super(const StellarAccountState());

  /// Connects to a wallet address (called by Freighter flow).
  void connect({required String address}) {
    state = state.copyWith(
      address: address,
      connectionStatus: ConnectionStatus.connected,
    );
    // Fetch balance after connection
    fetchBalance();
  }

  void disconnect() {
    state = const StellarAccountState();
  }

  void switchNetwork(StellarNetwork network) {
    state = state.copyWith(network: network);
    // Optionally refresh balance for new network
    if (state.address != null) fetchBalance();
  }

  Future<void> fetchBalance() async {
    final addr = state.address;
    if (addr == null) return;
    state = state.copyWith(connectionStatus: ConnectionStatus.connecting);
    try {
      final server = Server(_horizonUrl(state.network));
      final account = await server.accounts.account(addr);
      final nativeBalance = account.balances.firstWhere((b) => b.assetType == 'native');
      state = state.copyWith(
        balance: nativeBalance.balance,
        connectionStatus: ConnectionStatus.connected,
      );
    } catch (e) {
      // On error, keep previous balance but mark as disconnected
      state = state.copyWith(connectionStatus: ConnectionStatus.disconnected);
    }
  }

  String _horizonUrl(StellarNetwork network) {
    switch (network) {
      case StellarNetwork.mainnet:
        return 'https://horizon.stellar.org';
      case StellarNetwork.futurenet:
        return 'https://horizon-futurenet.stellar.org';
      case StellarNetwork.testnet:
      default:
        return 'https://horizon-testnet.stellar.org';
    }
  }
}

// Provider declaration
final stellarAccountProvider = StateNotifierProvider<StellarAccountNotifier, StellarAccountState>((ref) {
  return StellarAccountNotifier();
});
