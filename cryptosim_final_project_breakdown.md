# CryptoSim — Project Specification & Build Reference

## 0. Project Evolution & Current State

*This section summarizes the real-world architectural pivots and UI changes we have made beyond the initial specification.*

### UI & Architecture Pivot (iOS-first feel)
We have intentionally moved away from the default boxy/elevated Material 3 aesthetics in favor of a sleek, iOS-inspired layered design.
- **Sliver Architecture:** The core screens (Home, Markets, Wallet, Activity) have been completely refactored to use `CustomScrollView` with `SliverAppBar.medium` or `.large`. This gives a premium collapsing-title effect when scrolling.
- **Global Theme Overhaul:** We configured a global `AppBarTheme` where `backgroundColor` is `scaffoldBackgroundColor` (rendering it invisible when unscrolled) and the `surfaceTintColor` is specifically mapped to the dark `surfaceContainer`. When the user scrolls, the app bar gracefully cross-fades into a deep, native gray rather than the default Material bluish-purple tint.
- **Pinned Headers:** Search bars and filter chips (like on the Markets and Activity screens) are implemented using `SliverPersistentHeader`, allowing them to snap elegantly to the top of the screen right below the collapsed App Bar.
- **Bottom Sheets:** We use `StupidSimpleCupertinoSheetRoute` globally for Buy/Sell/Deposit flows and Success/Error alerts. We increased the initial snapping config from `0.5` to `0.6` to ensure buttons aren't cut off on smaller devices (like the iPhone 8).

### Market Data Strategy (Coinbase + CoinGecko)
We employ a dual-provider strategy for cryptocurrency data:
- **Coinbase WebSocket:** Used exclusively for the live ticker feed (`wss://ws-feed.exchange.coinbase.com`). *Why?* It provides ultra-low latency, real-time price updates for our top movers without strict unauthenticated rate limits. *(Note: Users on specific cellular networks like MTN Nigeria may experience blockages on this WebSocket port, requiring a future fallback).*
- **CoinGecko REST API:** Used for historical chart data and deep market metadata. *Why?* CoinGecko provides rich sparklines, market caps, and historical price matrices that Coinbase does not easily expose to unauthenticated clients.

### Auth Enhancements
- Fixed Firebase Auth race conditions where `displayName` was not being updated correctly on sign-up. The `firebase_auth_repository` now explicitly awaits `user.updateDisplayName()` upon registration.

---

## 1. Project Definition

CryptoSim is a realistic simulated cryptocurrency exchange and wallet application built with Flutter and Firebase.

The application behaves like a real crypto product from the user's perspective:

- Live cryptocurrency market prices and charts
- User accounts and authentication
- Virtual wallets with generated addresses
- QR codes for receiving payments
- QR scanning for sending payments
- Buy and sell flows with fees
- User-to-user crypto transfers
- Transaction states, hashes, and history
- Cross-device synchronization via Firestore

The only fundamentally fake part is the underlying money and assets: all balances are virtual/simulated. This application does not perform real cryptocurrency settlement or move real funds on a blockchain.

### Core Principle

The application should feel real without pretending that simulated transactions are real blockchain transactions.

**Real:**

- Market data, price charts, market changes
- HTTP/API communication
- Authentication infrastructure
- QR generation and scanning
- Cross-device data synchronization
- Wallet and address UX

**Simulated:**

- USD/USDT and cryptocurrency balances
- Buys, sells, deposits, withdrawals
- Internal transfers
- Transaction hashes
- Network fees
- Transaction processing and confirmation

Transaction hashes and wallet addresses are application-level identifiers unless the project is later extended to an actual blockchain testnet.

---

## 2. Technology Stack

### Framework

- Flutter 3.47+ (stable channel)
- Dart 3.13+
- Material 3 theming (default)

### State Management

- `flutter_riverpod` — core state management
- `riverpod_annotation` — `@riverpod` annotation support
- `riverpod_generator` — code generation for providers

### Routing

- `go_router` — declarative routing with ShellRoute for tabbed navigation

### Firebase

- `firebase_core` — Firebase initialization
- `firebase_auth` — authentication (email/password, auth state)
- `cloud_firestore` — real-time database for wallets, balances, transactions

Firebase Cloud Functions are a later-phase hardening step, not a blocker. Firebase Storage is only needed if profile images or uploaded media are added.

### HTTP Client

- `dio` — HTTP client for CoinGecko API calls, with manual service classes

### Models & Code Generation

- `freezed` — immutable data classes with union types
- `json_serializable` — JSON serialization/deserialization
- `build_runner` — code generation runner

### External Market Data

- CoinGecko API (free tier) for prices, charts, market stats, and asset metadata

### QR

- `qr_flutter` — QR code generation
- `mobile_scanner` — camera-based QR code scanning

### Charts

- `fl_chart` — line charts (smooth curved lines, gradient fills, touch tooltips, sparklines)

### Theming

- `flex_color_scheme` — Material 3 theme generation with fine-tuned surface blends and dark mode

### Bottom Sheets

- `stupid_simple_sheet` — sheet widget that opens and smoothly expands to full screen

### Motion & Animation

- `motor` — unified motion system with physics-based springs (CupertinoMotion, MaterialSpringMotion) and duration-based curves under one API

