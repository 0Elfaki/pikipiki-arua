import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/trip/presentation/home_screen.dart';
import '../features/trip/presentation/active_trip_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/trip-active',
      builder: (context, state) => const ActiveTripScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
