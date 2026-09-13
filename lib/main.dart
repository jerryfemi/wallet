import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
// import 'firebase_options.dart'; // Uncomment this once flutterfire configure is run

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase. You will need to run 'flutterfire configure' to generate firebase_options.dart
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const ProviderScope(child: CryptoSimApp()));
}

class CryptoSimApp extends ConsumerWidget {
  const CryptoSimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CryptoSim',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Enforce dark theme based on the prototype
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
