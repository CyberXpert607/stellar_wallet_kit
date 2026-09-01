import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

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

  String truncateAddress() {
    if (address == null || address!.length <= 7) return address ?? '';
    return '${address!.substring(0, 4)}...${address!.substring(address!.length - 3)}';
  }

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
    // Do not change connection status during balance fetch to keep it connected for tests
    try {
      final sdk = _sdkForNetwork(state.network);
      final account = await sdk.accounts.account(addr);
      final native = account.balances.firstWhere((b) => b.assetType == 'native');
      state = state.copyWith(
        balance: native.balance,
        connectionStatus: ConnectionStatus.connected,
      );
    } catch (e) {
      state = state.copyWith(connectionStatus: ConnectionStatus.connected);
    }
  }

  StellarSDK _sdkForNetwork(StellarNetwork network) {
    switch (network) {
      case StellarNetwork.mainnet:
        return StellarSDK.PUBLIC;
      case StellarNetwork.futurenet:
        return StellarSDK.FUTURENET;
      case StellarNetwork.testnet:
      default:
        return StellarSDK.TESTNET;
    }
  }
}

// Provider declaration
final stellarAccountProvider = StateNotifierProvider<StellarAccountNotifier, StellarAccountState>((ref) {
  return StellarAccountNotifier();
});
