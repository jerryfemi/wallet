# Implementation Plan: Premium Wallet Navigation & Send Flow Redesign

This document outlines the step-by-step technical plan to overhaul the Quick Actions, build the animated Trade button, restructure the Coin Details screen, and completely redesign the Send flow to achieve a top-tier premium aesthetic.

## Phase 1: Redesign the Send Screen (`SendScreen`)
**Goal:** Replace the basic form with a modern, dynamic, "Cash App" style interface.

* **Custom Keypad & Hero Amount:** 
  * Remove the native keyboard and `TextField` for the amount.
  * Build a `CustomNumericKeypad` widget.
  * The amount will be displayed in the center of the screen using massive, dynamic typography that scales down as the number gets longer.
* **Premium Input Field:**
  * Redesign the "To" (recipient) field into a sleek, floating pill at the top of the screen, rather than a bulky bordered box.
* **Send Action:**
  * Replace the generic `ElevatedButton` with a glowing, haptic-heavy "Slide to Send" widget (or a sleek hold-to-confirm button) to prevent accidental sends and increase the premium feel.
* **Success State:**
  * Implement a full-screen, vibrant micro-animation (e.g., a glowing checkmark burst) upon successful broadcast.

## Phase 2: Global Quick Actions (`QuickActionsRow`)
**Goal:** Remove contextual trading actions (Buy/Sell) from the global scope and focus on overarching money movement.

* **File to modify:** `lib/features/home/presentation/widgets/quick_actions_row.dart`
* **New Layout:**
  1. **Deposit** (Fiat entry)
  2. **Withdraw** (Fiat exit)
  3. **Send** (Crypto exit - opens an asset selector first)
  4. **Receive** (Crypto entry - opens an asset selector first)
* *Note: If we prefer Swap over Send/Receive here, we can easily swap one out.*

## Phase 3: Coin Details Scroll Body (`CoinDetailsScreen`)
**Goal:** Clean up the header and put standard asset transfers right where the user expects them.

* **Remove Header Icons:** Strip the "Send" and "Receive" icons from `CoinSliverHeaderDelegate` to make the glassmorphic scroll header perfectly clean.
* **Add In-Body Buttons:** Below the `CoinChartSection` (the chart and timeframes), add a new `Row` containing two massive, sleek pill buttons: **Send** and **Receive**.
  * These buttons will use standard `context.push()` to route to the `/send/:coinId` and `/receive/:coinId` routes.

## Phase 4: The Animated Sticky Trade Bar (`CoinDetailsScreen`)
**Goal:** Build the custom, animated bottom bar without using backdrop filters (solid/opaque background).

* **The Sticky Bar Component:**
  * Wrap the `CustomScrollView` in `CoinDetailsScreen` inside a `Stack`.
  * Position a container at the bottom (`bottom: 0, left: 0, right: 0`).
  * **Background:** Solid color matching the `scaffoldBackgroundColor` or slightly elevated `surfaceContainer` (no blur/backdrop filter).
  * **Left Side:** Text showing contextual data (e.g., "\$1B traded today").
* **The Animated Trade Button Component:**
  * Create a custom `HookWidget` managing an `AnimationController`.
  * **Collapsed State:** A single, vibrant primary-colored pill saying "Trade".
  * **Expanded State:** 
    * A full-screen invisible `GestureDetector` appears behind the bar to capture taps and close the menu.
    * The main pill animates its background to a muted color, and the text fades into an "X" icon.
    * Two new pills ("Buy" and "Sell") use `SlideTransition` and `FadeTransition` to pop upwards with a slight spring curve (`Curves.easeOutBack`).
  * Tapping "Buy" or "Sell" will collapse the menu and launch the existing `TradingSheet`.
