# Crypto Wallet

I built this crypto wallet to experiment with real-time market data, custom iOS-style gestures, and complex state synchronization in Flutter. 

It hooks into the Coinbase WebSocket for live, low-latency price ticking, uses the CoinGecko API for historical charts, and relies on Cloud Firestore to sync user wallets and simulated peer-to-peer transfers across devices.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ff9859bb-03c8-4bec-8a1b-2a8b8b555b33" width="30%" alt="Screenshot 1" />
  <img src="https://github.com/user-attachments/assets/ba8856d3-df63-4079-892f-fe883dc34f14" width="30%" alt="Screenshot 2" />
  <img src="https://github.com/user-attachments/assets/f20fa20c-0b50-4b05-a4d4-ad05872d2bbc" width="30%" alt="Screenshot 3" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/4a8bad6c-ac15-4ca2-a4cb-2d3dbdeb01e5" width="30%" alt="Screenshot 4" />
  <img src="https://github.com/user-attachments/assets/db684f29-c458-4804-a343-21794481340e" width="30%" alt="Screenshot 5" />
</p>

## What's inside

- **Dual Market Data:** Streams live prices directly from the Coinbase WebSocket, falling back to the CoinGecko REST API for rich historical charts and sparklines.
- **Custom Slivers & UI:** Avoids default boxy Material layouts. Core screens are built entirely with `CustomScrollView` and Slivers to create collapsing, glassmorphic headers that items scroll natively underneath.
- **QR Transfers:** Uses `mobile_scanner` for on-device camera scanning, letting users scan addresses to send peer-to-peer transfers.
- **State & Sync:** Powered by Riverpod for state and dependency injection, with Freezed handling immutable domain entities. The UI stays perfectly synced with Firestore streams.
- **Atomic Transactions:** Uses Firestore atomic transactions under the hood to process simulated buys, sells, and transfers without race conditions.

## Under the Hood

### Custom Sliver Architecture
To get the UI feeling native and layered, I relied heavily on `SliverPersistentHeader` rather than standard AppBars. This allows elements to float, blur, and cast shadows dynamically as content scrolls under them.

```dart
// Example: Fluid collapsing headers using SliverPersistentHeader
return CustomScrollView(
  slivers: [
    SliverPersistentHeader(
      pinned: true,
      delegate: AssetSelectionHeaderDelegate(),
    ),
    SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        // ... dynamically applies border radii to group tiles
      ),
    ),
  ],
);
```

### Atomic Financial Logic
To prevent race conditions, the app leverages Firestore atomic transactions to process simulated buy, sell, and deposit flows securely.

```dart
// Example: Processing a secure transfer via Firestore Transaction
await _firestore.runTransaction((transaction) async {
  final senderBalanceRef = _balances(senderUid).doc(assetId);
  final receiverBalanceRef = _balances(receiverUid).doc(assetId);
  
  // Read both balances
  final senderDoc = await transaction.get(senderBalanceRef);
  final receiverDoc = await transaction.get(receiverBalanceRef);
  
  // Verify funds and atomically update both ledgers
  if (senderDoc.data()!['amount'] < transferAmount) throw InsufficientFundsException();
  
  transaction.update(senderBalanceRef, {'amount': FieldValue.increment(-transferAmount)});
  transaction.update(receiverBalanceRef, {'amount': FieldValue.increment(transferAmount)});
});
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.47+)
- Dart (3.13+)
- Firebase CLI (`firebase-tools`)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jerryfemi/crypto-wallet.git
   cd crypto-wallet
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   Ensure you have a Firebase project set up with Authentication and Firestore enabled.
   ```bash
   flutterfire configure
   ```

4. **Run Code Generation:**
   ```bash
   dart run build_runner build -d
   ```

5. **Run the App:**
   ```bash
   flutter run
   ```

---
*Disclaimer: This project is a realistic financial sandbox designed to demonstrate complex Flutter architecture, UI/UX design, and Firebase integration. While it uses real live market data, all wallets, funds, and transactions within the app are strictly simulated.*