### Loading States

- `skeletonizer` — wraps actual widget trees and turns them into skeleton loading states automatically

### Utilities

- `intl` — number and date formatting, currency display
- `shared_preferences` — lightweight local caching (settings, preferences)
- `cached_network_image` — cached image loading for coin logos and assets

### Dev Dependencies

- `build_runner` — runs code generation for Freezed, json_serializable, and Riverpod
- `freezed_annotation` — annotations for Freezed
- `json_annotation` — annotations for json_serializable
- `riverpod_lint` — lint rules for Riverpod best practices
- `custom_lint` — custom lint runner

---

## 3. Architecture Overview

```text
Flutter UI
    |
Riverpod Providers / Notifiers
    |
Repositories (abstract interfaces)
    |
Data Sources (concrete implementations)
    |
+-------------------+-------------------+
|                   |                   |
v                   v                   v
Firebase Auth    Cloud Firestore    CoinGecko API
                     ^
                     |
           Simulation Financial Ledger
                     |
        +------------+------------+
        |            |            |
        v            v            v
      Wallet       Trade       Transfer
```

The repository pattern provides an abstraction layer between the UI and data sources. Unlike a mock-first approach, all repository implementations are real from the start — they talk to Firebase and the CoinGecko API directly.

The UI never directly calls Firestore or makes HTTP requests. It interacts only with Riverpod providers, which delegate to repositories.

The domain layer (entities, repository interfaces) has zero dependency on Firebase or any external package. The data layer adapts external data into domain entities.

### Domain vs Data Layer
- **Domain Layer**: Contains the core business logic and rules of the app. It houses `Entities` (pure Dart objects that represent our business models) and `Repositories` (abstract interfaces that define what data operations can be performed, without specifying *how*). It is completely independent of external libraries or frameworks like Firebase.
- **Data Layer**: Contains the concrete implementation of the repository interfaces defined in the domain layer. It interacts with `DataSources` (like Firestore, CoinGecko REST API, Coinbase WebSocket) and uses `Models` (DTOs that map external JSON/Firestore data into our pure Domain Entities).

### Freezed & Riverpod
- **Freezed**: We use Freezed extensively for both our Domain Entities and Data Models. It provides robust immutable state classes, pattern matching, and deep copy capabilities (`copyWith`). By using Freezed, we eliminate boilerplate code for `==` operators and `hashCode` overrides. We also combine it with `json_serializable` in the Data layer for automated JSON encoding/decoding.
- **Riverpod**: Our entire state management and dependency injection tree is built on Riverpod using the modern `@riverpod` code-generation syntax. We use it to inject repositories, manage asynchronous streams (like the live WebSocket ticker and Firestore snapshots), and handle complex UI states (like the simulated trade flow stages). The code generation ensures type safety and reduces human error in provider configuration.

---

## 4. Clean Architecture & Folder Structure

