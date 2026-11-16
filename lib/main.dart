import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env.dart';
import 'features/admin/providers/admin_provider.dart';
import 'features/auth/providers/auth_repo_provider.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/current_user/providers/current_user_provider.dart';
import 'features/day_summaries/providers/summary_provider.dart';
import 'features/profile/providers/onboarding_controller.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/tasks/providers/task_provider.dart';
import 'features/tasks/providers/tasks_for_date_provider.dart';
import 'providers/celebration_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<AuthState>? _authSubscription;
  String? _userId;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authRepositoryProvider);
    _userId = auth.currentUser?.id;
    _authSubscription = auth.authStateChanges.listen((event) {
      final userId = event.session?.user.id;
      if (userId == _userId) return;
      final previousUserId = _userId;
      _userId = userId;
      ref.invalidate(currentUserProvider);
      ref.invalidate(profileProvider);
      ref.invalidate(taskControllerProvider);
      ref.invalidate(daySummaryControllerProvider);
      ref.invalidate(tasksForDateProvider);
      ref.invalidate(membersProvider);
      ref.invalidate(adminControllerProvider);
      ref.invalidate(onboardingControllerProvider);
      ref.invalidate(celebrationProvider);
      if (previousUserId != null) {
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                userId == null ? const AuthScreen() : const SplashScreen(),
          ),
          (_) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
