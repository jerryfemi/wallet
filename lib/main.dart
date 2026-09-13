import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DevicePreview.enable(); // Enable DevicePreview (automatically respects kReleaseMode in v3)
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