```text
lib/
├── app/
│   ├── router/                   # GoRouter configuration
│   │   ├── app_router.dart       # Router instance, route tree, guards
│   │   └── routes.dart           # Route path constants and names
│   └── theme/
│       ├── app_theme.dart        # FlexColorScheme ThemeData configuration
│       ├── color_tokens.dart     # Color palette constants
│       └── text_styles.dart      # Typography definitions
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart    # CoinGecko base URL, endpoints
│   │   ├── app_constants.dart    # App-wide constants (supported assets, fee rates)
│   │   └── firestore_paths.dart  # Collection/document path constants
│   ├── errors/
│   │   └── failures.dart         # Sealed Failure class hierarchy
│   ├── extensions/
│   │   └── ...                   # DateTime, String, num extensions
│   ├── network/
│   │   ├── dio_client.dart       # Dio instance setup, interceptors, error mapping
│   │   └── api_error_handler.dart
│   └── utils/
│       ├── formatters.dart       # Currency, crypto amount, date formatters
│       ├── validators.dart       # Input validation (amount, address, email)
│       └── address_generator.dart # Simulated wallet address generation
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── firebase_auth_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_profile_model.dart      # Freezed DTO with fromJson/toJson
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_profile.dart             # Pure domain entity (Freezed)
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart          # Abstract interface
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart            # @riverpod annotated
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       └── widgets/
│   │           ├── portfolio_summary_card.dart
│   │           ├── quick_actions_row.dart
│   │           ├── holdings_list.dart
│   │           └── recent_activity_list.dart
│   │
│   ├── markets/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── coingecko_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── market_coin_model.dart
│   │   │   └── repositories/
│   │   │       └── market_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── market_coin.dart
│   │   │   └── repositories/
│   │   │       └── market_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── markets_provider.dart
│   │       ├── screens/
│   │       │   ├── markets_screen.dart
│   │       │   └── asset_detail_screen.dart
│   │       └── widgets/
│   │           ├── market_search_bar.dart
│   │           ├── coin_list_tile.dart
│   │           ├── sparkline_chart.dart
│   │           ├── price_chart.dart
│   │           └── timeframe_selector.dart
│   │
│   ├── wallet/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── firestore_wallet_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── wallet_model.dart
│   │   │   │   └── balance_model.dart
│   │   │   └── repositories/
│   │   │       └── wallet_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── wallet.dart
│   │   │   │   └── balance.dart
│   │   │   └── repositories/
│   │   │       └── wallet_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── wallet_provider.dart
│   │       ├── screens/
│   │       │   ├── wallet_screen.dart
│   │       │   ├── send_screen.dart
│   │       │   ├── receive_screen.dart
│   │       │   ├── deposit_screen.dart
│   │       │   └── withdraw_screen.dart
│   │       └── widgets/
│   │           ├── asset_balance_tile.dart
│   │           ├── portfolio_donut_chart.dart
│   │           └── address_qr_card.dart
│   │
│   ├── trading/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── firestore_trading_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── order_model.dart
│   │   │   └── repositories/
│   │   │       └── trading_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── order.dart
│   │   │   └── repositories/
│   │   │       └── trading_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── trading_provider.dart
│   │       ├── screens/
│   │       │   ├── buy_screen.dart
│   │       │   └── sell_screen.dart
│   │       └── widgets/
│   │           ├── amount_input.dart
│   │           ├── preset_amount_chips.dart
│   │           ├── order_summary_card.dart
│   │           └── fee_breakdown.dart
│   │
│   ├── transactions/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── firestore_transaction_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── transaction_model.dart
│   │   │   │   └── transfer_model.dart
│   │   │   └── repositories/
│   │   │       └── transaction_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── transaction.dart
│   │   │   │   └── transfer.dart
│   │   │   └── repositories/
│   │   │       └── transaction_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── transactions_provider.dart
│   │       ├── screens/
│   │       │   ├── activity_screen.dart
│   │       │   └── transaction_detail_screen.dart
│   │       └── widgets/
│   │           ├── transaction_list_tile.dart
│   │           └── filter_chips.dart
│   │
│   └── profile/
│       └── presentation/
│           ├── providers/
│           │   └── profile_provider.dart
│           ├── screens/
│           │   └── profile_screen.dart
│           └── widgets/
│               └── settings_tile.dart
│
├── shared/
│   ├── models/
│   │   └── ...                    # Cross-feature models if needed
│   └── widgets/
│       ├── app_button.dart        # Primary/secondary/outline buttons
│       ├── app_card.dart          # Standard card with surface blend
│       ├── status_badge.dart      # Transaction status indicator
│       ├── asset_icon.dart        # Coin logo with cached image
│       ├── amount_display.dart    # Formatted crypto/fiat amount
│       ├── empty_state.dart       # Empty state placeholder
│       └── error_state.dart       # Error state with retry
│
├── firebase_options.dart          # Generated by flutterfire configure
└── main.dart                      # App entry point, ProviderScope, Firebase init
```

### Rules

- **Domain layer** has zero dependency on Firebase, Dio, or any external package. It contains only pure Dart: entities (Freezed classes), abstract repository interfaces, and optional use cases.
- **Data layer** contains Freezed DTOs (models with `fromJson`/`toJson`), concrete repository implementations, and data source classes that interact with Firebase or APIs.
- **Presentation layer** contains Riverpod providers (annotated with `@riverpod`), screen widgets, and feature-specific reusable widgets.
- **Shared widgets** are UI components used across multiple features.
- Files are split by responsibility. No god-files. One widget per file. One provider per file.

---

## 5. GoRouter Navigation

### Route Tree

```text
/ (redirect → /home or /login based on auth state)
│
├── /login
├── /register
├── /forgot-password
│
├── /shell (StatefulShellRoute.indexedStack — bottom nav bar)
│   ├── /home                        Branch 0
│   ├── /markets                     Branch 1
│   │   └── /markets/:coinId         Asset detail (pushed within Markets tab)
│   ├── /wallet                      Branch 2
│   │   ├── /wallet/send             Full-screen push
│   │   ├── /wallet/receive          Full-screen push
│   │   ├── /wallet/deposit          Full-screen push
│   │   └── /wallet/withdraw         Full-screen push
│   ├── /activity                    Branch 3
│   │   └── /activity/:transactionId Transaction detail (pushed within Activity tab)
│   └── /profile                     Branch 4
│
├── /buy/:coinId                     Full-screen (outside shell, no bottom nav)
└── /sell/:coinId                    Full-screen (outside shell, no bottom nav)
```

### Key Implementation Details

- **StatefulShellRoute.indexedStack** preserves each tab's navigation stack independently. Switching between Home → Markets → Wallet does not destroy any tab's state.
- **Auth guard**: A `GoRouter.redirect` callback checks the Firebase Auth state. Unauthenticated users are redirected to `/login`. Authenticated users on `/login` are redirected to `/home`.
- **Auth state listenable**: The router's `refreshListenable` is a `GoRouterRefreshStream` wrapping `FirebaseAuth.instance.authStateChanges()`, so route redirects re-evaluate automatically on login/logout.
- **Deep-link handling**: The `cryptosim://pay?address=...&asset=...&amount=...` URI from QR scanning is parsed and redirected to `/wallet/send` with query parameters pre-filled.
- **Route constants**: All paths are defined as static constants in `routes.dart` to avoid magic strings.

### Bottom Navigation Bar

Five primary tabs:

```text
Home | Markets | Wallet | Activity | Profile
```

