import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'utils/router.dart';
import 'utils/theme.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize `.env` configuration (ignore errors if it doesn't exist yet to not break compilation)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('No .env file found: \$e');
  }

  // Initialize Firebase
  // Note: the Firebase configuration details need to be completed before full runtime
  // For web, you might have generated firebase_options.dart. If not, it will throw an error.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not fully configured or already initialized: \$e');
  }

  runApp(const ProviderScope(child: NexaraApp()));
}

class NexaraApp extends ConsumerWidget {
  const NexaraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Nexara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
