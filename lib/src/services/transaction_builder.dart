import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

/// Builds a real Stellar payment transaction for the example app.
class TransactionBuilderService {
  /// Build a payment transaction from source account to destination.
  ///
  /// [sourceSecret] - Secret key of the source account (must be funded on testnet)
  /// [destinationAddress] - Public key of the destination account
  /// [amount] - Amount in XLM to send (e.g., "1.5")
  /// [memoText] - Optional memo text
  /// [network] - Stellar network (testnet/mainnet)
  ///
  /// Returns a signed transaction XDR as a base64 string.
  static Future<String> buildPaymentTransaction({
    required String sourceSecret,
    required String destinationAddress,
    required String amount,
    String? memoText,
    StellarNetwork network = StellarNetwork.testnet,
  }) async {
    // Create keypair from secret
    final sourceKeypair = Keypair.fromSecret(sourceSecret);
    final sourceAddress = sourceKeypair.accountId;

    // Get network passphrase
    final passphrase = _getNetworkPassphrase(network);

    // Create server instance (using Horizon testnet)
    final server = Server("https://horizon-testnet.stellar.org");

    // Load the source account
    final accountResponse = await server.accounts.account(sourceAddress);
    final sourceAccount = Account(
      accountResponse.accountId,
      int.parse(accountResponse.sequenceNumber),
    );

    // Build the payment operation
    final paymentOperation = PaymentOperationBuilder(
      destinationAddress,
      AssetTypeNative(),
      amount,
    ).build();

    // Build the transaction
    final transaction = TransactionBuilder(sourceAccount)
      ..addOperation(paymentOperation)
      ..setBaseFee(FeeBumpTransaction.BASE_FEE)
      ..setTimeout(30);

    // Add memo if provided
    if (memoText != null && memoText.isNotEmpty) {
      transaction.addMemo(MemoText(memoText));
    }

    // Build the transaction
    final builtTransaction = transaction.build();

    // Sign the transaction
    builtTransaction.sign(sourceKeypair);

    // Return the XDR as base64
    return builtTransaction.toEnvelopeXdrBase64();
  }

  static String _getNetworkPassphrase(StellarNetwork network) {
    switch (network) {
      case StellarNetwork.mainnet:
        return 'Public Global Stellar Network ; September 2015';
      case StellarNetwork.testnet:
        return 'Test SDF Network ; September 2015';
      case StellarNetwork.futurenet:
        return 'Future Stellar Network ; September 2025';
    }
  }
}

/// Stellar network enum (matches the one in the main package)
enum StellarNetwork {
  mainnet,
  testnet,
  futurenet,
}