- **Home** — Portfolio overview, total balance, quick actions, holdings, recent activity
- **Markets** — Asset discovery, search, market data, top movers
- **Wallet** — Balances, send, receive, deposit, withdrawal
- **Activity** — Transaction and transfer history with filters
- **Profile** — Account settings, preferences, logout

---

## 6. Firebase Setup

### Initialization

Use `flutterfire configure` to generate `firebase_options.dart`. Initialize Firebase in `main.dart` before `runApp`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: CryptoSimApp()));
}
```

### Firebase Authentication

Handles:

- Email/password registration
- Login
- Logout
- Password reset
- Email verification (optional but recommended)
- Auth state stream (`authStateChanges()`)
- User identity via Firebase UID

The `AuthRepository` interface exposes these operations. The `FirebaseAuthRepository` implementation wraps `FirebaseAuth` calls.

**Initial Funding (Registration Hook):**
When a new user successfully registers, the authentication layer should trigger the creation of a default `Wallet` document for them, seeded with an initial balance of **$10,000 USD**. This allows the user to immediately begin using the trading simulator.
* The `Wallet` stores asset *quantities* (e.g. `10000 USD`, `0.05 BTC`).
* Total portfolio value is calculated dynamically in the UI layer by multiplying the held quantities by live market prices from CoinGecko, ensuring the user's total balance fluctuates authentically with the market.

### Cloud Firestore

Stores all application data: users, wallets, balances, orders, transactions. Provides real-time streams (`snapshots()`) for live-updating UI and one-shot reads (`get()`) where real-time is unnecessary.

Use Firestore transactions (`runTransaction`) for all financial mutations to ensure atomicity. A buy operation, for example, atomically debits USDT, credits the purchased crypto, and writes an order record.

### Security Rules

Protect private user data and prevent unauthorized financial mutations:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own profile
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // Wallets — users can read their own, writes are restricted
    match /wallets/{walletId} {
      allow read: if request.auth != null && resource.data.uid == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.uid == request.auth.uid;
      // Direct balance writes are forbidden — mutations go through transactions
      allow update, delete: if false;

      // Balances sub-collection
      match /balances/{assetId} {
        allow read: if request.auth != null
          && get(/databases/$(database)/documents/wallets/$(walletId)).data.uid == request.auth.uid;
        // Balance writes only via server-side or Firestore transactions
        allow write: if false;
      }
    }

    // Transactions — users can read their own
    match /transactions/{transactionId} {
      allow read: if request.auth != null
        && (resource.data.senderUid == request.auth.uid
            || resource.data.receiverUid == request.auth.uid);
      allow create: if request.auth != null
        && request.resource.data.senderUid == request.auth.uid;
      allow update, delete: if false;
    }

    // Orders — users can read their own
    match /orders/{orderId} {
      allow read: if request.auth != null && resource.data.uid == request.auth.uid;
      allow create: if request.auth != null
        && request.resource.data.uid == request.auth.uid;
      allow update, delete: if false;
    }
  }
}
```

These rules are a starting point. Once Cloud Functions handle financial mutations, the write rules can be tightened further to `allow write: if false` across the board, with only Cloud Functions (admin SDK) performing writes.

### Cloud Functions (Later Phase)

Not required before development starts. Useful later for moving authoritative operations out of the client:

- Buy / Sell
- Transfer
- Deposit / Withdrawal

The initial implementation uses Firestore transactions from trusted application flows. The same operations can later become callable Cloud Functions without changing the UI layer, because the UI only talks to repository interfaces.

---

## 7. Data Models

All models use Freezed for immutability and json_serializable for serialization. Monetary/asset amounts are stored as `String` (decimal strings) to avoid floating-point precision issues.

### UserProfile

```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String displayName,
    required String email,
    @Default('USD') String preferredCurrency,
    required DateTime createdAt,
  }) = _UserProfile;
}
```

### Wallet

```dart
@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String uid,
    required String address,    // e.g. sim-cryptosim-7A3919C2...
    required DateTime createdAt,
  }) = _Wallet;
}
```

### Balance

```dart
@freezed
class Balance with _$Balance {
  const factory Balance({
    required String assetId,    // e.g. BTC, ETH, USDT
    required String amount,     // Decimal string: "0.05200000"
    required DateTime updatedAt,
  }) = _Balance;
}
```

### Order (Buy/Sell)

```dart
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String uid,
    required String walletId,
    required OrderType type,          // BUY or SELL
    required String asset,            // e.g. BTC
    required String requestedAmount,  // Fiat amount for buy, crypto amount for sell
    required String executionPrice,   // Price at time of execution
    required String assetAmount,      // Crypto amount received/sold
    required String fee,
    required String totalCost,        // Total fiat spent/received
    required OrderStatus status,
    required String hash,             // Application-generated transaction hash
    required DateTime createdAt,
  }) = _Order;
}
```

### Transaction

```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String hash,             // Application-generated hex hash
    required TransactionType type,    // TRANSFER, DEPOSIT, WITHDRAWAL
    required String asset,
    required String amount,
    String? senderAddress,
    String? receiverAddress,
    String? senderUid,
    String? receiverUid,
    required String fee,
    required TransactionStatus status,
    required DateTime createdAt,
  }) = _Transaction;
}
```

### Transfer

