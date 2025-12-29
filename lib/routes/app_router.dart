import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/earnings/add_earning_screen.dart';
// Imports comentados - serão descomentados quando as telas forem implementadas
// import '../features/profile/profile_screen.dart';
// import '../features/reports/reports_screen.dart';
// import '../features/earnings/earnings_list_screen.dart';
// import '../features/expenses/expenses_list_screen.dart';
// import '../features/expenses/add_expense_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
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
        path: '/earnings/add',
        builder: (context, state) => const AddEarningScreen(),
      ),
      // Rotas comentadas - serão descomentadas quando as telas forem implementadas
      // GoRoute(
      //   path: '/profile',
      //   builder: (context, state) => const ProfileScreen(),
      // ),
      // GoRoute(
      //   path: '/reports',
      //   builder: (context, state) => const ReportsScreen(),
      // ),
      // GoRoute(
      //   path: '/earnings',
      //   builder: (context, state) => const EarningsListScreen(),
      // ),
      // GoRoute(
      //   path: '/expenses',
      //   builder: (context, state) => const ExpensesListScreen(),
      // ),
      // GoRoute(
      //   path: '/expenses/add',
      //   builder: (context, state) => const AddExpenseScreen(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Erro: ${state.error}'),
      ),
    ),
  );
}

