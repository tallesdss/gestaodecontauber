import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/earnings/add_earning_screen.dart';
import '../features/earnings/earnings_list_screen.dart';
import '../features/expenses/add_expense_screen.dart';
import '../features/expenses/expenses_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shared/detail_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/goals/goals_screen.dart';

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
        path: '/earnings',
        builder: (context, state) => const EarningsListScreen(),
      ),
      GoRoute(
        path: '/earnings/add',
        builder: (context, state) => const AddEarningScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesListScreen(),
      ),
      GoRoute(
        path: '/expenses/add',
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: '/detail/earning/:id',
        builder: (context, state) {
          // TODO: Buscar earning pelo ID do estado/banco de dados
          // Por enquanto, retorna uma tela vazia
          // final earningId = state.pathParameters['id'] ?? '';
          return DetailScreen(
            earning: null, // TODO: Buscar do banco de dados usando earningId
          );
        },
      ),
      GoRoute(
        path: '/detail/expense/:id',
        builder: (context, state) {
          // TODO: Buscar expense pelo ID do estado/banco de dados
          // Por enquanto, retorna uma tela vazia
          // final expenseId = state.pathParameters['id'] ?? '';
          return DetailScreen(
            expense: null, // TODO: Buscar do banco de dados usando expenseId
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Erro: ${state.error}'),
      ),
    ),
  );
}