```dart
@freezed
class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    required String hash,
    required String senderUid,
    required String receiverUid,
    required String senderAddress,
    required String receiverAddress,
    required String asset,
    required String amount,
    required String fee,
    required TransactionStatus status,
    required String idempotencyKey,
    required DateTime createdAt,
  }) = _Transfer;
}
```

### MarketCoin

```dart
@freezed
class MarketCoin with _$MarketCoin {
  const factory MarketCoin({
    required String id,               // CoinGecko ID: "bitcoin"
    required String symbol,           // "btc"
    required String name,             // "Bitcoin"
    required double currentPrice,
    required double priceChange24h,
    required double priceChangePercentage24h,
    required double marketCap,
    required double totalVolume,
    required double high24h,
    required double low24h,
    required String image,            // Logo URL
    List<double>? sparklineIn7d,      // 7-day sparkline data points
  }) = _MarketCoin;
}
```

### Enums

```dart
enum OrderType { buy, sell }

enum OrderStatus { pending, processing, completed, failed }

enum TransactionType { transfer, deposit, withdrawal }

enum TransactionStatus { pending, processing, completed, failed }
```

---

## 8. Firestore Collection Structure

```text
users/{uid}
    displayName: String
    email: String
    preferredCurrency: String
    createdAt: Timestamp

wallets/{walletId}
    uid: String
    address: String              # sim-cryptosim-{hex}
    createdAt: Timestamp

    └── balances/{assetId}       # Sub-collection
        assetId: String
        amount: String           # Decimal string
        updatedAt: Timestamp

orders/{orderId}
    uid: String
    walletId: String
    type: String                 # "BUY" or "SELL"
    asset: String
    requestedAmount: String
    executionPrice: String
    assetAmount: String
    fee: String
    totalCost: String
    status: String               # "PENDING", "PROCESSING", "COMPLETED", "FAILED"
    hash: String
    createdAt: Timestamp

transactions/{transactionId}
    hash: String
    type: String                 # "TRANSFER", "DEPOSIT", "WITHDRAWAL"
    asset: String
    amount: String
    senderAddress: String?
    receiverAddress: String?
    senderUid: String?
    receiverUid: String?
    fee: String
    status: String
    idempotencyKey: String?
    createdAt: Timestamp
```

### Recommended Composite Indexes

- `orders`: `uid` ASC + `createdAt` DESC — fetch a user's orders newest first
- `orders`: `uid` ASC + `asset` ASC + `createdAt` DESC — fetch a user's orders for a specific asset
- `transactions`: `senderUid` ASC + `createdAt` DESC — fetch a user's sent transactions
- `transactions`: `receiverUid` ASC + `createdAt` DESC — fetch a user's received transactions
- `transactions`: `senderUid` ASC + `type` ASC + `createdAt` DESC — filter by type

### Design Decisions

- Balances are a sub-collection of wallets, not a map field, so individual asset balances can be queried and updated independently.
- Transaction documents include both `senderUid` and `receiverUid` so both participants can query them.
- The `idempotencyKey` field on transactions prevents duplicate processing of the same operation.

---

## 9. Market Data (CoinGecko API)

### Dio Service Class

```dart
class CoinGeckoService {
  final Dio _dio;

  CoinGeckoService(this._dio);

  /// Fetch market data for top coins
  Future<List<MarketCoinModel>> getMarkets({
    String currency = 'usd',
    int perPage = 50,
    int page = 1,
    bool sparkline = true,
  }) async {
    final response = await _dio.get('/coins/markets', queryParameters: {
      'vs_currency': currency,
      'order': 'market_cap_desc',
      'per_page': perPage,
      'page': page,
      'sparkline': sparkline,
    });
    return (response.data as List)
        .map((json) => MarketCoinModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch historical price data for charts
  Future<List<List<num>>> getMarketChart({
    required String coinId,
    String currency = 'usd',
    required int days,
  }) async {
    final response = await _dio.get('/coins/$coinId/market_chart', queryParameters: {
      'vs_currency': currency,
      'days': days,
    });
    return (response.data['prices'] as List)
        .map((e) => (e as List).cast<num>())
        .toList();
  }
}
```

### Caching & Refresh Strategy

- **Market list**: Repository-level in-memory cache with a configurable TTL (e.g. 60 seconds). The provider exposes a `refresh()` method for pull-to-refresh.
- **Asset detail**: Refresh while the screen is active. Stop refreshing when the user navigates away.
- **Charts**: Fetch on-demand based on selected timeframe (1H, 1D, 1W, 1M, 1Y). Cache per timeframe.
- **Rate limiting**: CoinGecko free tier allows ~10-30 calls/minute. The repository layer should throttle requests accordingly.

---

## 10. Core User Flows

For UI design and layout, refer to the HTML prototype file in the project root. The following documents each flow at the logic level.

### Buy Flow

```text
Markets → Select Asset → Buy → Enter amount → Review → Confirm → Success → Transaction details
```

1. User selects an asset and taps Buy
2. User enters a fiat amount (USD). Preset chips offer quick amounts ($25, $50, $100, $250, $500)
3. App calculates: crypto amount = (fiat amount - fee) / current price
4. Review screen shows: asset, fiat amount, current price, crypto to receive, fee, total cost
5. On confirm, a Firestore transaction atomically:
   - Reads USDT balance
   - Validates sufficient balance
   - Debits USDT by total cost
   - Credits crypto asset by calculated amount
   - Writes an Order document with execution details
