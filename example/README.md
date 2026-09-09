# Stellar Wallet Kit Example

This example app demonstrates how to use the `stellar_wallet_kit` package.

## Features

- Connect to Freighter wallet
- Display connected address and balance
- Switch between networks
- Send real testnet payments

## Setup

1. Create a testnet account and fund it:
   - Get a secret key from https://stellar.org/laboratory
   - Fund it using Friendbot: https://friendbot.stellar.org/?addr=YOUR_PUBLIC_KEY

2. Update the secret key and destination address in `home_page.dart`:

   ```dart
   const sourceSecret = 'S...'; // Your testnet secret key
   const destinationAddress = 'G...'; // Destination address
   const amount = '0.01';
   ```

3. Run the app:
	``` flutter run ```

## How It Works
	1. Tap the "Pay (real)" button
	2. The app builds a real Stellar payment transaction using stellar_flutter_sdk
	3. A bottom sheet shows the transaction details
	4. Tap "Open Freighter to Sign" to sign with Freighter
	5. The transaction is submitted to the testnet

## Requirements
	Freighter wallet extension installed
	Testnet account with funds
	Internet connection