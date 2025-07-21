import 'package:bookify/screens/admin/admin_dashboard.dart';
import 'package:bookify/screens/admin/admin_rental_orders_screen.dart';
import 'package:bookify/screens/auth/auth_gate.dart';
import 'package:bookify/screens/auth/login_screen.dart';
import 'package:bookify/screens/user/book_details_screen.dart';
import 'package:bookify/screens/user/home_screen.dart';
import 'package:bookify/screens/user/profile_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AuthGate(),
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/admin', builder: (context, state) => const AdminDashboard()),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookDetailsScreen(bookId: id);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/admin/rentals',
      builder: (context, state) => const AdminRentalOrdersScreen(),
    ),
  ],
);