6. Success screen shows the order with its generated hash

The order record stores the execution price at the time of trade. Never rely on the latest market price to reconstruct historical transactions.

### Sell Flow

```text
Asset details → Sell → Enter crypto amount → Review → Confirm → Success → Transaction details
```

Mirror of the buy flow. User enters a crypto amount to sell. App calculates fiat proceeds minus fee. Firestore transaction atomically debits crypto, credits USDT, and writes an order record.

### Deposit (Simulated)

```text
Deposit → Choose asset → Enter amount → Review → Confirm → Balance increases → Transaction created
```

A simulated operation that credits the user's balance. Writes a transaction record of type `DEPOSIT`.

### Withdrawal (Simulated)

```text
Withdraw → Choose asset → Enter amount → Recipient address → Fee → Review → Confirm → Balance decreases → Transaction created
```

A simulated operation that debits the user's balance. Writes a transaction record of type `WITHDRAWAL`. Withdrawals are conceptually distinct from internal transfers:

- **Internal transfer**: CryptoSim user → CryptoSim user
- **Withdrawal**: CryptoSim user → external/simulated destination

### Send (Transfer)

```text
Wallet → Send → Enter recipient (manual or QR scan) → Enter amount → Review → Confirm → Processing → Completed → Transaction details
```

1. User enters a recipient address manually or scans a QR code
2. App resolves the recipient: queries Firestore for a wallet with matching address
3. If the address belongs to a CryptoSim user, proceed as an internal transfer
4. User enters amount, reviews fee breakdown
5. On confirm, a Firestore transaction atomically:
   - Reads sender balance
   - Validates sufficient balance (amount + fee)
   - Reads receiver balance
   - Debits sender
   - Credits receiver
   - Writes a Transaction document referencing both parties
   - Uses an idempotency key to prevent duplicate processing
6. Both sender and receiver see the transaction in their activity history with the same hash

### Receive

```text
Wallet → Receive → Select asset → Display QR code + address → Copy / Share
```

The receive screen displays:

- Selected asset
- Simulated wallet address
- QR code encoding the payment URI
- Copy address button
- Share button
- "CryptoSim Network" label

---

## 11. Transaction System

### Lifecycle States

Use explicit states rather than treating every transaction as an instant event:

```text
PENDING → PROCESSING → COMPLETED
                     → FAILED
```

For the simulator, the UI can transition rapidly from PENDING/PROCESSING to COMPLETED, but the state machine is still stored and respected. This allows realistic UX (showing a brief processing state) and leaves room for actual async processing if Cloud Functions are added later.

### Transaction Hashes

Every financial event receives an application-generated hash formatted as a hex string:

```text
0x8d1f5f2a9b7c4e3d...
```

Generation approach: UUID v4 → remove dashes → prepend `0x` → truncate to desired length.

The hash provides a stable reference for realistic UX. It is not a blockchain transaction hash unless the application is actually submitting to a blockchain.

### Idempotency

Every financial mutation carries a unique `idempotencyKey` (UUID). Before processing, the Firestore transaction checks whether a document with that key already exists. If so, the operation is rejected as a duplicate.

This protects against:

- Network failures causing retries
- App restart during submission
- Timeout-triggered re-sends
- Double-tap on confirm button

### Atomicity

All balance changes and their corresponding record writes happen inside a single `FirebaseFirestore.instance.runTransaction()` call. If any step fails, the entire operation rolls back.

### Concurrency

Firestore transactions use optimistic locking. If two requests try to spend the same balance simultaneously, only one succeeds; the other retries or fails. This prevents double-spending.

---

## 12. QR Code System

### Payload Format

Use a custom URI scheme rather than encoding only a raw address:

```text
cryptosim://pay?address=sim-cryptosim-7A3919C2&asset=BTC
```

Optionally include an amount:

```text
cryptosim://pay?address=sim-cryptosim-7A3919C2&asset=BTC&amount=0.25
```

### Generation

Use `qr_flutter` to encode the URI string into a QR code displayed on the Receive screen.

### Scanning

Use `mobile_scanner` to scan a QR code. On scan:

1. Parse the URI string
2. Validate the `cryptosim://` scheme
3. Extract `address`, `asset`, and optional `amount` parameters
4. Navigate to the Send screen (`/wallet/send`) via GoRouter with query parameters pre-filled
5. User reviews and confirms before submitting

### GoRouter Deep-Link Integration

The scanned URI parameters are passed as GoRouter query parameters or `extra` data when navigating to the send screen. The Send screen reads these from `GoRouterState` to pre-fill the recipient address, asset, and amount fields.

---

## 13. Simulated Wallet Addresses

### Format

```text
sim-cryptosim-{12-character-hex}
```

Example: `sim-cryptosim-7A3919C2F1B4`

### Generation

Generated once per user at wallet creation time using a secure random hex generator. Stored in the wallet's Firestore document.

### Purpose

- Identifies a wallet inside the CryptoSim simulator
- Used as sender/receiver in transaction records
- Encoded in QR codes
- The `sim-cryptosim-` prefix allows the app to quickly determine whether an address belongs to its own system (important for cross-app transfers in a later phase)

