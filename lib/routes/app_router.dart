import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../core/supabase/auth_service.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/earnings/add_earning_screen.dart';
import '../features/earnings/earnings_list_screen.dart';
import '../features/expenses/add_expense_screen.dart';
import '../features/expenses/expenses_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/shared/detail_screen.dart';
import '../shared/models/earning.dart';
import '../shared/models/expense.dart';
import '../features/reports/reports_screen.dart';
import '../features/goals/goals_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/backup/backup_screen.dart';
import '../features/export/export_data_screen.dart';
import '../features/theme/theme_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/help/help_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(AuthService.onAuthStateChange),
    redirect: (context, state) {
      final isAuthenticated = AuthService.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/onboarding';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && (state.matchedLocation == '/login' || state.matchedLocation == '/register')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsListScreen(),
      ),
      GoRoute(
        path: '/earnings/add',
        builder: (context, state) {
          final initialEarning = state.extra as Earning?;
          return AddEarningScreen(initialEarning: initialEarning);
        },
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesListScreen(),
      ),
      GoRoute(
        path: '/expenses/add',
        builder: (context, state) {
          final initialExpense = state.extra as Expense?;
          return AddExpenseScreen(initialExpense: initialExpense);
        },
      ),
      GoRoute(
        path: '/detail/earning/:id',
        builder: (context, state) {
          final earning = state.extra as Earning?;
          return DetailScreen(earning: earning);
        },
      ),
      GoRoute(
        path: '/detail/expense/:id',
        builder: (context, state) {
          final expense = state.extra as Expense?;
          return DetailScreen(expense: expense);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/backup',
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: '/export',
        builder: (context, state) => const ExportDataScreen(),
      ),
      GoRoute(
        path: '/theme',
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Erro: ${state.error}'),
      ),
    ),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

