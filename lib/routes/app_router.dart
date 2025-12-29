import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // TODO: Adicionar rotas quando as telas forem criadas
      // GoRoute(
      //   path: '/splash',
      //   builder: (context, state) => const SplashScreen(),
      // ),
      // GoRoute(
      //   path: '/onboarding',
      //   builder: (context, state) => const OnboardingScreen(),
      // ),
      // GoRoute(
      //   path: '/home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Erro: ${state.error}'),
      ),
    ),
  );
}