---

## 14. Financial Data Rules

Even though funds are simulated, the ledger must be implemented carefully.

### Decimal Safety

Do not use floating-point arithmetic for monetary/asset quantities. Represent amounts as decimal strings in Firestore and wire payloads. In Dart, use `Decimal` from the `decimal` package or parse strings carefully when performing arithmetic.

### Validation

Before any financial mutation, validate:

- Amount > 0
- Supported asset
- Sufficient balance (amount + fee ≤ available balance)
- Valid destination address (for transfers)
- Valid transaction state (no double-processing)
- Correct authorization (authenticated user owns the wallet)

### Fee Calculation

Use a simple percentage-based fee model:

- Buy/Sell: configurable fee rate (e.g. 1%)
- Transfer: flat fee per asset (e.g. 0.0001 BTC)
- Deposit: no fee
- Withdrawal: flat fee per asset

Fee rates are defined as constants in `app_constants.dart` and can be adjusted without code changes.

---

## 15. Design System & Theming

The visual design is defined by the HTML prototype. Map the prototype's design tokens to Flutter's `ThemeData` via `flex_color_scheme`.

### Color Palette (from prototype)

```dart
// Primary surfaces
static const bgPrimary = Color(0xFF0B0E14);
static const bgSurface = Color(0xFF151A23);
static const bgSurfaceLight = Color(0xFF1E2530);

// Accent
static const accentPrimary = Color(0xFF6C5CE7);    // Violet
static const accentSecondary = Color(0xFF00D2FF);   // Cyan

// Semantic
static const positive = Color(0xFF00C853);           // Green (price up)
static const negative = Color(0xFFFF5252);           // Red (price down)

// Text
static const textPrimary = Color(0xFFFFFFFF);
static const textSecondary = Color(0xFFB0BEC5);
static const textTertiary = Color(0xFF78909C);
```

### Typography

Use Inter (from Google Fonts) or the system default. Define text styles in `text_styles.dart` matching the prototype's hierarchy.

### FlexColorScheme Configuration

```dart
final darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.custom,
  darkIsTrueBlack: false,
  // Configure with custom colors matching the prototype palette
  // Surface blends for the layered dark surface effect
);
```

### Motion

Use the `motor` package for spring-based transitions:

- Tab switches and page transitions
- Card press/release interactions
- Pull-to-refresh bounce
- List item appearance animations
- Sheet open/close with `stupid_simple_sheet`

### Loading States

Use `skeletonizer` to wrap actual widget trees during loading. This automatically generates skeleton placeholders matching the real layout, ensuring consistency and reducing maintenance.

---

## 16. UI Interaction Rules

### Full Screens

Use dedicated full-screen pages for major actions:

- Buy
- Sell
- Send
- Receive
- Deposit
- Withdraw
- Transaction details
- Asset details (crypto detail page)

### Bottom Sheets (via `stupid_simple_sheet`)

Use sheets for lightweight, supplementary interactions:

- Asset selector (choose which crypto to send/receive)
- Filters (activity type filters)
- Timeframe selector (chart timeframes)
- Currency selector (preferred fiat currency)
- Small confirmations ("Are you sure?")

The sheet can expand smoothly to full screen when the content requires more space, leveraging `stupid_simple_sheet`'s built-in expand behavior.

---

## 17. Cross-App Transfer Protocol (Future Phase)

