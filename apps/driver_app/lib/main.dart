import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'core/network/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseService.initialize(
      url: 'https://demo.pikipiki-arua.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy-local-anon-key',
    );
  } catch (e) {
    debugPrint('Supabase init skipped (offline/demo mode): $e');
  }

  runApp(
    const ProviderScope(
      child: PikipikiDriverApp(),
    ),
  );
}

class PikipikiDriverApp extends StatelessWidget {
  const PikipikiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pikipiki Arua - Driver',
      debugShowCheckedModeBanner: false,
      theme: DriverAppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
