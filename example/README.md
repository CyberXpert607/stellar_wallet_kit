# Example App

This example demonstrates the full wallet flow using **stellar_wallet_kit**:

1. **Connect** – Tap the `StellarConnectButton` to enter a Stellar address (simulated connection).
2. **Balance** – The `StellarBalanceDisplay` shows the XLM balance fetched from Horizon.
3. **Network** – Switch between Testnet, Mainnet, and Futurenet with `StellarNetworkSwitcher`.
4. **Pay** – Press the floating action button to open a dummy payment sheet (`StellarSignRequestSheet`).

Run the example:
```bash
cd example
flutter run
```

The example uses Material‑3 theming and adapts automatically to the device's light/dark mode.