This section documents the interoperability design for exchanging simulated funds between independently built apps (e.g. your app and a friend's app). This is not part of the initial build phases but is kept in scope for later implementation.

### Architecture

```text
Your CryptoSim App
    |
    | Repository → Cloud Function
    |
    | HTTPS + JSON + shared secret
    v
Friend's receive endpoint
    |
    v
Friend's backend / data store
```

Your side debits the sender via a Firestore transaction, then calls the friend's `/receive` endpoint. Their service validates the request, credits their user, and returns success. If the receive call fails, your side rolls back the debit.

### Wire Contract

```json
{
  "asset": "BTC",
  "amount": "0.025",
  "senderAddress": "sim-cryptosim-...",
  "receiverAddress": "sim-friendapp-...",
  "idempotencyKey": "uuid-here"
}
```

### Key Fields

- `asset` — asset symbol (e.g. BTC)
- `amount` — decimal string, not a floating-point number
- `senderAddress` — sender's simulated wallet address
- `receiverAddress` — recipient's simulated wallet address
- `idempotencyKey` — unique request identifier to prevent duplicate crediting

### Address Namespacing

Each app uses a distinct prefix to identify its own addresses:

```text
sim-cryptosim-{hex}
sim-friendapp-{hex}
```

This allows each backend to quickly determine whether an address belongs to its own system and route accordingly.

---

## 18. Build Phases

### Phase 1 — Foundation

- Firebase project creation and `flutterfire configure`
- `pubspec.yaml` with all dependencies
- `main.dart` with Firebase init and `ProviderScope`
- GoRouter setup with `StatefulShellRoute` and 5-tab bottom nav
- FlexColorScheme dark theme with design tokens from prototype
- App shell: scaffold with bottom navigation bar
- Shared widget stubs (buttons, cards)
- Folder structure creation

### Phase 2 — Authentication

- Firebase Auth integration (register, login, logout, password reset)
- `AuthRepository` interface and `FirebaseAuthRepository` implementation
- Auth providers (`@riverpod` annotated)
- Login, Register, Forgot Password screens
- GoRouter auth guard (redirect unauthenticated users)
- User profile Firestore document creation on registration
- Wallet document creation on registration (with generated address)

### Phase 3 — Markets

- CoinGecko Dio service class
- `MarketRepository` interface and implementation with caching
- Markets provider with periodic refresh
- Markets screen: search bar, coin list with sparkline charts (`fl_chart`)
- Asset detail screen: price, 24h change, chart with timeframe selector, market stats
- Skeletonizer loading states for market list

### Phase 4 — Wallet & Ledger

- `WalletRepository` interface and Firestore implementation
- Wallet screen: total balance, asset breakdown, portfolio donut chart
- Balance display with real-time Firestore streams
- Deposit flow: choose asset → enter amount → confirm → Firestore transaction
- Withdrawal flow: choose asset → enter amount → address → fee → confirm → Firestore transaction
- Transaction record creation for deposits and withdrawals

### Phase 5 — Trading

- `TradingRepository` interface and Firestore implementation
- Buy screen: amount input, preset chips, price display, fee breakdown, review, confirm
- Sell screen: crypto amount input, fiat value calculation, fee, review, confirm
- Atomic Firestore transactions for buy/sell (debit one asset, credit another, write order)
- Order status tracking
- Transaction hash generation

### Phase 6 — Transfers & QR

- Send screen: recipient address input (manual + QR scan), amount, fee, review, confirm
- Receive screen: QR code generation (`qr_flutter`), address display, copy, share
- QR scanning integration (`mobile_scanner`)
- URI parsing for `cryptosim://pay?...` scheme
- GoRouter deep-link handling for scanned URIs
- Atomic Firestore transaction for transfers (debit sender, credit receiver, write transfer record)
- Idempotency key generation and duplicate detection
- Address resolution: look up wallet by address in Firestore

### Phase 7 — Activity

- `TransactionRepository` interface and Firestore implementation
- Activity screen: transaction list with filter chips (All, Buy, Sell, Send, Receive, Deposit, Withdraw)
- Transaction detail screen: status, type, asset, amount, fiat value, sender, receiver, fee, hash, timestamp
- Copy hash and share actions
- Real-time updates via Firestore streams
- Pagination for large transaction lists

### Phase 8 — Polish & Hardening

- `motor` spring animations for page transitions and interactions
- `skeletonizer` loading states across all screens
- Empty states for no holdings, no transactions, no search results
- Error states with retry actions
- Form validation with user-friendly error messages
- Security Rules hardening (finalize and test)
- Cloud Functions migration for financial mutations (optional)
- Two-device transfer testing
- Profile screen: display name, email, preferred currency, logout
- Edge cases: insufficient balance, invalid addresses, network failures

---

## 19. Testing Strategy

### Flutter Tests

- **Model tests**: Freezed entity creation, JSON serialization round-trips
- **Repository tests**: Use Firestore emulator or mock Firestore for unit tests
- **Provider tests**: Riverpod `ProviderContainer` with overridden dependencies
- **Widget tests**: Key screens render correctly with given state
- **Validation tests**: Amount validators, address validators, email validators

### Firebase Tests

- **Security Rules tests**: Use `@firebase/rules-unit-testing` to verify:
  - Users can only read their own data
  - Users cannot directly write to balance documents
  - Users cannot read other users' transactions
  - Unauthorized users are rejected
- **Financial operation tests**:
  - Buy with sufficient balance succeeds
  - Buy with insufficient balance fails
  - Transfer debits sender and credits receiver atomically
  - Duplicate idempotency key is rejected
  - Concurrent transfers on same balance don't double-spend

### End-to-End Demo

Test with two separate user accounts (two devices or emulators):

```text
User A: BTC = 1.0000
User B: BTC = 0.0000

User A sends 0.25 BTC to User B

User A → 0.7499 BTC (minus fee)
User B → 0.2500 BTC

Both activity histories show the transfer with the same hash.
```

---

## 20. Out of Scope

Do not add these during the MVP:

- Real money or real blockchain settlement
- Real mainnet/testnet crypto transfers
- Real banking or payment processing
- Futures, margin trading, leverage
- Staking, lending, yield
- NFTs
- P2P marketplace
- Copy trading or trading bots
- Advanced order books (limit orders, stop-loss)
- Complex KYC or identity verification
- Complex referral systems
- Social features (chat, follow, feed)

---

## 21. Definition of Done

The MVP is complete when two separate users can:

```text
Register
  → Login
  → View live market data from CoinGecko
  → View an asset's detail page with chart
  → Deposit simulated USDT
  → Buy simulated crypto (e.g. BTC)
  → View wallet with updated balance
  → Generate receive address + QR code
  → Share QR/address with friend
  → Friend scans QR code
  → Friend sends simulated crypto
  → Sender balance decreases (amount + fee)
  → Receiver balance increases
  → Transaction receives a hash
  → Both users can view the transaction in Activity
  → Sell simulated crypto
  → Withdraw simulated funds
  → View full activity history with filters
```
