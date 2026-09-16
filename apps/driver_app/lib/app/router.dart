import 'package:go_router/go_router.dart';
import '../features/auth/presentation/driver_login_screen.dart';
import '../features/trip/presentation/driver_radar_screen.dart';
import '../features/trip/presentation/active_navigation_screen.dart';
import '../features/earnings/presentation/earnings_screen.dart';
import '../features/profile/presentation/driver_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/radar',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const DriverLoginScreen(),
    ),
    GoRoute(
      path: '/radar',
      builder: (context, state) => const DriverRadarScreen(),
    ),
    GoRoute(
      path: '/navigation',
      builder: (context, state) => const ActiveNavigationScreen(),
    ),
    GoRoute(
      path: '/earnings',
      builder: (context, state) => const EarningsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const DriverProfileScreen(),
    ),
  ],
);
