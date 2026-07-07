import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locora_mobile/config/supabase_config.dart';
import 'package:locora_mobile/features/auth/presentation/pages/auth_page.dart';
import 'package:locora_mobile/features/auth/presentation/pages/launch_gate_page.dart';
import 'package:locora_mobile/features/auth/presentation/providers.dart';
import 'package:locora_mobile/features/home/presentation/pages/home_page.dart';
import 'package:locora_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:locora_mobile/features/onboarding/presentation/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  AppRouter._();

  static const String launch = '/launch';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String home = '/';

  static GoRouter build(Ref ref) {
    final onboardingSessionCache = ref.read(onboardingSessionStatusProvider.notifier);

    final refreshListenable = AuthRefreshListenable(
      ref.watch(authRepositoryProvider).authStateChanges(),
      onAuthChanged: () {
        onboardingSessionCache.clear();
      },
    );

    ref.onDispose(refreshListenable.dispose);

    return GoRouter(
      initialLocation: launch,
      refreshListenable: refreshListenable,
      redirect: (context, state) async {
        final session = SupabaseConfig.client.auth.currentSession;
        final location = state.matchedLocation;
        final isAtLaunch = location == launch;
        final isAtAuth = location == auth;
        final isAtOnboarding = location == onboarding;
        final isAtHome = location == home;

        if (session == null) {
          if (isAtAuth) {
            return null;
          }

          if (isAtLaunch || isAtOnboarding || isAtHome) {
            return auth;
          }

          return auth;
        }

        final userId = session.user.id;
        final cachedStatus = onboardingSessionCache.statusOf(userId);
        final onboardingCompleted =
            cachedStatus ??
            await ref.read(onboardingCompletedProvider(userId).future);

        if (cachedStatus == null) {
          onboardingSessionCache.setStatus(userId, completed: onboardingCompleted);
        }

        if (!onboardingCompleted) {
          if (isAtOnboarding) {
            return null;
          }

          return onboarding;
        }

        if (isAtLaunch || isAtAuth || isAtOnboarding) {
          return home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: launch,
          builder: (context, state) => const LaunchGatePage(),
        ),
        GoRoute(
          path: auth,
          builder: (context, state) => const AuthPage(),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.build(ref);
});

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(
    Stream<AuthState> authStateStream, {
    required VoidCallback onAuthChanged,
  }) {
    _subscription = authStateStream.listen((_) {
      onAuthChanged();
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
